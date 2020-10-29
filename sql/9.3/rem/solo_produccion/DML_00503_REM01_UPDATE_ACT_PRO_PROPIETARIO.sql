--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8298
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar cartera y subcartera de 3 registros en las tablas de propietarios y activos
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
    -- Bucle
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8298';
    -- Tablas
    V_TABLA_PROPIETARIO VARCHAR2(100 CHAR):= 'ACT_PRO_PROPIETARIO';
    V_TABLA_PROPIETARIO_ACTIVO VARCHAR2(100 CHAR):= 'ACT_PAC_PROPIETARIO_ACTIVO';
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    V_TABLA_DD_CARTERA VARCHAR2(100 CHAR):= 'DD_CRA_CARTERA';
    V_TABLA_DD_SUBCARTERA VARCHAR2(100 CHAR):= 'DD_SCR_SUBCARTERA';
    -- IDs
    V_ID_CARTERA NUMBER(16);
    V_ID_SUBCARTERA NUMBER(16);

    -- Array
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('7300524'),
        T_TIPO_DATA('7300538'),
        T_TIPO_DATA('7302137')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- Obtener ID de la cartera BANKIA
    V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_CARTERA||' WHERE DD_CRA_CODIGO = ''03''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_CARTERA;

    -- Obtener ID de la subcartera TITULIZADA
    V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SUBCARTERA||' WHERE DD_SCR_CODIGO = ''09''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBCARTERA;

    -- LOOP para actualizar cartera y subcartera de propietarios --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR CARTERA EN '||V_TABLA_PROPIETARIO||' Y SUBCARTERA EN '||V_TABLA_ACTIVO);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar si el activo existe en la tabla ACT_ACTIVO.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si existe el propietario se actualiza su subcartera en la tabla ACT_PRO_PROPIETARIO y su cartera en la tabla ACT_ACTIVO.
        IF V_NUM_TABLAS = 1 THEN

            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' SET 
            DD_CRA_ID = '''||V_ID_CARTERA||''',
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
            WHERE PRO_ID = (
            SELECT PRO.PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO||' PRO
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIO_ACTIVO||' PROACT ON PRO.PRO_ID = PROACT.PRO_ID
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON PROACT.ACT_ID = ACT.ACT_ID
            WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' 
            )';
	
	        EXECUTE IMMEDIATE V_MSQL;

            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' SET 
            DD_SCR_ID = '''||V_ID_SUBCARTERA||''',
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
            WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
	
	        EXECUTE IMMEDIATE V_MSQL;

            -- Información sobre el propietari actual
			DBMS_OUTPUT.PUT_LINE('[INFO]: PROPIETARIO: '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO.');
        
        ELSE
            -- Si el propietario no existe en la tabla de activos
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROPIETARIO CON NUMERO DE ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' NO EXISTE.');

		END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: CARTERA Y SUBCARTERA DE PROPIETARIOS ACTUALIZADAS CORRECTAMENTE');
 
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