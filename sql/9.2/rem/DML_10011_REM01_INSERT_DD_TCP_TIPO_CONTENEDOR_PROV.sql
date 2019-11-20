--/*
--#########################################
--## AUTOR=Alejandro Valverde 
--## FECHA_CREACION=20191113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8415
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de tabla 'DD_TCP_TIPO_CONTENEDOR_PROV'
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
V_TABLA VARCHAR2(40 CHAR) := 'DD_TCP_TIPO_CONTENEDOR_PROV';

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('01', 'Comunidades de vecinos', 'Comunidades de vecinos'),
    T_TIPO_DATA('02', 'Juntas de compensación', 'Juntas de compensación')
);

V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

DBMS_OUTPUT.PUT_LINE('[INFO]: Insercion en DD_TCP_TIPO_CONTENEDOR_PROV');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);  
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (' ||
                        'DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION, DD_TCP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                        'VALUES('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL'||','''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-8415'',SYSDATE, 0)';
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
