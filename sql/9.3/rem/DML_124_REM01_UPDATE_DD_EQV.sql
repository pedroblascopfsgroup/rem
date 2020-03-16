--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9390
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar la columna DD_EEC_DESCRIPCION de la tabla DD_EEC_EST_EXP_COMERCIAL
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EQV_ASPRO_REM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-9390';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_NUM NUMBER(16); -- Vble. auxiliar
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- CODIGO  DESCRIPCION  DESCRIPCION_LARGA 
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('B80775075', '1'),
        T_TIPO_DATA('A81036501', '2'),
        T_TIPO_DATA('B80775075', '0000195'),
        T_TIPO_DATA('A81036501', '0000194')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN
	
	
	 -- Verificar si la tabla ya existe
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  	IF V_NUM_TABLAS = 1 THEN
  	
  	
                DBMS_OUTPUT.PUT_LINE('Actualizar descripción de los estados de los expedientes comerciales de '||V_TEXT_TABLA);
        

                FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
                LOOP
                        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
                        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		        WHERE DD_NOMBRE_ASPRO = ''DD_PROPIETARIO_ASPRO'' AND DD_CODIGO_REM = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';

    	        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	        IF V_NUM = 1 THEN

                        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                            SET DD_CODIGO_ASPRO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
			        		, USUARIOMODIFICAR = '''||V_USUARIO||'''
				        	, FECHAMODIFICAR = SYSDATE
            		        WHERE  DD_NOMBRE_ASPRO = ''DD_PROPIETARIO_ASPRO'' AND DD_CODIGO_REM = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('Actualizado descripción de '||V_TEXT_TABLA);


                END IF;
                END LOOP;
                COMMIT;

    	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO][FIN] NO EXISTE LA TABLA '||V_TEXT_TABLA);
	END IF;
	
	
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