/*
 * Limipamos las talas OJO, comentar si no se quiere
 */
DELETE FROM BATCH_DATOS_SALIDA;

DELETE FROM TMP_REC_EXP_REPARTO_AGENCIAS;

DROP TABLE TEST_EXP;

DROP TABLE TEST_CEX;

commit;

/* Seleccionamos universo de contratos y personas para el test */

CREATE TABLE TEST_EXP AS 
SELECT 1 N, S_EXP_EXPEDIENTES.NEXTVAL EXP_ID FROM DUAL;

INSERT INTO TEST_EXP 
SELECT 2 , S_EXP_EXPEDIENTES.NEXTVAL FROM DUAL;

INSERT INTO TEST_EXP 
SELECT 3 , S_EXP_EXPEDIENTES.NEXTVAL FROM DUAL;

CREATE TABLE TEST_CEX AS 
SELECT EXP_ID, 1188348 PER_ID, 2317069 CNT_ID, 1 PASE FROM TEST_EXP WHERE N = 1
UNION
SELECT EXP_ID, 1188347 PER_ID, 2317069 CNT_ID, 1 PASE FROM TEST_EXP WHERE N = 1
UNION
SELECT EXP_ID, 1110062 PER_ID, 2363938 CNT_ID, 0 PASE FROM TEST_EXP WHERE N = 1
UNION
SELECT EXP_ID, 1110062 PER_ID, 2246989 CNT_ID, 0 PASE FROM TEST_EXP WHERE N = 1
UNION
SELECT EXP_ID, 1590261 PER_ID, 2985907 CNT_ID, 1 PASE FROM TEST_EXP WHERE N = 2
UNION
SELECT EXP_ID, 828327 PER_ID, 2557062 CNT_ID, 1 PASE FROM TEST_EXP WHERE N = 3

;


INSERT INTO BATCH_DATOS_SALIDA
SELECT
			        T.EXP_ID		-- EXPEDIENTE
			        , T.EXP_ID||' - NUEVO EXP RECOBRO' 	-- DESCRIPCIÓN
			        , 0 		-- MANUAL
			        , 'CP'  -- ÁMBITO DEL EXPEDIENTE
			        , 2  		-- ESTADO DEL EXPEDIENTE
			        , 5  		-- ESTADO DEL ITINERARIO
			        , sysdate 	-- FECHA ESTADO ITINERARIO
			        , C.OFI_ID 	-- OFICINA
			        , T.CNT_ID 	-- CONTRATO 
			        , T.PER_ID 	-- PERSONA
			        , 30 	-- ARQUETIPO
			        , T.PASE 		-- CEX_PASE
			        , T.PASE 		-- PEX_PASE
FROM TEST_CEX T
  JOIN CNT_CONTRATOS C ON T.CNT_ID = C.CNT_ID;

COMMIT;

INSERT INTO TMP_REC_EXP_REPARTO_AGENCIAS
SELECT EXP_ID
  , 2 AS CAR_ID
  , 2 AS RCF_SCA_ID
  , 2 AS RCF_AGE_ID
  , 1000 AS VRE
FROM BATCH_DATOS_SALIDA;

COMMIT;

UPDATE CNT_CONTRATOS SET OFI_ID_ADMIN = 1048 
WHERE CNT_ID IN (SELECT CNT_ID FROM BATCH_DATOS_SALIDA)
  AND OFI_ID_ADMIN IS NULL;
  
UPDATE CNT_CONTRATOS SET DD_PRO_ID = 2
WHERE CNT_ID IN (SELECT CNT_ID FROM BATCH_DATOS_SALIDA)
  AND DD_PRO_ID IS NULL;
  
INSERT INTO EXT_IAC_INFO_ADD_CONTRATO (IAC_ID,DD_IFC_ID,CNT_ID, IAC_VALUE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT S_EXT_IAC_INFO_ADD_CONTRATO.NEXTVAL,
  (SELECT DD_IFC_ID FROM EXT_DD_IFC_INFO_CONTRATO WHERE DD_IFC_CODIGO = 'NUMERO_ESPEC'),
  CNT_ID,
  123456789,
  0, 'TEST', SYSDATE, 0
FROM CNT_CONTRATOS CNT
WHERE CNT.CNT_ID IN (SELECT CNT_ID FROM BATCH_DATOS_SALIDA)
AND NOT EXISTS (SELECT IAC_VALUE FROM EXT_IAC_INFO_ADD_CONTRATO WHERE CNT_ID = CNT.CNT_ID AND DD_IFC_ID = (SELECT DD_IFC_ID FROM EXT_DD_IFC_INFO_CONTRATO WHERE DD_IFC_CODIGO = 'NUMERO_ESPEC'));

update dir_direcciones set dd_loc_id = mod(dir_id, 1000) +1
where dd_loc_id is null
  and dir_id in (select dir_id from dir_per where per_id in (select per_id from batch_datos_salida))
  ;
  
update dir_direcciones set dd_tvi_id = mod(dir_id, 4) +1
where dd_tvi_id is null
  and dir_id in (select dir_id from dir_per where per_id in (select per_id from BATCH_DATOS_SALIDA)); 
  
update per_personas set dd_pro_id = 2 where per_id in (select per_id from BATCH_DATOS_SALIDA);
  
COMMIT;