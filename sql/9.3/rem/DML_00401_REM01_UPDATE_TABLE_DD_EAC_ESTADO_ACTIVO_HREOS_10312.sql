--/*
--######################################### 
--## AUTOR=Javier Urbán
--## FECHA_CREACION=20201210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10312
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
	V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'HREOS-10312';
	
	TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION('01', 'Suelo'),
		T_FUNCION('02', 'Edificación obra en curso'),
		T_FUNCION('03', 'Edificación Terminada Obra Nueva'),
		T_FUNCION('04', 'Edificación Terminada Segunda Mano'),
		T_FUNCION('06', 'Edificación obra paralizada')
	);
	V_TMP_FUNCION T_FUNCION;
  
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización literales estados activo');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
	LOOP
	    V_TMP_FUNCION := V_FUNCION(I);
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO
					SET DD_EAC_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''
						,DD_EAC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_FUNCION(2))||'''
						,USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
						,FECHAMODIFICAR = SYSDATE
					WHERE DD_EAC_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''
		';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Literal DD_EAC_CODIGO = '||TRIM(V_TMP_FUNCION(1))||' actualizado con DD_EAC_DESCRIPCION = '||TRIM(V_TMP_FUNCION(2)));
		
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
