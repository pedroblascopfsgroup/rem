--/*
--##########################################
--## AUTOR=Luis Adelantado Romero
--## FECHA_CREACION=201922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5063
--## PRODUCTO=NO
--## Finalidad: DDL Creación de tabla ACT_DCA_DATOS_CONTRATO_ALQ
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_DCA_DATOS_CONTRATO_ALQ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

  --Array para crear las claves foraneas
  TYPE T_FK IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_FK IS TABLE OF T_FK;
  V_FK T_ARRAY_FK := T_ARRAY_FK(
      ------ ESQUEMA_ORIGEN --- TABLA_ORIGEN ------- CAMPO_ORIGEN ------- ESQUEMA_DESTINO ----- TABLA_DESTINO ----------- CAMPO_DESTINO --- NOMBRE_F -------------------------
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'ACT_ID'            ,''||V_ESQUEMA||''    ,'ACT_ACTIVO'            ,'ACT_ID'         ,'FK_ACT_DCA_ACT_ID')
  );      
  V_TMP_FK T_FK;
  
BEGIN
    
    -----------------------
    ---     TABLA       ---
    -----------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
		  "DCA_ID"                         	NUMBER(16,0),
		  "DCA_FECHA_CREACION"				DATE,
		  "DCA_NOM_PRINEX"                  VARCHAR2(255 CHAR),
		  "ACT_ID"                      	NUMBER(16,0),
		  "DCA_UHEDIT"                  	VARCHAR2(255 CHAR),
		  "DCA_ID_CONTRATO"              	VARCHAR2(255 CHAR),
		  "DCA_EST_CONTRATO"                VARCHAR2(255 CHAR),
		  "DCA_FECHA_FIRMA"                 DATE,
		  "DCA_FECHA_FIN_CONTRATO"          DATE,
		  "DCA_CUOTA"                      	NUMBER(16,2),
		  "DCA_NOMBRE_CLIENTE"              VARCHAR2(255 CHAR), 
		  "DCA_DEUDA_PENDIENTE"        		NUMBER(16,2),
	      "DCA_RECIBOS_PENDIENTES"          NUMBER(16,0),
	      "DCA_F_ULTIMO_PAGADO"             DATE, 
	      "DCA_F_ULTIMO_ADEUDADO"           DATE,
		  "VERSION"                  NUMBER(*,0) DEFAULT 0 NOT NULL,
		  "USUARIOCREAR"             VARCHAR2(50 CHAR) NOT NULL,
		  "FECHACREAR"               DATE DEFAULT SYSDATE NOT NULL,
	      "USUARIOMODIFICAR"         VARCHAR2(50 CHAR),
	      "FECHAMODIFICAR"           DATE,
	      "USUARIOBORRAR"            VARCHAR2(50 CHAR),
	      "FECHABORRAR"              DATE,
		"BORRADO"                  NUMBER(*,0) DEFAULT 0 NOT NULL
		   )';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');

		-- Creamos comentario tabla
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla para gestionar los datos de los contratos de alquiler.'' ';      
		EXECUTE IMMEDIATE V_SQL;
				
		-- Creamos comentarios columnas
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_ID IS ''Código identificador único de la tabla datos de los contratos de alquiler.'' ';      
		EXECUTE IMMEDIATE V_SQL;		

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_FECHA_CREACION IS ''Fecha de creación de los datos.'' ';      
		EXECUTE IMMEDIATE V_SQL;	
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_NOM_PRINEX IS ''Nombre Prinex'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID IS ''Código identificador único del activo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_UHEDIT IS ''Código UHEDIT.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_ID_CONTRATO IS ''Código identificador único del contrato.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_EST_CONTRATO IS ''Estado del contrato.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_FECHA_FIRMA IS ''Fecha de la firma.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_FECHA_FIN_CONTRATO IS ''Fecha del fin del contrato.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_CUOTA IS ''Cuota mensual.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_NOMBRE_CLIENTE IS ''Nombre del cliente.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_DEUDA_PENDIENTE IS ''Deuda pendiente.'' ';      
		EXECUTE IMMEDIATE V_SQL;		
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_RECIBOS_PENDIENTES IS ''Recibos pendientes.'' ';      
		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_F_ULTIMO_PAGADO IS ''Último recibo pagado.'' ';      
		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_F_ULTIMO_ADEUDADO IS ''Último recibo adecuado.'' ';      
		EXECUTE IMMEDIATE V_SQL;
		
    END IF;
    
    ---------------------------
    -------     PK      -------
    ---------------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P'''
        INTO V_NUM_TABLAS; 
        
    IF V_NUM_TABLAS > 0 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] La PK PK_'||V_TEXT_TABLA||'... Ya existe.');                 
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] Creando PK_'||V_TEXT_TABLA||'...');           
        /*PK_ACT_PRY_PROYECTO*/
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_TEXT_TABLA||' 
            ADD (CONSTRAINT PK_'||V_TEXT_TABLA||' PRIMARY KEY (DCA_ID))
        ';               
    END IF;    
    
    ---------------------------
    ---     SECUENCIA       ---
    ---------------------------
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME =''S_'||V_TEXT_TABLA||''' AND SEQUENCE_OWNER='''||V_ESQUEMA||''''
        INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[CREAMOS S_'||V_TEXT_TABLA||']');
		V_SQL:= 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[S_'||V_TEXT_TABLA||' CREADA]');
    END IF;
    
    --------------------------------
    ---     CLAVES FORANEAS      ---
    --------------------------------    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO CLAVES FORANEAS]');

    FOR J IN V_FK.FIRST .. V_FK.LAST
    LOOP
        V_TMP_FK := V_FK(J);
        
        EXECUTE IMMEDIATE '
          SELECT COUNT(1)
          FROM ALL_CONSTRAINTS CONS
            INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
          WHERE CONS.OWNER = '''||V_TMP_FK(1)||''' 
            AND CONS.TABLE_NAME = '''||V_TMP_FK(2)||''' 
            AND CONS.CONSTRAINT_TYPE = ''R''
            AND COL.COLUMN_NAME = '''||V_TMP_FK(3)||'''
        '
        INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_FK(7)||'... Ya existe.');                 
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_FK(7)||'...');           
            
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||' 
                ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||') 
                REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)
            '
            ;               
        END IF;
    
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');
    
    COMMIT;  
      
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
