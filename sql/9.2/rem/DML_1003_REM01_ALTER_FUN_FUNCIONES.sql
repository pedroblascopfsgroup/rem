--/*
--##########################################
--## AUTOR=Sergio Giménez
--## FECHA_CREACION=20190617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6703
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica los literales del campo FUN_DESCRIPCION_LARGA de la tabla FUN_FUNCIONES.
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'FUN_FUNCIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

    V_MSQL := 'UPDATE '''V_ESQUEMA'''.'''V_TEXT_TABLA''' 
        SET FUN_DESCRIPCION_LARGA = '''Pestaña de ciclo de recobro de contrato''', 
        USUARIOMODIFICAR = '''DML''' , 
        FECHAMODIFICAR = SYSDATE 
        WHERE FUN_DESCRIPCION = '''TAB_CICLORECOBRO_CONTRATO''';

    EXECUTE INMEDIATE V_MSQL;

    V_MSQL := UPDATE '''V_ESQUEMA'''.'''V_TEXT_TABLA''' 
        SET FUN_DESCRIPCION_LARGA = '''Pestaña de ciclo de recobro contrato expediente''', 
        USUARIOMODIFICAR = '''DML''' , 
        FECHAMODIFICAR = SYSDATE 
        WHERE FUN_DESCRIPCION = '''TAB_CICLORECOBRO_CNT_EXPEDIENTE''';

    EXECUTE INMEDIATE V_MSQL;

        UPDATE '''V_ESQUEMA'''.'''V_TEXT_TABLA''' 
        SET FUN_DESCRIPCION_LARGA = '''Pestaña de ciclo de recobro persona''', 
        USUARIOMODIFICAR = '''DML''' , 
        FECHAMODIFICAR = SYSDATE 
        WHERE FUN_DESCRIPCION = '''TAB_CICLORECOBRO_PERSONA''';

    EXECUTE INMEDIATE V_MSQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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