--/* 
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20181130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-GENCAT
--## INCIDENCIA_LINK=HREOS-4835
--## PRODUCTO=SI
--##
--## Finalidad: Insertar registro GENC-01 en el diccionario DD_TDN_TIPO_DOCUMENTO 
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

  	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDN_TIPO_DOCUMENTO WHERE DD_TDN_CODIGO= ''GENC-01'' ';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TDN_TIPO_DOCUMENTO(		 
						DD_TDN_ID,		  
						DD_TDN_CODIGO,		  
						DD_TDN_DESCRIPCION,	  
						DD_TDN_DESCRIPCION_LARGA,		
						VERSION,		  
						USUARIOCREAR,		  
						FECHACREAR, 		   		  
						BORRADO
 						)
		values ( 
 		 '|| V_ESQUEMA || '.S_DD_TDN_TIPO_DOCUMENTO.nextval,
				 ''GENC-01'',
				 ''GENCAT: Anulación de la comunicación'',
				 ''GENCAT: Anulación de la comunicación'',
				 1,
				''DML'',
				 SYSDATE,
				 0)';


		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL ; 
 	DBMS_OUTPUT.PUT_LINE('[INFO]:REGISTRO CREADO');

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

