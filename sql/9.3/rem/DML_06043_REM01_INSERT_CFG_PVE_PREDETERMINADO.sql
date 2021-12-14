--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10729
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar config proveedores
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10729';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);

    V_BFA VARCHAR2(100 CHAR):='17';
    V_BFA_SUB VARCHAR2(100 CHAR):='07';

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--CRA	SCR	
				T_TIPO_DATA('18','162'),
                T_TIPO_DATA('18','163'),
                T_TIPO_DATA('03','160')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
                JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID=CRA.DD_CRA_ID AND SCR.BORRADO = 0
                WHERE CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                        JOIN '||V_ESQUEMA||'.CFG_PVE_PREDETERMINADO CFG ON CFG.PVE_ID=PVE.PVE_ID AND CFG.BORRADO = 0
                        JOIN '||V_ESQUEMA_M||'.dd_prv_provincia PRV ON PRV.DD_PRV_ID=CFG.DD_PRV_ID AND PRV.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=CFG.DD_CRA_ID AND CRA.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=CFG.DD_SCR_ID AND SCR.BORRADO = 0
                        WHERE CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' ';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN

            V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CPP_ID,DD_CRA_ID,DD_SCR_ID,DD_TTR_ID,DD_STR_ID,PVE_ID,USUARIOCREAR,FECHACREAR,DD_PRV_ID) 
                        select '||V_ESQUEMA||'.S_CFG_PVE_PREDETERMINADO.NEXTVAL,
                        (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0),
                        (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' AND BORRADO = 0),
                        AUX.DD_TTR_ID,AUX.DD_STR_ID,AUX.PVE_ID,
                        '''||V_USU||''' AS USUARIOCREAR,
                        SYSDATE AS FECHACREAR,
                        AUX.DD_PRV_ID 
                        from
                            (
                            SELECT distinct CFG.DD_CRA_ID,CFG.DD_SCR_ID, cfg.dd_ttr_id, cfg.dd_str_id, cfg.pve_id, cfg.dd_prv_id FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                            JOIN '||V_ESQUEMA||'.CFG_PVE_PREDETERMINADO CFG ON CFG.PVE_ID=PVE.PVE_ID AND CFG.BORRADO = 0
                            JOIN '||V_ESQUEMA_M||'.dd_prv_provincia PRV ON PRV.DD_PRV_ID=CFG.DD_PRV_ID AND PRV.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=CFG.DD_CRA_ID AND CRA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=CFG.DD_SCR_ID AND SCR.BORRADO = 0
                            WHERE SCR.DD_SCR_CODIGO = ''08''
                            )AUX
                        ';
            EXECUTE IMMEDIATE V_MSQL;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TEXT_TABLA||' PARA CARTERA -> '||V_TMP_TIPO_DATA(1)||' SUBCARTERA -> '||V_TMP_TIPO_DATA(2)||'');

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya hay configuracion para CARTERA -> '||V_TMP_TIPO_DATA(1)||' SUBCARTERA -> '||V_TMP_TIPO_DATA(2)||'');
        END IF;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE CARTERA/SUBCARTERA O NO COINCIDE LA RELACION ENTRE CARTERA Y SUBCARTERA. CARTERA: '||V_TMP_TIPO_DATA(1)||' SUBCARTERA: '||V_TMP_TIPO_DATA(2)||'');

	END IF;
        
	END LOOP;

    V_NUM_TABLAS := 0;

    V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.CFG_PVE_PREDETERMINADO CFG
    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=CFG.DD_CRA_ID AND CRA.BORRADO = 0
    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=CFG.DD_SCR_ID AND SCR.BORRADO = 0
    WHERE CRA.DD_CRA_CODIGO='''||V_BFA||''' AND SCR.DD_SCR_CODIGO='''||V_BFA_SUB||'''
    ';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza la configuracion de BFA para que sea CARTERA -> BFA, SUBCARTERA -> BFA');

            --Actualizamos configuracion para BFA
        V_MSQL:= 'UPDATE '||V_ESQUEMA||'.CFG_PVE_PREDETERMINADO SET
        DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE BORRADO = 0 AND DD_CRA_CODIGO= '''||V_BFA||''' ),
        USUARIOMODIFICAR = '''|| V_USU ||''',
        FECHAMODIFICAR = SYSDATE
        WHERE DD_CRA_ID = (SELECT DD_cRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO=''03'' ) 
        AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_BFA_SUB||''') ';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada configuracion para BFA correctamente, actualizados '||SQL%ROWCOUNT||' ');

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya hay configuracion para BFA');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

EXIT;