--/*
--##########################################
--## Author: CARLOS
--## Finalidad: DML PARA PERSONALIZAR EL LOGO DEL CLIENTE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


  DBMS_OUTPUT.PUT_LINE('[INICIO] CAMBIO LOGO');  
  execute immediate 'UPDATE ' || V_ESQUEMA_M || '.ENTIDADCONFIG SET DATAVALUE = ''logo-haya-recovery.jpg'' WHERE ENTIDAD_ID = 1 AND DATAKEY=''logo''';
  
  DBMS_OUTPUT.PUT_LINE('[END] LOGO CAMBIADO CORRECTAMENTE');  
    
COMMIT;


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;

END;

/

EXIT
