--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8385
--## PRODUCTO=NO
--##
--## Finalidad: Modificar items tarea 'T001_CheckingInformacion'
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8385'; -- USUARIO CREAR/MODIFICAR
    V_TAP VARCHAR2(100 CHAR) := 'T001_CheckingInformacion';
    V_NOMBRE VARCHAR2(20 CHAR) := 'INFOREG';
    V_LABEL VARCHAR2(100 CHAR) := 'ACTIVO > T&iacute;tulo e Informaci&oacute;n Registral';

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP||''' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET
                    TFI_NOMBRE = '''||V_NOMBRE||''',
                    TFI_LABEL = '''||V_LABEL||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP||''' AND BORRADO = 0)
                    AND TFI_TIPO = ''elcactivo''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO EL NOMBRE DEL ENLACE');

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET
                    TFI_LABEL = ''<p style="margin-bottom: 10px">Para dar por completada esta tarea, deber&aacute; verificar que se han cumplimentado todos los 
                    campos b&aacute;sicos de la pesta&ntilde;a "T&iacute;tulo e Informaci&oacute;n Registral" del activo, anotando a continuaci&oacute;n en la 
                    presente pantalla la fecha en que ha cumplimentado y verificado la informaci&oacute;n b&aacute;sica del activo.</p><p style="margin-bottom: 10px">
                    En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>'',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP||''' AND BORRADO = 0)
                    AND TFI_TIPO = ''label''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO EL TÍTULO DEL FORMULARIO');

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA TAREA');

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