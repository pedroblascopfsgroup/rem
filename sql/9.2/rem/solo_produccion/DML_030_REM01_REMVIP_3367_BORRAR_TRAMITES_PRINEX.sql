--/*
--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3367
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar trámites
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
  V_TABLA_TEMP VARCHAR(50 CHAR):='APR_AUX_TAREAS_TRABAJOS';
  V_USUARIO_MODIFICAR VARCHAR(50 CHAR):='REMVIP-3367';
    
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_COUNT NUMBER(16);
        
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

BEGIN

 V_COUNT := 0;

  FOR REGISTRO IN (

	SELECT DISTINCT TAC.TAR_ID, TRA.TRA_ID
	FROM REM01.ACT_TRA_TRAMITE TRA, REM01.TAC_TAREAS_ACTIVOS TAC
	WHERE 1 = 1
	AND TRA.TRA_ID = TAC.TRA_ID
	AND TRA.BORRADO = 0
	AND TAC.BORRADO = 0
	AND EXISTS ( SELECT 1
             	     FROM REMMASTER.USU_USUARIOS USU
		     WHERE 1 = 1
             	     AND USU_USERNAME IN ( 
                                    	  'mblascop',
                                    	  'cmartinc',
                                    	  'ssalazar',
                                    	  'jdiazp',
                                    	  'rbarroso'
                                	 )
             	     AND USU.USU_ID = TAC.USU_ID
            	  )
	AND EXISTS ( SELECT 1
             	     FROM REM01.ACT_ACTIVO ACT
             	     WHERE 1 = 1
             	     AND (    USUARIOCREAR = 'ALT_PRINEX'
                   	   OR USUARIOMODIFICAR = 'ALT_PRINEX' )
             	     AND ACT.ACT_ID = TAC.ACT_ID
		     AND ACT.DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '08' )	
            	   )   
  )
  LOOP	       							 
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE EMPIEZA A BORRAR EL TRAMITE '|| TRIM(V_TMP_TIPO_DATA(1)) ||'');  
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
							TAR_FECHA_FIN = SYSDATE
							,TAR_TAREA_FINALIZADA = 1
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1
						WHERE TAR_ID = '|| REGISTRO.TAR_ID || '
                              AND TAR_TAREA_FINALIZADA = 0';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAR_TAREAS_NOTIFICACIONES');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
							USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHABORRAR = SYSDATE
						   ,BORRADO = 1 
						WHERE TAR_ID = '|| REGISTRO.TAR_ID ;
			
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAC_TAREAS_ACTIVOS');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET 
							TRA_DECIDIDO = 1
							,DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05'')
							,TRA_FECHA_FIN = SYSDATE
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1 
						WHERE TRA_ID = ' || REGISTRO.TRA_ID ;
						
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA ACT_TRA_TRAMITE');
			
  V_COUNT := V_COUNT + 1 ;

  END LOOP;
END;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN TRATADO ' || V_COUNT || ' TRAMITE/S' );		
    
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
