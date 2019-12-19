--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5874
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de relaciones Grupos-Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5874'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	T_FUNCION( 'grupgact' , 'agonzaleza'),
	T_FUNCION( 'grupgact' , 'rejarque'),
	T_FUNCION( 'grupgact' , 'jcook'),
	T_FUNCION( 'grupgact' , 'cmartinc'),
	T_FUNCION( 'grupgact' , 'jtamarit'),
	T_FUNCION( 'grupgact' , 'ext.lmartinez'),
	T_FUNCION( 'grupgact' , 'ext.storreblanca'),
	T_FUNCION( 'grupgact' , 'ext.iramos'),
	T_FUNCION( 'grupgact' , 'ext.abarrera'),
	T_FUNCION( 'grupgact' , 'ext.agonzalezr'),
	T_FUNCION( 'grupgact' , 'ext.jcastro'),
	T_FUNCION( 'grupgact' , 'mblascop'),
	T_FUNCION( 'grupgact' , 'mgarciaarr'),
	T_FUNCION( 'grupgact' , 'abotella'),
	T_FUNCION( 'grupgact' , 'ibenedito'),
	T_FUNCION( 'grupgact' , 'buk.agonzalez'),
	T_FUNCION( 'grupgact' , 'ele.jgarcia'),
	T_FUNCION( 'grupgact' , 'ext.jstrachan'),
	T_FUNCION( 'grupgact' , 'jmoralesv'),
	T_FUNCION( 'grupgact' , 'ele.rgutierrez'),
	T_FUNCION( 'grupgact' , 'ext.apradillo'),
	T_FUNCION( 'grupgact' , 'iba'),
	T_FUNCION( 'grupgact' , 'mriquelme'),
	T_FUNCION( 'grupgact' , 'schacon'),
	T_FUNCION( 'grupgact' , 'bgonzalezm'),
	T_FUNCION( 'grupgact' , 'gestalq'),
	T_FUNCION( 'grupgact' , 'ext.amuntanola'),
	T_FUNCION( 'grupgact' , 'ext.dballester'),
	T_FUNCION( 'grupgact' , 'ele.jgarciav'),
	T_FUNCION( 'grupgact' , 'ext.bbarchin'),
	T_FUNCION( 'grupgact' , 'texposito'),
	T_FUNCION( 'grupgact' , 'mgimenez'),
	T_FUNCION( 'grupgact' , 'vcastillo'),
	T_FUNCION( 'grupgact' , 'lrubio'),
	T_FUNCION( 'grupgact' , 'lramos'),
	T_FUNCION( 'grupgact' , 'ecasis'),
	T_FUNCION( 'grupgact' , 'lnestar'),
	T_FUNCION( 'grupgact' , 'rtalavera'),
	T_FUNCION( 'grupgact' , 'bbaviera'),
	T_FUNCION( 'grupgact' , 'ext.erodriguezo'),
	T_FUNCION( 'grupgact' , 'ext.agarrote'),
	T_FUNCION( 'grupgact' , 'ext.ravila'),
	T_FUNCION( 'grupgact' , 'ext.mllontop'),
	T_FUNCION( 'grupgact' , 'ogf.gherrero'),
	T_FUNCION( 'grupgact' , 'rcervantesi'),
	T_FUNCION( 'grupgact' , 'rdura'),
	T_FUNCION( 'grupgact' , 'ele.ndiaz'),
	T_FUNCION( 'grupgact' , 'ele.jgil'),
	T_FUNCION( 'grupgact' , 'ext.mmegias'),
	T_FUNCION( 'grupgact' , 'morandeira'),
	T_FUNCION( 'grupgact' , 'tgualix'),
	T_FUNCION( 'grupgact' , 'amonge'),
	T_FUNCION( 'grupgact' , 'mblat'),
	T_FUNCION( 'grupgact' , 'ext.aaznar'),
	T_FUNCION( 'grupgact' , 'ext.cmontero'),
	T_FUNCION( 'grupgact' , 'ext.prequejo'),
	T_FUNCION( 'grupgact' , 'ext.aquerol'),
	T_FUNCION( 'grupgact' , 'ycardo'),
	T_FUNCION( 'grupgact' , 'vmaldonado'),
	T_FUNCION( 'grupgact' , 'mcanton'),
	T_FUNCION( 'grupgact' , 'gmorenog'),
	T_FUNCION( 'grupgact' , 'mtl'),
	T_FUNCION( 'grupgact' , 'jtellov'),
	T_FUNCION( 'grupgact' , 'ssalazar'),
	T_FUNCION( 'grupgact' , 'ele.mmarti'),
	T_FUNCION( 'grupgact' , 'ext.eleon'),
	T_FUNCION( 'grupgact' , 'ext.rperis'),
	T_FUNCION( 'grupgact' , 'ext.acale'),
	T_FUNCION( 'grupgact' , 'dmontero'),
	T_FUNCION( 'grupgact' , 'acarabal'),
	T_FUNCION( 'grupgact' , 'tdiez'),
	T_FUNCION( 'grupgact' , 'emartinezr'),
	T_FUNCION( 'grupgact' , 'ndelaossa'),
	T_FUNCION( 'grupgact' , 'gestedi'),
	T_FUNCION( 'grupgact' , 'gestsue'),
	T_FUNCION( 'grupgact' , 'ext.acaro'),
	T_FUNCION( 'grupgact' , 'ext.igutierrez')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

		V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
						WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
							AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS_2 > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' ...no se modifica nada.');
				
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||'' ||
							' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL' ||
							',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''')' ||
							',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')' ||
							',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.');
				
		    END IF;

		ELSE
			DBMS_OUTPUT.PUT_LINE('[ INFO ]: El usuario no existe.');
		END IF;	

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
