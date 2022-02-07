--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15352
--## PRODUCTO=NO
--##
--## Finalidad: Merge para insertar los gestores de la subcartera Jaguar
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
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-15352'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES ges
				using (

                    SELECT  DISTINCT
                    act.ID,
                    act.TIPO_GESTOR,
                    act.COD_CARTERA,
                    act.COD_ESTADO_ACTIVO,
                    act.COD_TIPO_COMERZIALZACION,
                    act.COD_PROVINCIA,
                    act.COD_MUNICIPIO,
                    act.COD_POSTAL,
                    act.USERNAME,
                    act.NOMBRE_USUARIO,
                    act.BORRADO,
                    act.COD_SUBCARTERA,
                    act.TIPO_ACTIVO,
                    act.SUBTIPO_ACTIVO,
                    act.TIPO_ALQUILER
                    FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES act
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = act.COD_SUBCARTERA AND scr.DD_SCR_CODIGO = ''138''
                    WHERE  NOT EXISTS (
                        SELECT 1 
                        FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES ges2 
                        WHERE ges2.COD_SUBCARTERA=70)


                    ) us ON (us.ID = ges.ID AND us.COD_SUBCARTERA = 70)
                                                
                    WHEN NOT MATCHED THEN
                    INSERT      (ID,
                                TIPO_GESTOR,
                                COD_CARTERA,
                                COD_ESTADO_ACTIVO,
                                COD_TIPO_COMERZIALZACION,
                                COD_PROVINCIA,
                                COD_MUNICIPIO,
                                COD_POSTAL,
                                USERNAME,
                                NOMBRE_USUARIO,
                                BORRADO,
                                COD_SUBCARTERA,
                                TIPO_ACTIVO,
                                SUBTIPO_ACTIVO,
                                TIPO_ALQUILER,
                                USUARIOCREAR,
                                FECHACREAR
                                )
                                
                            VALUES ('||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
                                    us.TIPO_GESTOR,
                                    us.COD_CARTERA,
                                    us.COD_ESTADO_ACTIVO,
                                    us.COD_TIPO_COMERZIALZACION,
                                    us.COD_PROVINCIA,
                                    us.COD_MUNICIPIO,
                                    us.COD_POSTAL,
                                    us.USERNAME,
                                    us.NOMBRE_USUARIO,
                                    us.BORRADO,
                                    70,
                                    us.TIPO_ACTIVO,
                                    us.SUBTIPO_ACTIVO,
                                    us.TIPO_ALQUILER,
                                    '''||V_USUARIO||''',
                                    sysdate)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_GES_DIST_GESTORES');  



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
