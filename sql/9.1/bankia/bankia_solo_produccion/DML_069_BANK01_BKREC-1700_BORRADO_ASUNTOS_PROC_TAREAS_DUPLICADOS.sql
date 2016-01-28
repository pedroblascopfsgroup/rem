-- CREAMOS LA TABLA QUE ALOJARA LOS ASU_ID INVALIDOS, HAY QUE MIRAR POR ASU_ID_EXTERNO, QUE NO HAYA REPETIDOS
CREATE TABLE ASU_FOR_DELETE AS
WITH ROWNUMBER AS (
SELECT 
ASU.ASU_ID,
ASU.ASU_NOMBRE,
ASU.ASU_ID_EXTERNO,
ASU.FECHACREAR,
ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID_EXTERNO ORDER BY ASU.ASU_ID DESC) RN_EX
FROM BANK01.ASU_ASUNTOS ASU 
WHERE ASU.BORRADO = 0 
AND ASU.DD_EAS_ID != (SELECT DD_EAS_ID FROM BANKMASTER.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_DESCRIPCION = 'Cancelado')
AND ASU.DD_EAS_ID != (SELECT DD_EAS_ID FROM BANKMASTER.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_DESCRIPCION = 'Cerrado')
ORDER BY RN_EX ASC
),
DUPLICATES AS (
SELECT * FROM ROWNUMBER WHERE ROWNUMBER.RN_EX > 1
),
UNIQUE_ASU AS (
SELECT
ASU.ASU_ID,
ASU.ASU_ID_EXTERNO,
ASU.ASU_NOMBRE,
ASU.FECHACREAR,
ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID_EXTERNO ORDER BY ASU.ASU_ID ASC) RN 
FROM BANK01.ASU_ASUNTOS ASU
WHERE EXISTS (
SELECT 1 FROM DUPLICATES WHERE DUPLICATES.ASU_ID_EXTERNO = ASU.ASU_ID_EXTERNO
)
)
SELECT ASU_ID, ASU_ID_EXTERNO, ASU_NOMBRE, FECHACREAR FROM UNIQUE_ASU WHERE RN != 1;

-- 1ºBORRAMOS LOGICAMENTE TAREAS
MERGE INTO BANK01.TAR_TAREAS_NOTIFICACIONES TAR USING
ASU_FOR_DELETE ASU_DEL
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
ASU_FOR_DELETE ASU_DEL
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
ASU_FOR_DELETE ASU_DEL
ON (ASU_DEL.ASU_ID = ASU.ASU_ID)
WHEN MATCHED THEN
UPDATE
SET
ASU.BORRADO = 1,
ASU.USUARIOBORRAR = 'BKREC-1700',
ASU.FECHABORRAR = SYSDATE
;

COMMIT;

DROP TABLE ASU_FOR_DELETE PURGE;
