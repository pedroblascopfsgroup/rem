--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20212003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15353
--## PRODUCTO=NO
--##
--## Finalidad: Merge para insertar la configuración de cuentas y partidas de la subcartera Jaguar
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
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-15353'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP act
				using ( 
 
 
                SELECT  DISTINCT
                    act2.CPP_PTDAS_ID,
                    act2.CPP_PARTIDA_PRESUPUESTARIA,
                    act2.DD_TGA_ID,
                    act2.DD_STG_ID,
                    act2.DD_TIM_ID,
                    act2.DD_CRA_ID,
                    act2.DD_SCR_ID,
                    act2.PRO_ID,
                    act2.EJE_ID,
                    act2.CPP_ARRENDAMIENTO,
                    act2.CPP_REFACTURABLE,
                    act2.CPP_PRINCIPAL,
                    act2.DD_TBE_ID,
                    act2.CPP_APARTADO,
                    act2.CPP_CAPITULO,
                    act2.CPP_ACTIVABLE,
                    act2.CPP_PLAN_VISITAS,
                    act2.DD_TCH_ID,
                    act2.DD_TRT_ID,
                    act2.CPP_VENDIDO,
                    scr.DD_SCR_CODIGO,
                    act2.VERSION,
                    act2.BORRADO
                    FROM '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP act2                
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_ID = act2.DD_SCR_ID AND scr.DD_SCR_CODIGO = ''138''
                    WHERE  NOT EXISTS (
                        SELECT 1 
                        FROM '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP act3 
                        WHERE act3.DD_SCR_ID= (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''70''))
                        AND act2.BORRADO = 0  
                         AND act2.PRO_ID=(SELECT PRO.PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO_DOCIDENTIF=''A88203542'')              
                        
                        ) us ON (us.CPP_PTDAS_ID = act.CPP_PTDAS_ID AND us.DD_SCR_CODIGO = ''70'')
                                                
                    WHEN NOT MATCHED THEN
                    INSERT      (
                                CPP_PTDAS_ID,
                                CPP_PARTIDA_PRESUPUESTARIA,
                                DD_TGA_ID,
                                DD_STG_ID,
                                DD_TIM_ID,
                                DD_CRA_ID,
                                DD_SCR_ID,
                                PRO_ID,
                                EJE_ID,
                                CPP_ARRENDAMIENTO,
                                CPP_REFACTURABLE,
                                CPP_PRINCIPAL,
                                DD_TBE_ID,
                                CPP_APARTADO,
                                CPP_CAPITULO,
                                CPP_ACTIVABLE,
                                CPP_PLAN_VISITAS,
                                DD_TCH_ID,
                                DD_TRT_ID,
                                CPP_VENDIDO, 
                                BORRADO,
                                VERSION,                              
                                USUARIOCREAR,
                                FECHACREAR
                                )
                                
                            VALUES ('||V_ESQUEMA||'.S_ACT_CONFIG_PTDAS_PREP.NEXTVAL,                               
                                    
                                    
                                    us.CPP_PARTIDA_PRESUPUESTARIA,
                                    us.DD_TGA_ID,
                                    us.DD_STG_ID,
                                    us.DD_TIM_ID,
                                    us.DD_CRA_ID,
                                    (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''70''),
                                    (SELECT PRO.PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO_DOCIDENTIF=''B16896616''),
                                    us.EJE_ID,
                                    us.CPP_ARRENDAMIENTO,
                                    us.CPP_REFACTURABLE,
                                    us.CPP_PRINCIPAL,
                                    us.DD_TBE_ID,
                                    us.CPP_APARTADO,
                                    us.CPP_CAPITULO,
                                    us.CPP_ACTIVABLE,
                                    us.CPP_PLAN_VISITAS,
                                    us.DD_TCH_ID,
                                    us.DD_TRT_ID,
                                    us.CPP_VENDIDO,  
                                    0,                                
                                    0,                                  
                                    '''||V_USUARIO||''',
                                    sysdate)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_CONFIG_PTDAS_PREP');  



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
