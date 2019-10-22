--/*
--##########################################
--## AUTOR=Sergio Salt Moya
--## FECHA_CREACION=20191023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7039
--## PRODUCTO=NO
--## Finalidad: Inserción regisro en TGP_TIPO_GESTOR_PROPIEDAD
--##           
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
                        CAG_NOMBRE_GESTORIA,
                        CAG_USU_GRUPO_ADMISION,
                        CAG_USU_USERNAME_ADMISION,
                        CAG_USU_GRUPO_ADMINISTRACION,
                        CAG_USU_USERNAME_ADMINISTRACION,
                        CAG_USU_GRUPO_FORMALIZACION,
                        CAG_USU_USERNAME_FORMALIZACION,
                        VERSION,
                        USUARIOCREAR,
                        FECHACREAR,
                        USUARIOMODIFICAR,
                        FECHAMODIFICAR,
                        USUARIOBORRAR,
                        FECHABORRAR,
                        BORRADO
                    )
                    ( 
                    SELECT
                        S_CAG_CONFIG_ACCESO_GESTORIAS.NEXTVAL AS CAG_ID,
                        ADMISION.CAG_NOMBRE_GESTORIA,
                        ADMISION.USU_ID AS CAG_USU_GRUPO_ADMISION,
                        ADMISION.USU_USERNAME AS CAG_USU_USERNAME_ADMISION,
                        ADMINISTRACION.USU_ID AS CAG_USU_GRUPO_ADMINISTRACION,
                        ADMINISTRACION.USU_USERNAME AS CAG_USU_USERNAME_ADMINISTRACION,
                        FORMALIZACION.USU_ID AS CAG_USU_GRUPO_FORMALIZACION,
                        FORMALIZACION.USU_USERNAME AS CAG_USU_USERNAME_FORMALIZACION,
                        1 AS VERSION,
                        ''HREOS-8006'' AS USUARIOCREAR,
                        SYSDATE AS FECHACREAR,
                        NULL AS USUARIOMODIFICAR,
                        NULL AS FECHAMODIFICAR,
                        NULL AS USUARIOBORRAR,
                        NULL AS FECHABORRAR,
                        0 AS BORRADO
                    FROM
                        (
                            SELECT
                                GESTORES.*
                            FROM
                                (
                                    SELECT
                                        USU_ID,
                                        USU_NOMBRE AS CAG_NOMBRE_GESTORIA,
                                        USU_USERNAME
                                    FROM
                                        '||V_ESQUEMA_M||'.USU_USUARIOS USU
                                    WHERE
                                        REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*01$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*02$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*03$'' )
                                ) GESTORES
                            WHERE
                                REGEXP_LIKE ( USU_USERNAME,
                                ''^[a-zA-Z ]*01$'' )
                        ) ADMISION
                        INNER JOIN (
                            SELECT
                                GESTORES.*
                            FROM
                                (
                                    SELECT
                                        USU_ID,
                                        USU_NOMBRE AS CAG_NOMBRE_GESTORIA,
                                        USU_USERNAME
                                    FROM
                                        '||V_ESQUEMA_M||'.USU_USUARIOS USU
                                    WHERE
                                        REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*01$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*02$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*03$'' )
                                ) GESTORES
                            WHERE
                                REGEXP_LIKE ( USU_USERNAME,
                                ''^[a-zA-Z ]*02$'' )
                        ) ADMINISTRACION ON REGEXP_SUBSTR(ADMISION.USU_USERNAME,''^[a-zA-Z ]*'') = REGEXP_SUBSTR(ADMINISTRACION.USU_USERNAME,''^[a-zA-Z ]*'')
                        INNER JOIN (
                            SELECT
                                GESTORES.*
                            FROM
                                (
                                    SELECT
                                        USU_ID,
                                        USU_NOMBRE AS CAG_NOMBRE_GESTORIA,
                                        USU_USERNAME
                                    FROM
                                        '||V_ESQUEMA_M||'.USU_USUARIOS USU
                                    WHERE
                                        REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*01$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*02$'' )
                                        OR   REGEXP_LIKE ( USU_USERNAME,
                                        ''^[a-zA-Z ]*03$'' )
                                ) GESTORES
                            WHERE
                                REGEXP_LIKE ( USU_USERNAME,
                                ''^[a-zA-Z ]*03$'' )
                        ) FORMALIZACION ON REGEXP_SUBSTR(ADMISION.USU_USERNAME,''^[a-zA-Z ]*'') = REGEXP_SUBSTR(FORMALIZACION.USU_USERNAME,''^[a-zA-Z ]*'')
                    WHERE
                        NOT EXISTS (
                            SELECT
                                1
                            FROM
                                CAG_CONFIG_ACCESO_GESTORIAS CAGG
                            WHERE
                                CAGG.CAG_USU_GRUPO_ADMISION = ADMISION.USU_ID
                                OR   CAGG.CAG_USU_GRUPO_ADMINISTRACION = ADMINISTRACION.USU_ID
                                OR   CAGG.CAG_USU_GRUPO_FORMALIZACION = FORMALIZACION.USU_ID
                        )
    )';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
