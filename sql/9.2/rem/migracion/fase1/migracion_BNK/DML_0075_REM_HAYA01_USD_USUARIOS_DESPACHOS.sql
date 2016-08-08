--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160420
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USD_USUARIOS_DESPACHOS los datos añadidos en T_ARRAY_FUNCION
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
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
    
    T_FUNCION('REMCERT', 'TINSA'),
      T_FUNCION('REMSUPER', 'SUPER'),
      T_FUNCION('REMSUPADM', 'SUPADM'),
      T_FUNCION('REMADM', 'GESTADM'),
      T_FUNCION('REMSUPACT', 'SUPACT'),
      --T_FUNCION('REMACT', 'GESTACT'),
      T_FUNCION('REMGGADM', 'TECTRAMIT'),
      T_FUNCION('REMGGADM', 'ogf'),
      --T_FUNCION('REMGGADM', 'HIPOSERVI'),
      
 
      T_FUNCION('REMADM', 'mmontaner'),--gestores admision
      T_FUNCION('REMADM', 'morandeira'),--gestores admision
      T_FUNCION('REMSUPADM', 'nfernandez'),--supervisor admision
      --T_FUNCION('REMACT', 'jpoyatos'),--super-usuario
      --T_FUNCION('REMACT', 'ccompany'),--super-usuario
      --T_FUNCION('REMACT', 'hvictor'),--super-usuario
      
      T_FUNCION('REMACT', 'adesco'),
      T_FUNCION('REMACT', 'amartinezb'),
      T_FUNCION('REMACT', 'aml'),
      T_FUNCION('REMACT', 'aruiza'),
      T_FUNCION('REMACT', 'bbaviera'),
      T_FUNCION('REMACT', 'bizquierdo'),
      T_FUNCION('REMACT', 'bruiz'),
      T_FUNCION('REMACT', 'ccf'),
      T_FUNCION('REMACT', 'ckuhnel'),
      T_FUNCION('REMACT', 'cmolina'),
      T_FUNCION('REMACT', 'cmorales'),
      T_FUNCION('REMACT', 'cserrano'),
      T_FUNCION('REMACT', 'gmoreno'),
      T_FUNCION('REMSUPACT', 'hgimenez'),--supervisor gestor activo
      T_FUNCION('REMSUPACT', 'hvictor'),--supervisor gestor activo
      T_FUNCION('REMSUPACT', 'itavera'),--supervisor gestor activo
      T_FUNCION('REMACT', 'jberenguer'),
      T_FUNCION('REMACT', 'jcanovas'),
      T_FUNCION('REMACT', 'jlengua'),
      T_FUNCION('REMACT', 'jlpelaz'),
      T_FUNCION('REMACT', 'jortega'),
      T_FUNCION('REMACT', 'lfabe'),
      T_FUNCION('REMACT', 'mcanton'),
      T_FUNCION('REMACT', 'mcaselles'),
      T_FUNCION('REMACT', 'mgarciade'),
      T_FUNCION('REMSUPACT', 'mgodoy'),--supervisor gestor activo
      T_FUNCION('REMSUPACT', 'mle'),--supervisor gestor activo
      T_FUNCION('REMSUPACT', 'mmacip'),--supervisor gestor activo
      T_FUNCION('REMACT', 'mmartinm'),
      T_FUNCION('REMACT', 'morandeira'),
      T_FUNCION('REMACT', 'mperez'),
      T_FUNCION('REMACT', 'mriquelme'),
      T_FUNCION('REMACT', 'ndelaossa'),
      T_FUNCION('REMACT', 'nfernandez'),
      T_FUNCION('REMACT', 'nhorcajo'),
      T_FUNCION('REMACT', 'ollorca'),
      T_FUNCION('REMACT', 'osalazar'),
      T_FUNCION('REMACT', 'pmoruno'),
      T_FUNCION('REMACT', 'acuerpo'),
      T_FUNCION('REMACT', 'rdl'),
      T_FUNCION('REMACT', 'rdura'),
      T_FUNCION('REMACT', 'rguirado'),
      T_FUNCION('REMACT', 'saragon'),
      T_FUNCION('REMACT', 'ssalcedo'),
      T_FUNCION('REMACT', 'tecnotrami'),
      T_FUNCION('REMACT', 'vgl') 
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	 
    -- LOOP para insertar los valores en USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
			WHERE DES_ID = 
				(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
				WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(1))||''') 
				AND USU_ID = 
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
					WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
				
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
							' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
							' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||							
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(2))||'''),' ||
							' 1,1,''DML'',SYSDATE,0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: USD_USUARIOS_DESPACHOS ACTUALIZADO CORRECTAMENTE ');
   

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



   
