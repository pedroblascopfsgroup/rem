--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2251
--## PRODUCTO=SI 
--## Finalidad: Actualiza los campos del DD DD_SIT_SITUACION_TITULO
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_TMP VARCHAR2(25 CHAR); -- Configuracion tabla temporal
    V_TABLA_TMP2 VARCHAR2(25 CHAR); -- Configuracion tabla temporal
	
	V_ENTIDAD_ID  NUMBER(16);
	
	TYPE T_TIPO_SIT  IS TABLE OF VARCHAR2(250);
	TYPE T_ARRAY_SIT IS TABLE OF T_TIPO_SIT;
	V_TIPO_SIT T_ARRAY_SIT := T_ARRAY_SIT(
		T_TIPO_SIT('INS','INSCRITO', 'INSCRITO')
		, T_TIPO_SIT('PEN','PENDIENTE SUBSANACION', 'PENDIENTE SUBSANACION')
	);
	V_TMP_TIPO_SIT T_TIPO_SIT;
	
	V_USUARIO_CREAR VARCHAR2(10) := 'RECO-2251';
	
	SECUENCIA VARCHAR2(30 CHAR) :='S_DD_SIT_SITUACION_TITULO';
    
BEGIN	
	V_TABLA_TMP := 'DD_SIT_SITUACION_TITULO';
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL DICCIONARIO ['||V_TABLA_TMP||']');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... COMPROBAMOS QUE LOS VALORES CORRRECTOS EXISTEN ['||V_TABLA_TMP||']');
	
	FOR I IN V_TIPO_SIT.FIRST .. V_TIPO_SIT.LAST
	LOOP
		V_TMP_TIPO_SIT := V_TIPO_SIT(I);
		-- Comprobamos si existe el dato
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE DD_SIT_CODIGO = '''||TRIM(V_TMP_TIPO_SIT(1))||'''';
	      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
		  	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA_TMP||'... Ya existe el DD_SIT_CODIGO '''|| TRIM(V_TMP_TIPO_SIT(1)) ||'''');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA_TMP||'... Actualizamos la información del DD_SIT_CODIGO '''|| TRIM(V_TMP_TIPO_SIT(1)) ||'''');
			-- Insertamos dato
			DBMS_OUTPUT.PUT_LINE('Actualizamos el valor con DD_SIT_CODIGO '''||V_TMP_TIPO_SIT(1)||'''');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_TMP||' SET DD_SIT_DESCRIPCION = '''||V_TMP_TIPO_SIT(2)||''' ,' ||
				'DD_SIT_DESCRIPCION_LARGA = '''||V_TMP_TIPO_SIT(3)||''', USUARIOMODIFICAR = '''||TRIM(V_USUARIO_CREAR)||''', FECHAMODIFICAR = sysdate, BORRADO = 0 ' ||
				' WHERE DD_SIT_CODIGO = '''||V_TMP_TIPO_SIT(1)||''' ';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA_TMP||'... Actualizado el valor con DD_SIT_CODIGO '''|| TRIM(V_TMP_TIPO_SIT(1)) ||'''');
		ELSE
			-- Buscamos siguiente en la secuencia
			V_MSQL := 'SELECT '||V_ESQUEMA||'.'||SECUENCIA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			-- Insertamos dato
			DBMS_OUTPUT.PUT_LINE('Creando valor el DD_SIT_CODIGO '''||V_TMP_TIPO_SIT(1)||'''');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' (DD_SIT_ID, DD_SIT_CODIGO, DD_SIT_DESCRIPCION,' ||
				'DD_SIT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
				' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_SIT(1)||''','''||V_TMP_TIPO_SIT(2)||''','''
				||V_TMP_TIPO_SIT(3)||''','''
				||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
		END IF;
	END LOOP;
	V_TMP_TIPO_SIT := NULL;
	
	COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... BORRAMOS AQUELLOS VALORES QUE NO DEBEN ESTAR ['||V_TABLA_TMP||']');
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... BORRAMOS LOGICAMENTE LOS VALORES INCORRECTOS');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_TMP||' SET USUARIOBORRAR = '''||TRIM(V_USUARIO_CREAR)||''', FECHABORRAR = sysdate, BORRADO =1 
				WHERE DD_SIT_CODIGO NOT IN ( SELECT DD_SIT_CODIGO FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE (USUARIOMODIFICAR = '''||TRIM(V_USUARIO_CREAR)||''' OR USUARIOCREAR  = '''||TRIM(V_USUARIO_CREAR)||''') AND BORRADO = 0)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL;
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... BORRAMOS AQUELLOS VALORES QUE NO DEBEN ESTAR');
    
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL DICCIONARIO ['||V_TABLA_TMP||']');
	
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
