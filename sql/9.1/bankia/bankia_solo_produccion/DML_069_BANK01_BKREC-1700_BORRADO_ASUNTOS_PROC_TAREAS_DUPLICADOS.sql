DROP TABLE ASU_TO_DELETE PURGE;

-- CREAMOS LA TABLA QUE ALOJARA LOS ASU_ID INVALIDOS, HAY QUE MIRAR POR ASU_ID_EXTERNO, QUE NO HAYA REPETIDOS
CREATE TABLE ASU_TO_DELETE AS
	WITH ROWNUMBER AS (
		SELECT 
		  ASU.ASU_ID,
		  ASU.ASU_NOMBRE,
		  ASU.ASU_ID_EXTERNO,
		  ASU.FECHACREAR,
		  ASU.FECHAMODIFICAR,
		  ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID_EXTERNO ORDER BY ASU.DD_EAS_ID ASC, GREATEST(ASU.FECHACREAR, NVL(ASU.FECHAMODIFICAR,to_date('01/01/1970','DD/MM/RRRR'))) DESC) RN_EX
		  FROM BANK01.ASU_ASUNTOS ASU 
		WHERE ASU.BORRADO = 0 
		)
	SELECT
	ASU.ASU_ID,
	ASU.ASU_ID_EXTERNO,
	ASU.ASU_NOMBRE,
	ASU.FECHACREAR,
	ASU.FECHAMODIFICAR,
    ASU.DD_EAS_ID,
    ROWNUMBER.RN_EX
	FROM BANK01.ASU_ASUNTOS ASU
	JOIN ROWNUMBER ON ROWNUMBER.ASU_ID = ASU.ASU_ID
    WHERE ROWNUMBER.RN_EX > 1;

-- 1ºBORRAMOS LOGICAMENTE TAREAS
MERGE INTO BANK01.TAR_TAREAS_NOTIFICACIONES TAR USING
ASU_TO_DELETE ASU_DEL
ON (ASU_DEL.ASU_ID = TAR.ASU_ID)
WHEN MATCHED THEN
UPDATE
SET
TAR.BORRADO = 1,
TAR.USUARIOBORRAR = 'BKREC-1700',
TAR.FECHABORRAR = SYSDATE
;

-- 2ºBORRAMOS LOGICAMENTE PROCEDIMIENTOS
MERGE INTO BANK01.PRC_PROCEDIMIENTOS PRC USING
ASU_TO_DELETE ASU_DEL
ON (ASU_DEL.ASU_ID = PRC.ASU_ID)
WHEN MATCHED THEN
UPDATE
SET
PRC.BORRADO = 1,
PRC.USUARIOBORRAR = 'BKREC-1700',
PRC.FECHABORRAR = SYSDATE
;

-- 3ºBORRAMOS LOGICAMENTE ASUNTOS
MERGE INTO BANK01.ASU_ASUNTOS ASU USING
ASU_TO_DELETE ASU_DEL
ON (ASU_DEL.ASU_ID = ASU.ASU_ID)
WHEN MATCHED THEN
UPDATE
SET
ASU.BORRADO = 1,
ASU.USUARIOBORRAR = 'BKREC-1700',
ASU.FECHABORRAR = SYSDATE
;

COMMIT;


