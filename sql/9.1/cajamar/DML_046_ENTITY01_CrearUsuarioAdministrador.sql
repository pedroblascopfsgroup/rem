--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-477
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
    ID_ENTIDAD NUMBER(16);
    
    --Valores a insertar
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
      T_TIPO_TFA(
      	/*codigo tde.......*/ '',
      	/*username.........*/ 'CAJAMASTER',
      	/*password.........*/ '1234',
      	/*nombre usuario ..*/ 'ADMIN',
      	/*nombre-despacho..*/ '')
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;
    
BEGIN
	
    
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando...');  
	
    
	V_MSQL := 'SELECT ID FROM '|| V_ESQUEMA_M ||'.ENTIDAD WHERE DESCRIPCION=''BANKIA''';        
	EXECUTE IMMEDIATE V_MSQL INTO ID_ENTIDAD;
	
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP              
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);          		
            
            --Vamos a comprobar primero si existe el usuario que queremos crear
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||''' ';
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            --Si no existe el usuario lo damos de alta
			IF V_NUM_TABLAS < 1 THEN                        			
					
				-- CREAMOS UN USUARIO				
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
				        		||ID_ENTIDAD||','
				        		||''''||V_TMP_TIPO_TFA(2)||''''||','
				        		||''''||V_TMP_TIPO_TFA(3)||''''||','
				        		||''''||V_TMP_TIPO_TFA(4)||''''||','
				        		||'''ape1'', ''ape2'', ''111111111'', ''my@email.com'','
				        		||'0, ''ETL'',sysdate,''ETL'',sysdate,1,TO_DATE(''01/01/2017'',''DD/MM/YYYY''),0,sysdate,0,0,NULL,NULL)';					
				
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		
				EXECUTE IMMEDIATE V_MSQL;					
				
				DBMS_OUTPUT.PUT_LINE('Creado el usuario '||V_TMP_TIPO_TFA(2)||' correctamente.');					
						
					--Por último, damos los perfiles necesarios al usuario creado.
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (' ||
							  ' ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' ||
							  ' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01''), ' ||
							  '(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''FPFSRADMIN''), ' ||
							  '(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_TIPO_TFA(2)||'''),' ||
							  V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
							  '0,' ||
							  ''''||V_ESQUEMA_M||''',' ||
							  'sysdate,' ||
							  '0)';
							
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
              		
					EXECUTE IMMEDIATE V_MSQL;	
					
					DBMS_OUTPUT.PUT_LINE('Ya dado el perfil ''FPFSRADMIN'' () al usuario '||V_TMP_TIPO_TFA(2));							
			
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