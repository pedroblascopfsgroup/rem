--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8305
--## PRODUCTO=NO
--## 
--## Finalidad: Exceptuar dos activos de GENCAT
--##			
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8305';
    -- Tablas
    V_TABLA VARCHAR2(100 CHAR):= 'ACT_EXG_EXCLUSION_GENCAT';
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    -- IDs
    V_ID NUMBER(16);
    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('5933219'),
        T_TIPO_DATA('6973976')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- INFO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: Insertar exclusiones GENCAT');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Obtener ACT_ID a través del ACT_NUM_ACTIVO
        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        
        --Comprobar si ya existe en la tabla el activo.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe se inserta.
        IF V_NUM_TABLAS = 0 THEN

            V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
            VALUES 
            (
            '''||V_ID||''',
            ''0'',    
            '''||V_USUARIO||''',
            SYSDATE,
            ''0''
            )'; 

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha exceptuado el activo '''||V_TMP_TIPO_DATA(1)||''' en GENCAT');

		ELSE
            -- Si ya existe el activo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' ya está exceptuado');

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Activos exceptuados con éxito');
 
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