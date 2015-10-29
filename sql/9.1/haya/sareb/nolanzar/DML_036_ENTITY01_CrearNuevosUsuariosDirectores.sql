--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.4
--## INCIDENCIA_LINK=HR-998
--## PRODUCTO=NO
--##
--## Finalidad: dd
--## INSTRUCCIONES: dd
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
      T_TIPO_TFA('DDSDE','DTOR_SDE','Pintor32','DTOR_SDE','Gestoría Director Soporte Deuda'),      
      T_TIPO_TFA('DDADM','DTOR_ADM','Pintor32','DTOR_ADM','Gestoría Director Admisión'),
      T_TIPO_TFA('DDCON','DTOR_CON','Pintor32','DTOR_CON','Gestoría Director Contabilidad'),
      T_TIPO_TFA('DDDEU','DTOR_DEU','Pintor32','DTOR_DEU','Gestoría Director Gestión Deuda'),
      T_TIPO_TFA('DDSDE','D_SDE_V','Pintor32','D_SDE_V','Gestoría Director Soporte Deuda'),      
      T_TIPO_TFA('DDADM','D_ADM_V','Pintor32','D_ADM_V','Gestoría Director Admisión'),
      T_TIPO_TFA('DDCON','D_CON_V','Pintor32','D_CON_V','Gestoría Director Contabilidad'),
      T_TIPO_TFA('DDDEU','D_DEU_V','Pintor32','D_DEU_V','Gestoría Director Gestión Deuda'),
      T_TIPO_TFA('DDSDE','D_SDE_H','Pintor32','D_SDE_H','Gestoría Director Soporte Deuda'),      
      T_TIPO_TFA('DDADM','D_ADM_H','Pintor32','D_ADM_H','Gestoría Director Admisión'),
      T_TIPO_TFA('DDCON','D_CON_H','Pintor32','D_CON_H','Gestoría Director Contabilidad'),
      T_TIPO_TFA('DDDEU','D_DEU_H','Pintor32','D_DEU_H','Gestoría Director Gestión Deuda')
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
    
BEGIN
	
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DES_DESPACHO_EXTERNO');  
	-- LOOP Insertando valores en dd_tfa_fichero_adjunto
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.des_despacho_externo... Empezando a crear despachos...');
    
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP              
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);          		
            
            --Vamos a comprobar primero si existe el usuario que queremos crear
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||''' ';
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
			IF V_NUM_TABLAS < 1 THEN                        			
        		
				-- Creamos el despacho externo si no existe
				V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||V_TMP_TIPO_TFA(5)||''' ';
            	DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
							'12501,'||
							'(SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO='''||V_TMP_TIPO_TFA(1)||''') ' ||
						')';
	              		
						DBMS_OUTPUT.PUT_LINE(V_MSQL);
	              		
						EXECUTE IMMEDIATE V_MSQL;						
						
						DBMS_OUTPUT.PUT_LINE('Creado el despacho de tipo '||V_TMP_TIPO_TFA(1)||' correctamente.');					
					END IF;	
					
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
					
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;					
					
					DBMS_OUTPUT.PUT_LINE('Creado el usuario '||V_TMP_TIPO_TFA(2)||' correctamente.');					
					
              		
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
								
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Creado la relación del usuario '||V_TMP_TIPO_TFA(2)
						||' con el despacho de tipo '||V_TMP_TIPO_TFA(1)
						||' correctamente.');
						
					--Por último, damos los perfiles necesarios al usuario creado.
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (' ||
							  ' ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' ||
							  ' 12501,' ||
							  '(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''FPFSRLETEXT''),' ||
							  '(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||'''),' ||
							  V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
							  '0,' ||
							  '''HAYAMASTER'',' ||
							  'sysdate,' ||
							  '0)';
							
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Ya dado el perfil ''FPFSRLETEXT'' () al usuario '||V_TMP_TIPO_TFA(2));							
			
			--Si el usuario ya existe
			ELSE
				DBMS_OUTPUT.PUT_LINE('El usuario '||V_TMP_TIPO_TFA(2)||' ya existe, NO se creará de nuevo otra vez.');
			
			END IF;
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