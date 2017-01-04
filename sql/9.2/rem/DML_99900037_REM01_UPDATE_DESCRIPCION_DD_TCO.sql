--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1309
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza descripciones del diccionario de TIPO DE COMERCIALIZACION
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
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --TABLA PARA ACTUALIZAR
    V_TCO_TABLA VARCHAR2(1000 CHAR) := '';

    --REGISTRO ELEGIDO
    V_TCO_CODIGO_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TCO_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO PARA ACTUALIZAR
    V_TCO_CAMPO_1 VARCHAR2(100 CHAR)  := '';
    V_TCO_CAMPO_2 VARCHAR2(100 CHAR)  := '';
    V_TCO_VALOR VARCHAR2(1000 CHAR) := '';


BEGIN 
  
	DBMS_OUTPUT.PUT_LINE('[INICIO] Cambio del registro "Solo Alquiler" a "Alquiler"');

	--ACTUALIZACION DE VALORES DE DICCIONARIO TIPO COMERCIALIZACION 
	V_TCO_TABLA := 'DD_TCO_TIPO_COMERCIALIZACION';
	V_TCO_CODIGO_CAMPO := 'DD_TCO_CODIGO';
	V_TCO_CAMPO_1 := 'DD_TCO_DESCRIPCION';
	V_TCO_CAMPO_2 := 'DD_TCO_DESCRIPCION_LARGA';

	V_TCO_CODIGOS := ' ''03'' ';
	V_TCO_VALOR := 'Alquiler';
	
  
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TCO_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
	IF V_NUM_TABLAS > 0 THEN
  		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE LOS REGISTROS');

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TCO_TABLA||'
		             SET '||V_TCO_CAMPO_1||'='''||V_TCO_VALOR||'''
					 , '||V_TCO_CAMPO_2||'='''||V_TCO_VALOR||'''
		             ,FECHAMODIFICAR = sysdate
		             ,USUARIOMODIFICAR = ''REM_F2''
		             WHERE '||V_TCO_CODIGO_CAMPO||' IN ('||V_TCO_CODIGOS||')
		             ';
		
		DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');
	END IF;

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
