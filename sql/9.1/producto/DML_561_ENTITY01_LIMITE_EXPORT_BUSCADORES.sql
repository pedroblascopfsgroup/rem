--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20160129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=PRODUCTO-513
--## PRODUCTO=SI
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''limiteExportExcelBuscadorClientes''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''2000'' where pen_param = ''limiteExportExcelBuscadorClientes''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''limiteExportExcelBuscadorClientes'', ''2000'', ''Limite de resultados para una exportación a Excel en el buscador de clientes'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;	
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''limiteExportExcelBuscadorContratos''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''2000'' where pen_param = ''limiteExportExcelBuscadorContratos''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''limiteExportExcelBuscadorContratos'', ''2000'', ''Limite de resultados para una exportación a Excel en el buscador de contratos'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;	
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''limiteExportExcelBuscadorProcedimientos''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''2000'' where pen_param = ''limiteExportExcelBuscadorProcedimientos''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''limiteExportExcelBuscadorProcedimientos'', ''2000'', ''Limite de resultados para una exportación a Excel en el buscador de procedimientos'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''limiteExportExcelBuscadorExpedientes''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''2000'' where pen_param = ''limiteExportExcelBuscadorExpedientes''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''limiteExportExcelBuscadorExpedientes'', ''2000'', ''Limite de resultados para una exportación a Excel en el buscador de expedientes'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
    
V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''limiteExportExcelBuscadorTareas''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''2000'' where pen_param = ''limiteExportExcelBuscadorTareas''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''limiteExportExcelBuscadorTareas'', ''2000'', ''Limite de resultados para una exportación a Excel en el buscador de tareas pendientes'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
   

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

