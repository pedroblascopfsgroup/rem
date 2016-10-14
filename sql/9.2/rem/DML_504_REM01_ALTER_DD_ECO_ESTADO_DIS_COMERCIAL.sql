--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_ECO_ESTADO_DIS_COMERCIAL los datos necesarios.
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ECO_ESTADO_DIS_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

      -- Actualizar registros existentes.
      DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar registro existente (No condicionado)');
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_ECO_DESCRIPCION = ''No condicionado'' AND DD_ECO_CODIGO = ''02''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      IF V_NUM_REGISTRO > 0 THEN
	      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	                    'SET DD_ECO_DESCRIPCION = ''Disponible'''|| 
						', DD_ECO_DESCRIPCION_LARGA = ''Disponible'''||
						', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
						'WHERE DD_ECO_CODIGO = ''02''';
	      EXECUTE IMMEDIATE V_MSQL;
	  ELSE
	      DBMS_OUTPUT.PUT_LINE('[INFO]: No se ha encontrado el registro (No condicionado), quizás ya se encuentra actualizado');
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



   