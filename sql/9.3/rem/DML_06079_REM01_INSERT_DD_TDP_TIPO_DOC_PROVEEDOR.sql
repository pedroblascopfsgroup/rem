--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=2022021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10974
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tabla config gestores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('18', 'Contratos y convenios', 'Contrato: documento contractual', 'EN-05-CNCV-30'),
    T_TIPO_DATA('19', 'Informe localización Comunidad Propietarios	', 'Informe localización Comunidad Propietarios	', 'EN-05-ESIN-EH')
);

V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN
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
		                'VALUES('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''REMVIP-10974'', SYSDATE, 0)';
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