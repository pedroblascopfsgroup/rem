--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1529
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA, ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    				-- TTF_CODIGO VIEJO	-- CRA_CODIGO	- TF_CODIGO NUEVO
		T_TIPO_DATA('OM135'				,'01'			,'CM-CER7'),	--PARA CAJAMAR
		T_TIPO_DATA('OM136'				,'01'			,'CM-CER8'),
		T_TIPO_DATA('OM194'				,'01'			,'CM-CER9'),
		T_TIPO_DATA('OM195'				,'01'			,'CM-CER10'),
		T_TIPO_DATA('OM135'				,'02'			,'SAB-CER8'),	--PARA SAREB
		T_TIPO_DATA('OM136'				,'02'			,'SAB-CER9'),
		T_TIPO_DATA('OM194'				,'02'			,'SAB-CER10'),
		T_TIPO_DATA('OM195'				,'02'			,'SAB-CER11'),
    	T_TIPO_DATA('OM240'				,null				,'ANTIOC1'),	--PARA CUALQUIER CARTERA
    	T_TIPO_DATA('OM241'				,null				,'TAP3'),
    	T_TIPO_DATA('OM245'				,null				,'SS3'),
    	T_TIPO_DATA('OM246'				,null				,'ALR5'),
    	T_TIPO_DATA('OM274'				,null				,'SOL12'),
    	T_TIPO_DATA('TAS1'				,null				,null),			--SE ACTIVARÁ EL BORRADO LÓGICO SIN MÁS CAMBIOS
    	T_TIPO_DATA('TAS2'				,null				,null),
    	T_TIPO_DATA('TAS3'				,null				,null),
    	T_TIPO_DATA('TAS4'				,null				,null),
    	T_TIPO_DATA('TAS5'				,null				,null),
    	T_TIPO_DATA('TAS6'				,null				,null),
    	T_TIPO_DATA('TAS7'				,null				,null)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TTF_TIPO_TARIFA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO LOOP -> UPDATE EN DD_TTF_TIPO_TARIFA y  ACT_CFT_CONFIG_TARIFA ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE BORRADO = 0 AND DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        -- ------------------------------------------------------------------------------------
        --Si existe el TTF_CODIGO VIEJO, activamos el borrado lógico.
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVAMOS BORRADO DEL REGISTRO CON CODIGO'''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA '||
                    ' SET BORRADO = 1 '|| 
					', USUARIOMODIFICAR = ''DML_F2'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: OK en DD_TTF_TIPO_TARIFA');
          
       --Si no existe, NO HACEMOS NADA
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE O YA TIENE EL BORRADO ACTIVADO, NO SE ACTIVA EL BORRADO -- CODIGO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
        
       END IF;
       -- ------------------------------------------------------------------------------------
       
       -- Si tiene informado los campos CARTERA y DD_TTF_CODIGO NUEVO, buscamos en ACT_CFT_CONFIG_TARIFA los registros que apuntan al viejo código, para que apunten al nuevo.
       IF  V_TMP_TIPO_DATA(3) is not null THEN
       		
       		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA WHERE DD_TTF_ID = ( SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' )';
       		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       		IF V_NUM_TABLAS > 0 THEN	
       			-- SI EXISTE EL CODIGO NUEVO EN DD_TTF_TIPO_TARIFA
	       		V_SQL := 'SELECT COUNT(1) FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ';
	       		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       		END IF;
       		
       		--Si existen registros en ACT_CFT_CONFIG_TARIFA que apunten al TTF_CODIGO VIEJO, lo actualizamos por el nuevo, PARA LA CARTERA INDICADA
	        IF V_NUM_TABLAS > 0 AND V_TMP_TIPO_DATA(2) is not null THEN				
	          
	          	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS REGISTROS EN ACT_CFT_CONFIG_TARIFA QUE APUNTAN A DD_TTF CON CODIGO'''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_CFT_CONFIG_TARIFA '||
	                    ' SET DD_TTF_ID = ( SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ) '|| 
						', USUARIOMODIFICAR = ''DML_F2'' , FECHAMODIFICAR = SYSDATE '||
						' WHERE DD_TTF_ID = ( SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ) '||
						' AND DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
						' AND BORRADO = 0';
	          	EXECUTE IMMEDIATE V_MSQL;
	          	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE EN ACT_CFT_CONFIG_TARIFA PARA CARTERA CON CODIGO['''||TRIM(V_TMP_TIPO_DATA(2))||''']');
	       
	        --Si existen registros en ACT_CFT_CONFIG_TARIFA que apunten al TTF_CODIGO VIEJO, lo actualizamos por el nuevo, PARA CUALQUIER CARTERA	
	        ELSE 
	        	IF V_NUM_TABLAS > 0 THEN
	        
		         	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS REGISTROS EN ACT_CFT_CONFIG_TARIFA QUE APUNTAN A DD_TTF CON CODIGO'''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
		       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_CFT_CONFIG_TARIFA '||
		                    ' SET DD_TTF_ID = ( SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' ) '|| 
							', USUARIOMODIFICAR = ''DML_F2'' , FECHAMODIFICAR = SYSDATE '||
							' WHERE DD_TTF_ID = ( SELECT DD_TTF_ID FROM DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ) '||
							' AND BORRADO = 0';
			        EXECUTE IMMEDIATE V_MSQL;
			        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE EN ACT_CFT_CONFIG_TARIFA ');
		          
		        --Si no existe, NO HACEMOS NADA
	       		ELSE
	          		DBMS_OUTPUT.PUT_LINE('[INFO]: no existen registros con el códgio antiguo ['''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''], o no existe el nuevo códgio ['''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''] en el diccionario ');
	          	END IF;
	       
	       END IF;
    	END IF;
       -- ------------------------------------------------------------------------------------
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: LOOP ');
   

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
