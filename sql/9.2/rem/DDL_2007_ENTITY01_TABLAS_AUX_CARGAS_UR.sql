--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20160922
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-848
--## PRODUCTO=NO
--## 
--## Finalidad: Crear las tablas auxiliares de interfaz de cargas UVEM-REM
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(5500 CHAR);
    V_MSQL_C VARCHAR2(1000 CHAR);    
    V_MSQL_DROP VARCHAR2(4000 CHAR);
    V_TABLA VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;

BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

  V_TABLA :='APR_AUX_CAR_CARGAS';
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('[INFO] crear Tabla: '||V_TABLA);
  
  --Comprobar si existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
         NUMERO_ACTIVO              NUMBER(16,0) NOT NULL ENABLE, 
         TIPO_CARGA                 VARCHAR2(20 CHAR), 
         SUBTIPO_CARGA              VARCHAR2(20 CHAR), 
         TITULAR_CARGA              VARCHAR2(40 CHAR), 
         CODIGO_TITULAR             VARCHAR2(20 CHAR), 
         FECHA_INSCRIPCION_CARGA    DATE, 
         IMPORTE_CARGA              NUMBER(16,2), 
         IMPORTE_MAXIMO_CARGA       NUMBER(16,2), 
         CODIGO_GESTORIA            VARCHAR2(20 CHAR), 
         FECHA_PRESENT_CANCELACION  DATE, 
         FECHA_CANCELACION_ECONOM   DATE, 
         FECHA_ENTREGA_GEST_EVAL    DATE, 
         FECHA_DEVOL_625_CANCEL     DATE, 
         FECHA_INSCRIP_CANCELACION  DATE, 
         CODIGO_ESTADO_CARGA        VARCHAR2(20 CHAR), 
         CODIGO_UNIDAD_MONETARIA    VARCHAR2(20 CHAR), 
         CARGA_NO_CANCELABLE        NUMBER(1,0), 
         CARGA_CONTENIDO_ECONOM     NUMBER(1,0), 
         PROCEDIMIENTO_ID           NUMBER(16,0), 
         ANULACION_TOTAL_CARGAS     NUMBER(1,0), 
         NUMERO_ORDEN               NUMBER(3,0), 
         ID_CARGA_RECOVERY          NUMBER(16,0), 
         BIE_CAR_ID                 NUMBER(16,0), 
         CRG_ID                     NUMBER(16,0), 
         ACTUALIZA                  NUMBER(1,0), 
         BORRADO                    NUMBER(1,0), 
         FILLER                     VARCHAR2(43 CHAR),
         FECHA_EXTRACCION           DATE,
	       BIE_CAR_ECONOMICA NUMBER(1,0), 
	       BIE_CAR_REGISTRAL NUMBER(1,0)
  )';

  V_MSQL_C := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla auxiliar para el aprovisionamiento de la información de las cargas de los bienes de UVEM a REM.''';
  
  IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('    [INFO] '||V_TABLA||' no existe');
    EXECUTE IMMEDIATE V_MSQL;
    EXECUTE IMMEDIATE V_MSQL_C;    
    DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
  ELSE
    DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' ya existe');
    V_MSQL_DROP := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA;    
    
	EXECUTE IMMEDIATE V_MSQL_DROP;
    DBMS_OUTPUT.PUT_LINE('    [INFO] Borrada la tabla '||V_TABLA);
    
	EXECUTE IMMEDIATE V_MSQL;
        EXECUTE IMMEDIATE V_MSQL_C;   
    DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
  END IF; 
  

--------------------------------------------------------------------------------------------------------------------------  
  V_TABLA :='APR_AUX_CAR_REJECTS';
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('[INFO] crear Tabla: '||V_TABLA);
  
  --Comprobar si existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'   
  (      ERRORCODE      VARCHAR2(255 CHAR), 
         ERRORMESSAGE   VARCHAR2(512 CHAR), 
         ROWREJECTED    VARCHAR2(2048 CHAR)
   ) ';

  V_MSQL_C := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla auxiliar de rechazados para el aprovisionamiento de la información de las cargas de los bienes de UVEM a REM.''';  
  
  IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('    [INFO] '||V_TABLA||' no existe');
    EXECUTE IMMEDIATE V_MSQL;
    EXECUTE IMMEDIATE V_MSQL_C;       
    DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
  ELSE
    DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' ya existe');
    V_MSQL_DROP := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA;    
    
        EXECUTE IMMEDIATE V_MSQL_DROP;
    DBMS_OUTPUT.PUT_LINE('    [INFO] Borrada la tabla '||V_TABLA);
    
        EXECUTE IMMEDIATE V_MSQL;
        EXECUTE IMMEDIATE V_MSQL_C;   	
    DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
  END IF; 

--------------------------------------------------------------------------------------------------------------------------    
  
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
