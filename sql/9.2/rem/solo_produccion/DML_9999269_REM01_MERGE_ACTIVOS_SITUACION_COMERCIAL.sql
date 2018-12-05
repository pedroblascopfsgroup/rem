--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2721
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la situación comercial errónea de algunos activos tras la migración
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
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
			  USING ( SELECT ACT.ACT_ID
			    	  FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                      JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION	APU	ON APU.ACT_ID = ACT.ACT_ID
					  JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL	SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
				      JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION	MTO ON MTO.DD_MTO_ID = APU.DD_MTO_V_ID
				      WHERE (SCM.DD_SCM_CODIGO = ''02'' OR SCM.DD_SCM_CODIGO = ''03'') AND MTO.DD_MTO_CODIGO = ''07''
					) T2 
			  ON (T1.ACT_ID = T2.ACT_ID)
			  WHEN MATCHED THEN UPDATE SET
			  		T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''04'')
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE REALIZADO CORRECTAMENTE');

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
