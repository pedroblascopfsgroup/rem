--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7494
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE 	MUNICIPIO BIE_LOC
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
  LOC_CODIGO VARCHAR2(20 CHAR);
  LOC_ID  NUMBER(16);
  BIE_ID NUMBER(16);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7494';
  
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    -- NUM ACTIVO,  LOC_CODIGO

T_JBV(66166,'31902'),
T_JBV(7005111,'40225'),
T_JBV(7005112,'40225'),
T_JBV(7005113,'40225'),
T_JBV(7005114,'40225'),
T_JBV(7294775,'12032')

	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZA MUNICIPIO');
   FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	NUM_ACT := TRIM(V_TMP_JBV(1));
  	
  	LOC_CODIGO := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN	

		--Comprobamos el dato a insertar
		V_SQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
				
		EXECUTE IMMEDIATE V_SQL INTO BIE_ID;

		--Comprobamos el dato a insertar
		V_SQL := 'SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '||LOC_CODIGO||'';
				
		EXECUTE IMMEDIATE V_SQL INTO LOC_ID;

		--BIE_LOCALIZACION

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_LOCALIZACION WHERE BIE_ID = '||BIE_ID||'';
				
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
		
		--Si existe realizamos otra comprobacion
		IF V_NUM_TABLAS_2 > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION SET DD_LOC_ID = '''||LOC_ID||'''
							, USUARIOMODIFICAR = '''||V_USUARIO||'''
							, FECHAMODIFICAR = SYSDATE
					WHERE BIE_ID = '||BIE_ID||'';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE MUNICIPIO DEL ACTIVO '||NUM_ACT||' ');

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
