--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1058
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade campo PROCURADOR_PRC_ID en tablas de procedimientos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema ESQUEMA_DWH
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN 

V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''h_prc'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.h_prc ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''h_prc_semana'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.h_prc_semana ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''h_prc_mes'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.h_prc_mes ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''h_prc_trimestre'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.h_prc_trimestre ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''h_prc_anio'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.h_prc_anio ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''tmp_h_prc'' AND COLUMN_NAME= ''PROCURADOR_PRC_ID'' AND DATA_TYPE=''NUMBER(16,0)'' and owner = ''' || V_ESQUEMA || '''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.tmp_h_prc ADD ( PROCURADOR_PRC_ID NUMBER(16,0) )';
END IF;


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