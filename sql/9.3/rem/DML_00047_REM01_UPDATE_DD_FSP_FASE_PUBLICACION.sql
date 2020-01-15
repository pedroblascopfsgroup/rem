--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6124
--## PRODUCTO=NO
--## 
--## Finalidad:
--##            
--## INSTRUCCIONES:  
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
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master 
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-6124';
	
	TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION('02', 'Fase 0 (Calidad Pendiente)'),
		T_FUNCION('03', 'Fase I (Pendiente de actuaciones previas)'),
		T_FUNCION('04', 'Fase II (Pendiente de llaves)'),
		T_FUNCION('05', 'Fase III (Pendiente de Información)'),
		T_FUNCION('08', 'Fase IV (Pendiente de precio)'),
		T_FUNCION('09', 'Fase V (Incidencias de publicación)'),
		T_FUNCION('10', 'Fase VI (Calidad comprobada)')
	);
	V_TMP_FUNCION T_FUNCION;
  
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización literales fases de publicación');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
	LOOP
	    V_TMP_FUNCION := V_FUNCION(I);
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION
					SET DD_FSP_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''
						,DD_FSP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_FUNCION(2))||'''
						,USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						,FECHAMODIFICAR = SYSDATE
					WHERE DD_FSP_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''
		';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Literal DD_FSP_CODIGO = '||TRIM(V_TMP_FUNCION(1))||' actualizado con DD_FSP_DESCRIPCION = '||TRIM(V_TMP_FUNCION(2)));
		
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    
    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
