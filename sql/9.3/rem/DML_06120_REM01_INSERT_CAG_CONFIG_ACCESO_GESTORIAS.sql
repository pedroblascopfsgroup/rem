--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12064
--## PRODUCTO=NO
--## Finalidad: Tabla para la configuración de gestorias
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_M VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(32000 CHAR);
    V_NUM NUMBER(16);
    V_NUM2 NUMBER(16);
    V_NUM3 NUMBER(16);
    V_TABLA_TEXT VARCHAR2(4000 CHAR) := 'CAG_CONFIG_ACCESO_GESTORIAS';
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-12064';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('45','suncapital','GIAADMT')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]: ');
   V_MSQL := 'SELECT COUNT(1) FROM ALL_OBJECTS WHERE  OBJECT_TYPE in (''TABLE'') AND OBJECT_NAME = '''||V_TABLA_TEXT||'''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
    DBMS_OUTPUT.PUT_LINE('[INFO]: NUMERO DE TABLAS -> '||V_NUM);
    IF V_NUM > 0 THEN
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP

            V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            DBMS_OUTPUT.PUT_LINE('[INFO]: PREPARACION CARGA CONFIGURACION '''||TRIM(V_TMP_TIPO_DATA(1))||''' - '''||TRIM(V_TMP_TIPO_DATA(2))||''' - '''||TRIM(V_TMP_TIPO_DATA(3))||''' ... ');

            V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE UPPER(USU_USERNAME)=UPPER('''||TRIM(V_TMP_TIPO_DATA(2))||''')';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
            
            V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_IGE_IDENTIFICACION_GESTORIA WHERE DD_IGE_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM2;

            V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM3;

            DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO COMPROBACIONES PREVIAS... ');

            IF V_NUM = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR]: NO SE ENCUENTRA VALOR USERNAME '''||TRIM(V_TMP_TIPO_DATA(2))||''' ');
            ELSIF V_NUM2 = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR]: NO SE ENCUENTRA VALOR DD_IGE_CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');
            ELSIF V_NUM3 = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR]: NO SE ENCUENTRA VALOR DD_TGE_CODIGO '''||TRIM(V_TMP_TIPO_DATA(3))||''' ');
            ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBACIONES CORRECTAS!!! ');
            END IF;



            IF V_NUM > 0 AND V_NUM2 > 0 AND V_NUM3 > 0 THEN

                V_MSQL :='SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE UPPER(USU_USERNAME)=UPPER('''||TRIM(V_TMP_TIPO_DATA(2))||''')';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
            
                V_MSQL :='SELECT DD_IGE_ID FROM '||V_ESQUEMA||'.DD_IGE_IDENTIFICACION_GESTORIA WHERE DD_IGE_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM2;

                V_MSQL :='SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM3;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CAG_CONFIG_ACCESO_GESTORIAS CAG (
                                CAG_ID,
                                DD_IGE_ID,
                                CAG_USU_GRUPO,
                                DD_TGE_ID,
                                VERSION,
                                USUARIOCREAR,
                                FECHACREAR,
                                BORRADO
                            )
                            ( 
                                SELECT
                                    '||V_ESQUEMA||'.S_CAG_CONFIG_ACCESO_GESTORIAS.NEXTVAL AS CAG_ID,
                                    '||V_NUM2||',
                                    '||V_NUM||',
                                    '||V_NUM3||',
                                    0 AS VERSION,
                                    '''||V_USUARIO||''' AS USUARIOCREAR,
                                    SYSDATE AS FECHACREAR,
                                    0 AS BORRADO
                                FROM DUAL
                                )';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[SUCCESS]: INSERTADA CONFIGURACCION CORRECTAMENTE');

                V_NUM := NULL;
                V_NUM2 := NULL;
                V_NUM3 := NULL;

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[ERROR]: FALTAN VALORES ');
                END IF;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE(' [INFO] NO EXISTE LA TABLA'||V_TABLA_TEXT);
    END IF;

    COMMIT;
DBMS_OUTPUT.PUT_LINE('[FIN]: ');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;
END;
/
EXIT;