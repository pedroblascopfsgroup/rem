--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17287
--## PRODUCTO=NO
--##
--## Finalidad: Merge para insertar la configuración de las tarifas de la subcartera MACC Marina
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

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA act
				using ( 
 
 
 SELECT  DISTINCT
                    cft.CFT_ID,
                    cft.DD_TTF_ID,
                    cft.DD_TTR_ID,
                    cft.DD_STR_ID,
                    cft.DD_CRA_ID,
                    cft.CFT_PRECIO_UNITARIO,
                    cft.CFT_UNIDAD_MEDIDA,
                    cft.PVE_ID,
                    cft.DD_SCR_ID,
                    cft.CFT_FECHA_INI,
                    cft.CFT_FECHA_FIN,
                    cft.CFT_PRECIO_UNITARIO_CLIENTE,
                    cft.CFT_TARIFA_PVE,
                    scr.DD_SCR_CODIGO,
                    cft.VERSION,
                    cft.BORRADO
                    FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA cft                
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_ID = cft.DD_SCR_ID AND scr.DD_SCR_CODIGO = ''152''
                    WHERE  NOT EXISTS (
                        SELECT 1 
                        FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA cft2 
                        WHERE cft2.DD_SCR_ID= (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''71''))                
                        
                        ) us ON (us.CFT_ID = act.CFT_ID AND us.DD_SCR_CODIGO = ''71'')
                                                
                    WHEN NOT MATCHED THEN
                    INSERT      (
                                CFT_ID,
                                DD_TTF_ID,
                                DD_TTR_ID,
                                DD_STR_ID,
                                DD_CRA_ID,
                                CFT_PRECIO_UNITARIO,
                                CFT_UNIDAD_MEDIDA,
                                VERSION,
                                USUARIOCREAR,
                                FECHACREAR,
                                BORRADO,
                                PVE_ID,
                                DD_SCR_ID,
                                CFT_FECHA_INI,
                                CFT_FECHA_FIN,
                                CFT_PRECIO_UNITARIO_CLIENTE,
                                CFT_TARIFA_PVE
                                )
                                
                            VALUES ('||V_ESQUEMA||'.S_ACT_CFT_CONFIG_TARIFA.NEXTVAL,                               
                                    us.DD_TTF_ID,
                                    us.DD_TTR_ID,
                                    us.DD_STR_ID,
                                    us.DD_CRA_ID,
                                    us.CFT_PRECIO_UNITARIO,
                                    us.CFT_UNIDAD_MEDIDA,
                                    us.VERSION,                                  
                                    '''||V_USUARIO||''',
                                    sysdate,
                                    us.BORRADO,
                                    us.PVE_ID,
                                    (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''71''),
                                    us.CFT_FECHA_INI,
                                    us.CFT_FECHA_FIN,
                                    us.CFT_PRECIO_UNITARIO_CLIENTE,
                                    us.CFT_TARIFA_PVE)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_CFT_CONFIG_TARIFA');  



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
