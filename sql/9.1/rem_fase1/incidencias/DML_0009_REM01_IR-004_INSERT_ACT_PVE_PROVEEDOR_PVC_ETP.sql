--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=0
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
		T_TIPO_DATA('01073243V','Amador García Carrasco (ILS Abogados)','raqueldepablos@ilsabogados.com','02'),
  		T_TIPO_DATA('05239632V','Luis Pozo Lozano (Pozo & Irurzun abogados)','lpozol@icam.es','02'),
		T_TIPO_DATA('07214799K','Javier Fernández Merino','jfmerino@notariajfmerino.com','02'),
		T_TIPO_DATA('21430198V','Alfonso García Cortés','alfonso@garciacortes.com','02'),
		T_TIPO_DATA('22470753Y','Mariano Cartagena Sevilla','cartagena@abogadoscyb.es','02'),
		T_TIPO_DATA('22518378K','Alfonso Pascual de Miguel-Notaría','alfonsopascual@notariado.org','02'),
		T_TIPO_DATA('22624330N','Máximo Catalán Pardo-Notaría','mcatalan@correonotarial.org','02'),
		T_TIPO_DATA('22685627Z','Juan María Llatas Serrano','juanllatas@icav.es','02'),
		T_TIPO_DATA('25108836N','M. Paloma Gimeno García (Limpiezas el Arco)','jimenopaloma@hotmail.com','02'),
		T_TIPO_DATA('32403209G','Jose Francisco Freire Amador','josemaria@freireabogados.com','02'),
		T_TIPO_DATA('33399807N','GRV Arquitectura-Gonzalo Rio','grv.arquitectura@gmail.com','02'),
		T_TIPO_DATA('B93115921','GVA & ATENCIA ABOGADOS','pablo.atencia@atencia-abogados.es','02'),
		T_TIPO_DATA('42793075B','Francisco Javier Solís Robaina','losdragos32@gmail.com','02'),
		T_TIPO_DATA('43512163G','Javier Casas Martínez','xcasas@jcmadvocats.es','02'),
		T_TIPO_DATA('50801610S','Luis Boada Dotor','luisboada@notariado.org','02'),
		T_TIPO_DATA('77614922L','Eduardo Turón Miranda','info@dinamicadvocats.com','02'),
		T_TIPO_DATA('A28346054','Caser Asistencia','ggonzalez2@caser.es','02'),
		T_TIPO_DATA('A50001726','Schindler','julia.bernal@es.schindler.com','02'),
		T_TIPO_DATA('A62690953','Unipost','sfranco@unipost.es','02'),
		T_TIPO_DATA('A79222709','Isolux Corsán','vmartin@isoluxcorsan.com','02'),
		T_TIPO_DATA('B05201249','Jamitel 2006 (Jamitel-Garbantel)','info@garbantel.com','02'),
		T_TIPO_DATA('B26459560','Barinaga Abogados','psantana@barinagamartin.com','02'),
		T_TIPO_DATA('B29830577','LR Informática (Inerttia)','mpanteonj@inerttia.es','02'),
		T_TIPO_DATA('B45608270','Lucsan Abogados y Consultores','despacho@lucsanabogados.es','02'),
		T_TIPO_DATA('B60985421','Roca Junyent','jl.yus@rocajunyent.com','02'),
		T_TIPO_DATA('B63899660','Dalaia Trade (Hibuk Partners)','hibukbcn@gmail.com','02'),
		T_TIPO_DATA('B66610239','Aliven Legal','arodriguez@aliven.com','02'),
		T_TIPO_DATA('B80463565','JIDEPAR','vmoralo@jimenezdeparga.es','02'),
		T_TIPO_DATA('B82127358','Rojo Mata','pilar@rojomata.com','02'),
		T_TIPO_DATA('B82270240','PFS Group','isabel.garcia@pfsgroup.es','02'),
		T_TIPO_DATA('B82450727','Adarve Corporación Jurídica','juanjose.garcia@adarve.com','02'),
		T_TIPO_DATA('B82622713','Lupicinio Rodríguez','lrj@lupicinio.com','02'),
		T_TIPO_DATA('B84216993','Miguel Pintos Abogados','andrea.canadas@litigios.net','02'),
		T_TIPO_DATA('B85345452','Chavarri y Muñoz Abogados','sara.chamorro@chabogados.es','02'),
		T_TIPO_DATA('B85736023','Asigno Servicios Integrales de Recuperación de Créditos','marisecosmea@asigno.es','02'),
		T_TIPO_DATA('B86546900','Eco Avanza','info@eco-avanza.es','02'),
		T_TIPO_DATA('B86797065','Solís Martín Mochales (Luis Martín Cubillo) -  (JSM)','lmartincubillo@avestabogados.com','02'),
		T_TIPO_DATA('B86880127','ICARO Abogados y Economistas, S.L.P','pablo.ruiz@icaro.pro','02'),
		T_TIPO_DATA('B96818828','Broseta Abogados','jllujan@broseta.com','02'),
		T_TIPO_DATA('B97999254','Ponz asesores jurídicos','ponzasociados@ponzasociados.com','02'),
		T_TIPO_DATA('B98438633','Porcar & Morata Abogados y Consultores (Adolfo Porcar) JSM','aporcar@porcarmorata.es','02'),
		T_TIPO_DATA('B98658206','Ónice abogados y consultores','administracion@oniceabogados.com','02'),
		T_TIPO_DATA('E07306210','Tous, March, Riutord Pane Abogados C.B.','juanriutord@tous-riutord.com','02'),
		T_TIPO_DATA('E83658567','José Luis López de Garayo y Gallardo (Notaría Montesquinza)','mmonjo@notariosmonteesquinza6.com','02'),
		T_TIPO_DATA('E84026277','Notaría Madridejos-Tena','notaria@madridejostena.com','02'),
		T_TIPO_DATA('J64395726','Bufete Vallés-Arbos','jordi@bufetvalles.com','02'),
		T_TIPO_DATA('J82522061','Bufete López & Llovet','glopezmoron@lopezllovet.com','02'),
		T_TIPO_DATA('J82985573','Notaría Cachón-Mellado','mmellado@cmnotarios.net','02'),
		T_TIPO_DATA('J91899609','Notaría de Nervión','info@notariadenervion.com','02'),
		T_TIPO_DATA('N0066973I','Squire Sanders and Depsey','fernando.gonzalez@squirepb.com','02'),

		T_TIPO_DATA('A78601945','Ilunion Outsourcing (V2 Servicios Auxiliares)','fdiez@ilunion.com','02'),
 		T_TIPO_DATA('B04405403','Construcciones Y Promociones Joneco S.L.','joneco@hotmail.es','01')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
 
-- Proveedores existentes pero que falta contacto
    TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2(
		T_TIPO_DATA2('A28430882','Prosegur compañía de seguridad','cristobal.donesteve@prosegur.com','02'),
		T_TIPO_DATA2('A82451410','REPARALIA','vlabellas@reparalia.es','02'),
		T_TIPO_DATA2('B35921642','Arcoin','jpol@arcoin.es','02'),
		T_TIPO_DATA2('B58409269','Aliven Gestión de Activos','arodriguez@aliven.com','02'),
		T_TIPO_DATA2('B85735967','Léner asesores legales y económicos','marisecosmea@asigno.es','02'),
		T_TIPO_DATA2('B86561677','Vialegis Abogados','p.coloma@vialegis.com','02')
    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;

-- Proveedores existentes y sus contactos pero que falta entidad proveedor de una cartera
    TYPE T_TIPO_DATA3 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA3 IS TABLE OF T_TIPO_DATA3;
    V_TIPO_DATA3 T_ARRAY_DATA3 := T_ARRAY_DATA3(
		T_TIPO_DATA3('A04038014','GRUPO CONTROL EMPRESA DE SEGURIDAD S.A.','lbermejo@grupocontrol.com','01'),
		T_TIPO_DATA3('A80884372','Gesvalt Sociedad de Tasación','gesvalt@gesvalt.es','01'),
		T_TIPO_DATA3('B03830510','Gestimed Levante','bankia@gestimedlevante.es','01'),
		T_TIPO_DATA3('B84105899','Invertol, Promoción e Inversión Inmobiliaria','control@invertol.com','01'),
		T_TIPO_DATA3('B86689494','Tinsa Certify','bankiacee@tinsacertify.es','01'),
		T_TIPO_DATA3('B96534805','VARESER 96, S.L.','ofertas@vareser.net','01'),
		T_TIPO_DATA3('B97279012','Procyr, Edificación y Urbanismo, s.l.','ernesto.torregrosa@procyr.es','01')

   ); 
    V_TMP_TIPO_DATA3 T_TIPO_DATA3;
 
-- Proveedores existentes y sus contactos y entidad proveedor pero asignado a otra cartera
    TYPE T_TIPO_DATA4 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA4 IS TABLE OF T_TIPO_DATA4;
    V_TIPO_DATA4 T_ARRAY_DATA4 := T_ARRAY_DATA4(
		T_TIPO_DATA4('21430198V','Alfonso García Cortés','alfonso@garciacortes.com','02'),
		T_TIPO_DATA4('A03319530','VALORACIONES MEDITERRÁNEO, S.A.','reverte.sanchez@valmesa.es','01'),
		T_TIPO_DATA4('A79252219','SECURITAS SEGURIDAD ESPAÑA, S.A.','angel.castano@securitas.es','01'),
		T_TIPO_DATA4('B85030641','VALUATION & REAL ESTATE GROUP, S.L. - MREG','icruz@mreg.es','01'),
		T_TIPO_DATA4('B86880127','ICARO Abogados y Economistas, S.L.P','pablo.ruiz@icaro.pro','02'),
		T_TIPO_DATA4('B92687458','MALACITANA DE CONTROL, J.C., S.L.','ISABEL@MALACITANADECONTROL.COM','01'),
		T_TIPO_DATA4('B98658206','Ónice abogados y consultores','administracion@oniceabogados.com','02')

   ); 
    V_TMP_TIPO_DATA4 T_TIPO_DATA4;
 
 
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

	 
    -- LOOP para insertar los valores en ACT_PVE_PROVEEDOR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_PVE_PROVEEDOR] ');
    
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
				V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	        
	        
		        --Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        
		        --Si existe lo modificamos
		       IF V_NUM_TABLAS > 0 THEN			    
		          
		         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR...no se modifica nada. '||V_TMP_TIPO_DATA(1)||'.');
		         
		       ELSE
		       
       		      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
       		      
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
			       PVE_DIRECCION, 
			       VERSION, 
			       USUARIOCREAR, 
			       FECHACREAR, 
			       BORRADO,
			       PVE_EMAIL) ' ||
			       'SELECT 
			       '|| V_ID || ', 
			       (SELECT DD_TPR_ID FROM ' ||V_ESQUEMA|| '.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05''),
			        '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', 
			        '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
			        (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = ''NIF''), 
			        '''||TRIM(V_TMP_TIPO_DATA(1))||''',
			        NULL,
			        NULL,
			        NULL,
			        0, 
			        ''IR-004'',
			        SYSDATE,
			        0,
			        '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' 
			        FROM DUAL
			        '
			        ;			             
			       EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	         
	         
	         
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      
			      V_MSQL := '
			      SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
			      ETP_ID, 
			      DD_CRA_ID, 
			      PVE_ID) ' ||
			      'SELECT 
			      '|| V_ID_ETP || ', 
			      (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE UPPER(DD_CRA_DESCRIPCION) = UPPER(''SAREB'')), 
			      '|| V_ID || ' 
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
			      
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO ');  
			       
			      V_MSQL := '
			      SELECT 
			      '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACT;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (' ||
			      'PVC_ID, 
			      PVE_ID, 
			      DD_PRV_ID, 
			      USU_ID, 
			      DD_TDI_ID, 
			      PVC_DOCIDENTIF, 
			      PVC_NOMBRE, 
			      PVC_DIRECCION, 
			      VERSION,
			      USUARIOCREAR, 
			      FECHACREAR, 
			      BORRADO) ' ||
			      'SELECT 
			      '|| V_ID_ACT ||',
			      '|| V_ID ||', 
			      NULL, 
			      (select usu_id from '||V_ESQUEMA_M||'.usu_usuarios where USU_USERNAME  = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''), 
			      (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = ''NIF''), 
			      '''||TRIM(V_TMP_TIPO_DATA(1))||''', 
			      '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', 
			      NULL, 
			      0, 
			      ''IR-004'',
			      SYSDATE,
			      0 
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO');


			      
			END IF;
			
      	END LOOP;
     
 -- LOOP para insertar los valores en ACT_PVC_PROVEEDOR_CONTACTO DE PROVEEDORES EXISTENTES  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACT_PVC_PROVEEDOR_CONTACTO ] ');
    
    
    FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
      LOOP
      
			V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
	        
	        
		        --Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE PVC_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA2(1))||'''';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        
		       --Si existe no lo insertamos
		       IF V_NUM_TABLAS > 0 THEN			    
		          
		         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO...no se modifica nada. '||V_TMP_TIPO_DATA2(1)||'.');
		         
		       ELSE
		       
       		         DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''''); 

			      V_MSQL := '
			      SELECT 
			      '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACT;	

       		      
                              V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (' ||
			      'PVC_ID, 
			      PVE_ID, 
			      DD_PRV_ID, 
			      USU_ID, 
			      DD_TDI_ID, 
			      PVC_DOCIDENTIF, 
			      PVC_NOMBRE, 
			      PVC_DIRECCION, 
			      VERSION,
			      USUARIOCREAR, 
			      FECHACREAR, 
			      BORRADO) ' ||
                              'SELECT 
			      '|| V_ID_ACT ||',
			      (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''), 
			      NULL, 
			      (select usu_id from '||V_ESQUEMA_M||'.usu_usuarios where USU_USERNAME  = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''), 
			      (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = ''NIF''), 
			      '''||TRIM(V_TMP_TIPO_DATA2(1))||''', 
			      '''|| TRIM(V_TMP_TIPO_DATA2(2)) ||''', 
			      NULL, 
			      0, 
			      ''IR-004'',
			      SYSDATE,
			      0 
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;

				      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''');
	         	         
	         
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      
			      V_MSQL := '
			      SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
			      ETP_ID, 
			      DD_CRA_ID, 
			      PVE_ID) ' ||
			      'SELECT 
			      '|| V_ID_ETP || ', 
			      (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA2(4)) ||'''), 
			      (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''') 
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA2(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
			      
			END IF;


			
      	END LOOP; 

-- LOOP para insertar los valores en ACT_ETP_ENTIDAD_PROVEEDOR DE PROVEEDORES-PROVEEDORES_CONTACTO EXISTENTES  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_ETP_ENTIDAD_PROVEEDOR] ');
    
    
    FOR I IN V_TIPO_DATA3.FIRST .. V_TIPO_DATA3.LAST
      LOOP
      
			V_TMP_TIPO_DATA3 := V_TIPO_DATA3(I);
	        
		        --Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR WHERE PVE_ID = 
                                  (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA3(1)) ||''' AND
                                  DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05'') ) and
                                  DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA3(4)) ||''')';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        
		       --Si existe no lo insertamos
		       IF V_NUM_TABLAS > 0 THEN			    
		          
		             DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR...no se modifica nada. '||V_TMP_TIPO_DATA3(1)||'.');
		         
		       ELSE
		              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA3(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      
			      V_MSQL := '
			      SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
			      
			      V_MSQL := '
			      INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
			      ETP_ID, 
			      DD_CRA_ID, 
			      PVE_ID) ' ||
			      'SELECT 
			      '|| V_ID_ETP || ', 
			      (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA3(4)) ||'''), 
			      (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA3(1))||''' AND
                                  DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05'') )
			      FROM DUAL
			      '
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA3(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
			     			    
			      
			END IF;


			
      	END LOOP; 


-- LOOP para actualizar los valores en ACT_ETP_ENTIDAD_PROVEEDOR de carteras erróneas  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN ACT_ETP_ENTIDAD_PROVEEDOR] ');
    
    
    FOR I IN V_TIPO_DATA4.FIRST .. V_TIPO_DATA4.LAST
      LOOP
      
			V_TMP_TIPO_DATA4 := V_TIPO_DATA4(I);
	        
		        --Comprobamos el dato a modificar
		      
                         V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR WHERE PVE_ID = 
                                  (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA4(1)) ||''' AND
                                  DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05'') ) and
                                  DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO <> '''|| TRIM(V_TMP_TIPO_DATA4(4)) ||''')';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        
		       --Si existe lo modificamos
		       IF V_NUM_TABLAS > 0 THEN			    
		          
	       
       		              DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA4(1)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      
			      V_MSQL := '
                              UPDATE '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR 
			      SET 
			      DD_CRA_ID=
			      (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA4(4)) ||''')
		              WHERE PVE_ID = 
                                    (select pve_id from '||V_ESQUEMA||'.act_pve_proveedor 
                                     where PVE_DOCIDENTIF  = '''|| TRIM(V_TMP_TIPO_DATA4(1))||''' 
                                       and DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05'') ) 
                                AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO <> '''|| TRIM(V_TMP_TIPO_DATA4(4)) ||''')
			    '

   
			      ;
			      EXECUTE IMMEDIATE V_MSQL;
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA4(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
	                ELSE
			    		          
		             DBMS_OUTPUT.PUT_LINE('[INFO] No existen los datos en la tabla '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR...no se modifica nada. '||V_TMP_TIPO_DATA4(1)||'.');

			      
			END IF;


			
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
   
