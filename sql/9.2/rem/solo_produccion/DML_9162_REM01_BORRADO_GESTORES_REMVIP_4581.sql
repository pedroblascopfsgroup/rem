--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190619
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4581
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4581';
    V_SQL VARCHAR2(4000 CHAR);

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar gestores duplicados ');			


  
             

	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
        USING (

		SELECT 
		GEH.GEH_ID,
		( SELECT GEH2.GEH_FECHA_DESDE
  		  FROM  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH2, 
		        '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH2
		  WHERE 1 = 1
		  AND GEH2.GEH_ID = GAH2.GEH_ID
		  AND GEH2.GEH_ID <> GEH.GEH_ID
		  AND GAH2.ACT_ID = ACT.ACT_ID
		  AND GEH2.DD_TGE_ID = GEH.DD_TGE_ID
		  AND ( GEH2.USUARIOBORRAR IS NULL OR GEH2.USUARIOBORRAR <> ''HREOS-5932-PUNTO1'' ) 
		  AND GEH2.GEH_FECHA_HASTA IS NULL
		 ) AS FECHA_DESDE_NUEVO

		FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH, 
		'||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH, 
		'||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE,
		'||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE 1=1
		AND GEH.GEH_ID = GAH.GEH_ID
		AND GAH.ACT_ID = ACT.ACT_ID
		AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
		AND GEH.USUARIOBORRAR = ''HREOS-5932-PUNTO1''
		AND EXISTS ( SELECT 1
		             FROM  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH2, 
                   		'||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH2
		             WHERE 1 = 1
		             AND GEH2.GEH_ID = GAH2.GEH_ID
		             AND GEH2.GEH_ID <> GEH.GEH_ID
		             AND GAH2.ACT_ID = ACT.ACT_ID
             		     AND GEH2.DD_TGE_ID = GEH.DD_TGE_ID     
		             AND ( GEH2.USUARIOBORRAR IS NULL OR GEH2.USUARIOBORRAR <> ''HREOS-5932-PUNTO1'' )
	          )   

        ) T2 
        ON (T1.GEH_ID = T2.GEH_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.GEH_FECHA_HASTA = T2.FECHA_DESDE_NUEVO ,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GEH_GESTOR_ENTIDAD_HIST');  


-----------------------------------------------------------------------------------------------------------------


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso realizado');
	

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
