--/*
--###########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10175
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE CODIGO POSTAL
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
  CODIGO_POSTAL VARCHAR2(20 CHAR);
  LOC_ID  NUMBER(16);
  BIE_ID NUMBER(16);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-10175';
  
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    -- NUM ACTIVO,  CODIGO_POSTAL

T_JBV('7432581','43896'),
T_JBV('7432582','43896'),
T_JBV('7432583','43896'),
T_JBV('7432585','43896'),
T_JBV('7432586','43896'),
T_JBV('7432587','43896'),
T_JBV('7432588','43896'),
T_JBV('7432590','43896'),
T_JBV('7432592','43896'),
T_JBV('7432594','43896'),
T_JBV('7432595','43896'),
T_JBV('7432597','43896'),
T_JBV('7432599','43896'),
T_JBV('7432600','43896'),
T_JBV('7432601','43896'),
T_JBV('7432602','43896'),
T_JBV('7432603','43896'),
T_JBV('7432605','43896'),
T_JBV('7432606','43896'),
T_JBV('7432607','43896'),
T_JBV('7432608','43896'),
T_JBV('7432609','43896'),
T_JBV('7432610','43896'),
T_JBV('7432611','43896'),
T_JBV('7432612','43896'),
T_JBV('7432613','43896'),
T_JBV('7432614','43896'),
T_JBV('7432615','43896'),
T_JBV('7432616','43896'),
T_JBV('7432617','43896'),
T_JBV('7432618','43896')


	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZA CODIGP POSTAL');
   FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	NUM_ACT := TRIM(V_TMP_JBV(1));
  	
  	CODIGO_POSTAL := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN	

		--Comprobamos el dato a insertar
		V_SQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
		EXECUTE IMMEDIATE V_SQL INTO BIE_ID;

		--BIE_LOCALIZACION

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_LOCALIZACION WHERE BIE_ID = '||BIE_ID||'';
				
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
		
		--Si existe realizamos otra comprobacion
		IF V_NUM_TABLAS_2 > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION SET BIE_LOC_COD_POST = '''||CODIGO_POSTAL||'''
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
					WHERE BIE_ID = '||BIE_ID||'';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE CODIGO POSTAL DEL ACTIVO '||NUM_ACT||' ');

			V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
			
			--El activo no existe
		ELSE
				 
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '||NUM_ACT||' NO EXISTE');	
		END IF;
		
	--El activo no existe
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '||NUM_ACT||' NO EXISTE ');
	END IF;
		
    END LOOP;
    COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros en BIE_LOC_LOCALIZACION ');


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
