--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20190117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.5
--## INCIDENCIA_LINK=HREOS-5243
--## PRODUCTO=NO
--## 
--## Finalidad: Alter tabla de APR_AUX_BIE_ID_FROM_REC
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
  V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- #ESQUEMA# Configuracion Esquema
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TABLA VARCHAR2(50 CHAR):= 'APR_AUX_BIE_ID_FROM_REC'; -- Nombre de la tabla a crear
  V_COL VARCHAR2(50 CHAR):= 'TIPO_TRAMITE';
  V_TYPE VARCHAR2(50 CHAR):= 'VARCHAR2(30 CHAR)';

  
BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');
      
EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN

  DBMS_OUTPUT.PUT_LINE('[INFO] Procedemos a añadir la columna '||V_COL||' de 30 char. en '||V_ESQUEMA||'.'||V_TABLA);

  EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL||' '||V_TYPE;

ELSE

  DBMS_OUTPUT.PUT_LINE('[INFO] No existe '||V_ESQUEMA||'.'||V_TABLA);

END IF;

DBMS_OUTPUT.PUT_LINE('[FIN]');

COMMIT;

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