--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15234
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica unidad inferior
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_UPO_UNID_POBLACIONAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'HREOS-15234'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    V_LOC_CODIGO VARCHAR2(30 CHAR) := '07006';
    V_TEXT_TABLA2  VARCHAR2(27 CHAR) := 'DD_LOC_LOCALIDAD';
    V_LOC_ID NUMBER(16) := 0;
    
 



BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    V_MSQL:= 'SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA2||' WHERE DD_LOC_CODIGO = '''||V_LOC_CODIGO||'''
					AND BORRADO = 0';
     EXECUTE IMMEDIATE V_MSQL INTO V_LOC_ID;               

    IF V_LOC_ID != 0 THEN

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE DD_LOC_ID = '''||V_LOC_ID||'''
					AND DD_UPO_DESCRIPCION = ''ARTA'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT != 0 THEN

		V_MSQL:= 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' SET DD_UPO_DESCRIPCION = ''ARTÀ''
                        ,DD_UPO_DESCRIPCION_LARGA = ''ARTÀ''
                        ,USUARIOMODIFICAR = '''|| TRIM(V_USU)||'''
                        ,FECHAMODIFICAR = SYSDATE
					    WHERE DD_LOC_ID = '''||V_LOC_ID||''' AND DD_UPO_DESCRIPCION = ''ARTA'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS LOS REGISTROS  EN '||V_TEXT_TABLA||' CON EL NOMBRE DE ''ARTÀ''');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL REGISTRO CON DESCRIPCION ''ARTA'' EN '||V_TEXT_TABLA||' ');

	END IF;
	ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL REGISTRO '||V_LOC_CODIGO||'  EN '||V_TEXT_TABLA2||' ');
    
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