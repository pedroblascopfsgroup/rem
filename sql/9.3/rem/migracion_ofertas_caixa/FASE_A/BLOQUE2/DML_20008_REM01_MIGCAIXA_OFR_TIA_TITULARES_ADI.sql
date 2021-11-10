--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210727
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.11
--## INCIDENCIA_LINK=HREOS-14680
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## 
--## INSTRUCCIONES:  
--## VERSIONES:
--## 	0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'MIG_CAIXA';
	V_TABLA VARCHAR2(40 CHAR) := 'MIG2_OFR_TIA_TITULARES_ADI_CAIXA';
	V_TABLA_MIG VARCHAR2(40 CHAR) := 'OFR_TIA_TITULARES_ADICIONALES';
	V_SENTENCIA VARCHAR2(2000 CHAR);
	V_NUM_TABLAS NUMBER(16);
	V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

	--Inicio del proceso de volcado sobre OFR_TIA_TITULARES_ADICIONALES
V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';

EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
DBMS_OUTPUT.PUT_LINE('La tabla/s de migración implicada está vacía. No se realiza ninguna acción');

ELSE

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.MIG2_OFR_TIA_TITULARES_ADI_CAIXA (
		OFR_NUM_OFERTA	,
		TIA_NOMBRE	,
		DD_TDI_ID	,
		TIA_DOCUMENTO	,
		TIA_APELLIDOS	,
		TIA_DIRECCION	,
		DD_LOC_ID	,
		DD_PRV_ID	,
		TIA_CODPOSTAL	,
		DD_ECV_ID	,
		DD_REM_ID	,
		TIA_RECHAZAR_PUBLI	,
		TIA_RECHAZAR_PROPI	,
		TIA_RECHAZAR_PROVE	,
		TIA_RAZON_SOCIAL	,
		TIA_TELEFONO1	,
		TIA_TELEFONO2	,
		TIA_EMAIL	,
		DD_TVI_ID	,
		TIA_OBSERVACIONES	,
		DD_TDI_ID_CONYUGE	,
		TIA_DOCUMENTO_CONYUGE	,
		DD_TPE_ID	,
		DD_PAI_ID	,
		DD_TDI_ID_RTE	,
		TIA_DOCUMENTO_RTE	,
		TIA_DIRECCION_RTE	,
		DD_PRV_ID_RTE	,
		DD_LOC_ID_RTE	,
		DD_PAI_ID_RTE	,
		TIA_CODPOSTAL_RTE	,
		ADCOM_GDPR	,
		ADCOM_DOC_IDENT	,
		FECHA_ACEP_GDPR	,
		TIA_C4C_ID	,
		TIA_ID_PERSONA_HAYA	,
		IAP_ID	,
		TIA_FECHA_NACIMIENTO	,
		DD_LOC_NAC_ID	,
		DD_PAI_NAC_ID	
	)
		SELECT 
		MIG.COD_OFERTA_CAIXA	,
		TIA_NOMBRE	,
		DD_TDI_ID	,
		TIA_DOCUMENTO	,
		TIA_APELLIDOS	,
		TIA_DIRECCION	,
		DD_LOC_ID	,
		DD_PRV_ID	,
		TIA_CODPOSTAL	,
		DD_ECV_ID	,
		DD_REM_ID	,
		TIA_RECHAZAR_PUBLI	,
		TIA_RECHAZAR_PROPI	,
		TIA_RECHAZAR_PROVE	,
		TIA_RAZON_SOCIAL	,
		TIA_TELEFONO1	,
		TIA_TELEFONO2	,
		TIA_EMAIL	,
		DD_TVI_ID	,
		TIA_OBSERVACIONES	,
		DD_TDI_ID_CONYUGE	,
		TIA_DOCUMENTO_CONYUGE	,
		DD_TPE_ID	,
		DD_PAI_ID	,
		DD_TDI_ID_RTE	,
		TIA_DOCUMENTO_RTE	,
		TIA_DIRECCION_RTE	,
		DD_PRV_ID_RTE	,
		DD_LOC_ID_RTE	,
		DD_PAI_ID_RTE	,
		TIA_CODPOSTAL_RTE	,
		ADCOM_GDPR	,
		ADCOM_DOC_IDENT	,
		FECHA_ACEP_GDPR	,
		TIA_C4C_ID	,
		TIA_ID_PERSONA_HAYA	,
		IAP_ID	,
		TIA_FECHA_NACIMIENTO	,
		DD_LOC_NAC_ID	,
		DD_PAI_NAC_ID
		FROM '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES INF
		JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = INF.OFR_ID
		JOIN '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS MIG ON MIG.COD_OFERTA_CAIXA = OFR.OFR_NUM_OFERTA
	';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
	
	COMMIT;
	
END IF;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------');
		DBMS_OUTPUT.put_line(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/
EXIT;
