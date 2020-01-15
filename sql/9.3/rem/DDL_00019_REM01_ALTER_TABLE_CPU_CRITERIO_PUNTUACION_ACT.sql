--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6048
--## PRODUCTO=NO
--## Finalidad: Añadir la columna CPU_VALOR_BANKIA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_TABLAS NUMBER(25);
	
	V_TABLA VARCHAR2(50 CHAR) := 'CPU_CRITERIO_PUNTUACION_ACT';
	V_COLUMN VARCHAR2(50 CHAR) := 'CPU_VALOR_BANKIA';
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
  	IF V_NUM_TABLAS > 0 THEN
  		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
       	IF V_NUM_TABLAS = 0 THEN
       		-- Añadimos la columna
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COLUMN||' NUMBER(16,0)';
            
	  		-- Añadimos el comentario
            EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMN||' IS ''Valor otorgado al criterio de puntuación para la cartera Bankia''';
            
            DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '||V_TABLA||'.'||V_COLUMN||' creada.');
            
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '||V_TABLA||'.'||V_COLUMN||' ya existe.');
			
		END IF;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('	[INFO] La tabla '||V_TABLA||' no existe.');
		
	END IF;
	
	COMMIT;
  	DBMS_OUTPUT.PUT_LINE('[FIN]');
  	
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;   
END;
/
EXIT;