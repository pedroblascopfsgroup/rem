--/*
--##########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20200128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9269
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
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
	
    V_TEXT1 VARCHAR2(2400 CHAR) := 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'; -- Vble. auxiliar
    V_TEXT2 VARCHAR2(2400 CHAR) := 'Este campo es obligat&oacute;rio';
    V_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS';
    V_TABLA1 VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';
    V_COLUMN VARCHAR2(2400 CHAR) := 'TFI_ERROR_VALIDACION';
    V_COLUMN1 VARCHAR2(2400 CHAR) := 'TAP_CODIGO';
    V_COLUMN2 VARCHAR2(2400 CHAR) := 'TAP_ID';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  V_SQL := 'SELECT '||V_COLUMN2||' FROM '||V_ESQUEMA||'.'||V_TABLA1||' WHERE '||V_COLUMN1||' = ''T015_Posicionamiento'' ';
  EXECUTE IMMEDIATE V_SQL INTO V_ID;
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE '||V_COLUMN||' = '''||V_TEXT1||''' AND '||V_COLUMN2||' = '||V_ID||' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN 
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
						 SET '||V_COLUMN||' = '''||V_TEXT2||'''
						 , USUARIOMODIFICAR = ''HREOS-9269''
						 , FECHAMODIFICAR = SYSDATE
						 WHERE '||V_COLUMN||' = '''||V_TEXT1||''' AND '||V_COLUMN2||' = '||V_ID||' ';

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
    END IF;
    COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
EXIT;
