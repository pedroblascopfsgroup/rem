--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20160927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-788
--## PRODUCTO=NO
--## Finalidad: Stored Procedure que actualiza información de Stock Bankia en REM.
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


create or replace PROCEDURE SP_UPA_UPDATE_ACTIVES_UVEM (
      V_USUARIO	VARCHAR2 DEFAULT 'SP_UPA_UVEM',
      PL_OUTPUT       OUT VARCHAR2
)
AS
--David González
--HREOS-788
--27-09-2016
--V0.1

V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
V_NOT_UPDATE VARCHAR2(2000 CHAR) := '';

	--[1]TABLA BIE_BIEN
                      --BIE_VIVIENDA_HABITUAL
                      --BIE_PORCT_IMP_COMPRA
	--[2]TABLA BIE_DATOS_REGISTRALES
                      --BIE_DREG_LIBRO, BIE_DREG_TOMO Y BIE_DREG_FOLIO
  --[3]TABLA BIE_ADJ_ADJUDICACION
                      --BIE_ADJ_IMPORTE_ADJUDICACION
  --[4]TABLA ACT_ACTIVO
                       --ACT_VPO
                       --ACT_LLAVES_NECESARIAS
                       --ACT_LLAVES_FECHA_RECEP
  --[5]TABLA ACT_AJD_ADJJUDICIAL
                      --AJD_NUM_AUTO
                      --AJD_PROCURADOR
  --[6]TABLA ACT_ADN_AJDNOJUDICIAL
                      --ADN_FECHA_FIRMA_TITULO
  --[7]TABLA ACT_SPS_SIT_POSESORIA
                      --SPS_FECHA_TITULO
                      --SPS_FECHA_TOMA_POSESION
                      --SPS_OCUPADO
                      --DD_TPO_ID
  --[8]TABLA ACT_ADM_INF_ADMINISTRATIVA
                      --DD_TVP_ID
  --[9]TABLA ACT_TIT_TITULO
	TYPE T_TIPO_TABLA10 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA10 IS TABLE OF T_TIPO_TABLA10;
    V_TIPO_TABLA10 T_ARRAY_TABLA10 := T_ARRAY_TABLA10(
      T_TIPO_TABLA10('FEC_PRESENTACION_HACIENDA','TIT_FECHA_PRESENT_HACIENDA'),
      T_TIPO_TABLA10('FEC_PRESENTACION_REGISTRO','TIT_FECHA_PRESENT1_REG'),
      T_TIPO_TABLA10('FEC_ENTREGA_TITULO_GESTOR','TIT_FECHA_ENTREGA_GESTORIA'),
      T_TIPO_TABLA10('FEC_ENVIO_AUTO_ADICCION','TIT_FECHA_ENVIO_AUTO'),
      T_TIPO_TABLA10('FEC_SEGUNDA_PRESEN_REG','TIT_FECHA_PRESENT2_REG'),
      T_TIPO_TABLA10('FEC_INSCRIPCION_TITULO','TIT_FECHA_INSC_REG')
      --T_TIPO_TABLA10('','DD_ETI_ID')
    );
    V_TMP_TIPO_TABLA10 T_TIPO_TABLA10;
  --[10]TABLA ACT_OLE_OCUPANTE_LEGAL
                      --OLE_NOMBRE
  --[11]TABLA ACT_CFD_CONFIG_DOCUMENTO
                      --CFD_APLICA_F_CADUCIDAD
  --[12]TABLA ACT_MLV_MOVIMIENTO_LLAVE
                      --MLV_FECHA_ENTREGA
  --[13]¿¿TABLA ACT_PAC_PROPIETARIO_ACTIVO??
  --[14]TABLA ACT_EDI_EDIFICIO
                      --ASCEMSPRES
  --[15]TABLA ACT_VIV_VIVIENDA
  --[16]TABLA ACT_DIS_DISTRIBUCION
                      --DORMITORIOS
                      --BAÑOS
                      --TRASTEROS
                      --TERRAZAS
                      --GARAJES


BEGIN

	PL_OUTPUT := ' ';

  DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO DE ACTUALIZACIÓN DE INFORMACIÓN DE ACTIVOS.');
  DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

----------------------
---- [1] BIE_BIEN ----
----------------------
--[1.1]--BIE_VIVIENDA_HABITUAL
        EXECUTE IMMEDIATE '
        MERGE INTO '||V_ESQUEMA||'.BIE_BIEN BIE USING
        (
          WITH TEMP AS (
          SELECT DISTINCT
          DECODE(APR.RESIDENCIA_HABITUAL,''0'',0,''1'',1,''2'',0,''3'',''S'',1,''N'',0,NULL) AS RESIDENCIA_HABITUAL, APR_ID, ACT_NUMERO_UVEM, REM
          FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
          )
          SELECT TEMP.*, BIE.BIE_VIVIENDA_HABITUAL, BIE.BIE_ID
          FROM TEMP
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
            ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
          INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BIE
            ON BIE.BIE_ID = ACT.BIE_ID
          WHERE
            TEMP.REM = 1
            AND
             BIE.BIE_VIVIENDA_HABITUAL IS NULL
              AND
              TEMP.RESIDENCIA_HABITUAL IS NOT NULL
        ) TMP
        ON (TMP.BIE_ID = BIE.BIE_ID)
        WHEN MATCHED THEN UPDATE SET
        BIE.BIE_VIVIENDA_HABITUAL = TMP.RESIDENCIA_HABITUAL,
        BIE.USUARIOMODIFICAR = '''||V_USUARIO||''',
        BIE.FECHAMODIFICAR = SYSDATE
        '
        ;
        V_NUM_TABLAS := SQL%ROWCOUNT;

--[1.2]--BIE_PORCT_IMP_COMPRA
        EXECUTE IMMEDIATE '
        MERGE INTO '||V_ESQUEMA||'.BIE_BIEN BIE USING
        (
          WITH TEMP AS (
          SELECT DISTINCT
          APR.PORCENTAJE_IMPUESTO_COMPRA, APR_ID, ACT_NUMERO_UVEM, REM
          FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
          WHERE APR.PORCENTAJE_IMPUESTO_COMPRA != 0
          )
          SELECT TEMP.*, BIE.BIE_PORCT_IMP_COMPRA, BIE.BIE_ID
          FROM TEMP
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
            ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
          INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BIE
            ON BIE.BIE_ID = ACT.BIE_ID
          WHERE
            TEMP.REM = 1
            AND
             BIE.BIE_PORCT_IMP_COMPRA IS NULL
              AND
              TEMP.PORCENTAJE_IMPUESTO_COMPRA IS NOT NULL
        ) TMP
        ON (TMP.BIE_ID = BIE.BIE_ID)
        WHEN MATCHED THEN UPDATE SET
        BIE.BIE_PORCT_IMP_COMPRA = TMP.PORCENTAJE_IMPUESTO_COMPRA,
        BIE.USUARIOMODIFICAR = '''||V_USUARIO||''',
        BIE.FECHAMODIFICAR = SYSDATE
        '
        ;
        V_NUM_TABLAS := SQL%ROWCOUNT + V_NUM_TABLAS;


        IF V_NUM_TABLAS != 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_BIEN '||V_NUM_TABLAS||' Registros.');
          PL_OUTPUT := '[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_BIEN '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
          DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

          COMMIT;

        END IF;


-----------------------------------
---- [2] BIE_DATOS_REGISTRALES ----
-----------------------------------
--[2.1]--BIE_DREG_LIBRO, BIE_DREG_TOMO Y BIE_DREG_FOLIO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE USING
          (
            WITH TEMP AS (
              SELECT DISTINCT
              APR.NUM_LIBRO_ESCRITURA, APR.NUM_TOMO_ESCRITURA, APR.NUM_FOLIO_ESCRITURA, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
              WHERE APR.NUM_LIBRO_ESCRITURA != 0
              AND APR.NUM_TOMO_ESCRITURA != 0
              AND APR.NUM_FOLIO_ESCRITURA != 0
            )
            SELECT TEMP.*, BIE.BIE_DREG_LIBRO, BIE.BIE_DREG_TOMO, BIE.BIE_DREG_FOLIO, BIE.BIE_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE
              ON BIE.BIE_ID = ACT.BIE_ID
            WHERE
              TEMP.REM = 1
               AND
             (BIE.BIE_DREG_LIBRO IS NULL OR BIE.BIE_DREG_TOMO IS NULL OR BIE.BIE_DREG_FOLIO IS NULL)
              AND
              (TEMP.NUM_LIBRO_ESCRITURA IS NOT NULL OR TEMP.NUM_TOMO_ESCRITURA IS NOT NULL OR TEMP.NUM_FOLIO_ESCRITURA IS NOT NULL)
          ) TMP
          ON (TMP.BIE_ID = BIE.BIE_ID)
          WHEN MATCHED THEN UPDATE SET
          BIE.BIE_DREG_LIBRO = TMP.NUM_LIBRO_ESCRITURA,
          BIE.BIE_DREG_TOMO = TMP.NUM_TOMO_ESCRITURA,
          BIE.BIE_DREG_FOLIO = TMP.NUM_FOLIO_ESCRITURA,
          BIE.USUARIOMODIFICAR = '''||V_USUARIO||''',
          BIE.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


----------------------------------
---- [3] BIE_ADJ_ADJUDICACION ----
----------------------------------
--[3.1]--BIE_ADJ_IMPORTE_ADJUDICACION
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE USING
          (
            WITH TEMP AS (
              SELECT DISTINCT
              APR.IMPORTE_ADJUDICACION, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
              WHERE APR.IMPORTE_ADJUDICACION != 0
            )
            SELECT TEMP.*, BIE.BIE_ADJ_IMPORTE_ADJUDICACION, BIE.BIE_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE
              ON BIE.BIE_ID = ACT.BIE_ID
            WHERE
              TEMP.REM = 1
               AND
             (BIE.BIE_ADJ_IMPORTE_ADJUDICACION IS NULL
              AND
              TEMP.IMPORTE_ADJUDICACION IS NOT NULL)
          ) TMP
          ON (TMP.BIE_ID = BIE.BIE_ID)
          WHEN MATCHED THEN UPDATE SET
          BIE.BIE_ADJ_IMPORTE_ADJUDICACION = TMP.IMPORTE_ADJUDICACION,
          BIE.USUARIOMODIFICAR = '''||V_USUARIO||''',
          BIE.FECHAMODIFICAR = SYSDATE
          '
          ;



          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


------------------------
---- [4] ACT_ACTIVO ----
------------------------
--[4.1]--ACT_VPO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              DECODE(APR.REGIMEN_PROTECCION,''01'',1,''02'',1,''03'',1,''04'',1,NULL) AS REGIMEN_PROTECCION, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.ACT_VPO, ACT.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            WHERE
              TEMP.REM = 1
               AND
             (ACT.ACT_VPO IS NULL
              AND
              TEMP.REGIMEN_PROTECCION IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.ACT_VPO = TMP.REGIMEN_PROTECCION,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

--[4.2]--ACT_LLAVES_NECESARIAS
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              DECODE(APR.LLAVES_NECESARIAS,''N'',0,''S'',1,NULL) AS LLAVES_NECESARIAS, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.ACT_LLAVES_NECESARIAS, ACT.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            WHERE
              TEMP.REM = 1
               AND
             (ACT.ACT_LLAVES_NECESARIAS IS NULL
              AND
              TEMP.LLAVES_NECESARIAS IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.ACT_LLAVES_NECESARIAS = TMP.LLAVES_NECESARIAS,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

--[4.3]--ACT_LLAVES_FECHA_RECEP
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.FEC_RECEP_LLAVES, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.ACT_LLAVES_FECHA_RECEP, ACT.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            WHERE
              TEMP.REM = 1
               AND
             (ACT.ACT_LLAVES_FECHA_RECEP IS NULL
              AND
              TEMP.FEC_RECEP_LLAVES IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.ACT_LLAVES_FECHA_RECEP = TMP.FEC_RECEP_LLAVES,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ACTIVO '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ACTIVO '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


---------------------------------
---- [5] ACT_AJD_ADJJUDICIAL ----
---------------------------------
--[5.1]--AJD_NUM_AUTO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.NUM_AUTOS_JUZGADO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.AJD_NUM_AUTO, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.AJD_NUM_AUTO IS NULL
              AND
              TEMP.NUM_AUTOS_JUZGADO IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.AJD_NUM_AUTO = TMP.NUM_AUTOS_JUZGADO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

--[5.2]--AJD_PROCURADOR
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.NOMBRE_PROCURADOR, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.AJD_PROCURADOR, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.AJD_PROCURADOR IS NULL
              AND
              TEMP.NOMBRE_PROCURADOR IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.AJD_PROCURADOR = TMP.NOMBRE_PROCURADOR,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


-----------------------------------
---- [6] ACT_ADN_ADJNOJUDICIAL ----
-----------------------------------
--[6.1]--ADN_FECHA_FIRMA_TITULO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.FEC_RESOLUCION, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.ADN_FECHA_FIRMA_TITULO, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.ADN_FECHA_FIRMA_TITULO IS NULL
              AND
              TEMP.FEC_RESOLUCION IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.ADN_FECHA_FIRMA_TITULO = TMP.FEC_RESOLUCION,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


-----------------------------------
---- [7] ACT_SPS_SIT_POSESORIA ----
-----------------------------------
--[7.1]--SPS_FECHA_TITULO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.FEC_INICIO_CONTRATO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.SPS_FECHA_TITULO, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.SPS_FECHA_TITULO IS NULL
              AND
              TEMP.FEC_INICIO_CONTRATO IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.SPS_FECHA_TITULO = TMP.FEC_INICIO_CONTRATO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

--[7.2]--SPS_FECHA_TOMA_POSESION
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.FEC_REALIZADA_POSESION, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.SPS_FECHA_TOMA_POSESION, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.SPS_FECHA_TOMA_POSESION IS NULL
              AND
              TEMP.FEC_REALIZADA_POSESION IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.SPS_FECHA_TOMA_POSESION = TMP.FEC_REALIZADA_POSESION,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

--[7.3]--SPS_OCUPADO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              DECODE(APR.OCUPADO,''S'',1,''N'',0,NULL) AS OCUPADO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.SPS_OCUPADO, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.SPS_OCUPADO IS NULL
              AND
              TEMP.OCUPADO IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.SPS_OCUPADO = TMP.OCUPADO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

--[7.4]--DD_TPO_ID
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              CASE
                WHEN APR.OCUPADO = ''S'' AND APR.FEC_INICIO_CONTRATO IS NOT NULL THEN (SELECT TPO.DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_TITULO_POSESORIO TPO WHERE TPO.DD_TPO_CODIGO = ''02'')
                END AS TPO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.DD_TPO_ID, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.DD_TPO_ID IS NULL
              AND
              TEMP.TPO IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.DD_TPO_ID = TMP.TPO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


----------------------------------------
---- [8] ACT_ADM_INF_ADMINISTRATIVA ----
----------------------------------------
--[8.1]--DD_TVP_ID
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              TVP.DD_TVP_ID AS REGIMEN_PROTECCION, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
              LEFT JOIN '||V_ESQUEMA||'.DD_EQV_BANKIA_REM EQV
                  ON EQV.DD_NOMBRE_BANKIA = ''DD_REGIMEN_PROTECCION''
                  AND EQV.DD_CODIGO_BANKIA = APR.REGIMEN_PROTECCION
                LEFT JOIN '||V_ESQUEMA||'.DD_TVP_TIPO_VPO TVP
                 ON TVP.DD_TVP_CODIGO = EQV.DD_CODIGO_REM
            )
            SELECT TEMP.*, ACT.DD_TVP_ID, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.DD_TVP_ID IS NULL
              AND
              TEMP.REGIMEN_PROTECCION IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.DD_TVP_ID = TMP.REGIMEN_PROTECCION,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


----------------------------
---- [9] ACT_TIT_TITULO ----
----------------------------
--T_TIPO_TABLA10('FEC_PRESENTACION_HACIENDA','TIT_FECHA_PRESENT_HACIENDA'),
--T_TIPO_TABLA10('FEC_PRESENTACION_REGISTRO','TIT_FECHA_PRESENT1_REG'),
--T_TIPO_TABLA10('FEC_ENTREGA_TITULO_GESTOR','TIT_FECHA_ENTREGA_GESTORIA'),
--T_TIPO_TABLA10('FEC_ENVIO_AUTO_ADICCION','TIT_FECHA_ENVIO_AUTO'),
--T_TIPO_TABLA10('FEC_SEGUNDA_PRESEN_REG','TIT_FECHA_PRESENT2_REG'),
--T_TIPO_TABLA10('FEC_INSCRIPCION_TITULO','TIT_FECHA_INSC_REG')
FOR I IN V_TIPO_TABLA10.FIRST .. V_TIPO_TABLA10.LAST
    LOOP

			V_TMP_TIPO_TABLA10 := V_TIPO_TABLA10(I);

				V_SQL := '
				MERGE INTO '||V_ESQUEMA||'.ACT_TIT_TITULO TIT USING
				(
				WITH DISTINTOS AS (
				  SELECT APR_ID, ACT_NUMERO_UVEM, ROW_NUMBER () OVER (PARTITION BY ACT_NUMERO_UVEM ORDER BY APR_ID DESC) ORDEN
				  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
				)
				SELECT '||V_TMP_TIPO_TABLA10(1)||', ACT.ACT_ID
				FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
				LEFT JOIN DISTINTOS
				  ON DISTINTOS.APR_ID = APR.APR_ID
				LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
				  ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
				WHERE '||V_TMP_TIPO_TABLA10(1)||' IS NOT NULL
				AND ACT.BIE_ID IS NOT NULL
				AND DISTINTOS.ORDEN = 1
				) TMP
				ON (TIT.ACT_ID = TMP.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
				TIT.'||V_TMP_TIPO_TABLA10(2)||' = TMP.'||V_TMP_TIPO_TABLA10(1)||',
				TIT.USUARIOMODIFICAR = '''||V_USUARIO||''',
				TIT.FECHAMODIFICAR = SYSDATE
				WHERE TIT.'||V_TMP_TIPO_TABLA10(2)||' IS NULL
				'
				;

				EXECUTE IMMEDIATE V_SQL;

				V_NUM_TABLAS := SQL%ROWCOUNT;

			IF V_NUM_TABLAS != 0 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_TIT_TITULO.'||V_TMP_TIPO_TABLA10(2)||' '||V_NUM_TABLAS||' Registros.');
        PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_TIT_TITULO.'||V_TMP_TIPO_TABLA10(2)||' '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);

				COMMIT;

			END IF;


    END LOOP;

--[9.2]--DD_ETI_ID
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_TIT_TITULO ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              ETI.DD_ETI_ID AS SITUACION_TITULO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
              LEFT JOIN '||V_ESQUEMA||'.DD_EQV_BANKIA_REM EQV
                  ON EQV.DD_NOMBRE_BANKIA = ''DD_SITUACION_TITULO''
                  AND EQV.DD_CODIGO_BANKIA = APR.SITUACION_TITULO
                LEFT JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI
                  ON ETI.DD_ETI_CODIGO = EQV.DD_CODIGO_REM
            )
            SELECT TEMP.*, ACT.DD_ETI_ID, LINK.ACT_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO ACT
              ON ACT.ACT_ID = LINK.ACT_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.DD_ETI_ID IS NULL
              AND
              TEMP.SITUACION_TITULO IS NOT NULL)
          ) TMP
          ON (TMP.ACT_ID = ACT.ACT_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.DD_ETI_ID = TMP.SITUACION_TITULO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_TIT_TITULO.DD_ETI_ID '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_TIT_TITULO.DD_ETI_ID '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


-------------------------------------
---- [10] ACT_OLE_OCUPANTE_LEGAL ----
-------------------------------------
--[10.1]--OLE_NOMBRE
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.NOMBRE_ARRENDATARIO, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.OLE_NOMBRE, LINK.ACT_ID, SPS.SPS_ID, SYSDATE AS FECHACREAR
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN ACT_SPS_SIT_POSESORIA SPS
              ON SPS.ACT_ID = LINK.ACT_ID
            LEFT JOIN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL ACT
              ON ACT.SPS_ID = SPS.SPS_ID
            WHERE
              TEMP.REM = 1
               AND
             (ACT.OLE_NOMBRE IS NULL
              AND
              TEMP.NOMBRE_ARRENDATARIO IS NOT NULL)
          ) TMP
          ON (TMP.SPS_ID = ACT.SPS_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.OLE_NOMBRE = TMP.NOMBRE_ARRENDATARIO,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          WHEN NOT MATCHED THEN INSERT
          (
          OLE_ID,
          SPS_ID,
          OLE_NOMBRE,
          USUARIOCREAR,
          FECHACREAR
          )
          VALUES
          (
          '||V_ESQUEMA||'.S_ACT_OLE_OCUPANTE_LEGAL.NEXTVAL,
          TMP.SPS_ID,
          TMP.NOMBRE_ARRENDATARIO,
          '''||V_USUARIO||''',
          TMP.FECHACREAR
          )
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


---------------------------------------
---- [11] ACT_ADO_ADMISION_DOCUMENTO ----
---------------------------------------
--[11.1]--ACT_ADO_ADMISION_DOCUMENTO
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ACT USING
          (
           WITH TCE AS (
              SELECT APR.APR_ID, TCE.DD_TCE_ID
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
              LEFT JOIN '||V_ESQUEMA||'.DD_TCE_TIPO_CALIF_ENERGETICA TCE
                ON TCE.DD_TCE_CODIGO = APR.COD_CALIF_EFICI_ENERGETICA
            )
            SELECT
            ACT.ACT_ID AS ACT_ID,
            CFD.CFD_ID AS CFD_ID,
            1 AS ADO_APLICA,
            TCE.DD_TCE_ID,
            APR.FEC_EMISION_CERTIFI_ENERG AS ADO_FECHA_CALIFICACION,
            APR.FEC_CADUCIDAD_CERTIFI_ENERG AS ADO_FECHA_CADUCIDAD,
            SYSDATE AS FECHACREAR
            FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
              ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
            INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BIE
              ON BIE.BIE_ID = ACT.BIE_ID
            INNER JOIN TCE
              ON TCE.APR_ID = APR.APR_ID
            INNER JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD
              ON CFD.DD_TPA_ID = ACT.DD_TPA_ID
              AND CFD.DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''11'')
            LEFT JOIN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
              ON ADO.ACT_ID = ACT.ACT_ID
            WHERE TCE.DD_TCE_ID IS NOT NULL
            AND
              APR.REM = 1
          ) TMP
          ON (TMP.CFD_ID = ACT.CFD_ID)
          WHEN NOT MATCHED THEN INSERT
          (
          ADO_ID,
          ACT_ID,
          CFD_ID,
          ADO_APLICA,
          ADO_FECHA_EMISION,
          ADO_FECHA_CADUCIDAD,
          USUARIOCREAR,
          FECHACREAR
          )
          VALUES
          (
          '||V_ESQUEMA||'.S_ACT_ADO_ADMISION_DOCUMENTO.NEXTVAL,
          TMP.ACT_ID,
          TMP.CFD_ID,
          TMP.ADO_APLICA,
          TMP.ADO_FECHA_CALIFICACION,
          TMP.ADO_FECHA_CADUCIDAD,
          '''||V_USUARIO||''',
          TMP.FECHACREAR
          )
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;


---------------------------------------
---- [12] ACT_MLV_MOVIMIENTO_LLAVE ----
---------------------------------------
--[12.1]--MLV_FECHA_ENTREGA
          EXECUTE IMMEDIATE '
          MERGE INTO '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE ACT USING
          (
           WITH TEMP AS (
              SELECT DISTINCT
              APR.FEC_ENVIO_LLAVES_GESTOR, APR_ID, ACT_NUMERO_UVEM, REM
              FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
            )
            SELECT TEMP.*, ACT.MLV_FECHA_ENTREGA, LINK.ACT_ID, ACT.MLV_ID, LLV.LLV_ID
            FROM TEMP
            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO LINK
              ON LINK.ACT_NUM_ACTIVO_UVEM = TEMP.ACT_NUMERO_UVEM
            INNER JOIN ACT_LLV_LLAVE LLV
              ON LLV.ACT_ID = LINK.ACT_ID
            LEFT JOIN ACT_MLV_MOVIMIENTO_LLAVE ACT
              ON ACT.LLV_ID = LLV.LLV_ID
            WHERE
              TEMP.REM = 1
               AND
              (ACT.MLV_FECHA_ENTREGA IS NULL
              AND
              TEMP.FEC_ENVIO_LLAVES_GESTOR IS NOT NULL)
          ) TMP
          ON (TMP.MLV_ID = ACT.MLV_ID)
          WHEN MATCHED THEN UPDATE SET
          ACT.MLV_FECHA_ENTREGA = TMP.FEC_ENVIO_LLAVES_GESTOR,
          ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
          ACT.FECHAMODIFICAR = SYSDATE
          WHEN NOT MATCHED THEN INSERT
          (MLV_ID,
          LLV_ID,
          MLV_FECHA_ENTREGA,
          USUARIOCREAR,
          FECHACREAR)
          VALUES
          ('||V_ESQUEMA||'.S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL,
          TMP.LLV_ID,
          TMP.FEC_ENVIO_LLAVES_GESTOR,
          '''||V_USUARIO||''',
          SYSDATE)
          '
          ;
          V_NUM_TABLAS := SQL%ROWCOUNT;

          IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

          END IF;
          
          
---------------------------------
---- [14] ACT_EDI_EDIFICIO ----
---------------------------------
--[14.1]--ASCENSORES
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI USING
	(
	  SELECT DISTINCT
	  ACT.ACT_ID,
	  ICO.ICO_ID,
	  DECODE(APR.ASCENSOR_ACTIVO,''S'',1,''N'',0,NULL) AS EDI_ASCENSOR,
	  1 AS EDI_NUM_ASCENSORES,
	  SYSDATE AS FECHACREAR
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  WHERE APR.ASCENSOR_ACTIVO IS NOT NULL
	) TMP
	ON (TMP.ICO_ID = EDI.ICO_ID)
	WHEN NOT MATCHED THEN INSERT
	(
	EDI_ID,
	ICO_ID,
	EDI_ASCENSOR,
	EDI_NUM_ASCENSORES,
	USUARIOCREAR,
	FECHACREAR
	)
	VALUES
	(
	'||V_ESQUEMA||'.S_ACT_EDI_EDIFICIO.NEXTVAL,
	TMP.ICO_ID,
	TMP.EDI_ASCENSOR,
	TMP.EDI_NUM_ASCENSORES,
	'''||V_USUARIO||''',
	TMP.FECHACREAR
	)
	'
	;
	V_NUM_TABLAS := SQL%ROWCOUNT;
	
	IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

    END IF;



---------------------------------
---- [15] ACT_VIV_VIVIENDA ----
---------------------------------
--[15.1]--ACT_VIV_VIVIENDA
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV USING 
	  (
		SELECT ACT.ACT_ID, ICO.ICO_ID, DIS.ICO_ID AS ICO_ID_DIS
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS
		ON DIS.ICO_ID = ICO.ICO_ID
	  WHERE DIS.ICO_ID IS NULL
	  AND APR.DORMITORIOS_ACTIVO IS NOT NULL
	  OR APR.BANIOS_ACTIVO IS NOT NULL
	  OR APR.GARAJE IS NOT NULL
	  OR APR.TRASTERO_ACTIVO IS NOT NULL
	  OR APR.NUM_TERRAZAS_DESCUBIERTAS IS NOT NULL
	) TMP
	ON (TMP.ICO_ID = VIV.ICO_ID)
	WHEN NOT MATCHED THEN INSERT 
	(
	ICO_ID
	)
	VALUES
	(
	TMP.ICO_ID
	)
	'
	;
	V_NUM_TABLAS := SQL%ROWCOUNT;
	
	IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

    END IF;


---------------------------------
---- [16] ACT_DIS_DISTRIBUCION ----
---------------------------------
--[16.1]--DORMITORIOS
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING 
	(
	  SELECT DISTINCT 
	  ACT.ACT_ID, ICO.ICO_ID,
	  0 AS DIS_NUM_PLANTA,
	  (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''01'') AS DD_TPH_ID,
	  APR.DORMITORIOS_ACTIVO AS DIS_CANTIDAD,
	  0 AS DIS_SUPERFICIE,
	  SYSDATE AS FECHACREAR
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  where APR.DORMITORIOS_ACTIVO IS NOT NULL
	) TMP
	ON (TMP.ICO_ID = DIS.ICO_ID
	AND TMP.DD_TPH_ID = DIS.DD_TPH_ID)
	WHEN NOT MATCHED THEN INSERT 
	(
	DIS_ID,
	ICO_ID,
	DIS_NUM_PLANTA,
	DD_TPH_ID,
	DIS_CANTIDAD,
	DIS_SUPERFICIE,
	USUARIOCREAR,
	FECHACREAR
	)
	VALUES
	(
	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
	TMP.ICO_ID,
	TMP.DIS_NUM_PLANTA,
	TMP.DD_TPH_ID,
	TMP.DIS_CANTIDAD,
	TMP.DIS_SUPERFICIE,
	'''||V_USUARIO||''',
	TMP.FECHACREAR
	)
	'
	;
	V_NUM_TABLAS := SQL%ROWCOUNT;



--[16.2]--BAÑOS
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING 
	(
	  SELECT DISTINCT 
	  ACT.ACT_ID, ICO.ICO_ID,
	  0 AS DIS_NUM_PLANTA,
	  (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''02'') AS DD_TPH_ID,
	  APR.BANIOS_ACTIVO AS DIS_CANTIDAD,
	  0 AS DIS_SUPERFICIE,
	  SYSDATE AS FECHACREAR
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  where APR.BANIOS_ACTIVO IS NOT NULL
	) TMP
	ON (TMP.ICO_ID = DIS.ICO_ID
	AND TMP.DD_TPH_ID = DIS.DD_TPH_ID)
	WHEN NOT MATCHED THEN INSERT 
	(
	DIS_ID,
	ICO_ID,
	DIS_NUM_PLANTA,
	DD_TPH_ID,
	DIS_CANTIDAD,
	DIS_SUPERFICIE,
	USUARIOCREAR,
	FECHACREAR
	)
	VALUES
	(
	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
	TMP.ICO_ID,
	TMP.DIS_NUM_PLANTA,
	TMP.DD_TPH_ID,
	TMP.DIS_CANTIDAD,
	TMP.DIS_SUPERFICIE,
	'''||V_USUARIO||''',
	TMP.FECHACREAR
	)
	'
	;
	V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;
	
	
--[16.3]--TERRAZAS_DESCUBIERTAS
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING 
	(
	  SELECT DISTINCT 
	  ACT.ACT_ID, ICO.ICO_ID,
	  0 AS DIS_NUM_PLANTA,
	  (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''16'') AS DD_TPH_ID,
	  APR.NUM_TERRAZAS_DESCUBIERTAS AS DIS_CANTIDAD,
	  0 AS DIS_SUPERFICIE,
	  SYSDATE AS FECHACREAR
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  where APR.NUM_TERRAZAS_DESCUBIERTAS IS NOT NULL
	) TMP
	ON (TMP.ICO_ID = DIS.ICO_ID
	AND TMP.DD_TPH_ID = DIS.DD_TPH_ID)
	WHEN NOT MATCHED THEN INSERT 
	(
	DIS_ID,
	ICO_ID,
	DIS_NUM_PLANTA,
	DD_TPH_ID,
	DIS_CANTIDAD,
	DIS_SUPERFICIE,
	USUARIOCREAR,
	FECHACREAR
	)
	VALUES
	(
	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
	TMP.ICO_ID,
	TMP.DIS_NUM_PLANTA,
	TMP.DD_TPH_ID,
	TMP.DIS_CANTIDAD,
	TMP.DIS_SUPERFICIE,
	'''||V_USUARIO||''',
	TMP.FECHACREAR
	)
	'
	;
	V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;
	
	
--[16.4]--TRASTEROS
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING 
	(
	  SELECT DISTINCT 
	  ACT.ACT_ID, ICO.ICO_ID,
	  0 AS DIS_NUM_PLANTA,
	  (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''11'') AS DD_TPH_ID,
	  DECODE(APR.TRASTERO_ACTIVO,''S'',1,''N'',0,NULL) AS DIS_CANTIDAD,
	  0 AS DIS_SUPERFICIE,
	  SYSDATE AS FECHACREAR
	  FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
	  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
	  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		ON ICO.ACT_ID = ACT.ACT_ID
	  where APR.TRASTERO_ACTIVO = ''S''
	) TMP
	ON (TMP.ICO_ID = DIS.ICO_ID
	AND TMP.DD_TPH_ID = DIS.DD_TPH_ID)
	WHEN NOT MATCHED THEN INSERT 
	(
	DIS_ID,
	ICO_ID,
	DIS_NUM_PLANTA,
	DD_TPH_ID,
	DIS_CANTIDAD,
	DIS_SUPERFICIE,
	USUARIOCREAR,
	FECHACREAR
	)
	VALUES
	(
	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
	TMP.ICO_ID,
	TMP.DIS_NUM_PLANTA,
	TMP.DD_TPH_ID,
	TMP.DIS_CANTIDAD,
	TMP.DIS_SUPERFICIE,
	'''||V_USUARIO||''',
	TMP.FECHACREAR
	)
	'
	;
	V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;


--[16.5]--GARAJES
	EXECUTE IMMEDIATE '
	MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING 
    (
      SELECT DISTINCT 
      ACT.ACT_ID, ICO.ICO_ID, APR.GARAJE,1 AS DIS_CANTIDAD_1, APR.NUM_PLAZAS_GARAJE AS DIS_CANTIDAD_2,
      (SELECT DD_TPH_ID FROM DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''12'') AS DD_TPH_ID,
      0 AS DIS_NUM_PLANTA,
      0 AS DIS_SUPERFICIE,
      SYSDATE AS FECHACREAR
      FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
        ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM
      INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
        ON ICO.ACT_ID = ACT.ACT_ID
      WHERE APR.GARAJE = ''S''
    ) TMP
    ON (TMP.ICO_ID = DIS.ICO_ID
    AND TMP.DD_TPH_ID = DIS.DD_TPH_ID)
    WHEN NOT MATCHED THEN INSERT 
    (
    DIS_ID,
    ICO_ID,
    DIS_NUM_PLANTA,
    DD_TPH_ID,
    DIS_CANTIDAD,
    DIS_SUPERFICIE,
    USUARIOCREAR,
    FECHACREAR
    )
    VALUES
    (
    '||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
    TMP.ICO_ID,
    TMP.DIS_NUM_PLANTA,
    TMP.DD_TPH_ID,
    COALESCE(DIS_CANTIDAD_2,DIS_CANTIDAD_1),
    TMP.DIS_SUPERFICIE,
    '''||V_USUARIO||''',
    TMP.FECHACREAR
    )
    '
    ;
    V_NUM_TABLAS := V_NUM_TABLAS + SQL%ROWCOUNT;
    
    IF V_NUM_TABLAS != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION '||V_NUM_TABLAS||' Registros.');
            PL_OUTPUT := PL_OUTPUT||'[INFO] REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION '||V_NUM_TABLAS||' Registros. '||CHR(10)||CHR(10);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');

            COMMIT;

	END IF;


    DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO FINALIZADO.');

EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END SP_UPA_UPDATE_ACTIVES_UVEM;
/
EXIT