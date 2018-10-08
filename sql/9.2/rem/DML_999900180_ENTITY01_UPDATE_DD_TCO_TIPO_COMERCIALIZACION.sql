--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20181008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4561
--## PRODUCTO=SI
--## 
--## Finalidad: Borrado lógico del registro de 'Alquiler con opción a compra'. 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TABLA VARCHAR2(30 CHAR) := 'DD_TCO_TIPO_COMERCIALIZACION';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'HREOS-4561'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de actualización de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  
  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');  
      
        V_MSQL := 'SELECT COUNT(1) FROM ' ||V_ESQUEMA|| '.'||V_TABLA||' WHERE DD_TCO_CODIGO = ''04'' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
		IF V_NUM_TABLAS = 1 THEN
		
			DBMS_OUTPUT.PUT_LINE('  [INFO] Borrado lógico del registro con código 04...');
			  
			  EXECUTE IMMEDIATE '
			  UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
				SET
				  BORRADO = 1,
				  USUARIOBORRAR = '''||V_USR||''',
				  FECHABORRAR = SYSDATE 
				WHERE DD_TCO_CODIGO = ''04'' ';
			  DBMS_OUTPUT.PUT_LINE('  [INFO] Borrado lógico realizado OK!');
		ELSE
			  DBMS_OUTPUT.PUT_LINE('  [INFO] El registro con código 04... No existe.');
		END IF;

    COMMIT;
    
  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... No existe.');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;

