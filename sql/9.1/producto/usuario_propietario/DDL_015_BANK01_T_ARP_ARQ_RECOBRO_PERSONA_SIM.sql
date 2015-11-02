--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=SI
--## Finalidad: DDL
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
    

    -------------------------------------
    --  T_ARP_ARQ_RECOBRO_PERSONA_SIM  --
    ------------------------------------- 
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''T_ARP_ARQ_RECOBRO_PERSONA_SIM'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM... Comprobaciones previas FIN');


    --** Creamos la tabla

           
     V_MSQL := 'CREATE TABLE ' ||v_esquema|| '.T_ARP_ARQ_RECOBRO_PERSONA_SIM 
				   (	
					ARP_ID                         NUMBER(16,0), 
					PER_ID                         NUMBER(16,0), 
					ARQ_ID                         NUMBER(16,0), 
					ARQ_NAME                       VARCHAR2(100 CHAR), 
					ARQ_PRIO                       NUMBER(16,0), 
					ARQ_DATE                       TIMESTAMP (6), 
					VERSION                        NUMBER(1,0) DEFAULT 0, 
					USUARIOCREAR                   VARCHAR2(10 CHAR) NOT NULL, 
					FECHACREAR                     TIMESTAMP (6) DEFAULT SYSDATE NOT NULL, 
					USUARIOMODIFICAR               VARCHAR2(10 CHAR), 
					FECHAMODIFICAR                 TIMESTAMP (6), 
					USUARIOBORRAR                  VARCHAR2(10 CHAR), 
					FECHABORRAR                    TIMESTAMP (6), 
					BORRADO NUMBER(1,0)            DEFAULT 0 NOT NULL
				   )';
	 
  
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.T_ARP_ARQ_RECOBRO_PERSONA_SIM... Tabla creada');

    
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
    
