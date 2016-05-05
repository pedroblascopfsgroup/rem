--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3089
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
    
    -----------------------
    --   DD_ESTADO_CNT   --
    -----------------------   
    
    --** Cambiamos Diccionario estado contrato 
       
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA PRIMER RECLAMADO'', dd_tcp_descripcion_larga=''ENTREGA PRIMER RECLAMADO'' where dd_tcp_codigo=''01'''; 
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA OTROS RECLAMADOS'', dd_tcp_descripcion_larga=''ENTREGA OTROS RECLAMADOS'' where dd_tcp_codigo=''02'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA TERCEROS POR CUENTA DEL RECLAMADO'', dd_tcp_descripcion_larga=''ENTREGA TERCEROS POR CUENTA DEL RECLAMADO'' where dd_tcp_codigo=''03'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS'', dd_tcp_descripcion_larga=''TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS'' where dd_tcp_codigo=''04'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''REFINANCIACIÓN/REINSTRUMENTACIÓN'', dd_tcp_descripcion_larga=''REFINANCIACIÓN/REINSTRUMENTACIÓN'' where dd_tcp_codigo=''05''';  
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''DACIÓN EN PAGO DE DEUDA'', dd_tcp_descripcion_larga=''DACIÓN EN PAGO DE DEUDA'' where dd_tcp_codigo=''06'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA JUDICIAL POR RETENCIÓN DE HABERES'', dd_tcp_descripcion_larga=''ENTREGA JUDICIAL POR RETENCIÓN DE HABERES'' where dd_tcp_codigo=''07'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA JUDICIAL POR CESIÓN DE REMATE'', dd_tcp_descripcion_larga=''ENTREGA JUDICIAL POR CESIÓN DE REMATE'' where dd_tcp_codigo=''08''';  
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA'', dd_tcp_descripcion_larga=''ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA'' where dd_tcp_codigo=''09'''; 
 EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'update '||v_esquema||'.dd_tcp_tipo_cobro_pago set dd_tcp_descripcion=''Gastos procurador'', dd_tcp_descripcion_larga=''Gastos procurador'' where dd_tcp_codigo=''47''';  
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'delete from '||v_esquema||'.dd_tcp_tipo_cobro_pago where dd_tcp_codigo in (''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'')'; 
 EXECUTE IMMEDIATE V_MSQL;

    
     
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
