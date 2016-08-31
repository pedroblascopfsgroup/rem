--/*
--##########################################
--## AUTOR=Manuel Rodríguez Sajardo
--## FECHA_CREACION=20160707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=RECOVERY-2021
--## PRODUCTO=NO
--## Finalidad: Crear la tabla MIG_EXPEDIENTES_LIQUIDACIONES
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'MIG_EXPEDIENTES_LIQUIDACIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN
	
	-- Comprobamos si existe la tabla
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'... YA EXISTE');
	ELSE
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
        (   
            NUM_CUENTA          NUMBER(17,0)    NOT NULL ENABLE, 
            CAPITAL_CER           NUMBER(15,2),
            INTERES_CER           NUMBER(15,2),
            DEMORA_CER          NUMBER(15,2),
            FECHA_CIERRE         DATE              
        ) SEGMENT CREATION IMMEDIATE 
        NOCOMPRESS LOGGING';
		EXECUTE IMMEDIATE V_MSQL;	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'...  HA SIDO CREADA');
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
