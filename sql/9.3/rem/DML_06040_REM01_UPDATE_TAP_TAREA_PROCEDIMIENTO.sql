--/*
--##########################################
--## AUTOR=Julián Dolz
--## FECHA_CREACION=20211111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16314
--## PRODUCTO=NO
--##
--## Finalidad: Modificar decisión 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_TMP VARCHAR2(50 CHAR) := 'TMP_TAP_PROCEDIMIENTO_CAIXABANK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16314'; -- Usuario modificar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
	    T_TIPO_DATA('T018_AnalisisBc','valores[''''T018_AnalisisBc''''][''''comboResultado'''']')
    );          
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||
				'TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN
    --Update

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                    SET TAP_SCRIPT_DECISION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
                    ', USUARIOMODIFICAR = '''||V_USUARIO||''' '||
                    ', FECHAMODIFICAR = SYSDATE '||
                    'WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        
    EXECUTE IMMEDIATE V_MSQL;
    
    ELSE
    --Insert
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '||TRIM(V_TMP_TIPO_DATA(1))||' NO EXISTE');
    END IF;

    END LOOP;

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
