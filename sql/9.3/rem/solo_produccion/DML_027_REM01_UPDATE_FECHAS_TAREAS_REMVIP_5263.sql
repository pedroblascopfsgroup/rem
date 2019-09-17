--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5263
--## PRODUCTO=NO
--## 
--## Finalidad: actualizar fecha tareas de ofertas afectadas
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-5263';
  PL_OUTPUT VARCHAR2(32000 CHAR);

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
		USING
		(
		    SELECT  TAR.TAR_ID ,OFR.OFR_NUM_OFERTA, 
		    TAR.TAR_DESCRIPCION, 
		    TAR.TAR_FECHA_FIN,       
		    TAR.FECHABORRAR
		    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
		    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
		    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID 
		    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
		    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID 
		    JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID 
		    JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID 
		    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID 
		    WHERE EEC.DD_EEC_DESCRIPCION = ''Vendido'' 
		    AND OFR.FECHAMODIFICAR IS NOT NULL 
		    AND OFR.USUARIOMODIFICAR = ''REMVIP-5263'' 
		    AND TAR_FECHA_FIN >= TO_DATE(''06/09/19'', ''DD/MM/RR'') 
		    ORDER BY OFR.FECHAMODIFICAR DESC
			) T2
		ON ( T1.TAR_ID = T2.TAR_ID )
		WHEN MATCHED THEN UPDATE SET
		T1.TAR_FECHA_FIN = T2.FECHABORRAR,
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		T1.FECHAMODIFICAR = SYSDATE ';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' TAREAS ACTUALIZADAS CON LA FECHA CORRECTA.');  

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
		USING
		(
		    SELECT  TAR.TAR_ID ,OFR.OFR_NUM_OFERTA, 
		    TAR.TAR_DESCRIPCION, 
		    TAR.TAR_FECHA_FIN,       
		    TAR.FECHABORRAR
		    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
		    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID 
		    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID 
		    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
		    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID 
		    JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID 
		    JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID 
		    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID 
		    WHERE EEC.DD_EEC_DESCRIPCION = ''Vendido''
		    AND (TAR.TAR_DESCRIPCION = ''Documentos post-venta''  
           	    OR TAR.TAR_DESCRIPCION = ''Informe jurídico''
                    OR TAR.TAR_DESCRIPCION = ''Validación clientes''
           	    OR TAR.TAR_DESCRIPCION = ''Resolución tanteo'') 
		    AND OFR.FECHAMODIFICAR IS NOT NULL 
                    AND TAR.FECHABORRAR IS NULL
            	    AND OFR.USUARIOMODIFICAR = ''REMVIP-5263'' 
		    AND TAR_FECHA_FIN >= TO_DATE(''06/09/19'', ''DD/MM/RR'') 
		    ORDER BY OFR.FECHAMODIFICAR DESC
			) T2
		ON ( T1.TAR_ID = T2.TAR_ID AND T1.TAR_FECHA_FIN is null )
		WHEN MATCHED THEN UPDATE SET
		T1.BORRADO = 0,
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		T1.FECHAMODIFICAR = SYSDATE ';

		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' TAREAS QUE QUEDARON PENDIENTES ACTUALIZADAS.');  

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
            
           
