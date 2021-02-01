--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8569
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualización de config y cuentas contables
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8569'; --Vble. auxiliar para almacenar el usuario

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR CONFIG CUENTAS CONTABLES');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.CPS_CONFIG_SUBPTDAS_PRE SET 
                CPS_CUENTA_CONTABLE = 6311000,
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE
                WHERE CPS_DESCRIPCION = ''IBI EJERCICIOS ANTERIORES''';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADA ''IBI EJERCICIOS ANTERIORES''');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.CPS_CONFIG_SUBPTDAS_PRE SET 
                CPS_CUENTA_CONTABLE = 6311003,
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE
                WHERE CPS_DESCRIPCION = ''IBI EJERCICIO ANTERIOR''';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADA ''IBI EJERCICIO ANTERIOR''');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES SET 
                CCC_CUENTA_CONTABLE = 6311003,
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE
                WHERE CCC_CUENTA_CONTABLE = ''6311000''';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADA CUENTAS '||SQL%ROWCOUNT||' ''IBI EJERCICIO ANTERIOR''');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES SET 
                CCC_CUENTA_CONTABLE = 6311000,
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE
                WHERE CCC_CUENTA_CONTABLE = ''6311003''
                AND EJE_ID != 70';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADA CUENTAS '||SQL%ROWCOUNT||' ''IBI EJERCICIOS ANTERIORES''');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
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
EXIT