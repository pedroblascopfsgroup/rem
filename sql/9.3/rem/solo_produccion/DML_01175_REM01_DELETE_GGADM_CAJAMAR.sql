--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11559
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tabla config gestores
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-11559'; -- USUARIOCREAR/USUARIOMODIFICAR


    V_USU_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
     V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --          ACT_NUM_ACTIVO_PRINEX
                    T_TIPO_DATA(24006, 'P'),
                    T_TIPO_DATA(55901, 'P'),
                    T_TIPO_DATA(55902, 'P'),
                    T_TIPO_DATA(59905, 'P'),
                    T_TIPO_DATA(59913, 'P'),
                    T_TIPO_DATA(67365, 'P'),
                    T_TIPO_DATA(69020, 'P'),
                    T_TIPO_DATA(71171, 'P'),
                    T_TIPO_DATA(71172, 'P'),
                    T_TIPO_DATA(71173, 'P'),
                    T_TIPO_DATA(71174, 'P'),
                    T_TIPO_DATA(71208, 'P'),
                    T_TIPO_DATA(71211, 'P'),
                    T_TIPO_DATA(71212, 'P'),
                    T_TIPO_DATA(71218, 'P'),
                    T_TIPO_DATA(71220, 'P'),
                    T_TIPO_DATA(71223, 'P'),
                    T_TIPO_DATA(71671, 'P'),
                    T_TIPO_DATA(72056, 'P'),
                    T_TIPO_DATA(73366, 'P'),
                    T_TIPO_DATA(74062, 'P'),
                    T_TIPO_DATA(74437, 'P'),
                    T_TIPO_DATA(75485, 'P'),
                    T_TIPO_DATA(75561, 'P'),
                    T_TIPO_DATA(77331, 'P'),
                    T_TIPO_DATA(77337, 'P'),
                    T_TIPO_DATA(77583, 'P'),
                    T_TIPO_DATA(78822, 'P'),
                    T_TIPO_DATA(79861, 'P'),
                    T_TIPO_DATA(80559, 'P'),
                    T_TIPO_DATA(80582, 'P'),
                    T_TIPO_DATA(83384, 'P'),
                    T_TIPO_DATA(85010, 'P'),
                    T_TIPO_DATA(91869, 'P'),
                    T_TIPO_DATA(91891, 'P'),
                    T_TIPO_DATA(91894, 'P'),
                    T_TIPO_DATA(482, 'P'),
                    T_TIPO_DATA(9049, 'P'),
                    T_TIPO_DATA(10438, 'P'),
                    T_TIPO_DATA(10550, 'P'),
                    T_TIPO_DATA(10736, 'P'),
                    T_TIPO_DATA(10739, 'P'),
                    T_TIPO_DATA(10751, 'P'),
                    T_TIPO_DATA(10766, 'P'),
                    T_TIPO_DATA(10768, 'P'),
                    T_TIPO_DATA(10769, 'P'),
                    T_TIPO_DATA(24664, 'P'),
                    T_TIPO_DATA(24672, 'P'),
                    T_TIPO_DATA(30165, 'P'),
                    T_TIPO_DATA(55898, 'P'),
                    T_TIPO_DATA(57731, 'P'),
                    T_TIPO_DATA(57952, 'P'),
                    T_TIPO_DATA(60466, 'P'),
                    T_TIPO_DATA(60506, 'P'),
                    T_TIPO_DATA(60525, 'P'),
                    T_TIPO_DATA(60544, 'P'),
                    T_TIPO_DATA(66082, 'P'),
                    T_TIPO_DATA(69256, 'P'),
                    T_TIPO_DATA(69340, 'P'),
                    T_TIPO_DATA(69344, 'P'),
                    T_TIPO_DATA(69445, 'P'),
                    T_TIPO_DATA(69554, 'P'),
                    T_TIPO_DATA(74063, 'P'),
                    T_TIPO_DATA(6722536, 'H'),
                    T_TIPO_DATA(6135540, 'H'),
                    T_TIPO_DATA(6135663, 'H'),
                    T_TIPO_DATA(6712381, 'H'),
                    T_TIPO_DATA(7459912, 'H'),
                    T_TIPO_DATA(7465117, 'H')
        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    IF V_TMP_TIPO_DATA(2) = 'P' THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] PONER FECHA FIN DE GESTORIA ADMISION DE ACTIVOS'); 

        V_MSQL :=   'UPDATE GEH_GESTOR_ENTIDAD_HIST T1
                    SET   T1.GEH_FECHA_HASTA = SYSDATE,		     
                        T1.FECHAMODIFICAR = SYSDATE,
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    WHERE T1.GEH_ID = (SELECT DISTINCT GEH.GEH_ID
                        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                        INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID
                        INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''01''
                        INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                        WHERE  ACT_NUM_ACTIVO_PRINEX = '||V_TMP_TIPO_DATA(1)||'
                        AND TGE.DD_TGE_CODIGO = ''GGADM'' AND GEH.GEH_FECHA_HASTA IS NULL)';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEH_GESTOR_ENTIDAD_HIST');  

        V_MSQL :=   'UPDATE GEE_GESTOR_ENTIDAD T1				
                            SET	 T1.BORRADO = 1,	     
                                T1.FECHABORRAR = SYSDATE,
                                T1.USUARIOBORRAR ='''||V_USUARIO||'''
                            WHERE T1.GEE_ID = (SELECT DISTINCT GEE.GEE_ID
                                FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                                INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                                INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID
                                INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''01''
                                INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                                WHERE  ACT_NUM_ACTIVO_PRINEX = '||V_TMP_TIPO_DATA(1)||'
                            AND TGE.DD_TGE_CODIGO = ''GGADM'' AND GEE.BORRADO = 0)';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEE_GESTOR_ENTIDAD'); 

    ELSIF V_TMP_TIPO_DATA(2) = 'H' THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] PONER FECHA FIN DE GESTORIA ADMISION DE ACTIVOS'); 

        V_MSQL :=   'UPDATE GEH_GESTOR_ENTIDAD_HIST T1
                    SET   T1.GEH_FECHA_HASTA = SYSDATE,		     
                        T1.FECHAMODIFICAR = SYSDATE,
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    WHERE T1.GEH_ID = (SELECT DISTINCT GEH.GEH_ID
                        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                        INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                        INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID
                        INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                        INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                        WHERE  ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
                        AND TGE.DD_TGE_CODIGO = ''GGADM'' AND GEH.GEH_FECHA_HASTA IS NULL)';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEH_GESTOR_ENTIDAD_HIST');  

        V_MSQL :=   'UPDATE GEE_GESTOR_ENTIDAD T1				
                            SET	 T1.BORRADO = 1,	     
                                T1.FECHABORRAR = SYSDATE,
                                T1.USUARIOBORRAR ='''||V_USUARIO||'''
                            WHERE T1.GEE_ID = (SELECT DISTINCT GEE.GEE_ID
                                FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                                INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                                INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID
                                INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                                INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                                WHERE  ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
                            AND TGE.DD_TGE_CODIGO = ''GGADM'' AND GEE.BORRADO = 0)';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEE_GESTOR_ENTIDAD'); 

    END IF;

    END LOOP;   


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