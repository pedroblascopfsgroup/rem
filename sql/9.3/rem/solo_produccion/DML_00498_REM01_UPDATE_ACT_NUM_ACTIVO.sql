--/*
--######################################### 
--## AUTOR=Carlos Santos
--## FECHA_CREACION=20201023
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8273
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar ACT_NUM_ACTIVO
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8273'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('999147344'),
        T_TIPO_DATA('999132483'),
        T_TIPO_DATA('999144283'),
        T_TIPO_DATA('999144244'),
        T_TIPO_DATA('999147342'),
        T_TIPO_DATA('999132200'),
        T_TIPO_DATA('999132020'),
        T_TIPO_DATA('999147341'),
        T_TIPO_DATA('999132481'),
        T_TIPO_DATA('999156147'),
        T_TIPO_DATA('999156668'),
        T_TIPO_DATA('999144541'),
        T_TIPO_DATA('999132021'),
        T_TIPO_DATA('999144245'),
        T_TIPO_DATA('999147757'),
        T_TIPO_DATA('999147641'),
        T_TIPO_DATA('999147643'),
        T_TIPO_DATA('999156194'),
        T_TIPO_DATA('999156007'),
        T_TIPO_DATA('999144539'),
        T_TIPO_DATA('999147642'),
        T_TIPO_DATA('999156006'),
        T_TIPO_DATA('999144153'),
        T_TIPO_DATA('999147345'),
        T_TIPO_DATA('999132271'),
        T_TIPO_DATA('999144152'),
        T_TIPO_DATA('999156669'),
        T_TIPO_DATA('9996846943'),
        T_TIPO_DATA('9996846764'),
        T_TIPO_DATA('9996847106'),
        T_TIPO_DATA('9996847168')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_NUM_ACTIVO EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = SUBSTR('''||V_TMP_TIPO_DATA(1)||''', 4, LENGTH('''||V_TMP_TIPO_DATA(1)||'''))';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo 999 se actualiza.
        IF V_NUM_TABLAS = 0 THEN

            -- Almacena el número de activo sin prefijo
            V_MSQL := 'SELECT SUBSTR(ACT_NUM_ACTIVO, 4, LENGTH(ACT_NUM_ACTIVO)) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_ACTIVO;
       	
           V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET ACT_NUM_ACTIVO = '''||V_NUM_ACTIVO||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado ACT_NUM_ACTIVO con codigo '||V_NUM_ACTIVO);

		ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' sin el prefijo 999 ya existe');

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
    
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
EXIT