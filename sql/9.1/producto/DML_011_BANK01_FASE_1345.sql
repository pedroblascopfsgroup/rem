--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.
--## INCIDENCIA_LINK=FASE-1261
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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

V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO= ''NTGPS''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE ...no se modificará nada.');
	ELSE
		V_MSQL := 'Insert into '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
   		(DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, dd_tge_id, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 			Values
  		('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.nextval, 3, ''NTGPS'', ''Notificación Tasación Gestor Propuesta Subasta'', ''Notificación Tasación Gestor Propuesta Subasta'', (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESTPROP''), 0, ''DD'', sysdate, 0, ''EXTSubtipoTarea'')';
        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Datos del diccionario insertado');
        
    END IF;	

   
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
