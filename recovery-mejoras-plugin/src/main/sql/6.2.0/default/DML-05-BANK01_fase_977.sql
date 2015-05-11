--/*
--##########################################
--## Author: Óscar
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR(1500 CHAR);
    
BEGIN

	 V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.dd_ta_tipo_anotacion WHERE DD_TA_CODIGO= ''PROV''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'insert into '||V_ESQUEMA||'.dd_ta_tipo_anotacion (DD_TA_ID, DD_TA_CODIGO, DD_TA_DESCRIPCION, DD_TA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES ((select max(dd_ta_id)+1 from '||V_ESQUEMA||'.dd_ta_tipo_anotacion), ''PROV'', ''Provisión'', ''Provisión'', ''SAG'', sysdate)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
	

    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA_M||'.dd_eas_estado_asuntos WHERE DD_EAS_CODIGO= ''20''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'insert into '||V_ESQUEMA_M||'.dd_eas_estado_asuntos (dd_eas_id, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES ('||V_ESQUEMA_M||'.s_dd_eas_estado_asuntos.nextval, ''20'', ''Gestión finalizada'', ''Gestión finalizada con provisiones pendientes'', ''SAG'', sysdate)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  

    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.asu_asuntos asu join '||V_ESQUEMA_M||'.dd_eas_estado_asuntos eas on asu.dd_eas_id = eas.dd_eas_id where dd_eas_codigo in (''00'', ''08'', ''12'', ''10'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Existen registros, con lo que no se puede marcar como borrado');
    ELSE        
      V_SQL := 'update '||V_ESQUEMA_M||'.dd_eas_estado_asuntos set borrado = 1, usuarioborrar = ''SAG'', fechaborrar = sysdate where dd_eas_codigo in (''00'', ''08'', ''12'', ''10'')';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
 


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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

