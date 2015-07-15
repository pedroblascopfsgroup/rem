--/*
--##########################################
--## Author: Roberto
--## Finalidad: DML para crear usuarios de prueba
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    V_USUARIO_ID NUMBER(16);
    
    --Valores a insertar
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(

      T_TIPO_TFA(
      	/*valor dd_tde_codigo de la tabla DD_TDE_TIPO_DESPACHO*/ 'DUCL',
      	/*USUARIO*/ 'DTOR_UCL',
      	/*PASSWORD*/ '1234',
      	/*NOMBRE DEL USUARIO*/ 'NOMBRE_PRUEBA',
      	/*NOMBRE GESTORIA A LA QUE PERTENECE ESTE USUARIO*/ 'Gestoría Director Unidad Concursos y Litigios'
      ),      
      T_TIPO_TFA('SUCL','SUPER_UCL','1234','NOMBRE_PRUEBA','Gestoría Supervisor Unidad Concursos y Litigios'),
      T_TIPO_TFA('GUCL','GEST_UCL','1234','NOMBRE_PRUEBA','Gestoría Gestor Unidad Concursos y Litigios'),            
      T_TIPO_TFA('GSUB','GEST_SUB','1234','NOMBRE_PRUEBA','Gestoría Gestor subastas'),
      T_TIPO_TFA('SSUB','SUPER_SUB','1234','NOMBRE_PRUEBA','Gestoría Supervisor subastas'),
      T_TIPO_TFA('GDEU','GEST_DEUDA','1234','NOMBRE_PRUEBA','Gestoría Gestor deuda'),
      T_TIPO_TFA('SDEU','SUP_DEUDA','1234','NOMBRE_PRUEBA','Gestoría Supervisor gestión deuda'),
      T_TIPO_TFA('GSDE','GEST_SOP','1234','NOMBRE_PRUEBA','Gestoría Gestor soporte deuda'),
      T_TIPO_TFA('SSDE','SUPER_SOP','1234','NOMBRE_PRUEBA','Gestoría Supervisor soporte deuda'),
      T_TIPO_TFA('UCON','GEST_CONT','1234','NOMBRE_PRUEBA','Gestoría Usuario contabilidad'),
      T_TIPO_TFA('SCON','SUPER_CONT','1234','NOMBRE_PRUEBA','Gestoría Supervisor contabilidad'),
      T_TIPO_TFA('UFIS','GEST_FISC','1234','NOMBRE_PRUEBA','Gestoría Usuario fiscal'),
      T_TIPO_TFA('SFIS','SUPER_FISC','1234','NOMBRE_PRUEBA','Gestoría Supervisor fiscal'),
      T_TIPO_TFA('GAREO','GEST_ADM','1234','NOMBRE_PRUEBA','Gestoría Gestor admisión REO'),      
      T_TIPO_TFA('SAREO','SUPER_ADM','1234','NOMBRE_PRUEBA','Gestoría Supervisor admisión REO'),
      T_TIPO_TFA('GPS','GEST_SAN','1234','NOMBRE_PRUEBA','Gestoría Gestoría para saneamiento'), /*No lo utilizamos, es de Bankia*/
      T_TIPO_TFA('GPA','GEST_ADJ','1234','NOMBRE_PRUEBA','Gestoría Gestoría para adjudicación'), /*No lo utilizamos, es de Bankia*/
      --T_TIPO_TFA('GLL','GEST_LLA1','1234','NOMBRE_PRUEBA','Gestoría primera depositaria de llaves'), /*No lo utilizamos, es de Bankia*/
      --T_TIPO_TFA('GDLL','GEST_LLA2','1234','NOMBRE_PRUEBA','Gestoría segunda depositaria de llaves'), /*No lo utilizamos, es de Bankia*/      
      T_TIPO_TFA('LETR','LETRADO','1234','NOMBRE_PRUEBA','Gestoría Letrado'),
      T_TIPO_TFA('GESTORIA','GESTORIA','1234','NOMBRE_PRUEBA','Gestoría'), /*Este tipo de gestor ya existía de Bankia*/
	  
      /*Doy de alta más usuarios por si coincide que el cliente prueba en el mismo entorno de nuestra gente.*/      
      T_TIPO_TFA('DUCL','D_UCL_H','1234','NOMBRE_PRUEBA','Gestoría Director Unidad Concursos y Litigios'),      
      T_TIPO_TFA('SUCL','S_UCL_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor Unidad Concursos y Litigios'),
      T_TIPO_TFA('GUCL','G_UCL_H','1234','NOMBRE_PRUEBA','Gestoría Gestor Unidad Concursos y Litigios'),            
      T_TIPO_TFA('GSUB','G_SUB_H','1234','NOMBRE_PRUEBA','Gestoría Gestor subastas'),
      T_TIPO_TFA('SSUB','S_SUB_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor subastas'),
      T_TIPO_TFA('GDEU','G_DEUDA_H','1234','NOMBRE_PRUEBA','Gestoría Gestor deuda'),
      T_TIPO_TFA('SDEU','S_DEUDA_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor gestión deuda'),
      T_TIPO_TFA('GSDE','G_SOP_H','1234','NOMBRE_PRUEBA','Gestoría Gestor soporte deuda'),
      T_TIPO_TFA('SSDE','S_SOP_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor soporte deuda'),
      T_TIPO_TFA('UCON','G_CONT_H','1234','NOMBRE_PRUEBA','Gestoría Usuario contabilidad'),
      T_TIPO_TFA('SCON','S_CONT_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor contabilidad'),
      T_TIPO_TFA('UFIS','G_FISC_H','1234','NOMBRE_PRUEBA','Gestoría Usuario fiscal'),
      T_TIPO_TFA('SFIS','S_FISC_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor fiscal'),
      T_TIPO_TFA('GAREO','G_ADM_H','1234','NOMBRE_PRUEBA','Gestoría Gestor admisión REO'),      
      T_TIPO_TFA('SAREO','S_ADM_H','1234','NOMBRE_PRUEBA','Gestoría Supervisor admisión REO'),  
      T_TIPO_TFA('GPS','G_SAN_H','1234','NOMBRE_PRUEBA','Gestoría Gestoría para saneamiento'), /*No lo utilizamos, es de Bankia*/
      T_TIPO_TFA('GPA','G_ADJ_H','1234','NOMBRE_PRUEBA','Gestoría Gestoría para adjudicación'), /*No lo utilizamos, es de Bankia*/
      --T_TIPO_TFA('GLL','G_LLA1_H','1234','NOMBRE_PRUEBA','Gestoría primera depositaria de llaves'), /*No lo utilizamos, es de Bankia*/
      --T_TIPO_TFA('GDLL','G_LLA2_H','1234','NOMBRE_PRUEBA','Gestoría segunda depositaria de llaves'), /*No lo utilizamos, es de Bankia*/      
      T_TIPO_TFA('LETR','LETRADO_H','1234','NOMBRE_PRUEBA','Gestoría Letrado'),
      T_TIPO_TFA('GESTORIA','GESTORIA_H','1234','NOMBRE_PRUEBA','Gestoría') /*Este tipo de gestor ya existía de Bankia*/      
      
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
            V_SQL := 'select count(1) from HAYAMASTER.usu_usuarios where usu_username='''||V_TMP_TIPO_TFA(2)||''' ';
            DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
			IF V_NUM_TABLAS < 1 THEN                        

		        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_des_despacho_externo.NEXTVAL FROM DUAL';        
        		EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;			
        		
				-- Creamos el despacho externo
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.des_despacho_externo (' ||
						'des_id,'|| 
						'des_despacho, '||
						'des_tipo_via, '||
						'des_domicilio_plaza,'|| 
						'des_codigo_postal, '||
						'des_persona_contacto, '||
						'des_telefono1,'||
						'des_telefono2, '||
						'version, '||
						'usuariocrear, '||
						'fechacrear, '||
						'borrado, '||
						'zon_id,'||
						'dd_tde_id'||
					') values ('||
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
						'(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='''||V_TMP_TIPO_TFA(1)||''') ' ||
					')';
              		
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;						
					
					DBMS_OUTPUT.PUT_LINE('Creado el despacho de tipo '||V_TMP_TIPO_TFA(1)||' correctamente.');					
										
					-- CREAMOS UN USUARIO PARA EL DESPACHO ELEGIDO					
					V_MSQL := 'SELECT HAYAMASTER.S_USU_USUARIOS.NEXTVAL FROM DUAL';					
					EXECUTE IMMEDIATE V_MSQL INTO V_USUARIO_ID;
					
					V_MSQL := 'INSERT INTO HAYAMASTER.USU_USUARIOS ('||
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
					        		||'0, ''ETL'',sysdate,''ETL'',sysdate,1,''01/01/2017'',0,sysdate,0,0,NULL,NULL)';					
					
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;					
					
					DBMS_OUTPUT.PUT_LINE('Creado el usuario '||V_TMP_TIPO_TFA(2)||' correctamente.');					
					
              		
					--Ahora creamos la relación de un usuario con este despacho					
              		V_MSQL := 'insert into usd_usuarios_despachos ('||
										'usd_id, '||
										'usu_id, '||
										'des_id, '||
										'usd_gestor_defecto, '||
										'usd_supervisor, '||
										'version, '||
										'usuariocrear, '||
										'fechacrear,'||
										'borrado'||
									') values ('||
										's_usd_usuarios_despachos.nextval,'||
										V_USUARIO_ID||','||
										V_ENTIDAD_ID||','||
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
					V_MSQL := 'insert into zon_pef_usu (zon_id,pef_id,usu_id,zpu_id,version,usuariocrear,fechacrear,borrado) values (' ||
							'12501,' ||
							'(select pef_id from pef_perfiles where pef_codigo=''FPFSRLETEXT''),' ||
							'(select usu_id from HAYAMASTER.usu_usuarios where usu_username='''||V_TMP_TIPO_TFA(2)||'''),' ||
							's_zon_pef_usu.nextval,' ||
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
      
      DBMS_OUTPUT.PUT_LINE('Refrescamos las vistas necesarias...(esto puede tarde un poco, espere hasta que finalice el proceso.)');
      
		--Refrescamos las vistas    	
	  DBMS_MVIEW.REFRESH ('VTAR_ASU_VS_USU');  
	  
	  DBMS_MVIEW.REFRESH ('VTAR_ASUNTO_GESTOR');
	  
	  DBMS_MVIEW.REFRESH ('V_TAREA_USUPENDIENTE');
	  
	  DBMS_MVIEW.REFRESH ('V42_BUSQUEDA_TAREAS');	
	
	  DBMS_OUTPUT.PUT_LINE('Script finalizado correctamente.');

	  COMMIT;
	  
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('La consulta que ha fallado es: '||V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
