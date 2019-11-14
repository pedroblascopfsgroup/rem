--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8188
--## PRODUCTO=NO
--## Finalidad: Tabla para la configuración de gestores
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
    V_TABLA_TEXT VARCHAR2(4000 CHAR) := 'CAG_CONFIG_ACCESO_GESTORIAS';

BEGIN
   V_MSQL := 'SELECT COUNT(1) FROM ALL_OBJECTS WHERE  OBJECT_TYPE in (''TABLE'') AND OBJECT_NAME = '''||V_TABLA_TEXT||'''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
    DBMS_OUTPUT.PUT_LINE('NUMERO DE TABLAS -> '||V_NUM);
    IF V_NUM > 0 THEN
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
                            GESTORES.DD_IGE_ID,
                            GESTORES.USU_ID AS CAG_USU_GRUPO,
                            GESTORES.DD_TGE_ID,
                            0 AS VERSION,
                            ''HREOS-8188'' AS USUARIOCREAR,
                            SYSDATE AS FECHACREAR,
                            0 AS BORRADO
                        FROM
                            (SELECT
                                    USU_ID,
                                    IGE.DD_IGE_ID AS DD_IGE_ID,
                                    USU.USU_NOMBRE,
                                    CASE
                                        WHEN REGEXP_LIKE ( USU_USERNAME,''^[a-zA-Z ]*01$'') THEN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GTOADM'')
                                        WHEN REGEXP_LIKE ( USU_USERNAME,''^[a-zA-Z ]*02$'') THEN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GIAADMT'')
                                        WHEN REGEXP_LIKE ( USU_USERNAME,''^[a-zA-Z ]*03$'') THEN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GIAFORM'')
                                    END DD_TGE_ID
                                FROM
                                    '||V_ESQUEMA_M||'.USU_USUARIOS USU
                                JOIN
                                    '||V_ESQUEMA||'.DD_IGE_IDENTIFICACION_GESTORIA IGE ON USU.USU_NOMBRE = IGE.DD_IGE_DESCRIPCION
                                WHERE
                                    USU.USU_NOMBRE IS NOT NULL AND
                                    REGEXP_LIKE ( USU_USERNAME,
                                    ''^[a-zA-Z ]*01$'')
                                    OR   REGEXP_LIKE ( USU_USERNAME,
                                    ''^[a-zA-Z ]*02$'')
                                    OR   REGEXP_LIKE ( USU_USERNAME,
                                    ''^[a-zA-Z ]*03$'')
                            ) GESTORES
                        )';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE(' [INFO] INSERTADO '||SQL%ROWCOUNT||' REGISTRO(S) PARA LA TABLA ' || V_TABLA_TEXT);
    ELSE
        DBMS_OUTPUT.PUT_LINE(' [INFO] NO EXISTE LA TABLA');
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;
END SP_AGA_ASIGNA_GESTOR_ACTIVO_V3;
/
EXIT;
