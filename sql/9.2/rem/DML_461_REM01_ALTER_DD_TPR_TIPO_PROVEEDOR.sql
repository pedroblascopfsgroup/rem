--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_TPR_TIPO_PROVEEDOR los datos necesarios.
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro. 
    V_CODIGO_REGISTRO VARCHAR2(25 CHAR); -- Vble. para obtener el codigo de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TPR_TIPO_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
      -- Eliminar registros existentes.
      DBMS_OUTPUT.PUT_LINE('[INFO]: Eliminar registro existente (Tasadora)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_CODIGO = 26';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
	      V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_CODIGO = 26';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Tasadora), quizás ya se encuentra eliminado');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: Eliminar registro existente (Mediador / Colaborador / API)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_CODIGO = 20';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
	      V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_CODIGO = 20';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Mediador / Colaborador / API), quizás ya se encuentra eliminado');
      END IF;
      
      -- Actualizar registros existentes.
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (Colaborador)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_DESCRIPCION = ''Colaborador''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
      	  V_SQL := 'SELECT DD_TPR_CODIGO FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TPR_DESCRIPCION = ''Colaborador''';
      	  EXECUTE IMMEDIATE V_SQL INTO V_CODIGO_REGISTRO;
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	                    'SET DD_TPR_DESCRIPCION = ''Mediador / Colaborador / API'''|| 
						', DD_TPR_DESCRIPCION_LARGA = ''Mediador / Colaborador / API'''||
						', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						'WHERE DD_TPR_CODIGO = '''||V_CODIGO_REGISTRO||'''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (Colaborador), quizás ya se encuentra actualizado');
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



   