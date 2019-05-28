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

DECLARE
V_SQL VARCHAR2(10000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_REMVIP_4269_2';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
										
	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CRG_CARGAS 
		 (CRG_ID,
		  ACT_ID,
		  BIE_CAR_ID,
		  DD_TCA_ID,
		  DD_STC_ID,
		  CRG_CARGAS_PROPIAS,
		  USUARIOCREAR,
		  FECHACREAR)
	      SELECT  
	      '||V_ESQUEMA||'.S_ACT_CRG_CARGAS.NEXTVAL,
	      ACT.ACT_ID,
	      CAR.BIE_CAR_ID,
	      1,
	      AUX.SUBTIPO_CARGA,
	      AUX.CARGAS_PROPIAS,
	      CAR.USUARIOCREAR,
	      SYSDATE
	      FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR 
	      JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.BIE_ID = CAR.BIE_ID 
	      JOIN '||V_ESQUEMA||'.AUX_REMVIP_4269_2 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO AND AUX.ROWID = CAR.USUARIOMODIFICAR
	      WHERE CAR.USUARIOCREAR= ''REMVIP_4269''
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
