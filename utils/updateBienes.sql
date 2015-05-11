/*
 * Actualizar los campos nuevos de los bienes manuales con la información que ya tienen 
 * 
 */

INSERT INTO BIE_DATOS_REGISTRALES (	BIE_DREG_ID, BIE_ID, BIE_DREG_REFERENCIA_CATASTRAL,	BIE_DREG_SUPERFICIE, VERSION, USUARIOCREAR, FECHACREAR) 
	SELECT S_BIE_DATOS_REGISTRALES.NEXTVAL, BIE_ID, BIE_REFERENCIA_CATASTRAL, BIE_SUPERFICIE, 0, 'SAG', sysdate 
	FROM BIE_BIEN WHERE DD_ORIGEN_ID = (SELECT DD_ORIGEN_ID FROM DD_ORIGEN_BIEN WHERE DD_ORIGEN_DESCRIPCION = 'Manual');


INSERT INTO BIE_LOCALIZACION (BIE_LOC_ID,  BIE_ID, BIE_LOC_POBLACION, VERSION, USUARIOCREAR, FECHACREAR) 
	SELECT S_BIE_LOCALIZACION.NEXTVAL, BIE_ID, BIE_POBLACION, 0, 'SAG', sysdate 
	FROM BIE_BIEN WHERE DD_ORIGEN_ID = (SELECT DD_ORIGEN_ID FROM DD_ORIGEN_BIEN WHERE DD_ORIGEN_DESCRIPCION = 'Manual');


/*
 * Corregir tablas
 * 
 */

ALTER TABLE BIE_DATOS_REGISTRALES ADD BIE_DREG_NUM_FINCA VARCHAR2(50);
ALTER TABLE BIE_LOCALIZACION DROP COLUMN BIE_LOC_NUM_FINCA;

UPDATE PFSMASTER.FUN_FUNCIONES SET FUN_DESCRIPCION = 'BOTON_INF_AGREGADO_CONTRATO' WHERE FUN_DESCRIPCION = 'BOTON_SITUACION_CONTENCIOSO';