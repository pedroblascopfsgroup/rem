--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9699
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade las funciones faltantes al Gestor formalización que tiene la Gestoría de formalización
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
	V_SQL VARCHAR2(100 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'HREOS-9699';
	V_PERFIL VARCHAR2(20) := 'HAYAGESTFORM';
	V_PERFIL_COPIA VARCHAR2(20) := 'PERFGCV';
	V_PEF_DESC VARCHAR2(100) := 'Gestor Cierre Venta';
	V_NUM NUMBER;
	V_NUM2 NUMBER;

BEGIN	
    
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_PERFIL||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe el perfil '||V_PERFIL_COPIA||'');
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_PERFIL_COPIA||'''';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL INTO V_NUM2;
		IF V_NUM2 = 0 THEN
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (
			PEF_ID
			, PEF_CODIGO
			, PEF_DESCRIPCION
			, PEF_DESCRIPCION_LARGA
			, USUARIOCREAR
			, FECHACREAR
			)
			SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL
			, '''||V_PERFIL_COPIA||'''
			, '''||V_PEF_DESC||'''
			, '''||V_PEF_DESC||'''
			, '''||V_ITEM||'''
			, SYSDATE
			FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el perfil '||V_PERFIL_COPIA||'');
		END IF; 

		DBMS_OUTPUT.PUT_LINE('[INFO] Se comienza la copia de funciones sobre el perfil '||V_PERFIL_COPIA||'');

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (
			FUN_ID
			, PEF_ID
			, FP_ID
			, USUARIOCREAR
			, FECHACREAR
			)
			SELECT 
			fun.fun_id
			, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_PERFIL_COPIA||''')
			, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL
			, '''||V_ITEM||'''
			, SYSDATE
			FROM '||V_ESQUEMA_M||'.fun_funciones fun
			join '||V_ESQUEMA||'.fun_pef on fun.fun_id = fun_pef.fun_id and fun_pef.borrado = 0
			join '||V_ESQUEMA||'.pef_perfiles pef on pef.pef_id = fun_pef.pef_id and pef.borrado = 0
			where fun.borrado = 0 and pef.pef_codigo = '''||V_PERFIL||'''
			and not EXISTS (SELECT 1 FROM '||V_ESQUEMA_M||'.fun_funciones aux_fun
			join '||V_ESQUEMA||'.fun_pef aux_fun_pef on aux_fun.fun_id = aux_fun_pef.fun_id and aux_fun_pef.borrado = 0
			join '||V_ESQUEMA||'.pef_perfiles aux_pef on aux_pef.pef_id = aux_fun_pef.pef_id and aux_pef.borrado = 0
			where aux_fun.borrado = 0 and aux_pef.pef_codigo = '''||V_PERFIL_COPIA||''' and fun.fun_id = aux_fun.fun_id)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Funciones añadidas al nuevo perfil '||V_PERFIL_COPIA||': ' || sql%rowcount);
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el perfil ' || V_PERFIL || ', no se realizará la copia de funciones.');
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
EXIT;
