--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6720
--## PRODUCTO=NO
--##
--## Finalidad: Modificar estado alquilar y check subrogado
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6720'; -- USUARIO CREAR/MODIFICAR

    V_ACTIVO1 NUMBER(25):= 131598; --LIBRE (ID 1) Y NO SUBROGADO
    V_ACTIVO2 NUMBER(25):= 177262; --ALQUILADO (ID 2) Y SUBROGADO
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO1||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO SET
                    DD_EAL_ID = 1, CHECK_SUBROGADO = 0,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO1||')
                    AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO MODIFICADO');

    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO2||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO SET
                    DD_EAL_ID = 2, CHECK_SUBROGADO = 1,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO2||')
                    AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO MODIFICADO');

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