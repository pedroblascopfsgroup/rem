--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160421
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en PEF_PERFILES los datos añadidos en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	  --T_FUNCION('HAYAGESACT', 'GESTACT'),
	  T_FUNCION('HAYACERTI', 'TINSA'),
      T_FUNCION('HAYAGESTADM', 'SUPER'),
      T_FUNCION('HAYAGESTADM', 'SUPADM'),
      T_FUNCION('HAYAGESTADM', 'GESTADM'),
      T_FUNCION('HAYAGESACT', 'SUPACT'),
      T_FUNCION('HAYAGESTADM', 'TECTRAMIT'),
      T_FUNCION('HAYAGESTADM', 'OGF'),
      --T_FUNCION('HAYAGESTADM', 'HIPOSERVI'),

	  
	  T_FUNCION('HAYAGESTADM', 'MR013'),--gestores admision
      T_FUNCION('HAYAGESTADM', 'MR014'),--gestores admision
      T_FUNCION('HAYAGESTADM', 'MR018'),--gestores admision
      T_FUNCION('HAYAGESACT', 'A158377'),
      T_FUNCION('HAYAGESACT', 'A164869'),
      T_FUNCION('HAYAGESACT', 'A121298'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'A137949'),
      T_FUNCION('HAYAGESACT', 'A166034'),
      T_FUNCION('HAYAGESACT', 'A121643'),
      T_FUNCION('HAYAGESACT', 'A166039'),
      T_FUNCION('HAYAGESACT', 'A164884'),
      T_FUNCION('HAYAGESACT', 'A164740'),
      T_FUNCION('HAYAGESACT', 'A136655'),
      T_FUNCION('HAYAGESACT', 'A166036'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'A166035'),
      T_FUNCION('HAYAGESACT', 'A164755'),
      T_FUNCION('HAYAGESACT', 'A164892'),
      T_FUNCION('HAYAGESACT', 'A141178'),
      T_FUNCION('HAYAGESACT', 'A108677'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'A164878'),
      T_FUNCION('HAYAGESACT', 'MR001'),
      T_FUNCION('HAYAGESACT', 'MR002'),
      T_FUNCION('HAYAGESACT', 'MR003'),
      T_FUNCION('HAYAGESACT', 'MR004'),
      T_FUNCION('HAYAGESACT', 'MR005'),
      T_FUNCION('HAYAGESACT', 'MR006'),
      T_FUNCION('HAYAGESACT', 'MR007'),
      T_FUNCION('HAYAGESACT', 'MR008'),
      T_FUNCION('HAYAGESACT', 'MR009'),
      T_FUNCION('HAYAGESACT', 'MR010'),
      T_FUNCION('HAYAGESACT', 'MR011'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'MR012'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'MR019'),--supervisor gestor activo
      T_FUNCION('HAYAGESACT', 'MR020')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
				
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
							' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
							' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
							' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||'''),' ||
							' ''DML'',SYSDATE,0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ZON_PEF_USU insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');
   

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

EXIT



   
