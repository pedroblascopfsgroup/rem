--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8208
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
    V_TABLA_GESTORES VARCHAR( 100 CHAR ) := 'ACT_GES_DIST_GESTORES';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8208'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_USERNAME VARCHAR2(50 CHAR):= 'tecnotra01';
    V_USU_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                --  COD_SCR     SUBCARTERA
        T_TIPO_DATA('133','Zeus - Inmobiliario'), 
        T_TIPO_DATA('134','Zeus - Financiero'), 
        T_TIPO_DATA('138','Apple - Inmobiliario'), 
        T_TIPO_DATA('17','INMOBILIARIO') 
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR CONFIGURACION TECNOTRAMIT');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GESTORES||' SET
		        BORRADO = 1, USUARIOBORRAR = '''||V_USUARIO||''', FECHABORRAR = SYSDATE
                WHERE USERNAME = '''||V_USERNAME||''' AND COD_CARTERA = ''7''
                AND TIPO_GESTOR = ''GGADM''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS'); 

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR GESTORIA ADMISION TECNOTRAMIT PARA CERBERUS, EXCEPTO DIVARIAN');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GESTORES||' (ID, TIPO_GESTOR, COD_CARTERA, USERNAME,
                    NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, COD_SUBCARTERA)
                    SELECT S_'||V_TABLA_GESTORES||'.NEXTVAL, ''GGADM'', ''7'', '''||V_USERNAME||''',
                    (SELECT USU_NOMBRE || USU_APELLIDO1 || USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||''' AND BORRADO = 0),
                    '''||V_USUARIO||''',SYSDATE, '''||V_TMP_TIPO_DATA(1)||''' FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] CONFIGURACION AÑADIDA GESTORIA ADMISION TECNOTRAMIT PARA '||V_TMP_TIPO_DATA(2)||'');

    END LOOP;   

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS GESTORIA ADMISION TECNOTRAMIT PARA CERBERUS, EXCEPTO DIVARIAN');

    V_MSQL :=   'SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] PONER FECHA FIN TECNOTRAMIT DE GESTORIA ADMISION PARA DIVARIAN'); 

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1 USING(
                    SELECT GEH.GEH_ID FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH 
                    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAH.ACT_ID AND ACT.BORRADO = 0
                    WHERE ACT.DD_SCR_ID IN (443,444) AND GEH.DD_TGE_ID = 369 AND GEH.BORRADO = 0 
                    AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.USU_ID = '|| V_USU_ID ||') T2
                ON (T1.GEH_ID = T2.GEH_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.GEH_FECHA_HASTA = SYSDATE,		     
                T1.FECHAMODIFICAR = SYSDATE,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS PONIENDO FECHA FIN HOY A TECNOTRAMIT DE GESTORIA ADMISION PARA DIVARIAN');  

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR REGISTRO TECNOTRAMIT DE GESTORIA ADMISION PARA DIVARIAN'); 

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1 USING(
                    SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
                    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID AND ACT.BORRADO = 0
                    WHERE ACT.DD_SCR_ID IN (443,444) AND GEE.DD_TGE_ID = 369 AND GEE.BORRADO = 0 
                    AND GEE.USU_ID = '|| V_USU_ID ||') T2
                ON (T1.GEE_ID = T2.GEE_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.BORRADO = 1,	     
                T1.FECHABORRAR = SYSDATE,
                T1.USUARIOBORRAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS');  

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
