--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20151027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-383
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER(16);
    
    V_ENTIDAD_ID NUMBER(16);
    V_USUARIO_ID NUMBER(16);
    
    --Valores a insertar
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESCHRE',
      	/*username.........*/ 'CJ_GESCHRE',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GESCHRE',
      	/*nombre-despacho..*/ 'Despacho Gestor control de gestión HRE',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUCHRE',
      	/*username.........*/ 'CJ_SUCHRE',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUCHRE',
      	/*nombre-despacho..*/ 'Despacho Supervisor control gestión HRE',
        /*codigo perfil....*/ 'SER_CENTRALES'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-DIRREC',
      	/*username.........*/ 'CJ_DIRREC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_DIRREC',
      	/*nombre-despacho..*/ 'Despacho Dirección recuperaciones',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESCON',
      	/*username.........*/ 'CJ_GESCON',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GESCON',
      	/*nombre-despacho..*/ 'Despacho Gestor concursal',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESINC',
      	/*username.........*/ 'CJ_GESINC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GESINC',
      	/*nombre-despacho..*/ 'Despacho Gestor de incumplimiento',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GERREC',
      	/*username.........*/ 'CJ_GERREC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GERREC',
      	/*nombre-despacho..*/ 'Despacho Gerente de recuperaciones',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GEANREC',
      	/*username.........*/ 'CJ_GEANREC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GEANREC',
      	/*nombre-despacho..*/ 'Despacho Gestor análisis de recuperaciones',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESHRE',
      	/*username.........*/ 'CJ_GESHRE',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GESHRE',
      	/*nombre-despacho..*/ 'Despacho Gestor HRE',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GADMCON',
      	/*username.........*/ 'CJ_GADMCON',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GADMCON',
      	/*nombre-despacho..*/ 'Despacho Gestor administración contable',
        /*codigo perfil....*/ 'GES_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESOF',
      	/*username.........*/ 'CJ_GESOF',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GESOF',
      	/*nombre-despacho..*/ 'Despacho Gestor oficina',
        /*codigo perfil....*/ 'OFI_OFICINA'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUCON',
      	/*username.........*/ 'CJ_SUCON',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUCON',
      	/*nombre-despacho..*/ 'Despacho Supervisor concursal',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUINC',
      	/*username.........*/ 'CJ_SUINC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUINC',
      	/*nombre-despacho..*/ 'Despacho Supervisor de incumplimiento',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUANREC',
      	/*username.........*/ 'CJ_SUANREC',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUANREC',
      	/*nombre-despacho..*/ 'Despacho Supervisor análisis de recuperaciones',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUHRE',
      	/*username.........*/ 'CJ_SUHRE',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUHRE',
      	/*nombre-despacho..*/ 'Despacho Supervisor HRE',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-SUADCON',
      	/*username.........*/ 'CJ_SUADCON',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_SUADMCON',
      	/*nombre-despacho..*/ 'Despacho Supervisor administración contable',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-DIRCON',
      	/*username.........*/ 'CJ_DIRCON',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_DIRCON',
      	/*nombre-despacho..*/ 'Despacho Director concursal',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
      T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-DIRHRE',
      	/*username.........*/ 'CJ_DIRHRE',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_DIRHRE',
      	/*nombre-despacho..*/ 'Despacho Director control gestión HRE',
        /*codigo perfil....*/ 'DIR_RIESGOS'),
    T_TIPO_TFA(
      	/*codigo tde.......*/ 'D-GESHREIN',
      	/*username.........*/ 'CJ_GEHREIN',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'CJ_GEHREIN',
      	/*nombre-despacho..*/ 'Despacho Gestor concursal HRE insinuación',
        /*codigo perfil....*/ 'GES_RIESGOS')    
      	
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
    
    
    
     --Valores a insertar
    TYPE T_TIPO_PEF IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PEF IS TABLE OF T_TIPO_PEF;
    V_TIPO_PEF T_ARRAY_PEF := T_ARRAY_PEF(  
      T_TIPO_PEF(
      	/*descripcion larga*/ 'Acceso a las funcionalidades de Gestor de riesgos',
      	/*descripcion......*/ 'Gestor de riesgos',
      	/*carterizado......*/ '0',
      	/*codigo...........*/ 'GES_RIESGOS'
      	),
      	T_TIPO_PEF(
      	/*descripcion larga*/ 'Acceso a las funcionalidades de Director de riesgos',
      	/*descripcion......*/ 'Director de riesgos',
      	/*carterizado......*/ '0',
      	/*codigo...........*/ 'DIR_RIESGOS'
      	),
      	T_TIPO_PEF(
      	/*descripcion larga*/ 'Acceso a las funcionalidades de oficina',
      	/*descripcion......*/ 'Oficina',
      	/*carterizado......*/ '0',
      	/*codigo...........*/ 'OFI_OFICINA'
      	),
      	T_TIPO_PEF(
      	/*descripcion larga*/ 'Acceso a las funcionalidades de Servicios centrales',
      	/*descripcion......*/ 'Servicios centrales',
      	/*carterizado......*/ '0',
      	/*codigo...........*/ 'SER_CENTRALES'
      	)
        
); 
    V_TMP_TIPO_PEF T_TIPO_PEF;
    
    
    
    
    
    
    
BEGIN
	
	/*
    * UPDATE: DES_DESPACHO_EXTERNO
    *---------------------------------------------------------------------
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO ' ||
	          ' SET DES_DESPACHO=''Gestoría Gestor Unidad Concursos'' ' ||
	          ' WHERE DES_DESPACHO=''Gestoría Gestor Unidad Concursos y Litigios'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Despacho externo GUCL ya renombrado a GUCO.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO ' ||
	          ' SET DES_DESPACHO=''Gestoría Supervisor Unidad Concursos'' ' ||
	          ' WHERE DES_DESPACHO=''Gestoría Supervisor Unidad Concursos y Litigios'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Despacho externo SUCL ya renombrado a SUCO.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO ' ||
	          ' SET DES_DESPACHO=''Gestoría Director Unidad Concursos'' ' ||
	          ' WHERE DES_DESPACHO=''Gestoría Director Unidad Concursos y Litigios'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Despacho externo DUCL ya renombrado a DUCO.');
    */
	
    /*
    * UPDATE: USU_USUARIOS
    *---------------------------------------------------------------------
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''SUPER_UCO'' ' ||
	          ' WHERE USU_USERNAME=''SUPER_UCL'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario SUPER_UCL ya renombrado a SUPER_UCO.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''GEST_UCO'' ' ||
	          ' WHERE USU_USERNAME=''GEST_UCL'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario GEST_UCL ya renombrado a GEST_UCO.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''DTOR_UCO'' ' ||
	          ' WHERE USU_USERNAME=''DTOR_UCL'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario DTOR_UCL ya renombrado a DTOR_UCO.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''S_UCO_V'' ' ||
	          ' WHERE USU_USERNAME=''S_UCL_V'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario S_UCL_V ya renombrado a S_UCO_V.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''G_UCO_V'' ' ||
	          ' WHERE USU_USERNAME=''G_UCL_V'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario G_UCL_V ya renombrado a G_UCO_V.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''D_UCO_V'' ' ||
	          ' WHERE USU_USERNAME=''D_UCL_V'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario D_UCL_V ya renombrado a D_UCO_V.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''S_UCO_H'' ' ||
	          ' WHERE USU_USERNAME=''S_UCL_H'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario S_UCL_H ya renombrado a S_UCO_H.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''G_UCO_H'' ' ||
	          ' WHERE USU_USERNAME=''G_UCL_H'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario G_UCL_H ya renombrado a G_UCO_H.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS ' ||
	          ' SET USU_USERNAME=''D_UCO_H'' ' ||
	          ' WHERE USU_USERNAME=''D_UCL_H'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Usuario D_UCL_H ya renombrado a D_UCO_H.');
    */
    
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DES_DESPACHO_EXTERNO');  
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando perfiles...');
		
	
	-------------------------------
	FOR I IN V_TIPO_PEF.FIRST .. V_TIPO_PEF.LAST
      LOOP              
            V_TMP_TIPO_PEF := V_TIPO_PEF(I);          		
            
             --Comprobamos que no exista el perfil
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''' || V_TMP_TIPO_PEF(4) || '''';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
          IF V_NUM_TABLAS < 1 THEN 
          
					--Por último, damos los perfiles necesarios al usuario creado.
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (' ||
							  ' PEF_ID,PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (' ||
							  V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL, ' || 
							  '''' ||V_TMP_TIPO_PEF(1) || ''','   ||
							  '''' ||V_TMP_TIPO_PEF(2) || ''','   ||
							  '''0'',' ||
							  '''CMREC-383'',' ||
							  'sysdate,' ||
							  '0,' ||
							  '''' ||V_TMP_TIPO_PEF(4) || ''','   ||
							  '''' || V_TMP_TIPO_PEF(3) || ''',' ||
							  '''EXTPerfil'')';
							
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Creado el perfil '''||V_TMP_TIPO_PEF(4)||'''');	
          
          ELSE
           DBMS_OUTPUT.PUT_LINE('El perfil '||V_TMP_TIPO_PEF(4)
						||' ya existe, NO se creará de nuevo otra vez.');
          END IF;
    END LOOP;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.des_despacho_externo... Empezando a crear despachos...');
	
    
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP              
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);          		
              
            --Vamos a comprobar primero si existe el usuario que queremos crear
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||''' ';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
			IF V_NUM_TABLAS < 1 THEN 
        -- CREAMOS UN USUARIO PARA EL DESPACHO ELEGIDO					
					V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';					
					EXECUTE IMMEDIATE V_MSQL INTO V_USUARIO_ID;
					
					V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS ('||
					        		'USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD,'||
					        		'USU_NOMBRE, USU_APELLIDO1, USU_APELLIDO2, USU_TELEFONO, USU_MAIL,'||
					        		'VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,'||
					        		'USU_EXTERNO, USU_FECHA_VIGENCIA_PASS,'||
					        		'USU_GRUPO, USU_FECHA_EXTRACCION,USU_BAJA_LDAP, BORRADO, USUARIOBORRAR, FECHABORRAR)'||
								' VALUES ('
					        		||V_USUARIO_ID||','
					        		||'1,'
					        		||''''||V_TMP_TIPO_TFA(2)||''''||','
					        		||''''||V_TMP_TIPO_TFA(3)||''''||','
					        		||''''||V_TMP_TIPO_TFA(4)||''''||','
					        		||'''ape1'', ''ape2'', ''111111111'', ''my@email.com'','
					        		||'0, ''ETL'',sysdate,''ETL'',sysdate,1,TO_DATE(''01/01/2017'',''DD/MM/YYYY''),0,sysdate,0,0,NULL,NULL)';					
					
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;					
					
					DBMS_OUTPUT.PUT_LINE('Creado el usuario '||V_TMP_TIPO_TFA(2)||' correctamente.');	
      ELSE
        V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_USUARIO_ID;
				DBMS_OUTPUT.PUT_LINE('El usuario '||V_TMP_TIPO_TFA(2)||' ya existe, NO se creará de nuevo otra vez.');
			
			END IF;
        		
				-- Creamos el despacho externo si no existe
				V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||V_TMP_TIPO_TFA(5)||''' ';
            	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
            	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            	--Si no existe el despacho lo damos de alta
				IF V_NUM_TABLAS < 1 THEN
					V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL FROM DUAL';        
        			EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
        			
					V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO (' ||
							'DES_ID,'|| 
							'DES_DESPACHO, '||
							'DES_TIPO_VIA, '||
							'DES_DOMICILIO_PLAZA,'|| 
							'DES_CODIGO_POSTAL, '||
							'DES_PERSONA_CONTACTO, '||
							'DES_TELEFONO1,'||
							'DES_TELEFONO2, '||
							'VERSION, '||
							'USUARIOCREAR, '||
							'FECHACREAR, '||
							'BORRADO, '||
							'ZON_ID,'||
							'DD_TDE_ID'||
						') VALUES ('||
							V_ENTIDAD_ID||','||
							''''||V_TMP_TIPO_TFA(5)||''''||','||
							'null,'||
							'''VALENCIA'','||
							'''46000'','||
							'''APELLIDOS, NOMBRE'','||
							'''01230112300'','||
							'''01230112301'','||
							'0,'||
							'''SAG'','||
							'sysdate,'||
							'0,'||
							'(SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND BORRADO=0),'||
							'(SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO='''||V_TMP_TIPO_TFA(1)||''') ' ||
						')';
	              		
						--DBMS_OUTPUT.PUT_LINE(V_MSQL);
	              		
						EXECUTE IMMEDIATE V_MSQL;						
						
						DBMS_OUTPUT.PUT_LINE('Creado el despacho de tipo '||V_TMP_TIPO_TFA(1)||' correctamente.');
          ELSE 
            DBMS_OUTPUT.PUT_LINE('El despacho de tipo  '||V_TMP_TIPO_TFA(1)||' ya existe, NO se creará de nuevo otra vez.');
					END IF;	
					
									
					 --Comprobamos que no exista la relacion usd
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE USU_ID=' || V_USUARIO_ID  || ' AND DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||V_TMP_TIPO_TFA(5)||''' )  ';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
          IF V_NUM_TABLAS < 1 THEN 
              		
					--Ahora creamos la relación de un usuario con este despacho					
              		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS ('||
										'USD_ID, '||
										'USU_ID, '||
										'DES_ID, '||
										'USD_GESTOR_DEFECTO, '||
										'USD_SUPERVISOR, '||
										'VERSION, '||
										'USUARIOCREAR, '||
										'FECHACREAR,'||
										'BORRADO'||
									') VALUES ('||
										V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,'||
										V_USUARIO_ID||','||
										'(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||V_TMP_TIPO_TFA(5)||''' ),'||
										'0,'||
										'1,'||
										'0,'||
										'''SAG'','||
										'sysdate,'||
										'0' ||
								')';
								
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Creado la relación del usuario '||V_TMP_TIPO_TFA(2)
						||' con el despacho de tipo '||V_TMP_TIPO_TFA(1)
						||' correctamente.');
						
          ELSE
            DBMS_OUTPUT.PUT_LINE('La relacion  del usuario '||V_TMP_TIPO_TFA(2)
						||' con el despacho de tipo '||V_TMP_TIPO_TFA(1) ||' ya existe, NO se creará de nuevo otra vez.');
          END IF;
          
          
          
          
          --Comprobamos que no exista la relacion usd
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE ZON_ID = (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND BORRADO=0) AND USU_ID=' || V_USUARIO_ID  || ' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''' || V_TMP_TIPO_TFA(6) || ''') ';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
          IF V_NUM_TABLAS < 1 THEN 
          
					--Por último, damos los perfiles necesarios al usuario creado.
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (' ||
							  ' ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' ||
							  '(SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND BORRADO=0),' ||
							  '(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''' || V_TMP_TIPO_TFA(6) || '''),' || 
							  ' '||V_USUARIO_ID||' ,' ||
							  V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
							  '0,' ||
							  '''CMREC-383'',' ||
							  'sysdate,' ||
							  '0)';
							
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Ya dado el perfil '''||V_TMP_TIPO_TFA(6)||''' al usuario '||V_TMP_TIPO_TFA(2));	
          
          ELSE
           DBMS_OUTPUT.PUT_LINE('La zonificación  del usuario '||V_TMP_TIPO_TFA(2)
						||' con el perfil '''||V_TMP_TIPO_TFA(6)||''' ya existe, NO se creará de nuevo otra vez.');
          END IF;
			
			--Si el usuario ya existe
			
      END LOOP;   
      
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('Usuarios dados de alta.');
 
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;