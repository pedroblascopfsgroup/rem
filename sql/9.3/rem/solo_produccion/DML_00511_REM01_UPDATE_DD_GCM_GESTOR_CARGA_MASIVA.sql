--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6536
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar DD_GCM_ACTIVO de la fila 'Supervisor formalización' de la cartera Third Parties e insertar un gestor SFORM con la subcartera Omega
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_6536';
    -- Tablas
    V_TABLA_CARGA VARCHAR2(100 CHAR):= 'DD_GCM_GESTOR_CARGA_MASIVA';
    V_TABLA_GESTORES VARCHAR2(100 CHAR):= 'ACT_GES_DIST_GESTORES';
    V_TABLA_DD_CARTERA VARCHAR2(100 CHAR):= 'DD_CRA_CARTERA';
    V_TABLA_DD_SUBCARTERA VARCHAR2(100 CHAR):= 'DD_SCR_SUBCARTERA';
    -- IDs
    V_ID_CARTERA NUMBER(16);
    V_ID_SUBCARTERA NUMBER(16);
    V_USER_NAME VARCHAR2(100);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- Obtener ID de la cartera BANKIA
    V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_CARTERA||' WHERE DD_CRA_CODIGO = ''11''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_CARTERA;

    -- Obtener ID de la subcartera TITULIZADA
    V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SUBCARTERA||' WHERE DD_SCR_CODIGO = ''65''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBCARTERA;

    -- Obtener nombre de usuario scapellan
    V_MSQL := 'SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''scapellan''';
    EXECUTE IMMEDIATE V_MSQL INTO V_USER_NAME;

    -- INFO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar DD_GCM_ACTIVO a 1 en '||V_TABLA_CARGA||' con cartera THIRD PARTIES y código SFORM');

    --Comprobar si el campo DD_GCM_ACTIVO está a 0.
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_CARGA||' WHERE DD_GCM_CODIGO = ''SFORM'' AND DD_CRA_ID = '''||V_ID_CARTERA||''' AND DD_GCM_ACTIVO = ''0''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    -- Si está a 0 se actualiza.
    IF V_NUM_TABLAS = 1 THEN

        V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_CARGA||' SET 
        DD_GCM_ACTIVO = ''1'',
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE
        WHERE DD_GCM_CODIGO = ''SFORM'' AND DD_CRA_ID = '''||V_ID_CARTERA||''' AND DD_GCM_ACTIVO = ''0''';

        EXECUTE IMMEDIATE V_MSQL;

        -- Información sobre la actualización
        DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla '||V_TABLA_CARGA||' actualizada en el campo DD_GCM_ACTIVO para el registro SFORM de Third Parties');
    
    ELSE
        -- Si el campo ya está en 1
        DBMS_OUTPUT.PUT_LINE('[INFO]: No es necesario actualizar el campo, ya está en 1');

    END IF;


    -- INFO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: Insertar gestor SFORM en '||V_TABLA_GESTORES||' con subcartera OMEGA para el usuario ''scapellan''');

    --Comprobar si el registro con tipo de gestor SFORM, cartera Third Parties y subcartera Omega con gestor scapellan existe.
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GESTORES||' WHERE TIPO_GESTOR = ''SFORM'' AND COD_CARTERA = '''||V_ID_CARTERA||''' AND COD_SUBCARTERA = '''||V_ID_SUBCARTERA||''' AND USERNAME = ''scapellan''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    -- Si no existe se crea.
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GESTORES||' (ID, TIPO_GESTOR, COD_CARTERA, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) VALUES 
        (
        '|| V_ESQUEMA ||'.S_'||V_TABLA_GESTORES||'.NEXTVAL,
        ''SFORM'',
        '''||V_ID_CARTERA||''',
        ''scapellan'',
        '''||V_USER_NAME||''',
        ''0'',
        '''||V_USUARIO||''',
        SYSDATE,
        ''0'',
        '''||V_ID_SUBCARTERA||'''
        )';

        EXECUTE IMMEDIATE V_MSQL;

        -- Información sobre la actualización
        DBMS_OUTPUT.PUT_LINE('[INFO]: Usuario ''scapellan'' insertado como gestor SFORM con cartera THIRD PARTIES y subcartera OMEGA.');
    
    ELSE
        -- Si gestor scapellan ya existe
        DBMS_OUTPUT.PUT_LINE('[INFO]: El usuario ''scapellan'', gestor con cartera THIRD PARTIES y subcartera OMEGA ya existe');

    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: UPDATE e INSERT realizados con éxito');
 
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