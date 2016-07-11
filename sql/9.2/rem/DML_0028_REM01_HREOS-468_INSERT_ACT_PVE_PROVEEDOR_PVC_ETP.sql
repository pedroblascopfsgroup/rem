--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160520
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-468
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en ACT_PVE_PROVEEDOR los datos añadidos en T_ARRAY_DATA. ACT_PVC_PROVEEDOR_CONTACTO y ACT_ETP_ENTIDAD_PROVEEDOR
--## ** Adaptar insert ACT_ETP_ENTIDAD_PROVEEDOR si se van a insertar Proveedores de una cartera diferente a SAREB. Y añadirlos al array.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_SEC NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_ID_ACT NUMBER(16);
  
-- Proveedores inexistentes
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--    NIF-PROV	 TPR			PROVEEDOR			   TDI	 PRV	LOC		  CP           DIRECCION				EMAIL			TEL/FAX		 MOVIL		  NUM_CUENTA           	CARTERA		NOM_PVC	  APELL_PVC  TELF_PVC
		T_TIPO_DATA('B54448097', '05', 'TRISOLIA INVESTMENT, S.L.U.', 'NIF', '3', '03014', '03006', 'C/Lira, 4 Planta Baja', 'jruiz@trisolia.es', '965287565', '619780356', '3058 2515 6227 2000 6613', '01', 'Jose Ramon', 'Ruiz', '648495328' )
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
 
BEGIN	


	--AVANZAMOS LAS SECUENCIAS 
	--S_ACT_ETP_ENTIDAD_PROVEEDOR
	
	EXECUTE IMMEDIATE '
	SELECT '||V_ESQUEMA||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.nextval FROM DUAL
	'
	INTO V_SEC
	;
	
	EXECUTE IMMEDIATE '
	SELECT MAX(ETP_ID) FROM '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR
	'
	INTO V_NUM_TABLAS
	;
	
	WHILE V_SEC < V_NUM_TABLAS
	LOOP 
	
		EXECUTE IMMEDIATE '
		SELECT '||V_ESQUEMA||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL
		'
		INTO V_SEC
		;
	
	END LOOP;
	
	--S_ACT_PVE_PROVEEDOR
	
	EXECUTE IMMEDIATE '
	SELECT '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.nextval FROM DUAL
	'
	INTO V_SEC
	;
	
	EXECUTE IMMEDIATE '
	SELECT MAX(PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR
	'
	INTO V_NUM_TABLAS
	;
	
	WHILE V_SEC < V_NUM_TABLAS
	LOOP 
	
		EXECUTE IMMEDIATE '
		SELECT '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL FROM DUAL
		'
		INTO V_SEC
		;
	
	END LOOP;
	
	--S_ACT_PVC_PROVEEDOR_CONTACTO
	
	EXECUTE IMMEDIATE '
	SELECT '||V_ESQUEMA||'.S_ACT_PVC_PROVEEDOR_CONTACTO.nextval FROM DUAL
	'
	INTO V_SEC
	;
	
	EXECUTE IMMEDIATE '
	SELECT MAX(PVC_ID) FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO
	'
	INTO V_NUM_TABLAS
	;
	
	WHILE V_SEC < V_NUM_TABLAS
	LOOP 
	
		EXECUTE IMMEDIATE '
		SELECT '||V_ESQUEMA||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL
		'
		INTO V_SEC
		;
	
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en ACT_PVE_PROVEEDOR, ACT_ETP_ENTIDAD_PROVEEDOR y ACT_PVC_PROVEEDOR_CONTACTO -----------------------------------------------------------------   
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
				V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	        
				----------------------------------
			    --Insercion en ACT_PVE_PROVEEDOR--
			    ----------------------------------
			    
		        --Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR
		         WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
		         AND DD_TPR_ID = (SELECT DD_TPR_ID FROM ' ||V_ESQUEMA|| '.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''')';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        
		        --Si existe lo modificamos
		       IF V_NUM_TABLAS > 0 THEN			    
		          
		         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR...no se modifica nada. '||V_TMP_TIPO_DATA(1)||'.');
		         
		       ELSE
		       
       		      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVE_PROVEEDOR');   
       		      
			      V_MSQL := '
			      SELECT '|| V_ESQUEMA ||'.S_ACT_PVE_PROVEEDOR.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR (' ||
			      'PVE_ID,
			       DD_TPR_ID,
			       PVE_NOMBRE,
			       PVE_NOMBRE_COMERCIAL,
			       DD_TDI_ID, 
			       PVE_DOCIDENTIF, 
			       DD_PRV_ID, 
			       DD_LOC_ID,
			       PVE_CP, 
			       PVE_DIRECCION,
			       PVE_TELF1,
			       PVE_TELF2,
			       PVE_FAX,
			       PVE_EMAIL,
			       PVE_NUM_CUENTA, 
			       VERSION, 
			       USUARIOCREAR, 
			       FECHACREAR, 
			       BORRADO) ' ||
			       'SELECT 
			       '|| V_ID || ', 
			       (SELECT DD_TPR_ID FROM ' ||V_ESQUEMA|| '.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''),
			        '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''', 
			        '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
			        (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''), 
			        '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
			        (SELECT DD_PRV_ID FROM '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''),
			        (SELECT DD_LOC_ID FROM '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(6)) ||'''),
			        '''|| TRIM(V_TMP_TIPO_DATA(7)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(8)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(10)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(11)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(10)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(9)) ||''',
			        '''|| TRIM(V_TMP_TIPO_DATA(12)) ||''',
			        0, 
			        ''HREOS-468'',
			        SYSDATE,
			        0			         
			        FROM DUAL
			        '
			        ;			             
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVE_PROVEEDOR');
					
				  END IF;						  
				  
			      
			    ------------------------------------------
			    --Insercion en ACT_ETP_ENTIDAD_PROVEEDOR--
			    ------------------------------------------
			      
			      V_MSQL := '
			      SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL
			      '
			      ;
			      
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;
			      
			      --Comprobamos el dato a insertar
		          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR
		           WHERE PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		           AND DD_CRA_ID = (SELECT DD_CRA_ID FROM ' ||V_ESQUEMA|| '.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(13)) ||''')';
		          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		          
		          --Si existe lo modificamos
				  IF V_NUM_TABLAS > 0 THEN			    
		          
				  	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR...no se modifica nada. '||V_TMP_TIPO_DATA(1)||'.');
		         
				  ELSE		      	
			      
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      
					V_MSQL := '
					INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
					ETP_ID, 
					DD_CRA_ID, 
					PVE_ID) ' ||
					'SELECT 
					'|| V_ID_ETP || ', 
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(13)) ||'''), 
					'|| V_ID || ' 
					FROM DUAL
					'
					;
					EXECUTE IMMEDIATE V_MSQL;
			      
					DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
			      END IF;
			      
			      
			    -------------------------------------------
			    --Insercion en ACT_PVC_PROVEEDOR_CONTACTO--
			    -------------------------------------------
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO ');  
			       
			      V_MSQL := '
			      SELECT 
			      '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACT;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (
			      PVC_ID, 
			      PVE_ID, 
			      DD_PRV_ID, 
			      USU_ID, 
			      DD_TDI_ID, 
			      PVC_DOCIDENTIF, 
			      PVC_NOMBRE,
			      PVC_APELLID01,			      
			      PVC_DIRECCION,
			      PVC_TELF1, 
			      PVC_EMAIL, 
			      VERSION,
			      USUARIOCREAR, 
			      FECHACREAR, 
			      BORRADO)
			      SELECT 
			      '|| V_ID_ACT ||',
			      '|| V_ID ||', 
			      NULL, 
			      (SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''),
			      NULL, 
			      NULL, 
			      '''|| TRIM(V_TMP_TIPO_DATA(14)) ||''',
			      '''|| TRIM(V_TMP_TIPO_DATA(15)) ||''',			      
			      NULL,
			      '''|| TRIM(V_TMP_TIPO_DATA(16)) ||''',
			      '''|| TRIM(V_TMP_TIPO_DATA(9)) ||''', 
			      0, 
			      ''HREOS-468'',
			      SYSDATE,
			      0 
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO');
			
      	END LOOP;
	COMMIT;
    
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
   

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
   
