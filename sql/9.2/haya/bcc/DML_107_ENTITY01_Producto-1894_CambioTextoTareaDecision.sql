--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=PRODUCTO-1894	
--## PRODUCTO=SI
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

	      
      V_SQL := 'update '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE SET DD_STA_DESCRIPCION=''Tarea toma de decisión'',DD_STA_DESCRIPCION_LARGA=''Tarea toma de decisión'', USUARIOMODIFICAR=''PRODUCTO-1894'', FECHAMODIFICAR=SYSDATE WHERE DD_STA_CODIGO=''CJ-814''';
      EXECUTE IMMEDIATE V_SQL ;      
    
      
       V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CJ-814D''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

       IF V_NUM_TABLAS = 0 THEN
      
	   	   V_SQL := 'Insert into '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
	 		  (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TGE_ID, DTYPE)
	 			Values
			   ('||V_ESQUEMA_M||'.s_dd_sta_subtipo_tarea_base.nextval, 1, ''CJ-814D'', ''Tarea toma de decisión'', ''Tarea toma de decisión'', 0, ''PRODUCTO-1894'', sysdate, 0, (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), ''EXTSubtipoTarea'')';
			EXECUTE IMMEDIATE V_SQL ; 
		
	   ELSE
	  		DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya existía');
	   END IF;
   
        V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_STA_ID=(SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''CJ-814D''), USUARIOMODIFICAR=''PRODUCTO-1894'', FECHAMODIFICAR=SYSDATE WHERE TAP_CODIGO=''H015_RegistrarSolicitudDecision''';
        EXECUTE IMMEDIATE V_SQL ; 
        
        V_SQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_DESCRIPCION=''Tarea toma de decisión'', USUARIOMODIFICAR=''PRODUCTO-1894'', FECHAMODIFICAR=SYSDATE WHERE DD_STA_ID = (select dd_sta_id from '||V_ESQUEMA_M||'.dd_sta_subtipo_Tarea_base where dd_sta_codigo=''CJ-814'')';
        EXECUTE IMMEDIATE V_SQL ; 
        

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

