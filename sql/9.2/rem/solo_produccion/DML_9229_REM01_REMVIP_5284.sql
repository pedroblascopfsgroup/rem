--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190926
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5284
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5284'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO ACT_TRA_TRAMITE ');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA
		    USING( 

			   SELECT TRA_ID
			   FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE
			   WHERE 1 = 1
			   AND USUARIOMODIFICAR = ''' || V_USR || '''
			   AND BORRADO = 0
			   AND TRA_FECHA_FIN IS NULL

			) AUX
		    ON ( AUX.TRA_ID = TRA.TRA_ID )
		    WHEN MATCHED THEN UPDATE SET
		    TRA_FECHA_FIN = TO_DATE( ''25/09/2019'', ''DD/MM/YYYY'' ),
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USR || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_TRA_TRAMITE'); 	

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
