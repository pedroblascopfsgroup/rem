--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210806
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10295
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10295'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('99991183'),
        T_TIPO_DATA('99989923'),
        T_TIPO_DATA('99991414'),
        T_TIPO_DATA('99979531'),
        T_TIPO_DATA('999138733'),
        T_TIPO_DATA('999151276'),
        T_TIPO_DATA('999160530'),
        T_TIPO_DATA('999160841'),
        T_TIPO_DATA('999151491'),
        T_TIPO_DATA('999143533'),
        T_TIPO_DATA('999139209'),
        T_TIPO_DATA('999151740'),
        T_TIPO_DATA('999139207'),
        T_TIPO_DATA('999143289'),
        T_TIPO_DATA('999161286'),
        T_TIPO_DATA('999143112'),
        T_TIPO_DATA('999143287'),
        T_TIPO_DATA('999143292'),
        T_TIPO_DATA('999143535'),
        T_TIPO_DATA('999161484'),
        T_TIPO_DATA('999139206'),
        T_TIPO_DATA('999161746'),
        T_TIPO_DATA('999139583'),
        T_TIPO_DATA('999151411'),
        T_TIPO_DATA('999139377'),
        T_TIPO_DATA('999161284'),
        T_TIPO_DATA('999139582'),
        T_TIPO_DATA('999143113'),
        T_TIPO_DATA('999151567'),
        T_TIPO_DATA('999151741'),
        T_TIPO_DATA('999143534'),
        T_TIPO_DATA('999143114'),
        T_TIPO_DATA('999139379'),
        T_TIPO_DATA('999144008'),
        T_TIPO_DATA('999139426'),
        T_TIPO_DATA('999151841'),
        T_TIPO_DATA('999161483'),
        T_TIPO_DATA('999161285'),
        T_TIPO_DATA('999151410'),
        T_TIPO_DATA('999151742'),
        T_TIPO_DATA('999144009'),
        T_TIPO_DATA('999151843'),
        T_TIPO_DATA('999144007'),
        T_TIPO_DATA('999151566'),
        T_TIPO_DATA('999151409'),
        T_TIPO_DATA('999151568'),
        T_TIPO_DATA('999139581'),
        T_TIPO_DATA('999139208'),
        T_TIPO_DATA('999143111'),
        T_TIPO_DATA('999151842'),
        T_TIPO_DATA('999151412'),
        T_TIPO_DATA('999151565'),
        T_TIPO_DATA('999143288'),
        T_TIPO_DATA('999161482'),
        T_TIPO_DATA('999151408'),
        T_TIPO_DATA('999161283'),
        T_TIPO_DATA('999139376')


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