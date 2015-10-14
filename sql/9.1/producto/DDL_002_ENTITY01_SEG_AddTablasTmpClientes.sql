--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=NO-DISPONIBLE
--## INCIDENCIA_LINK=NO-DISPONIBLE
--## PRODUCTO=SI
--##
--## Finalidad: Adaptar el modelo de datos al proceso batch de creación de clientes
--## INSTRUCCIONES: --
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


SET SERVEROUTPUT ON; 

DECLARE
V_NUM_TABLAS number(16);
V_ESQUEMA   VARCHAR(25) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
V_SQL varchar2(4000);

BEGIN



    DBMS_OUTPUT.PUT_LINE('[START] Creación tablas temporales para inserción de clientes');

    --Se verifica si existe la tabla  en el esquema indicado
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_PER_ARQUETIPO_RECUPERACION'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tabla ''TMP_PER_ARQUETIPO_RECUPERACION'', en esquema '||V_ESQUEMA||'...'); 
    IF V_NUM_TABLAS > 0 THEN

      EXECUTE IMMEDIATE 'DROP TABLE ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION PURGE';
      DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_PER_ARQUETIPO_RECUPERACION borrada');
    END IF;

    EXECUTE IMMEDIATE '
    CREATE TABLE ' || V_ESQUEMA || '.TMP_PER_ARQUETIPO_RECUPERACION (
        PER_ID NUMBER(16) NOT NULL
        , ARQ_ID NUMBER(16) NOT NULL
        , CLI_ID NUMBER(16) NOT NULL
        , DD_TIT_CODIGO VARCHAR(5 CHAR) NOT NULL
    )';
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_PER_ARQUETIPO_RECUPERACION creada');




    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNT_NUEVOS_CLI'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tabla ''TMP_CNT_NUEVOS_CLI'', en esquema '||V_ESQUEMA||'...'); 
    IF V_NUM_TABLAS > 0 THEN

      EXECUTE IMMEDIATE 'DROP TABLE ' || V_ESQUEMA || '.TMP_CNT_NUEVOS_CLI PURGE';
      DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_CNT_NUEVOS_CLI borrada');
    END IF;
    
    -- CREATE TABLE TMP_CNT_NUEVOS_CLI (
    EXECUTE IMMEDIATE '
    CREATE TABLE ' || V_ESQUEMA || '.TMP_CNT_NUEVOS_CLI (
      PER_ID  NUMBER(16) NOT NULL
      , CNT_ID NUMBER(16) NOT NULL
      , OFI_ID NUMBER(16) NOT NULL
      , FECHA_POS_VENCIDA DATE
      , ES_CNT_PASE NUMBER(1) NOT NULL
    )';

    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_PER_ARQUETIPO_RECUPERACION creada');
 




DBMS_OUTPUT.PUT_LINE('[END] Creación tablas temporales para la inserción de clientes');
 
EXCEPTION     
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;

