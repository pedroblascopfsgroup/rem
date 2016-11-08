--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1076
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_TTR_TIPO_TRABAJO los datos necesarios.
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TTR_TIPO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TTR'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

      -- Actualizar registros existentes.
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Tasación)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = ''01''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	                    'SET BORRADO = 1'|| 
						', USUARIOBORRAR = ''DML'' , FECHABORRAR = SYSDATE '||
						'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = ''01''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Tasación), quizás ya se encuentra actualizado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Comercialización)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = ''06''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	                    'SET BORRADO = 1'|| 
						', USUARIOBORRAR = ''DML'' , FECHABORRAR = SYSDATE '||
						'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = ''06''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Comercialización), quizás ya se encuentra actualizado');
      END IF;
      
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   