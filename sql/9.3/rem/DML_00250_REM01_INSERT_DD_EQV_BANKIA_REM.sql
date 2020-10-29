--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8298
--## PRODUCTO=NO
--## 
--## Finalidad:  Introducir tres reglas en la tabla DD_EQV_BANKIA_REM

--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    -- Esquemas
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    -- Bucle
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8298';
    -- Tablas
    V_TABLA_BANKIA VARCHAR2(100 CHAR):= 'DD_EQV_BANKIA_REM';
    -- Otras variables
    V_DESCRIPCION VARCHAR(100 CHAR);

    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('373'),
        T_TIPO_DATA('375'),
        T_TIPO_DATA('376')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- LOOP para insertar reglas --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR REGLAS EN '||V_TABLA_BANKIA||'');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        -- Asigna una descripción en base a la sociedad patrimonial
        IF V_TMP_TIPO_DATA(1) = '373' THEN

            V_DESCRIPCION := 'CAIXA PENEDES 1 TDA';

        ELSIF V_TMP_TIPO_DATA(1) = '375' THEN
 
            V_DESCRIPCION := 'CAIXA PENEDES FTGENCAT 1 TDA';

        ELSIF V_TMP_TIPO_DATA(1) = '376' THEN
    
            V_DESCRIPCION := 'CAIXA PENEDES PYMES 1 TDA';

        END IF;

        --Comprobar si la regla no existe en la tabla.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' WHERE DD_CODIGO_BANKIA = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        -- Si existe el propietario se actualiza su subcartera en la tabla ACT_PRO_PROPIETARIO y su cartera en la tabla ACT_ACTIVO.
        IF V_NUM_TABLAS = 0 THEN

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_BANKIA||' (
                DD_NOMBRE_BANKIA,
                DD_CODIGO_BANKIA,
                DD_DESCRIPCION_BANKIA,
                DD_DESCRIPCION_LARGA_BANKIA,
                DD_NOMBRE_REM,
                DD_CODIGO_REM,
                DD_DESCRIPCION_REM,
                DD_DESCRIPCION_LARGA_REM,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO
             )
             VALUES
             (
                ''DD_SCR_CODIGO'',
                '''||V_TMP_TIPO_DATA(1)||''',
                '''||V_DESCRIPCION||''',
                '''||V_DESCRIPCION||''',
                ''DD_SCR_SUBCARTERA'',
                ''09'',
                ''TITULIZADAS'',
                ''TITULIZADAS'',
                ''0'',
                '''||V_USUARIO||''',
                SYSDATE,
                ''0''
             )';
	
	        EXECUTE IMMEDIATE V_MSQL;

            -- Mensaje de regla insertada
            DBMS_OUTPUT.PUT_LINE('[INFO]: LA REGLA: '''||V_TMP_TIPO_DATA(1)||''' HA SIDO INSERTADA.');
        
        ELSE
            -- Si el propietario no existe en la tabla de activos
			DBMS_OUTPUT.PUT_LINE('[INFO]: LA REGLA: '''||V_TMP_TIPO_DATA(1)||''' YA EXISTE.');

		END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: REGLAS INTRODUCIDAS CORRECTAMENTE');
 
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

                