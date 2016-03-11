--/*
--##########################################
--## AUTOR=SERGIO HERNANDEZ
--## FECHA_CREACION=20151222
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=HR-1499
--## INCIDENCIA_LINK=HR-1499
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');
  --Validamos si existen los campos antes de crearlos
  SELECT COUNT(*) INTO V_EXISTE  
  FROM ALL_TAB_COLUMNS 
  WHERE TABLE_NAME = 'BIE_TEA'
    AND OWNER      = ''||V_ESQUEMA||''
    AND COLUMN_NAME = 'SYS_GUID';
            
 IF V_EXISTE = 0 THEN   

       EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.BIE_TEA ADD SYS_GUID VARCHAR2(32 BYTE)');                                      
       DBMS_OUTPUT.PUT_LINE('COLUMNA SYS_GUID CREADA');

  ELSE   
       DBMS_OUTPUT.PUT_LINE('Los campos ya existen en la tabla BIE_TEA');  
  END IF;     
 

  SELECT COUNT(*) INTO V_EXISTE  
  FROM ALL_TAB_COLUMNS 
  WHERE TABLE_NAME = 'TEA_CNT'
    AND OWNER      = ''||V_ESQUEMA||''
    AND COLUMN_NAME = 'SYS_GUID';
            
 IF V_EXISTE = 0 THEN   

       EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.TEA_CNT ADD SYS_GUID VARCHAR2(32 BYTE)');                                      
       DBMS_OUTPUT.PUT_LINE('COLUMNA SYS_GUID CREADA');

  ELSE   
       DBMS_OUTPUT.PUT_LINE('Los campos ya existen en la tabla TEA_CNT');  
  END IF;     
        

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



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
