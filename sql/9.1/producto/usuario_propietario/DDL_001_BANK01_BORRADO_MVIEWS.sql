--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151028
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=SI
--## Finalidad: Borrar vistas materializadas que no se usan
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
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
       
    --** Comprobamos si existeN las vistas  
    
	--TMP_ARQ_RECOBRO
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''TMP_ARQ_RECOBRO'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.TMP_ARQ_RECOBRO';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ARQ_RECOBRO... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ARQ_RECOBRO... Comprobaciones previas FIN');
    
     
	--BATCH_RCF_ENTRADA
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_RCF_ENTRADA'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_RCF_ENTRADA';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_RCF_ENTRADA... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_RCF_ENTRADA... Comprobaciones previas FIN');
    
	--BATCH_DATOS_EXP
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_EXP'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_EXP';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXP... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXP... Comprobaciones previas FIN');      

	--BATCH_DATOS_CNT_EXP
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_CNT_EXP'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_CNT_EXP';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_EXP... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_EXP... Comprobaciones previas FIN');      
    
	--BATCH_DATOS_PER_EXP
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_PER_EXP'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_PER_EXP';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER_EXP... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER_EXP... Comprobaciones previas FIN');      
    
	--BATCH_DATOS_EXP_MANUAL
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_EXP_MANUAL'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_EXP_MANUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXP_MANUAL... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXP_MANUAL... Comprobaciones previas FIN');      
    
	--BATCH_DATOS_CNT_PER
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_CNT_PER'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_CNT_PER';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_PER... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_PER... Comprobaciones previas FIN');      
    
	--BATCH_DATOS_CNT
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_CNT'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_CNT';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT... Comprobaciones previas FIN');          
            
	--BATCH_DATOS_PER
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_PER'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_PER';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_PER... Comprobaciones previas FIN');          
            
	--BATCH_DATOS_CNT_INFO
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_CNT_INFO'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_CNT_INFO';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_INFO... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_INFO... Comprobaciones previas FIN');          
         
	--BATCH_DATOS_CLI
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_CLI'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_CLI';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CLI... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CLI... Comprobaciones previas FIN');          
          
	--BATCH_DATOS_EXCEPTUADOS
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_EXCEPTUADOS'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_EXCEPTUADOS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXCEPTUADOS... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_EXCEPTUADOS... Comprobaciones previas FIN');          
            
	--BATCH_DATOS_GCL
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''BATCH_DATOS_GCL'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.BATCH_DATOS_GCL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_GCL... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_GCL... Comprobaciones previas FIN');          

	--T_ARP_ARQ_RECOBRO_PERSONA
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''T_ARP_ARQ_RECOBRO_PERSONA'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA... Comprobaciones previas FIN'); 
    
	--T_ARP_ARQ_RECOBRO_PERSONA_SIM
	
    V_SQL := 'Select COUNT(1) from ALL_MVIEWS where MVIEW_NAME = ''T_ARP_ARQ_RECOBRO_PERSONA_SIM'' and owner= '''||v_esquema||'''';	
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP MATERIALIZED VIEW '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM... Vista Materializada borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM... Comprobaciones previas FIN');                                                                 

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


