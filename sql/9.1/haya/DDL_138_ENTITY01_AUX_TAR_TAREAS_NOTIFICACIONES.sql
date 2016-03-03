--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=29-2-2016
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-2285
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla AUX_TAR_TAREAS_NOTIFICACIONES
--##           
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--------------------------------------------------------
--  DDL for Table AUX_TAR_TAREAS_NOTIFICACIONES
--------------------------------------------------------
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN
	     
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_TAR_TAREAS_NOTIFICACIONES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AUX_TAR_TAREAS_NOTIFICACIONES... La tabla YA EXISTE');
    ELSE
    		  --Creamos la tabla
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_TAR_TAREAS_NOTIFICACIONES
   (	"TAR_ID" NUMBER(16,0), 
	"CLI_ID" NUMBER(16,0), 
	"EXP_ID" NUMBER(16,0), 
	"ASU_ID" NUMBER(16,0), 
	"TAR_TAR_ID" NUMBER(16,0), 
	"SPR_ID" NUMBER(16,0), 
	"SCX_ID" NUMBER(16,0), 
	"DD_EST_ID" NUMBER(16,0), 
	"DD_EIN_ID" NUMBER(16,0), 
	"DD_STA_ID" NUMBER(16,0), 
	"TAR_CODIGO" VARCHAR2(100 CHAR), 
	"TAR_TAREA" VARCHAR2(100 CHAR), 
	"TAR_DESCRIPCION" VARCHAR2(4000 CHAR), 
	"TAR_FECHA_FIN" TIMESTAMP (6), 
	"TAR_FECHA_INI" TIMESTAMP (6), 
	"TAR_EN_ESPERA" NUMBER(1,0) DEFAULT 0, 
	"TAR_ALERTA" NUMBER(1,0) DEFAULT 0, 
	"TAR_TAREA_FINALIZADA" NUMBER(1,0) DEFAULT 0, 
	"TAR_EMISOR" VARCHAR2(50 CHAR), 
	"VERSION" NUMBER(*,0) DEFAULT 0, 
	"USUARIOCREAR" VARCHAR2(50 CHAR), 
	"FECHACREAR" TIMESTAMP (6), 
	"USUARIOMODIFICAR" VARCHAR2(50 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(50 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0, 
	"PRC_ID" NUMBER(16,0), 
	"CMB_ID" NUMBER(16,0), 
	"SET_ID" NUMBER(16,0), 
	"TAR_FECHA_VENC" TIMESTAMP (6), 
	"OBJ_ID" NUMBER(16,0), 
	"TAR_FECHA_VENC_REAL" TIMESTAMP (6), 
	"DTYPE" VARCHAR2(30 CHAR) DEFAULT 'EXTTareaNotificacion', 
	"NFA_TAR_REVISADA" NUMBER(1,0) DEFAULT 0, 
	"NFA_TAR_FECHA_REVIS_ALER" TIMESTAMP (6), 
	"NFA_TAR_COMENTARIOS_ALERTA" VARCHAR2(255 CHAR), 
	"DD_TRA_ID" NUMBER(16,0), 
	"CNT_ID" NUMBER(16,0), 
	"TAR_DESTINATARIO" VARCHAR2(20 CHAR), 
	"TAR_TIPO_DESTINATARIO" VARCHAR2(20 CHAR), 
	"TAR_ID_DEST" NUMBER(16,0), 
	"PER_ID" NUMBER(16,0), 
	"RPR_REFERENCIA" NUMBER(16,0), 
	"T_REFERENCIA" NUMBER(16,0), 
	"SYS_GUID" VARCHAR2(32 BYTE)
   )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AUX_TAR_TAREAS_NOTIFICACIONES... Tabla creada');
    		
    		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.AUX_TAR_TAREAS_NOTIFICACIONES  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AUX_TAR_TAREAS_NOTIFICACIONES... Secuencia creada correctamente.');
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
