--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190531
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP_4408
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
V_SQL VARCHAR2(10000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
DD_GRF_CODIGO VARCHAR2(25 CHAR):= '17';
V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH  WHERE DD_GRF_CODIGO = '||DD_GRF_CODIGO||'';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS < 1 THEN
	
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH 
			(DD_GRF_ID,
			DD_GRF_CODIGO,
			DD_GRF_CARPETA,
			DD_GRF_DESCRIPCION,
			DD_GRF_DESCRIPCION_LARGA,
			DD_GRF_NOM_GES_FICH,
			PVE_COD_REM,
			NUCLII,
			POS_5_A_6_PROV,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			USUARIOMODIFICAR,
			FECHAMODIFICAR,
			USUARIOBORRAR,
			FECHABORRAR,
			BORRADO,
			USERNAME_GIAADMT,
			USERNAME_GTOPOSTV,
			USERNAME_GTOPLUS) 
			VALUES (
			'||V_ESQUEMA||'.S_DD_GRF_GESTORIA_RECEP_FICH.NEXTVAL,
			''17'',
			''gestinova99'',
			''Gestinova 99'',
			''Gestinova 99'',
			''GESTINOVA99'',
			''10005751'',
			NULL,
			NULL,
			''0'',
			''DML'',
			SYSDATE,
			''REMVIP-4408'',
			SYSDATE,
			NULL,
			NULL,
			''0'',
			''gestinov02'',
			''gestinov07'',
			''gestinov06'')';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTRO INSERTADO EN DD_GRF_GESTORIA_RECEP_FICH.');  
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO YA EXISTE');
		
	END IF;
										

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;
END;

/

EXIT
