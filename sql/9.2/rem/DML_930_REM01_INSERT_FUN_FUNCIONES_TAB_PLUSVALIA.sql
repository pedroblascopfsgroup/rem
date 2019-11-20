--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.5
--## INCIDENCIA_LINK=HREOS-6634
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    -- EDITAR: NÚMERO DE ITEM
    V_ITEM VARCHAR2(30 CHAR) := 'HREOS-6634'; -- USUARIOCREAR/USUARIOMODIFICAR.

    --EDITAR: DATOS DE LA FUNCION
    V_FUN_CODIGO VARCHAR2(50) := 'EDITAR_TAB_ACTIVO_PLUSVALIA';
    V_FUN_DESCRIPCION VARCHAR2(255) := 'Función para editar los campos del tab plusvalia';

    -- EDITAR: SI SE DESEA BORRAR PERMISOS PREVIOS PARA ESTA FUNCIÓN, PONER 1
    V_BORRAR_PERMISOS NUMBER := 1;

    --EDITAR: PERFILES ASOCIADOS A LA FUNCIÓN
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PERFIL IS TABLE OF T_PERFIL;
    V_PERFIL T_ARRAY_PERFIL := T_ARRAY_PERFIL(
      T_PERFIL('HAYASUPER'),
      T_PERFIL('HAYASADM'),
      T_PERFIL('HAYAADM')
    ); 
    V_TMP_PERFIL T_PERFIL; 

	V_NOM_PERFIL VARCHAR2(200);
    V_NUM_PERFILES NUMBER(16); 
	V_NUM_FUNCIONES NUMBER(16); 
	V_NUM_FPS NUMBER(16); 

	V_CONSULTA_FUNCION VARCHAR2(200) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION=:1';
    V_CONSULTA_PERFIL  VARCHAR(200)  := 'SELECT COUNT(*) FROM ' || V_ESQUEMA   || '.PEF_PERFILES WHERE PEF_CODIGO=:1';
	V_SQL_INSERT_FUNCION VARCHAR(200) := 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, 
		VERSION, USUARIOCREAR, FECHACREAR, BORRADO ) VALUES ('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL,:1,:2,0,:3,SYSDATE,0)';
	V_SQL_UPDATE_FUNCION VARCHAR(200) := 'UPDATE ' || V_ESQUEMA_M || '.FUN_FUNCIONES SET FUN_DESCRIPCION_LARGA=:1,
		USUARIOMODIFICAR=:2, FECHACREAR=SYSDATE, BORRADO=0 WHERE FUN_DESCRIPCION=:1';
	V_SQL_DELETE_FUN_PEF VARCHAR2(2048) := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=:1)';
	V_SQL_INSERT_FUN_PEF VARCHAR2(2048) := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
		'SELECT :1, :2, '|| V_ESQUEMA || q'[.S_FUN_PEF.NEXTVAL, 0, :3, SYSDATE, 0 FROM DUAL ]';
	V_CONSULTA_FUN_PEF VARCHAR2(2048) := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=:1 AND PEF_ID=:2';
	V_CONSULTA_PEF_ID VARCHAR2(2048) := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=:1';
	V_CONSULTA_FUN_ID VARCHAR2(2048) := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=:1';
	V_PEF_ID NUMBER;
	V_FUN_ID NUMBER;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION FUNCIÓN: ' || V_FUN_CODIGO);
	EXECUTE IMMEDIATE V_CONSULTA_FUNCION INTO V_NUM_FUNCIONES USING V_FUN_CODIGO;
	
	IF V_NUM_FUNCIONES = 0 THEN
		EXECUTE IMMEDIATE V_SQL_INSERT_FUNCION USING V_FUN_CODIGO, V_FUN_DESCRIPCION, V_ITEM;
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO INSERTADO en FUN_FUNCIONES: ' || V_FUN_CODIGO || ', ' || V_FUN_DESCRIPCION || ': ' || sql%rowcount);
	ELSE
		EXECUTE IMMEDIATE V_SQL_UPDATE_FUNCION USING V_FUN_DESCRIPCION, V_ITEM, V_FUN_CODIGO;
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO ACTUALIZADO ' || V_FUN_CODIGO || ',' || V_FUN_DESCRIPCION || ': ' || sql%rowcount);
		IF V_BORRAR_PERMISOS = 1 THEN
		    EXECUTE IMMEDIATE V_SQL_DELETE_FUN_PEF USING V_FUN_CODIGO;
		    DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registros previos borrados (' || V_FUN_CODIGO || '): ' || sql%rowcount);
		END IF;
	END IF;

	EXECUTE IMMEDIATE V_CONSULTA_FUN_ID INTO V_FUN_ID USING V_FUN_CODIGO;
	FOR I IN V_PERFIL.FIRST .. V_PERFIL.LAST 
    LOOP
        V_TMP_PERFIL := V_PERFIL(I);
        V_NOM_PERFIL := V_TMP_PERFIL(1);
        EXECUTE IMMEDIATE V_CONSULTA_PERFIL INTO V_NUM_PERFILES USING V_NOM_PERFIL;
		IF V_NUM_PERFILES=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] Perfil ' || V_NOM_PERFIL || ' no existe.');
		ELSE
			EXECUTE IMMEDIATE V_CONSULTA_PEF_ID INTO V_PEF_ID USING V_NOM_PERFIL;
		    EXECUTE IMMEDIATE V_CONSULTA_FUN_PEF INTO V_NUM_FPS USING V_FUN_ID, V_PEF_ID;
			IF V_NUM_FPS>0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registro YA existe (' || V_NOM_PERFIL || ',' || V_FUN_CODIGO || ')');
			ELSE
				EXECUTE IMMEDIATE V_SQL_INSERT_FUN_PEF USING V_FUN_ID, V_PEF_ID, V_ITEM;
				DBMS_OUTPUT.PUT_LINE('[INFO] FUN_PEF registro insertado (' || V_NOM_PERFIL || ',' || V_FUN_CODIGO || '): ' || sql%rowcount);
			END IF;
		END IF;
	END LOOP;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] PERFIL ' || V_FUN_CODIGO || ',' || V_FUN_DESCRIPCION || ' Y PERMISOS CORRECTAMENTE ACTUALIZADOS.');
 
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
