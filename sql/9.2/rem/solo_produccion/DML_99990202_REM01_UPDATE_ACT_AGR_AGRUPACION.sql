--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3419
--## PRODUCTO=NO
--##
--## Finalidad: Actualizacion de la vigencia de las agrupaciones
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
    
    -- ARRAY PARA EL BORRADO DE LA FECHA BAJA
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--		AGR_NUM_AGRUP_REM
    	T_TIPO_DATA('2201015'),
		T_TIPO_DATA('2672893'),
		T_TIPO_DATA('5179957'),
		T_TIPO_DATA('6138922'),
		T_TIPO_DATA('7307720'),
		T_TIPO_DATA('7308039'),
		T_TIPO_DATA('1971329')

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    -- ARRAY PARA LA ACTUALIZACION DE LA FECHA INICIO VIGENCIA
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
    	--		AGR_NUM_AGRUP_REM	AGR_INI_VIGENCIA
    	T_TIPO_DATA_2('2201015','09/11/2017'),
		T_TIPO_DATA_2('2672893','16/11/2017'),
		T_TIPO_DATA_2('4384735','13/11/2017'),
		T_TIPO_DATA_2('5179957','14/11/2017'),
		T_TIPO_DATA_2('6138922','08/11/2017'),
		T_TIPO_DATA_2('7014452','07/11/2017'),
		T_TIPO_DATA_2('7307720','10/11/2017'),
		T_TIPO_DATA_2('7308039','11/11/2017'),
		T_TIPO_DATA_2('7396179','15/11/2017'),
		T_TIPO_DATA_2('1971329','27/10/2017'),
		T_TIPO_DATA_2('2728098','08/11/2017'),
		T_TIPO_DATA_2('4790139','23/11/2017'),
		T_TIPO_DATA_2('7770503','20/11/2017'),
		T_TIPO_DATA_2('7354816','30/11/2017'),
		T_TIPO_DATA_2('8380326','30/11/2017'),
		T_TIPO_DATA_2('7354320','30/11/2017')

	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	-- LOOP PARA BORRAR LA FECHA BAJA-----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_AGR_AGRUPACION, BORRAR FECHA BAJA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM ='||TRIM(V_TMP_TIPO_DATA(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos realizamos el update
        IF V_NUM_TABLAS > 0 THEN		

			  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
			  V_MSQL := 'UPDATE REM01.ACT_AGR_AGRUPACION AGR
						SET AGR.AGR_FECHA_BAJA = NULL,
						AGR.USUARIOMODIFICAR = ''HREOS-3419'',
						AGR.FECHAMODIFICAR = SYSDATE
						WHERE AGR.AGR_NUM_AGRUP_REM LIKE '|| TRIM(V_TMP_TIPO_DATA(1)) ||'
			  ';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON  AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' HA SIDO MODIFICADA CORRECTAMENTE');  
			
       --El proveedor no existe  
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO EXISTE');   
        
       END IF;
    END LOOP;
	
	 
    -- LOOP PARA ACTUALIZAR LA FECHA VIFENCIA-----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_AGR_AGRUPACION, ACTUALIZAR INICIO VIGENCIA] ');
    FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
      LOOP
      
        V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM ='||TRIM(V_TMP_TIPO_DATA_2(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos realizamos el update
        IF V_NUM_TABLAS > 0 THEN		

			  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' ');
			  V_MSQL := 'UPDATE REM01.ACT_AGR_AGRUPACION AGR
						SET AGR.AGR_INI_VIGENCIA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA_2(2))||''', ''DD/MM/YYYY''),
						AGR.USUARIOMODIFICAR = ''HREOS-3419'',
						AGR.FECHAMODIFICAR = SYSDATE
						WHERE AGR.AGR_NUM_AGRUP_REM LIKE '|| TRIM(V_TMP_TIPO_DATA_2(1)) ||'
			  ';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON  AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' HA SIDO MODIFICADA CORRECTAMENTE');  
			
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' NO EXISTE');   
        
       END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_AGR_AGRUPACION ACTUALIZADA CORRECTAMENTE ');
   

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