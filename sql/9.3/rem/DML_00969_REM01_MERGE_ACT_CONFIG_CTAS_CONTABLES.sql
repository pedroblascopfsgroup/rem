--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17287
--## PRODUCTO=NO
--##
--## Finalidad: Merge para insertar la configuración de cuentas y partidas de la subcartera MACC_MARINA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-17287'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES act
				using ( 
 
                SELECT  DISTINCT
                    act2.CCC_CTAS_ID,
                    act2.CCC_CUENTA_CONTABLE,
                    act2.DD_TGA_ID,
                    act2.DD_STG_ID,
                    act2.DD_TIM_ID,
                    act2.DD_CRA_ID,
                    act2.DD_SCR_ID,
                    act2.PRO_ID,
                    act2.EJE_ID,
                    act2.CCC_ARRENDAMIENTO,
                    act2.CCC_REFACTURABLE,
                    act2.DD_TBE_ID,
                    act2.CCC_SUBCUENTA_CONTABLE,
                    act2.CCC_ACTIVABLE,
                    act2.CCC_PLAN_VISITAS,
                    act2.DD_TCH_ID,
                    act2.CCC_PRINCIPAL,
                    act2.DD_TRT_ID,
                    act2.CCC_VENDIDO,
                    scr.DD_SCR_CODIGO,
                    act2.VERSION,
                    act2.BORRADO
                    FROM '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES act2                
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_ID = act2.DD_SCR_ID AND scr.DD_SCR_CODIGO = ''138''
                    WHERE  NOT EXISTS (
                        SELECT 1 
                        FROM '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES act3 
                        WHERE act3.DD_SCR_ID= (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''71''))                
                        
                        ) us ON (us.CCC_CTAS_ID = act.CCC_CTAS_ID AND us.DD_SCR_CODIGO = ''71'')
                                                
                    WHEN NOT MATCHED THEN
                    INSERT      (
                                CCC_CTAS_ID,
                                CCC_CUENTA_CONTABLE,
                                DD_TGA_ID,
                                DD_STG_ID,
                                DD_TIM_ID,
                                DD_CRA_ID,
                                DD_SCR_ID,
                                PRO_ID,
                                EJE_ID,
                                CCC_ARRENDAMIENTO,
                                CCC_REFACTURABLE,
                                DD_TBE_ID,
                                CCC_SUBCUENTA_CONTABLE,
                                CCC_ACTIVABLE,
                                CCC_PLAN_VISITAS,
                                DD_TCH_ID,
                                CCC_PRINCIPAL,
                                DD_TRT_ID,
                                CCC_VENDIDO,                               
                                BORRADO,
                                VERSION,
                                USUARIOCREAR,
                                FECHACREAR)
                                
                            VALUES ('||V_ESQUEMA||'.S_ACT_CONFIG_CTAS_CONTABLES.NEXTVAL,
                                    us.CCC_CUENTA_CONTABLE,
                                    us.DD_TGA_ID,
                                    us.DD_STG_ID,
                                    us.DD_TIM_ID,
                                    us.DD_CRA_ID,
                                    (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''71''),
                                    us.PRO_ID,
                                    us.EJE_ID,
                                    us.CCC_ARRENDAMIENTO,
                                    us.CCC_REFACTURABLE,
                                    us.DD_TBE_ID,
                                    us.CCC_SUBCUENTA_CONTABLE,
                                    us.CCC_ACTIVABLE,
                                    us.CCC_PLAN_VISITAS,
                                    us.DD_TCH_ID,
                                    us.CCC_PRINCIPAL,
                                    us.DD_TRT_ID,
                                    us.CCC_VENDIDO,
                                    us.BORRADO,
                                    us.VERSION,                                  
                                    '''||V_USUARIO||''',
                                    sysdate)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_CONFIG_CTAS_CONTABLES');  



    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
