--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210705
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10060
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tabla situacion comercial activos
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-10060';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			

-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - SITUACION COMERCIAL A ALQUILADO');


    --GASTOS < 2016 CUENTAS
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
		        USING (
                    SELECT DISTINCT ACT.ACT_ID

                    FROM '||V_ESQUEMA||'.ACT_aCTIVO ACT
                    JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion APU ON APU.ACT_ID=ACT.ACT_ID AND APU.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID=APU.DD_TCO_ID AND TCO.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.dd_scm_situacion_comercial SCM ON SCM.DD_SCM_ID=ACT.DD_SCM_ID AND SCM.BORRADO=0
                    JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID=ACT.ACT_ID AND PTA.BORRADO=0
                    JOIN '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL ON EAL.DD_EAL_ID=PTA.DD_EAL_ID AND EAL.BORRADO = 0
                    WHERE ACT.BORRADO = 0 AND SCM.DD_SCM_CODIGO NOT IN (''10'',''05'') AND EAL.DD_EAL_CODIGO = ''02''
                    AND TCO.DD_TCO_CODIGO = ''02''
                
        		) T2 
        	  ON (T1.ACT_ID = T2.ACT_ID )
				WHEN MATCHED THEN UPDATE SET 
                    T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE BORRADO = 0 AND DD_SCM_CODIGO=''10''),
	    			T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    			T1.FECHAMODIFICAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' ACTIVOS a situacion comercial alquilado');  



-----------------------------------------------------------------------------------------------------------------


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
