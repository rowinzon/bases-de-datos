USE Taller2;
--A) Consultar el c�digo de los goles realizados por el jugador �Juan Perea�. 
SELECT G.CODIGO_GOL FROM GOL G INNER JOIN JUGADOR J ON J.CODIGO_JUGADOR=G.CODIGO_JUGADOR WHERE NOMBRE='JUAN PEREA'
--B) Consultar todos los goles realizados de visitante por los jugadores de la posici�n de �defensa�
SELECT G.CODIGO_GOL FROM GOL G INNER JOIN JUGADOR J ON J.CODIGO_JUGADOR=G.CODIGO_JUGADOR INNER JOIN PARTIDO P ON P.CODIGO_PARTIDO=G.CODIGO_PARTIDO WHERE J.POSICION='DEFENSA' AND J.CODIGO_EQUIPO=P.EQUIPO_VIS
--C) Consultar el presidente del equipo de futbol �los tiburones�.
SELECT P.NOMBRE FROM PRESIDENTE P INNER JOIN EQUIPO E ON E.CODIGO_EQUIPO=P.CODIGO_EQUIPO WHERE E.NOMBRE='LOS TIBURONES'
--D) Listar la n�mina de jugadores del equipo de futbol �tigres�
use Taller2;
DECLARE @EQUIPOBUSCAR NVARCHAR (50) = 'LOS TIBURONES'
declare @NOMINA as table (NOMBRE NVARCHAR (50),NUMERO_DOC INT , EQUIPO NVARCHAR(50),CARGO NVARCHAR (50))
INSERT INTO @NOMINA (NOMBRE , NUMERO_DOC , EQUIPO , CARGO)
SELECT P.NOMBRE,P.NUMERO_DOC, E.NOMBRE,'PRESIDENTE'  FROM  PRESIDENTE P INNER JOIN EQUIPO E  ON E.CODIGO_EQUIPO = P.CODIGO_EQUIPO WHERE E.NOMBRE=@EQUIPOBUSCAR
INSERT INTO @NOMINA (NOMBRE , NUMERO_DOC , EQUIPO , CARGO)
SELECT J.NOMBRE,J.NUMERO_DOC, E.NOMBRE,'JUGADOR'  FROM  JUGADOR J INNER JOIN EQUIPO E  ON E.CODIGO_EQUIPO = J.CODIGO_EQUIPO WHERE E.NOMBRE=@EQUIPOBUSCAR
SELECT * FROM @NOMINA ORDER BY NOMBRE
--E) Consultar los jugadores que no han marcado un gol el en torneo actual
SELECT * FROM JUGADOR J FULL OUTER JOIN  GOL G ON G.CODIGO_JUGADOR = J.CODIGO_JUGADOR WHERE CODIGO_GOL IS NULL 
--F) Consultar si existe un jugador que tambi�n sea el presidente del equipo donde milita.
SELECT P.*,E.* FROM JUGADOR J INNER JOIN PRESIDENTE P ON P.NUMERO_DOC=J.NUMERO_DOC INNER JOIN EQUIPO E ON E.CODIGO_EQUIPO=P.CODIGO_EQUIPO
--G) Consultar los equipos de futbol que tienen m�s goles realizados antes de los primeros 15 minutos
SELECT COUNT (J.CODIGO_EQUIPO) CANTIDAD_DE_GOLES, E.NOMBRE EQUIPO FROM GOL G  INNER JOIN JUGADOR J ON J.CODIGO_JUGADOR=G.CODIGO_JUGADOR INNER JOIN EQUIPO E ON J.CODIGO_EQUIPO=E.CODIGO_EQUIPO WHERE G.MINUTO<=15 GROUP BY J.CODIGO_EQUIPO,E.NOMBRE

