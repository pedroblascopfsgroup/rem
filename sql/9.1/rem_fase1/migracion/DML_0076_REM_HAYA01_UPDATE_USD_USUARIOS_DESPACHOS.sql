----/*
----##########################################
----## AUTOR=DAVID GONZALEZ
----## FECHA_CREACION=20160420
----## ARTEFACTO=online
----## VERSION_ARTEFACTO=9.1
----## INCIDENCIA_LINK=0
----## PRODUCTO=NO
----##
----## Finalidad: Script que añade en USD_USUARIOS_DESPACHOS los datos añadidos en T_ARRAY_FUNCION
----## INSTRUCCIONES:
----## VERSIONES:
----##        0.1 Versión inicial
----##########################################
----*/


--WHENEVER SQLERROR EXIT SQL.SQLCODE;
--SET SERVEROUTPUT ON; 
--SET DEFINE OFF;


--DECLARE
    --V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    --V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    --V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    --V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    --ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    --ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    --V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    --V_ENTIDAD_ID NUMBER(16);
    --V_ID NUMBER(16);
    
    --TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    --TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    --V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      --T_FUNCION('REMCERT', 'TINSA'),
      --T_FUNCION('REMSUPER', 'SUPER'),
      --T_FUNCION('REMSUPADM', 'SUPADM'),
      --T_FUNCION('REMADM', 'GESTADM'),
      --T_FUNCION('REMSUPACT', 'SUPACT'),
      ----T_FUNCION('REMACT', 'GESTACT'),
      --T_FUNCION('REMGGADM', 'TECTRAMIT'),
      --T_FUNCION('REMGGADM', 'OGF'),
      ----T_FUNCION('REMGGADM', 'HIPOSERVI'),
      
      ----T_FUNCION('REMACT', 'MR015'),--super-usuario
      ----T_FUNCION('REMACT', 'MR016'),--super-usuario
      ----T_FUNCION('REMACT', 'MR017'),--super-usuario
      
      --T_FUNCION('REMACT', 'A164878'),
      --T_FUNCION('REMACT', 'A164892'),
      --T_FUNCION('REMACT', 'A164740'),
      --T_FUNCION('REMACT', 'A158377'),
      --T_FUNCION('REMACT', 'A164755'),
      --T_FUNCION('REMACT', 'A136655'),
      --T_FUNCION('REMACT', 'A166035'),
      --T_FUNCION('REMACT', 'A166034'),
      --T_FUNCION('REMACT', 'A164884'),
      --T_FUNCION('REMACT', 'A164869'),
      --T_FUNCION('REMACT', 'A121643'),
      --T_FUNCION('REMACT', 'A166039'),
      --T_FUNCION('REMACT', 'A137949'),
      --T_FUNCION('REMACT', 'A141178'),
      --T_FUNCION('REMACT', 'A108677'),--supervisor gestor activo
      --T_FUNCION('REMACT', 'A121298'),--supervisor gestor activo
      --T_FUNCION('REMACT', 'A166036'),--supervisor gestor activo
      --T_FUNCION('REMACT', 'MR001'),
      --T_FUNCION('REMACT', 'MR002'),
      --T_FUNCION('REMACT', 'MR003'),
      --T_FUNCION('REMACT', 'MR004'),
      --T_FUNCION('REMACT', 'MR005'),
      --T_FUNCION('REMACT', 'MR006'),
      --T_FUNCION('REMACT', 'MR007'),
      --T_FUNCION('REMACT', 'MR008'),
      --T_FUNCION('REMACT', 'MR009'),
      --T_FUNCION('REMACT', 'MR010'),
      --T_FUNCION('REMACT', 'MR011'),--supervisor gestor activo
      --T_FUNCION('REMACT', 'MR012'),--supervisor gestor activo
      --T_FUNCION('REMADM', 'MR013'),--gestores admision
      --T_FUNCION('REMADM', 'MR014'),--gestores admision
      --T_FUNCION('REMADM', 'MR018'),--supervisor admision
      --T_FUNCION('REMACT', 'MR019'),--supervisor gestor activo
      --T_FUNCION('REMACT', 'MR020')      
    --); 
    --V_TMP_FUNCION T_FUNCION;
    --V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    --V_MSQL_1 VARCHAR2(4000 CHAR);
    
--BEGIN	
	
	--DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	 
    ---- LOOP para insertar los valores en USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
    --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS] ');
     --FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      --LOOP
            --V_TMP_FUNCION := V_FUNCION(I);
			
			--V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			--WHERE DES_ID = 
				--(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				--WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(1))||''') 
				--AND USU_ID = 
					--(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					--WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''')';
			--EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			---- Si existe la FUNCION
			--IF V_NUM_TABLAS > 0 THEN	  
			
				--DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS.');
				
			--ELSE
			
				--DBMS_OUTPUT.PUT_LINE('[INFO] Existen cambios más recientes. Se actualizarán con los últimos datos.');
				
				--V_MSQL_1 := '
				--UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
				--SET DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(1))||''')
				--WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''')
				--'
				--;
				
				--EXECUTE IMMEDIATE V_MSQL_1;
				
				--DBMS_OUTPUT.PUT_LINE('[INFO] Registros modificados en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS.');
				
		    --END IF;	
      --END LOOP;
    --COMMIT;
    --DBMS_OUTPUT.PUT_LINE('[FIN]: USD_USUARIOS_DESPACHOS ACTUALIZADO CORRECTAMENTE ');
   

--EXCEPTION
     --WHEN OTHERS THEN
          --err_num := SQLCODE;
          --err_msg := SQLERRM;

          --DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          --DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          --DBMS_OUTPUT.put_line(err_msg);

          --ROLLBACK;
          --RAISE;          

--END;

--/

EXIT



   
