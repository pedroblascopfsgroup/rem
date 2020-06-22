--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7494
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR REFERENCIA CATASTRAL ACTIVOS CON MAS DE UNA
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
  V_NUM_TABLAS_3 NUMBER(16); -- Vble. para validar la existencia de una tabla. 
  V_NUM_TABLAS_4 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  NUM_ACT NUMBER(16);
  ACT_ID  NUMBER(16);
  REF_CAT VARCHAR2(50 CHAR);
  REF_CAT_ANT VARCHAR2(50 CHAR);
  BIE_ID NUMBER(16);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar inserts
  V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar inserts
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7494_V2';
  
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    -- NUM ACTIVO,  REF CATASTRAL 

T_JBV(110339,'8847820DF2884F0012FQ','8847820DF2884F0026WS'),
T_JBV(109594,'8847820DF2884F0013GW','8847820DF2884F0004OL'),
T_JBV(107523,'8847820DF2884F0014HE','8847820DF2884F0005PB'),
T_JBV(109595,'8847820DF2884F0018BU','8847820DF2884F0006AZ'),
T_JBV(110842,'8847820DF2884F0024MP','8847820DF2884F0022ZI'),
T_JBV(110340,'8847820DF2884F0026WS','8847820DF2884F0024MP'),
T_JBV(6756916,'3497006VK3539N0001ZS','3497006VK3539N0001ZS/3497006VK3539N0002XD/3497006V')

	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTA REFERENCIA CATASTRAL ACTIVOS');
   FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	NUM_ACT := TRIM(V_TMP_JBV(1));
  	
  	REF_CAT := TRIM(V_TMP_JBV(2));

	REF_CAT_ANT := TRIM(V_TMP_JBV(3));

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		

		--Comprobamos el dato a insertar
		V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
		EXECUTE IMMEDIATE V_SQL INTO ACT_ID;

		--Comprobamos el dato a insertar
		V_SQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
		EXECUTE IMMEDIATE V_SQL INTO BIE_ID;

		--ACT_CAT_CATASTRO

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO WHERE ACT_ID = '||ACT_ID||' AND BORRADO = 0';
				
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
		
		--Si existe realizamos otra comprobacion
		IF V_NUM_TABLAS_2 > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO SET CAT_REF_CATASTRAL = '''||REF_CAT||'''
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID = '||ACT_ID||' AND BORRADO = 0 AND CAT_REF_CATASTRAL = '''||REF_CAT_ANT||'''';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA REFERENCIA CATASTRAL DEL ACTIVO '||NUM_ACT||' ');

			V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
			
			--El activo no existe
		ELSE
				 
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '||NUM_ACT||' NO EXISTE EN ACT_CAT_CATASTRO');	
		END IF;

		--BIE_BIEN

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_BIEN WHERE BIE_ID =  '||BIE_ID||' AND BORRADO = 0';
				
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_3;
		
		--Si existe realizamos otra comprobacion
		IF V_NUM_TABLAS_3 > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_BIEN SET BIE_REFERENCIA_CATASTRAL = '''||REF_CAT||'''
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
					WHERE BIE_ID = '||BIE_ID||' AND BORRADO = 0';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA REFERENCIA CATASTRAL DEL BIEN '||BIE_ID||'');

			V_COUNT_UPDATE_2 := V_COUNT_UPDATE_2 + 1;
			
			--El activo no existe
		ELSE
				 
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL BIEN '||BIE_ID||' NO EXISTE EN BIE_BIEN');	
		END IF;

		--BIE_DATOS_REGISTRALES

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES WHERE BIE_ID =  '||BIE_ID||' AND BORRADO = 0';
				
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_4;
		
		--Si existe realizamos otra comprobacion
		IF V_NUM_TABLAS_4 > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES SET BIE_DREG_REFERENCIA_CATASTRAL = '''||REF_CAT||'''
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
					WHERE BIE_ID = '||BIE_ID||' AND BORRADO = 0';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA REFERENCIA CATASTRAL EN TABLA BIE_DATOS_REGISTRALES DEL BIEN '||BIE_ID||'');

			V_COUNT_UPDATE_3 := V_COUNT_UPDATE_3 + 1;
			
			--El activo no existe
		ELSE
				 
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL BIEN '||BIE_ID||' NO EXISTE EN BIE_DATOS_REGISTRALES');	
		END IF;
		
	--El activo no existe
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '||NUM_ACT||' NO EXISTE ');
	END IF;
		
    END LOOP;
    COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros en ACT_CAT_CATASTRO ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_2||' registros en BIE_BIEN ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_3||' registros en BIE_DATOS_REGISTRALES ');

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
