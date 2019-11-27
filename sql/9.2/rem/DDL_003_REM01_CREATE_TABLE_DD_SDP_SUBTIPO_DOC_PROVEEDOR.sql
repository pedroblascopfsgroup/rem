--/*
--#########################################
--## AUTOR=Sergio Giménez Mota
--## FECHA_CREACION=20191127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=HREOS-6927
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'DD_SDP_SUBTIPO_DOC_PROVEEDOR'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'DD_SDP_SUBTIPO_DOC_PROVEEDOR';

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA(1, '01', 'NIF', 'NIF', 'EN-01-DOCI-07'),
    T_TIPO_DATA(1, '02', 'Cuenta bancaria', 'Cuenta bancaria', 'EN-02-CERJ-86'),
    T_TIPO_DATA(1, '03', 'Escritura constitución', 'Escritura constitución', 'EN-05-ESCR-04'),
    T_TIPO_DATA(1, '04', 'Estatutos vigentes', 'Estatutos vigentes', 'EN-01-ESTA-02'),
    T_TIPO_DATA(1, '05', 'Acta de asamblea (Sociedad mercantil)', 'Acta de asamblea (Sociedad mercantil)', 'EN-05-ACTR-01'),
    T_TIPO_DATA(1, '06', 'Convocatoria asamblea', 'Convocatoria asamblea', 'EN-05-CONV-01'),
    T_TIPO_DATA(1, '07', 'Circular comunidad', 'Circular comunidad', 'EN-05-COMU-06'),
    T_TIPO_DATA(1, '08', 'Acta titular real', 'Acta titular real', 'EN-01-DOCN-05'),
    T_TIPO_DATA(1, '09', 'Certificado AEAT', 'Certificado AEAT', 'EN-02-CERJ-24'),
    T_TIPO_DATA(1, '10', 'Certificado SS', 'Certificado SS', 'EN-02-CERA-33'),
    T_TIPO_DATA(1, '11', 'Certificado subcontratistas', 'Certificado subcontratistas', 'EN-02-CERA-64'),
    T_TIPO_DATA(1, '12', 'Impuesto Actividades Económicas', 'Impuesto Actividades Económicas', 'EN-05-COMU-05'),
    T_TIPO_DATA(1, '13', 'Seguros sociales mes', 'Seguros sociales mes', 'EN-02-CERA-33'),
    T_TIPO_DATA(1, '14', 'Comunidad de propietarios: Carta para localización', 'Comunidad de propietarios: Carta para localización', 'EN-05-COMU-67'),
    T_TIPO_DATA(1, '15', 'Comunidad de propietarios: Burofax para localización', 'Comunidad de propietarios: Burofax para localización', 'EN-05-COMU-76'),
    T_TIPO_DATA(1, '16', 'Certificado no deuda', 'Certificado no deuda', 'EN-05-CERJ-11'),
    T_TIPO_DATA(1, '17', 'Acta Junta (Comunidad de propietarios)', 'Acta Junta (Comunidad de propietarios)', 'EN-05-ACTR-07'),
    T_TIPO_DATA(2, '18', 'NIF', 'NIF', 'EN-01-DOCI-07'),
    T_TIPO_DATA(2, '19', 'Cuenta bancaria', 'Cuenta bancaria', 'EN-02-CERJ-86'),
    T_TIPO_DATA(2, '20', 'Escritura constitución', 'Escritura constitución', 'EN-05-ESCR-04'),
    T_TIPO_DATA(2, '21', 'Estatutos vigentes', 'Estatutos vigentes', 'EN-01-ESTA-02'),
    T_TIPO_DATA(2, '22', 'Acta de asamblea (Sociedad mercantil)', 'Acta de asamblea (Sociedad mercantil)', 'EN-05-ACTR-01'),
    T_TIPO_DATA(2, '23', 'Convocatoria asamblea', 'Convocatoria asamblea', 'EN-05-CONV-01'),
    T_TIPO_DATA(2, '24', 'Circular comunidad', 'Circular comunidad', '  EN-05-COMU-06'),
    T_TIPO_DATA(2, '25', 'Acta titular real', 'Acta titular real', 'EN-01-DOCN-05'),
    T_TIPO_DATA(2, '26', 'Certificado AEAT', 'Certificado AEAT', 'EN-02-CERJ-24'),
    T_TIPO_DATA(2, '27', 'Certificado SS', 'Certificado SS', 'EN-02-CERA-33'),
    T_TIPO_DATA(2, '28', 'Certificado subcontratistas', 'Certificado subcontratistas', 'EN-02-CERA-64'),
    T_TIPO_DATA(2, '29', 'Impuesto Actividades Económicas', 'Impuesto Actividades Económicas', 'EN-05-COMU-05'),
    T_TIPO_DATA(2, '30', 'Seguros sociales mes', 'Seguros sociales mes', 'EN-02-CERA-33'),
    T_TIPO_DATA(2, '31', 'Comunidad de propietarios: Carta para localización', 'Comunidad de propietarios: Carta para localización', 'EN-05-COMU-67'),
    T_TIPO_DATA(2, '32', 'Comunidad de propietarios: Burofax para localización', 'Comunidad de propietarios: Burofax para localización', 'EN-05-COMU-76'),
    T_TIPO_DATA(2, '33', 'Certificado no deuda', 'Certificado no deuda', 'EN-05-CERJ-11'),
    T_TIPO_DATA(2, '34', 'Acta Junta (Comunidad de propietarios)', 'Acta Junta (Comunidad de propietarios)', 'EN-05-ACTR-07');

V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
    
END IF;

V_MSQL := '
CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
(
    DD_SDP_ID                   NUMBER(16,0) NOT NULL ,
    DD_TDP_ID                   NUMBER(16,0),
    DD_SDP_CODIGO               VARCHAR2(20 CHAR),
    DD_SDP_DESCRIPCION          VARCHAR2(100 CHAR),
    DD_SDP_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
    DD_SDP_MATRICULA_GD         VARCHAR2(20 CHAR),
    USUARIOCREAR        	    VARCHAR2(10) NOT NULL,
    FECHACREAR          	    TIMESTAMP(6) NOT NULL,
    USUARIOMODIFICAR    	    VARCHAR2(10),
    FECHAMODIFICAR      	    TIMESTAMP(6),	 
    VERSION                   	INTEGER NOT NULL,
    USUARIOBORRAR             	VARCHAR2(50),
    FECHABORRAR               	TIMESTAMP(6),
    BORRADO                  	NUMBER(1) NOT NULL
)';

EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  

V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
    EXECUTE IMMEDIATE V_MSQL;		
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
END IF;

V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(DD_SDP_ID) TABLESPACE '||V_TABLESPACE_IDX;		
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DD_SDP_ID) USING INDEX)';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_SDP_DD_TDP_ID FOREIGN KEY (DD_TDP_ID) REFERENCES '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PROVEEDOR (DD_TDP_ID))';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK creada.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDP_ID IS ''Subtipo''';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TDP_ID IS ''Tipo''';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDP_CODIGO IS ''Subtipo código''';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDP_DESCRIPCION IS ''Subtipo descripción''';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDP_DESCRIPCION_LARGA IS ''Subtipo descripción larga''';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDP_DESCRIPCION_LARGA IS ''Subtipo matrícula''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] COMENTARIOS CREADOS');

DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SDP_SUBTIPO_DOC_PROVEEDOR ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);  
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (' ||
                        'DD_SDP_ID, DD_TDP_ID, DD_SDP_CODIGO, DD_SDP_DESCRIPCION, DD_SDP_DESCRIPCION_LARGA, DD_SDP_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                        'VALUES('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''DML'',SYSDATE, 0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        END LOOP;

COMMIT;

EXCEPTION

WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/

EXIT;