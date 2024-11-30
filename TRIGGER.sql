USE CLUB_UAN;
GO 

CREATE TRIGGER VERIFICAR_CAMBIO_TIPO_SUBSCRIPCION
ON SOCIO
AFTER UPDATE
AS
BEGIN
    DECLARE @ID_SOCIO INT;
    DECLARE @TIPO_ANTERIOR NVARCHAR(20);
    DECLARE @TIPO_NUEVO NVARCHAR(20);
    DECLARE @FONDOS_DISPONIBLES DECIMAL(10,2);
    DECLARE @MIN_FONDOS DECIMAL(10,2);
    DECLARE @MAX_FONDOS DECIMAL(10,2);

    -- Obtener el ID del socio, el tipo anterior y el nuevo tipo de suscripción
    SELECT @ID_SOCIO = I.ID_SOCIO, 
           @TIPO_ANTERIOR = (SELECT TIPO FROM TIPO_SUBSCRIPCION WHERE ID_TIPO_SUB = D.ID_TIPO_SUB),
           @TIPO_NUEVO = (SELECT TIPO FROM TIPO_SUBSCRIPCION WHERE ID_TIPO_SUB = I.ID_TIPO_SUB)
    FROM INSERTED I
    JOIN DELETED D ON I.ID_SOCIO = D.ID_SOCIO;

    -- Verificar si hubo un cambio en el tipo de suscripción
    IF @TIPO_ANTERIOR <> @TIPO_NUEVO
    BEGIN
        -- Obtener los fondos disponibles del socio
        SELECT @FONDOS_DISPONIBLES = FONDOS_DISPO
        FROM SOCIO
        WHERE ID_SOCIO = @ID_SOCIO;

        -- Obtener los valores mínimo y máximo de fondos para el nuevo tipo de suscripción
        SELECT @MIN_FONDOS = FONDO_INICIAL_MIN, @MAX_FONDOS = FONDO_MAX
        FROM TIPO_SUBSCRIPCION
        WHERE TIPO = @TIPO_NUEVO;

        -- Validar si los fondos del socio son suficientes para el nuevo tipo de suscripción
        IF @FONDOS_DISPONIBLES < @MIN_FONDOS
        BEGIN
            -- Si los fondos no son suficientes, revertir la transacción
            ROLLBACK TRANSACTION;
            PRINT 'ERROR: El socio no tiene suficientes fondos para cambiar a este tipo de suscripción.';
            RETURN;
        END
        ELSE IF @FONDOS_DISPONIBLES > @MAX_FONDOS
        BEGIN
            -- Si los fondos exceden el máximo, revertir la transacción
            ROLLBACK TRANSACTION;
            PRINT 'ERROR: El socio tiene más fondos de los permitidos para este tipo de suscripción.';
            RETURN;
        END

        PRINT 'Cambio de tipo de suscripción realizado con éxito.';
    END
END;

