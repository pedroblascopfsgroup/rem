--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20150721
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=NO-DISPONIBLE
--## INCIDENCIA_LINK=NO-DISPONIBLE
--## PRODUCTO=SI
--##
--## Finalidad: Adaptar el modelo de datos al proceso batch de revisión de clientes
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

TYPE T_TABLA IS TABLE OF VARCHAR2(1500);
TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
V_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
  T_TABLA(V_ESQUEMA,'TMP_CLI_PER_ARQ','TABLE',' CLI_ID NUMBER(16) NOT NULL
      , PER_ID  NUMBER(16) NOT NULL
      , ARQ_CLIENTE NUMBER(16) NOT NULL
      , ARQ_PERSONA NUMBER(16) NOT NULL
      , ES_ARQ_GESTION NUMBER(1) NOT NULL')
  ,T_TABLA(V_ESQUEMA,'TMP_CLI_A_CANCELAR','TABLE','CLI_ID NUMBER(16) NOT NULL')
  ,T_TABLA(V_ESQUEMA,'TMP_MOV_REVISADOS','TABLE','CNT_ID NUMBER(16,0) NOT NULL,    
    cli_id number(16,0) not null,
    ARQ_ID NUMBER(16,0) NOT NULL,
    DD_TIT_CODIGO  VARCHAR2(50 CHAR) NOT NULL,
    ES_PASE               NUMBER(1) NOT NULL,
    CANCELADO             NUMBER(1) NOT NULL,
    SALDADOSINMOVANTERIOR NUMBER(1) NOT NULL,
    SALDADO               NUMBER(1) NOT NULL,
    DIFERENCIA            NUMBER(14,2) NOT NULL,
    IMPORTE               NUMBER(14,2) NOT NULL,
    IMPORTEANTERIOR       NUMBER(14,2) NOT NULL,
    ACTIVO                NUMBER(1,0) NOT NULL,
    FECHAVENCIDO          DATE,
    FECHAEXTRACCION       DATE')
  ,T_TABLA(V_ESQUEMA,'TMP_EXP_REVISION','TABLE',
  ' EXP_ID NUMBER(16) NOT NULL
   , CNT_ID  NUMBER(16) NOT NULL
   , PASE NUMBER(1) NOT NULL
   , PROCESS_BPM NUMBER(16) NOT NULL
   , MANUAL NUMBER(1) NOT NULL'
  )
  ,
   T_TABLA(V_ESQUEMA,'TMP_MOV_REVISADOS_EXP','TABLE','CNT_ID NUMBER(16,0) NOT NULL,    
    EXP_ID number(16,0) not null,
    ES_PASE               NUMBER(1) NOT NULL,
    CANCELADO             NUMBER(1) NOT NULL,
    SALDADOSINMOVANTERIOR NUMBER(1) NOT NULL,
    SALDADO               NUMBER(1) NOT NULL,
    DIFERENCIA            NUMBER(14,2) NOT NULL,
    IMPORTE               NUMBER(14,2) NOT NULL,
    IMPORTEANTERIOR       NUMBER(14,2) NOT NULL,
    ACTIVO                NUMBER(1,0) NOT NULL,
    FECHAVENCIDO          DATE,
    FECHAEXTRACCION       DATE')
   ,
   T_TABLA(V_ESQUEMA,'TMP_EXP_A_CANCELAR','TABLE','EXP_ID NUMBER(16) NOT NULL')
  
  --,T_TABLA('','GLOBAL TEMPORARY TABLE')
);
V_TMP_TABLA T_TABLA;
BEGIN


    DBMS_OUTPUT.PUT_LINE('[START] Creación tablas temporales para revisión de clientes');

  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
            V_TMP_TABLA := V_TABLA(I);
            
            --Se verifica si existe la tabla  en el esquema indicado
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || TRIM(V_TMP_TABLA(2)) || ''' AND OWNER = '''|| TRIM(V_TMP_TABLA(1)) || '''';
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
            -- Si existe la tabla se borra
            DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando existencia tabla ''' || TRIM(V_TMP_TABLA(2)) || ''', en esquema '|| TRIM(V_TMP_TABLA(1)) ||'...'); 
            IF V_NUM_TABLAS > 0 THEN        
              V_SQL :=  'DROP TABLE ' || TRIM(V_TMP_TABLA(1)) || '.' || TRIM(V_TMP_TABLA(2)) || ' PURGE';
              --DBMS_OUTPUT.PUT_LINE (V_SQL);
              EXECUTE IMMEDIATE V_SQL;
              DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || TRIM(V_TMP_TABLA(2)) || ' borrada');
            END IF;
        
            --Creación de la tabla
            V_SQL :=  'CREATE ' || TRIM(V_TMP_TABLA(3)) || ' ' || TRIM(V_TMP_TABLA(1)) || '.' || TRIM(V_TMP_TABLA(2)) 
                      || ' ( ' || TRIM(V_TMP_TABLA(4)) || ' )';
            --DBMS_OUTPUT.PUT_LINE (V_SQL);
            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || TRIM(V_TMP_TABLA(2)) || ' creada');

    END LOOP;
    

DBMS_OUTPUT.PUT_LINE('[END] Creación tablas temporales para la REVISIÓN de clientes');
 
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
