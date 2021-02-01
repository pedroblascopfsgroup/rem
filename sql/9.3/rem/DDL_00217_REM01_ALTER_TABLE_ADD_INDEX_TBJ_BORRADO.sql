--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20200127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12924
--## PRODUCTO=NO
--## Finalidad: Añadir índice tbj-borrado
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COLUMN VARCHAR2(256 CHAR) := 'TBJ_ID';
    V_COLUMN2 VARCHAR2(256 CHAR) := 'BORRADO';
    V_INDEX VARCHAR2(256 CHAR) := 'IDX_ACT_TBJ_BORRADO';


    
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN||''' and COLUMN_NAME = '''||V_COLUMN2||''' AND TABLE_NAME = '''||V_TEXT_TABLA||'''  and OWNER = '''||V_ESQUEMA||'''';
		
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS > 0 THEN 
			
			 V_SQL :='SELECT COUNT(INDEX_NAME) INTO HAY FROM ALL_INDEXES  WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND INDEX_NAME ='''||V_INDEX||'''  ';
			 
			 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			 
			 IF V_NUM_TABLAS = 0 THEN 
		
				EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.' || V_INDEX || '. ON ' || V_ESQUEMA || '.' || V_TEXT_TABLA || ' (' || V_COLUMN || ',' || V_COLUMN2 || ') ' ;
				
			END IF;
			
		END IF;
		
	COMMIT;
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT