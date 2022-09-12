--/* 
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.3
--## INCIDENCIA_LINK=HREOS-18322
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar la tabla OFC_OFERTAS_CONCURRENCIA
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
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  V_TABLA VARCHAR2(50 CHAR):= 'OFC_OFERTAS_CONCURRENCIA'; -- Nombre de la tabla a crear
 	  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    
BEGIN   

  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  
--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;      
  DBMS_OUTPUT.PUT_LINE('[INFO]LA TABLA ' || V_ESQUEMA || '.'||V_TABLA|| ' SE HA BORRADO CORRECTAMENTE');

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
