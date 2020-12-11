--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8264
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar gasto que crea conflicto
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8264'; -- USUARIO CREAR/MODIFICAR

    V_GPVTBJ_ID NUMBER(25):= 127223;
    V_GPV_ID NUMBER(25):= 7949583;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_TBJ WHERE GPV_TBJ_ID = '||V_GPVTBJ_ID||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_TBJ SET
                    BORRADO = 1, USUARIOBORRAR = '''||V_USUARIO||''', FECHABORRAR = SYSDATE
                    WHERE GPV_TBJ_ID = '||V_GPVTBJ_ID||'';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO-TRABAJO ELIMINADO');

    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_ID = '||V_GPV_ID||' AND DD_EGA_ID = 12';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN
    
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR SET
                    BORRADO = 1, USUARIOBORRAR = '''||V_USUARIO||''', FECHABORRAR = SYSDATE
                    WHERE GPV_ID = '||V_GPV_ID||' AND DD_EGA_ID = 12';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO ELIMINADO: CREABA CONFLICTO POR ESTADO INCOMPLETO');
    
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');

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