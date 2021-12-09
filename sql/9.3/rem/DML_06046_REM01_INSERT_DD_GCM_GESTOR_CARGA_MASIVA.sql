--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10784
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar config para carga masiva gestores
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
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10784';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_GCM_GESTOR_CARGA_MASIVA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--DD_CRA_CODIGO
				T_TIPO_DATA('18'),
                T_TIPO_DATA('17')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
                WHERE CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA GCM
                        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=GCM.DD_CRA_ID AND CRA.BORRADO = 0
                        WHERE CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND GCM.BORRADO = 0';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN

            V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                        (DD_GCM_ID,DD_GCM_CODIGO,DD_GCM_DESCRIPCION,DD_GCM_DESCRIPCION_LARGA,DD_CRA_ID,DD_GCM_ACTIVO,DD_GCM_EXPEDIENTE,DD_GCM_AGRUPACION,
                        USUARIOCREAR,FECHACREAR) 
                        select '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                        AUX.DD_GCM_CODIGO,
                        AUX.DD_GCM_DESCRIPCION,
                        AUX.DD_GCM_DESCRIPCION_LARGA,
                        (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0),
                        AUX.DD_GCM_ACTIVO,AUX.DD_GCM_EXPEDIENTE,AUX.DD_GCM_AGRUPACION,
                        '''||V_USU||''' AS USUARIOCREAR,
                        SYSDATE AS FECHACREAR
                        from
                            (
                            SELECT distinct GCM.DD_GCM_CODIGO,GCM.DD_GCM_DESCRIPCION,GCM.DD_GCM_DESCRIPCION_LARGA, GCM.DD_CRA_ID,GCM.DD_GCM_ACTIVO,GCM.DD_GCM_EXPEDIENTE,GCM.DD_GCM_AGRUPACION
                            FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' GCM
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=GCM.DD_CRA_ID AND CRA.BORRADO = 0
                            WHERE CRA.DD_CRA_CODIGO=''03'' AND GCM.BORRADO = 0
                            )AUX
                        ';
            EXECUTE IMMEDIATE V_MSQL;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TEXT_TABLA||' PARA CARTERA -> '||V_TMP_TIPO_DATA(1)||' ');

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya hay configuracion para CARTERA -> '||V_TMP_TIPO_DATA(1)||' ');
        END IF;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE CARTERA: '||V_TMP_TIPO_DATA(1)||' ');

	END IF;
        
	END LOOP;

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