--/* 
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20181130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-GENCAT
--## INCIDENCIA_LINK=HREOS-4835
--## PRODUCTO=SI
--##
--## Finalidad: Insertar 5 filas Creado, Rechazado, Comunicado, Sancionado y Anulado en el diccionario DD_ECG_ESTADO_COM_GENCAT 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 


BEGIN

  -------------- PRIMER REGISTRO
  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO= ''CREADO'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT(		 
						DD_ECG_ID,		  
						DD_ECG_CODIGO,		  
						DD_ECG_DESCRIPCION,	  
						DD_ECG_DESCRIPCION_LARGA,  		
						VERSION, 		  
						USUARIOCREAR, 		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_ECG_ESTADO_COM_GENCAT.nextval,
				 ''CREADO'',
				 ''Creado'',
				 ''Creado'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: PRIMER REGISTRO CREADO');

	END IF;  

  -------------- SEGUNDO REGISTRO
            
  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO= ''RECHAZADO'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT(		 
						DD_ECG_ID,		  
						DD_ECG_CODIGO,		  
						DD_ECG_DESCRIPCION,	  
						DD_ECG_DESCRIPCION_LARGA,  		
						VERSION, 		  
						USUARIOCREAR, 		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_ECG_ESTADO_COM_GENCAT.nextval,
				 ''RECHAZADO'',
				 ''Rechazado'',
				 ''Rechazado'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: SEGUNDO REGISTRO CREADO');

	END IF;  


  -------------- TERCER REGISTRO
            
  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO= ''COMUNICADO'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT(		 
						DD_ECG_ID,		  
						DD_ECG_CODIGO,		  
						DD_ECG_DESCRIPCION,	  
						DD_ECG_DESCRIPCION_LARGA,  		
						VERSION, 		  
						USUARIOCREAR, 		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_ECG_ESTADO_COM_GENCAT.nextval,
				 ''COMUNICADO'',
				 ''Comunicado'',
				 ''Comunicado'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: TERCER REGISTRO CREADO');

	END IF;  

  -------------- CUARTO REGISTRO
            
  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO= ''SANCIONADO'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT(		 
						DD_ECG_ID,		  
						DD_ECG_CODIGO,		  
						DD_ECG_DESCRIPCION,	  
						DD_ECG_DESCRIPCION_LARGA,  		
						VERSION, 		  
						USUARIOCREAR, 		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_ECG_ESTADO_COM_GENCAT.nextval,
				 ''SANCIONADO'',
				 ''Sancionado'',
				 ''Sancionado'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: CUARTO REGISTRO CREADO');

	END IF;  

  -------------- QUINTO REGISTRO
            
  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT WHERE DD_ECG_CODIGO= ''ANULADO'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT(		 
						DD_ECG_ID,		  
						DD_ECG_CODIGO,		  
						DD_ECG_DESCRIPCION,	  
						DD_ECG_DESCRIPCION_LARGA,  		
						VERSION,		  
						USUARIOCREAR, 		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_ECG_ESTADO_COM_GENCAT.nextval,
				 ''ANULADO'',
				 ''Anulado'',
				 ''Anulado'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]: QUINTO REGISTRO CREADO');

	END IF;  

 COMMIT;
           
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;

/

EXIT;

