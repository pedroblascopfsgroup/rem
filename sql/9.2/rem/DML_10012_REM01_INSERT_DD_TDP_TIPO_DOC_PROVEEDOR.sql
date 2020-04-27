--/*
--#########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20200220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9384
--## PRODUCTO=NO
--## 
--## Finalidad: Repoblación de tabla 'DD_TDP_TIPO_DOC_PROVEEDOR'
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

V_SQL VARCHAR2(32000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'DD_TDP_TIPO_DOC_PROVEEDOR';
V_NUM_TABLAS NUMBER := 0;

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('01', 'NIF', 'NIF', 'EN-01-DOCI-07'),
    T_TIPO_DATA('02', 'Cuenta bancaria', 'Cuenta bancaria', 'EN-02-CERJ-86'),
    T_TIPO_DATA('03', 'Escritura constitución', 'Escritura constitución', 'EN-05-ESCR-04'),
    T_TIPO_DATA('04', 'Estatutos vigentes', 'Estatutos vigentes', 'EN-01-ESTA-02'),
    T_TIPO_DATA('05', 'Acta de asamblea (Sociedad mercantil)', 'Acta de asamblea (Sociedad mercantil)', 'EN-05-ACTR-01'),
    T_TIPO_DATA('06', 'Convocatoria asamblea', 'Convocatoria asamblea', 'EN-05-CONV-01'),
    T_TIPO_DATA('07', 'Circular comunidad', 'Circular comunidad', 'EN-05-COMU-06'),
    T_TIPO_DATA('08', 'Acta titular real', 'Acta titular real', 'EN-01-DOCN-05'),
    T_TIPO_DATA('09', 'Certificado AEAT', 'Certificado AEAT', 'EN-02-CERJ-24'),
    T_TIPO_DATA('10', 'Certificado SS', 'Certificado SS', 'EN-02-CERA-33'),
    T_TIPO_DATA('11', 'Certificado subcontratistas', 'Certificado subcontratistas', 'EN-02-CERA-64'),
    T_TIPO_DATA('12', 'Impuesto Actividades Económicas', 'Impuesto Actividades Económicas', 'EN-05-COMU-05'),
    T_TIPO_DATA('13', 'Seguros sociales mes', 'Seguros sociales mes', 'EN-02-CERA-33'),
    T_TIPO_DATA('14', 'Comunidad de propietarios: Carta para localización', 'Comunidad de propietarios: Carta para localización', 'EN-05-COMU-67'),
    T_TIPO_DATA('15', 'Comunidad de propietarios: Burofax para localización', 'Comunidad de propietarios: Burofax para localización', 'EN-05-COMU-76'),
    T_TIPO_DATA('16', 'Certificado no deuda', 'Certificado no deuda', 'EN-05-CERJ-11'),
    T_TIPO_DATA('17', 'Acta Junta (Comunidad de propietarios)', 'Acta Junta (Comunidad de propietarios)', 'EN-05-ACTR-07')
);

V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

  	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICANDO TABLA '||V_TABLA);
    
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TDP_CODIGO = ''NAJC'', BORRADO = 1, USUARIOMODIFICAR = ''HREOS-9384'', FECHAMODIFICAR = SYSDATE, USUARIOBORRAR = ''HREOS-9384'', FECHABORRAR = SYSDATE WHERE DD_TDP_DESCRIPCION = ''Juntas de compensación''';
        EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TDP_CODIGO = ''NACV'', BORRADO = 1, USUARIOMODIFICAR = ''HREOS-9384'', FECHAMODIFICAR = SYSDATE, USUARIOBORRAR = ''HREOS-9384'', FECHABORRAR = SYSDATE WHERE DD_TDP_DESCRIPCION = ''Comunidades de vecinos''';
        EXECUTE IMMEDIATE V_SQL;
        
    	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS DE LA TABLA '||V_TABLA||' BORRADOS.');

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERCION EN DD_TDP_TIPO_DOC_PROVEEDOR.');

    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);  
        
	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
								  AND DD_TDP_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
								  AND DD_TDP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
								  AND DD_TDP_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	    IF V_NUM_TABLAS = 0 THEN
		    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS EL REGISTRO CON DESCRIPCION: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
		    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (' ||
		                'DD_TDP_ID, DD_TDP_CODIGO, DD_TDP_DESCRIPCION, DD_TDP_DESCRIPCION_LARGA, DD_TDP_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
		                'VALUES('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-9384'', SYSDATE, 0)';
		    EXECUTE IMMEDIATE V_SQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	    ELSE
		    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO EXISTENTE');
	    END IF;

        END LOOP;

END IF;

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
