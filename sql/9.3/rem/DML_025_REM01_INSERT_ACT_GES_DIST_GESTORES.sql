--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20190531
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6430
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta gestores en ACT_GES_DIST_GESTORES
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
	V_SQL VARCHAR2(10000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	-- Variables relacionadas con el ítem:
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-6430';
	V_TABLA VARCHAR(50 CHAR)    := 'ACT_GES_DIST_GESTORES';
	V_TABLA_TIPO_GEST  VARCHAR2(50 CHAR)  := 'GPM';
	V_TABLA_CARTERA    VARCHAR2(50 CHAR)  := '7';
	
	-- Arays para los gestores:
	TYPE T_GEST IS TABLE OF VARCHAR2(50 CHAR);
	TYPE T_GEST_LIST IS TABLE OF T_GEST;
	V_GEST T_GEST_LIST := T_GEST_LIST(T_GEST('omora'), T_GEST('pgarciafraile'), T_GEST('jguarch'));
	V_GESTOR T_GEST;

	TYPE T_GEST_2 IS TABLE OF VARCHAR2(256 CHAR);
	TYPE T_GEST_LIST_2 IS TABLE OF T_GEST_2;
	V_GEST_2 T_GEST_LIST_2 := T_GEST_LIST_2(T_GEST_2('Oscar Mora Rodriguez'), T_GEST_2('Pablo García Fraile'), T_GEST_2('Jose Maria Guarch Herrero'));
	V_GESTOR_2 T_GEST_2;

	-- Arrays para los DD_PRV_CODIGO de provincias de cada gestor:
	-- omora: Andalucía, Ceuta y Melilla
	V_PRV_GEST_1 VARCHAR2(200 CHAR) := '(4, 11, 51, 14, 18, 21, 23, 29, 41, 52)';
	-- pgarciafraile: Cataluña, Comunidad Valenciana, Murcia y Baleares
	V_PRV_GEST_2 VARCHAR2(200 CHAR) := '(3, 7, 8, 12, 17, 25, 30, 43, 46)';
	-- jguarch: El resto de provincias
	V_PRV_GEST_3 VARCHAR2(200 CHAR) := '(1, 2, 5, 6, 9, 10, 13, 15, 16, 19, 20, 22, 24, 26, 27, 28, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 42, 44, 45, 47, 48, 49, 50)';
	-- Auxiliar	
	V_TMP_PRV_GEST VARCHAR2(200 CHAR);

	V_TABLA_SUBCART VARCHAR2(50 CHAR) := '138';
	V_TABLA_PRV VARCHAR(50 CHAR) := 'DD_PRV_PROVINCIA';
	V_TABLA_LOC VARCHAR(50 CHAR) := 'DD_LOC_LOCALIDAD';
	
	-- Otras variables	
	V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
	V_ENTIDAD_ID NUMBER(16);
	V_ID NUMBER(16);
	V_COUNT NUMBER(16);

	V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');	 
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_GES_DIST_GESTORES ');
	DBMS_OUTPUT.PUT_LINE('');

	FOR I IN V_GEST.FIRST .. V_GEST.LAST
	LOOP	
		V_GESTOR := V_GEST(I);
		V_GESTOR_2 := V_GEST_2(I);	
		
		DBMS_OUTPUT.PUT_LINE('[INICIO]: Iniciando inserción para gestor '''||V_GESTOR(1)||''' ('||V_GESTOR_2(1)||')...');
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: 	Asignando array de provincias correspondiente...');	
		IF V_GESTOR(1) = 'omora' THEN V_TMP_PRV_GEST := V_PRV_GEST_1;
		ELSIF V_GESTOR(1) = 'pgarciafraile' THEN V_TMP_PRV_GEST := V_PRV_GEST_2;
		ELSIF V_GESTOR(1) = 'jguarch' THEN V_TMP_PRV_GEST := V_PRV_GEST_3;
		ELSE V_TMP_PRV_GEST := '(99)';
		END IF;		

		DBMS_OUTPUT.PUT_LINE('[INFO]: 	Comprobando si los registros ya existen...');
		V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' DIST 
			JOIN '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV ON PRV.DD_PRV_CODIGO = DIST.COD_PROVINCIA AND PRV.DD_PRV_CODIGO IN '||V_TMP_PRV_GEST||' 
			WHERE DIST.USUARIOCREAR = '''||V_USUARIO||''' 
			AND DIST.USERNAME = '''||V_GESTOR(1)||''' 
			AND DIST.NOMBRE_USUARIO = '''||V_GESTOR_2(1)||''' 
		';
		--DBMS_OUTPUT.PUT_LINE(''||V_SQL||'');
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;		
					
		IF V_COUNT > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: Los registros de uno o más gestores ya estaban insertados');				
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]:		Insertando...');
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
				(ID,TIPO_GESTOR,COD_CARTERA,COD_PROVINCIA,USERNAME,NOMBRE_USUARIO,USUARIOCREAR,FECHACREAR,BORRADO,COD_SUBCARTERA)
	
				SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
				'''||V_TABLA_TIPO_GEST||''',
				'''||V_TABLA_CARTERA||''',
				PRV.DD_PRV_CODIGO,
				'''||V_GESTOR(1)||''',
				'''||V_GESTOR_2(1)||''',
				'''||V_USUARIO||''',
				SYSDATE,
				0,
				'''||V_TABLA_SUBCART||'''
				FROM '||V_ESQUEMA_M||'.'||V_TABLA_PRV||' PRV WHERE PRV.DD_PRV_CODIGO IN '||V_TMP_PRV_GEST||' 	
			';
			--DBMS_OUTPUT.PUT_LINE(''||V_SQL||'');	
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: 	Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES para el gestor '''||V_GESTOR(1)||'''');	
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN]: 	Fin de inserción para el gestor actual.');
		DBMS_OUTPUT.PUT_LINE('');
	END LOOP;		
								
	COMMIT;
	--ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('[FIN]: ACT_GES_DIST_GESTORES ACTUALIZADO CORRECTAMENTE ');   

EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;

		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);

		ROLLBACK;
		RAISE;          
	END;
/
EXIT;
