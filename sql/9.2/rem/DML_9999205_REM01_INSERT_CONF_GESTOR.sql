--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-5854
--## PRODUCTO=NO
--## Finalidad: Insert en configuracion de la distribución de los gestores
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-5854 
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- Configuracion Tablespace de Indices
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-5854';
    V_COD_CARTERA VARCHAR2(50 CHAR);
    V_COD_ESTADO_ACTIVO VARCHAR2(50 CHAR);
    V_COD_TIPO_COMERZIALZACION VARCHAR2(50 CHAR);
    V_COD_PROVINCIA VARCHAR2(50 CHAR);
    V_COD_MUNICIPIO VARCHAR2(50 CHAR);
    V_COD_POSTAL VARCHAR2(50 CHAR);
   	V_COUNT NUMBER(7) := 0;
    TYPE T_GESTOR IS TABLE OF VARCHAR2(50 CHAR);
    TYPE T_CONFIG IS TABLE OF T_GESTOR;
    T_ARRAY T_CONFIG := T_CONFIG (
    		T_GESTOR('GFORMADM', 'NULL', 'NULL', 'NULL', '8', 'NULL', 'NULL', 'gruforadmto'),
    		T_GESTOR('GFORMADM', 'NULL', 'NULL', 'NULL', '17', 'NULL', 'NULL', 'gruforadmto'),
    		T_GESTOR('GFORMADM', 'NULL', 'NULL', 'NULL', '43', 'NULL', 'NULL', 'gruforadmto'),
    		T_GESTOR('GFORMADM', 'NULL', 'NULL', 'NULL', '25', 'NULL', 'NULL', 'gruforadmto')
    	);
   	V_GESTOR T_GESTOR;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[START]');

	FOR I IN T_ARRAY.FIRST .. T_ARRAY.LAST
	LOOP
		V_GESTOR := T_ARRAY(I);
        
        V_MSQL := 'SELECT NVL2('||V_GESTOR(2)||', '' = '||V_GESTOR(2)||''', ''IS NULL'')
                , NVL2('||V_GESTOR(3)||', '' = '||V_GESTOR(3)||''', ''IS NULL'')
                , NVL2('||V_GESTOR(4)||', '' = '||V_GESTOR(4)||''', ''IS NULL'')
                , NVL2('||V_GESTOR(5)||', '' = '||V_GESTOR(5)||''', ''IS NULL'')
                , NVL2('||V_GESTOR(6)||', '' = '||V_GESTOR(6)||''', ''IS NULL'')
                , NVL2('||V_GESTOR(7)||', '' = '||V_GESTOR(7)||''', ''IS NULL'')
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_CARTERA, V_COD_ESTADO_ACTIVO, V_COD_TIPO_COMERZIALZACION
            , V_COD_PROVINCIA, V_COD_MUNICIPIO, V_COD_POSTAL;
        
        V_MSQL := '
            MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES CNF
            USING (
                SELECT '''||V_GESTOR(1)||''' TIPO_GESTOR, '||V_GESTOR(2)||' COD_CARTERA, '||V_GESTOR(3)||' COD_ESTADO_ACTIVO
                    , '||V_GESTOR(4)||' COD_TIPO_COMERZIALZACION, '||V_GESTOR(5)||' COD_PROVINCIA
                    , '||V_GESTOR(6)||' COD_MUNICIPIO, '||V_GESTOR(7)||' COD_POSTAL, USU.USU_USERNAME USERNAME
                    , USU.USU_NOMBRE || '' '' || USU.USU_APELLIDO1 || '' '' || USU.USU_APELLIDO2 NOMBRE_USUARIO
                    , '''||V_USUARIO||''' USUARIO, SYSDATE FECHA
                FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
                WHERE USU.USU_USERNAME = '''||V_GESTOR(8)||'''
                ) T2
            ON (CNF.TIPO_GESTOR = T2.TIPO_GESTOR AND CNF.COD_CARTERA '||V_COD_CARTERA||'
				AND CNF.COD_ESTADO_ACTIVO '||V_COD_ESTADO_ACTIVO||' AND CNF.COD_TIPO_COMERZIALZACION '||V_COD_TIPO_COMERZIALZACION||' 
                AND CNF.COD_PROVINCIA '||V_COD_PROVINCIA||' AND CNF.COD_MUNICIPIO '||V_COD_MUNICIPIO||' 
                AND CNF.COD_POSTAL '||V_COD_POSTAL||')
            WHEN MATCHED THEN UPDATE SET
                CNF.USERNAME = T2.USERNAME, CNF.NOMBRE_USUARIO = T2.NOMBRE_USUARIO
                , CNF.USUARIOMODIFICAR = T2.USUARIO, CNF.FECHAMODIFICAR = T2.FECHA
            WHERE NVL(CNF.USERNAME,0) <> T2.USERNAME AND NVL(CNF.NOMBRE_USUARIO,0) <> T2.NOMBRE_USUARIO
            WHEN NOT MATCHED THEN INSERT (
                CNF.ID, CNF.TIPO_GESTOR, CNF.COD_CARTERA, CNF.COD_ESTADO_ACTIVO
                , CNF.COD_TIPO_COMERZIALZACION, CNF.COD_PROVINCIA, CNF.COD_MUNICIPIO, CNF.COD_POSTAL
                , CNF.USERNAME, CNF.NOMBRE_USUARIO, CNF.USUARIOCREAR, CNF.FECHACREAR)
            VALUES (
                '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, T2.TIPO_GESTOR, T2.COD_CARTERA, T2.COD_ESTADO_ACTIVO
                , T2.COD_TIPO_COMERZIALZACION, T2.COD_PROVINCIA, T2.COD_MUNICIPIO, T2.COD_POSTAL
                , T2.USERNAME, T2.NOMBRE_USUARIO, T2.USUARIO, T2.FECHA
                )
            ';
        EXECUTE IMMEDIATE V_MSQL;
		V_COUNT := V_COUNT + SQL%ROWCOUNT;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('  [INFO] ' ||V_COUNT|| ' registros de configuración de gestores fusionados');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[END]');

EXCEPTION
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('KO!');
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
		DBMS_OUTPUT.PUT_LINE(ERR_MSG);
        DBMS_OUTPUT.PUT_LINE('[ERROR] Query errónea: '||V_MSQL);
		ROLLBACK;
		RAISE;          
END;
/
EXIT