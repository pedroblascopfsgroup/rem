--/*
--##########################################
--## Author: AIA
--## Finalidad: DDL UNDER_1
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    
BEGIN
  --
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-594');
  EXECUTE IMMEDIATE ' ALTER TABLE ' ||V_ESQUEMA|| '.BIE_CAR_CARGAS ADD DD_SIC_ID2 NUMBER(16) DEFAULT 3 NOT NULL ';
  
  EXECUTE IMMEDIATE ' ALTER TABLE ' ||V_ESQUEMA|| '.BIE_CAR_CARGAS ADD (
  CONSTRAINT FK_BIE_DD_SIC2
  FOREIGN KEY (DD_SIC_ID2)
  REFERENCES ' ||V_ESQUEMA|| '.DD_SIC_SITUACION_CARGA (DD_SIC_ID))' ; 
  
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;

END ;

/

EXIT
