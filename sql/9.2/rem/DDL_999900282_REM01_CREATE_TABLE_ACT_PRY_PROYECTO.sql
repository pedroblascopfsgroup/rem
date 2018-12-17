--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4293
--## PRODUCTO=NO
--## Finalidad: DDL Creación de tabla ACT_PRY_PROYECTO
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

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRY_PROYECTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

  --Array para crear las claves foraneas
  TYPE T_FK IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_FK IS TABLE OF T_FK;
  V_FK T_ARRAY_FK := T_ARRAY_FK(
      ------ ESQUEMA_ORIGEN --- TABLA_ORIGEN ------- CAMPO_ORIGEN ------- ESQUEMA_DESTINO ----- TABLA_DESTINO ------------------ CAMPO_DESTINO --- NOMBRE_F -------------------------
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'AGR_ID'            ,''||V_ESQUEMA||''    ,'ACT_AGR_AGRUPACION'            ,'AGR_ID'         ,'FK_ACT_PRY_AGR_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_PRV_ID'         ,''||V_ESQUEMA_M||''    ,'DD_PRV_PROVINCIA'            ,'DD_PRV_ID'      ,'FK_ACT_PRY_DD_PRV_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_LOC_ID'         ,''||V_ESQUEMA_M||''    ,'DD_LOC_LOCALIDAD'            ,'DD_LOC_ID'      ,'FK_ACT_PRY_DD_LOC_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_TPA_ID'         ,''||V_ESQUEMA||''    ,'DD_TPA_TIPO_ACTIVO'            ,'DD_TPA_ID'      ,'FK_ACT_PRY_DD_TPA_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_SAC_ID'         ,''||V_ESQUEMA||''    ,'DD_SAC_SUBTIPO_ACTIVO'         ,'DD_SAC_ID'      ,'FK_ACT_PRY_DD_SAC_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_EAC_ID'         ,''||V_ESQUEMA||''    ,'DD_EAC_ESTADO_ACTIVO'          ,'DD_EAC_ID'      ,'FK_ACT_PRY_DD_EAC_ID'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'PRY_GESTOR_ACTIVO'       ,''||V_ESQUEMA_M||''    ,'USU_USUARIOS'          ,'USU_ID'         ,'FK_ACT_PRY_GESTOR_ACTIVO'),
      T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'PRY_DOBLE_GESTOR_ACTIVO'       ,''||V_ESQUEMA_M||''    ,'USU_USUARIOS'    ,'USU_ID'         ,'FK_ACT_PRY_DOBLE_GESTOR_ACTIVO')
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
		  "PRY_ID"                         NUMBER(16,0)   NOT NULL ENABLE,
		  "AGR_ID"                         NUMBER(16,0),
		  "DD_PRV_ID"                      NUMBER(16,0),
		  "DD_LOC_ID"                      NUMBER(16,0),
		  "PRY_DIRECCION"                  VARCHAR2(255 CHAR),
		  "PRY_ACREEDOR_PDV"               VARCHAR2(255 CHAR),
		  "PRY_CP"                         VARCHAR2(255 CHAR),
		  "DD_TPA_ID"                      NUMBER(16,0),
		  "DD_SAC_ID"                      NUMBER(16,0),
		  "DD_EAC_ID"                      NUMBER(16,0),
		  "PRY_GESTOR_ACTIVO"              NUMBER(16,0), 
		  "PRY_DOBLE_GESTOR_ACTIVO"        NUMBER(16,0),
	      "VERSION"                        NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE,
	      "USUARIOCREAR"                   VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	      "FECHACREAR"                     TIMESTAMP (6) NOT NULL ENABLE, 
	      "USUARIOMODIFICAR"               VARCHAR2(50 CHAR), 
	      "FECHAMODIFICAR"                 TIMESTAMP (6), 
	      "USUARIOBORRAR"                  VARCHAR2(50 CHAR), 
	      "FECHABORRAR"                    TIMESTAMP (6), 
	      "BORRADO"                        NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
		   )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');

		-- Creamos comentario tabla
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla para gestionar la información de las agrupaciones de tipo proyecto de los activos.'' ';      
		EXECUTE IMMEDIATE V_SQL;
				
		-- Creamos comentarios columnas
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_ID IS ''Código identificador único de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;		

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AGR_ID IS ''Código identificador único de la agrupación.'' ';      
		EXECUTE IMMEDIATE V_SQL;	
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_LOC_ID IS ''Localidad (municipio) de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_PRV_ID IS ''Provincia de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_ACREEDOR_PDV IS ''Acreedor de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_CP IS ''Código postal de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_DIRECCION IS ''Dirección de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPA_ID IS ''Tipo de activo de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SAC_ID IS ''Subtipo de activo de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_EAC_ID IS ''Estado del activo de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_GESTOR_ACTIVO IS ''Gestor del activo de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRY_DOBLE_GESTOR_ACTIVO IS ''Doble gestor del activo de la agrupación de tipo proyecto.'' ';      
		EXECUTE IMMEDIATE V_SQL;					
    
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
            ADD (CONSTRAINT PK_'||V_TEXT_TABLA||' PRIMARY KEY (PRY_ID))
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

    END IF;
    
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
