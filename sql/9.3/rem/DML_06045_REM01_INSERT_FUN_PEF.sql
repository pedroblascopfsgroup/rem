--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20211115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16370
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-5987';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('ADD_PROVEEDORES_HOMOLOGABLES')
    ); 
    V_TMP_FUNCION T_FUNCION;

    -- EDITAR: SI SE DESEA BORRAR PERMISOS PREVIOS PARA ESTAS FUNCIONES, PONER 1
    V_BORRAR_PERMISOS NUMBER := 0;

    -- EDITAR: PERFILES A LOS QUE CONCEDER LA FUNCIÓN
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PERFIL IS TABLE OF T_PERFIL;
    V_PERFIL T_ARRAY_PERFIL := T_ARRAY_PERFIL(
      T_PERFIL('DESINMOBILIARIO')
    ); 
    V_TMP_PERFIL T_PERFIL;

    V_CONSULTA_PERFIL VARCHAR2(2048) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO=:1';
    V_CONSULTA_PERFIL_ID VARCHAR2(2048) := 'SELECT PEF_ID FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO=:1';
    V_NUM_PERFILES NUMBER;
    V_PERFIL_ID NUMBER; 
    V_NOM_PERFIL VARCHAR2(200);

    V_CONSULTA_FUNCION VARCHAR2(2048) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION=:1';
    V_CONSULTA_FUNCION_ID VARCHAR2(2048) := 'SELECT FUN_ID FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION=:1';
    V_NUM_FUNCIONES NUMBER;
    V_FUNCION_ID NUMBER; 
    V_NOM_FUNCION VARCHAR2(200);

    V_SQL_DELETE_FUN_PEF VARCHAR2(2048) := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=:1';
	V_SQL_INSERT_FUN_PEF VARCHAR2(2048) := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
		q'[ SELECT :1, :2, ]' || V_ESQUEMA || q'[.S_FUN_PEF.NEXTVAL, 0, :3, SYSDATE, 0 FROM DUAL ]';
    V_CONSULTA_FUN_PEF VARCHAR2(2048) := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=:1 AND PEF_ID=:2';
	V_NUM_FPS NUMBER;

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        V_NOM_FUNCION := V_TMP_FUNCION(1);
        EXECUTE IMMEDIATE V_CONSULTA_FUNCION INTO V_NUM_FUNCIONES USING V_NOM_FUNCION;
		IF V_NUM_FUNCIONES=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] Función ' || V_NOM_FUNCION || ' no existe.');
		ELSE
		    EXECUTE IMMEDIATE V_CONSULTA_FUNCION_ID INTO V_FUNCION_ID USING V_NOM_FUNCION;
		    IF V_BORRAR_PERMISOS = 1 THEN
		        EXECUTE IMMEDIATE V_SQL_DELETE_FUN_PEF USING V_FUNCION_ID;
		        DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registros previos borrados (' || V_NOM_FUNCION || '): ' || sql%rowcount);
		    END IF;
		    FOR I IN V_PERFIL.FIRST .. V_PERFIL.LAST 
		    LOOP
		    	V_TMP_PERFIL := V_PERFIL(I);
		    	V_NOM_PERFIL := V_TMP_PERFIL(1);
		    	EXECUTE IMMEDIATE V_CONSULTA_PERFIL INTO V_NUM_PERFILES USING V_NOM_PERFIL;
		    	IF V_NUM_PERFILES=0 THEN
		    		DBMS_OUTPUT.PUT_LINE('[INFO] Perfil ' || V_NOM_PERFIL || ' no existe.');
		    	ELSE
		    		EXECUTE IMMEDIATE V_CONSULTA_PERFIL_ID INTO V_PERFIL_ID USING V_NOM_PERFIL;
		    		EXECUTE IMMEDIATE V_CONSULTA_FUN_PEF INTO V_NUM_FPS USING V_FUNCION_ID, V_PERFIL_ID;
					IF V_NUM_FPS>0 THEN
						DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registro YA existe (' || V_NOM_FUNCION || ',' || V_NOM_PERFIL || ')');
					ELSE
			    		EXECUTE IMMEDIATE V_SQL_INSERT_FUN_PEF USING V_FUNCION_ID, V_PERFIL_ID, V_ITEM;
				        DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registro insertado (' || V_NOM_FUNCION || ',' || V_NOM_PERFIL || '): ' || sql%rowcount);
					END IF;
				END IF;
			END LOOP;
		END IF;
	END LOOP;
    
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
EXIT;