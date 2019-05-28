--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190524
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP_4269
--## PRODUCTO=NO
--## 
--## Finalidad: Merge de cargas
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
--ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE
V_SQL VARCHAR2(10000 CHAR);
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_REMVIP_4269_2';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
										
	 V_SQL := 'INSERT INTO REM01.BIE_CAR_CARGAS 
		 (BIE_ID,
		  BIE_CAR_ID,
		  BIE_CAR_TITULAR,
		  BIE_CAR_IMPORTE_REGISTRAL,
		  BIE_CAR_IMPORTE_ECONOMICO, 
		  BIE_CAR_REGISTRAL, 
		  DD_SIC_ID,
		  BIE_CAR_ECONOMICA,
		  DD_TPC_ID,
		  USUARIOMODIFICAR,
		  USUARIOCREAR,
		  FECHACREAR)
	SELECT  ACT.BIE_ID,
	       '||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL,
	       SUBSTRB(AUX.TITULAR_CARGA,0,49),
	       AUX.IMPORTE_CARGA,
	       0,
	       1,
	       1,
	       0,
	       3,
	       AUX.ROWID,
	       ''REMVIP_4269'',
	       SYSDATE
	       FROM '||V_ESQUEMA||'.AUX_REMVIP_4269_2 AUX
	       JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
	       JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC ON SIC.DD_SIC_DESCRIPCION = AUX.ESTADO_REGISTRAL
		';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos el numero de finca.');  

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
