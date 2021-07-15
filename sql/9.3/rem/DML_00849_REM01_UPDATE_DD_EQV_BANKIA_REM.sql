--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14265
--## PRODUCTO=NO
--## 
--## Finalidad: Modificar reglas en la tabla DD_EQV_BANKIA_REM

--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14265';
    V_TABLA_BANKIA VARCHAR2(100 CHAR):= 'DD_EQV_BANKIA_REM';
    V_DESCRIPCION_BNK VARCHAR(100 CHAR);
    V_DESCRIPCION_REM VARCHAR(100 CHAR);
    V_CODIGO_REM VARCHAR(100 CHAR);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('0'),
        T_TIPO_DATA('1'),
        T_TIPO_DATA('2'),
        T_TIPO_DATA('3'),
        T_TIPO_DATA('4'),
        T_TIPO_DATA('5'),
        T_TIPO_DATA('6')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- LOOP para insertar reglas --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR REGLAS EN '||V_TABLA_BANKIA||'');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        IF V_TMP_TIPO_DATA(1) = '0' THEN

            V_DESCRIPCION_BNK := 'DESCONOCIDO';
            V_DESCRIPCION_REM := 'Desconocido';
            V_CODIGO_REM := '04';

        ELSIF V_TMP_TIPO_DATA(1) = '1' THEN
 
            V_DESCRIPCION_BNK := 'NULO';
            V_DESCRIPCION_REM := 'Nulo';
            V_CODIGO_REM := '07';

        ELSIF V_TMP_TIPO_DATA(1) = '2' THEN
    
            V_DESCRIPCION_BNK := 'INSCRITO';
            V_DESCRIPCION_REM := 'Inscrito';
            V_CODIGO_REM := '02';

        ELSIF V_TMP_TIPO_DATA(1) = '3' THEN
    
            V_DESCRIPCION_BNK := 'SUBSANAR';
            V_DESCRIPCION_REM := 'Subsanar';
            V_CODIGO_REM := '06';

        ELSIF V_TMP_TIPO_DATA(1) = '4' THEN
    
            V_DESCRIPCION_BNK := 'IMPOSIBLE INSCRIPCION';
            V_DESCRIPCION_REM := 'Imposible inscripción';
            V_CODIGO_REM := '03';

        ELSIF V_TMP_TIPO_DATA(1) = '5' THEN
    
            V_DESCRIPCION_BNK := 'INMATRICULADOS';
            V_DESCRIPCION_REM := 'Inmatriculados';
            V_CODIGO_REM := '05';

        ELSIF V_TMP_TIPO_DATA(1) = '6' THEN
    
            V_DESCRIPCION_BNK := 'EN TRAMITACION';
            V_DESCRIPCION_REM := 'En tramitación';
            V_CODIGO_REM := '01';

        END IF;

        --Comprobar si la regla no existe en la tabla.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' WHERE DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' AND DD_CODIGO_BANKIA = '''||V_TMP_TIPO_DATA(1)||'''
                        AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        --EXISTE REGISTRO CON ESE CODIGO
        IF V_NUM_TABLAS = 1 THEN 

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' WHERE DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' AND DD_CODIGO_BANKIA = '''||V_TMP_TIPO_DATA(1)||'''
                            AND DD_DESCRIPCION_BANKIA = '''||V_DESCRIPCION_BNK||''' AND DD_DESCRIPCION_REM = '''||V_DESCRIPCION_REM||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --EQUIVALENCIA INCORRECTA
            IF V_NUM_TABLAS = 0 THEN

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' SET DD_DESCRIPCION_BANKIA = '''||V_DESCRIPCION_BNK||''',
                            DD_DESCRIPCION_REM = '''||V_DESCRIPCION_REM||''',DD_DESCRIPCION_LARGA_REM = '''||V_DESCRIPCION_REM||''',
                            DD_CODIGO_REM = '''||V_CODIGO_REM||''', USUARIOMODIFICAR = '''||V_USUARIO||''', 
                            FECHAMODIFICAR = SYSDATE
                            WHERE DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO'' AND DD_CODIGO_BANKIA = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: LA REGLA '''||V_TMP_TIPO_DATA(1)||''' HA SIDO IGUALADA CORRECTAMENTE: '||V_DESCRIPCION_BNK||' --> '||V_DESCRIPCION_REM||'');

            --EQUIVALENCIA CORRECTA
            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: LA REGLA '''||V_TMP_TIPO_DATA(1)||''' YA ESTA DE IGUALADA CORRECTAMENTE');

            END IF;
        
        --NO EXISTE REGISTRO CON ESE CODIGO
        ELSE

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' (
                DD_NOMBRE_BANKIA,
                DD_CODIGO_BANKIA,
                DD_DESCRIPCION_BANKIA,
                DD_DESCRIPCION_LARGA_BANKIA,
                DD_NOMBRE_REM,
                DD_CODIGO_REM,
                DD_DESCRIPCION_REM,
                DD_DESCRIPCION_LARGA_REM,
                USUARIOCREAR,
                FECHACREAR) VALUES (
                ''DD_SITUACION_TITULO'',
                '''||V_TMP_TIPO_DATA(1)||''',
                '''||V_DESCRIPCION_BNK||''',
                '''||V_DESCRIPCION_BNK||''',
                ''DD_ETI_ESTADO_TITULO'',
                '''||V_CODIGO_REM||''',
                '''||V_DESCRIPCION_REM||''',
                '''||V_DESCRIPCION_REM||''',
                '''||V_USUARIO||''',
                SYSDATE)';
	
	        EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: LA REGLA '''||V_TMP_TIPO_DATA(1)||''' HA SIDO INSERTADA.');

		END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: REGLAS MODIFICADAS CORRECTAMENTE');
 
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
EXIT;

                