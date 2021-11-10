--/*
--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20210628
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14376
--## PRODUCTO=NO
--## 
--## Finalidad: Insert de tabla DD_MDE_MOTIVO_DESBLOQUEO
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################


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
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('DBLOQS','Desbloqueo Screening')
   
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		--Comprobar matricula

           DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR CODIGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
    		--Comprobar codigo      
          	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MDE_MOTIVO_DESBLOQUEO  WHERE DD_MDE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	          
			-- Insertar el nuevo codigo y matricula
			IF V_NUM_TABLAS = 0 THEN 	
	       	   V_MSQL := '
	                     INSERT INTO '|| V_ESQUEMA ||'.DD_MDE_MOTIVO_DESBLOQUEO (
	                        DD_MDE_ID,
	                        DD_MDE_CODIGO,
	                        DD_MDE_DESCRIPCION,
	                        DD_MDE_DESCRIPCION_LARGA,
	                        VERSION,
	                        USUARIOCREAR,
	                        FECHACREAR,
	                        BORRADO 		                       
	                    ) VALUES (
	                        '|| V_ESQUEMA ||'.S_DD_MDE_MOTIVO_DESBLOQUEO.NEXTVAL,
	                        '''||TRIM(V_TMP_TIPO_DATA(1))||''',
	                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	                        0,
	                        ''HREOS-14376'',
	                        SYSDATE,
	                        0		                        
	                      )';
	
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		        
		    ELSE
 
				DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR REGISTRO PARA EL CÓDIGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');		
				--Actualizar matricula				
			    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MDE_MOTIVO_DESBLOQUEO
										SET DD_MDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
			            				DD_MDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
			            				USUARIOMODIFICAR = ''HREOS-14376'',
			            				FECHAMODIFICAR = SYSDATE,
			            				BORRADO = 0
										WHERE DD_MDE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
			                        
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
			
		END IF;            
      
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MDE_MOTIVO_DESBLOQUEO ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
