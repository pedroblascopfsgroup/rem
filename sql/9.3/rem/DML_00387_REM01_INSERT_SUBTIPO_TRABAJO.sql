--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8281
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar subtipo trabajo
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8281'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='DD_STR_SUBTIPO_TRABAJO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_TIPO_TRABAJO VARCHAR2(100 CHAR):='DD_TTR_TIPO_TRABAJO';
    V_ID_TIPO_TRABAJO VARCHAR2(100 CHAR); --Vble para almacenar el id del proveedor relacionado con el proveedor
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    V_SUBTIPO_TRABAJO VARCHAR2(100 CHAR):='Actuación derivada de Sentencia'; --Vble para almacenar la descripcion del subtipo de trabajo
    V_ID NUMBER(16);

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EN '||V_TABLA);

        
        --Comprobamos si existe el proveedor "OFICINA" con el cod rem indicado:
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_STR_DESCRIPCION= '''||V_SUBTIPO_TRABAJO||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe el subtipo
        IF V_NUM_TABLAS = 0 THEN
        
            
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO_TRABAJO||' WHERE DD_TTR_CODIGO=''03'' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si existe el tipo de trabajo
            IF V_NUM_TABLAS > 0 THEN
            
                --Obtenemos el id del proveedor a relacionar "API"
                V_MSQL := 'SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TIPO_TRABAJO||' WHERE DD_TTR_CODIGO=''03'' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO_TRABAJO;

                --Insertamos subtipo trabajo
                 V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
                (DD_STR_ID, DD_TTR_ID, DD_STR_CODIGO, DD_STR_DESCRIPCION, DD_STR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) 
                SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '||V_ID_TIPO_TRABAJO||',''146'','''||V_SUBTIPO_TRABAJO||''','''||V_SUBTIPO_TRABAJO||''','''||V_USUARIO||''', sysdate, 0 FROM DUAL';
          	    EXECUTE IMMEDIATE V_MSQL;  

                DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el subtipo de trabajo: '''||V_SUBTIPO_TRABAJO||''' ');

            ELSE
                --Si no existe el proveedor "API"
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL TIPO DE TRABAJO CON CODIGO ''03'' ');
            END IF;      	

		ELSE
            -- Si no existe el proveedor "OFICINA"
			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL SUBTIPO DE TRABAJO CON DESCRIPCION: '''||V_SUBTIPO_TRABAJO||''' ');

		END IF;
    
    
    COMMIT;
    
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