--/*
--##########################################
--## AUTOR=Daniel Albert Pérez
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-257
--## PRODUCTO=NO
--## Finalidad: DML reparación asuntos CAJAMAR
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

  MERGE INTO
    #ESQUEMA#.ASU_ASUNTOS T1
  USING
  (
    WITH ASU_CNT AS
    (
      SELECT DISTINCT
        A.ASU_ID
        , C.CNT_ID
      FROM
        #ESQUEMA#.ASU_ASUNTOS A
        , #ESQUEMA#.PRC_PROCEDIMIENTOS P
        , #ESQUEMA#.PRC_CEX PC
        , #ESQUEMA#.CEX_CONTRATOS_EXPEDIENTE CE
        , #ESQUEMA#.CNT_CONTRATOS C
      WHERE
        A.ASU_ID = P.ASU_ID
        AND P.PRC_ID = PC.PRC_ID
        AND CE.CEX_ID = PC.CEX_ID
        AND CE.CNT_ID = C.CNT_ID
        AND A.DD_EAS_ID = (SELECT DD_EAS_ID FROM #ESQUEMA_MASTER#.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = '03')
        AND A.DD_TAS_ID = (SELECT DD_TAS_ID FROM #ESQUEMA_MASTER#.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = '01')
        AND A.USUARIOCREAR = 'ALTAASUNCM'
    )
    , ASUNTOS_MASD1 AS
    (
      SELECT
        ASU_ID
      FROM
        ASU_CNT
      GROUP BY
        ASU_ID
      HAVING
        COUNT(1) > 1
    )
    , CNTS_ASU AS
    (
      SELECT
        A.ASU_ID
        , A.ASU_NOMBRE
        , C.CNT_ID
        , LPAD(C.CNT_CONTRATO,16,'0') CNT_CONTRATO
        , CASE WHEN LPAD(C.CNT_CONTRATO,16,'0') = SUBSTR(A.ASU_NOMBRE,1,16) THEN 1 ELSE 0 END CONTRATO_CORRECTO
      FROM
        #ESQUEMA#.ASU_ASUNTOS A
        , ASUNTOS_MASD1 AMC
        , ASU_CNT AC
        , #ESQUEMA#.CNT_CONTRATOS C
      WHERE
        A.ASU_ID = AMC.ASU_ID
        AND A.ASU_ID = AC.ASU_ID
        AND C.CNT_ID = AC.CNT_ID
    )
    , CNTS_OK AS
    (
      SELECT
        ASU_ID
        , ASU_NOMBRE
        , CNT_ID
        , CNT_CONTRATO
        , ROW_NUMBER () OVER (PARTITION BY ASU_ID ORDER BY CONTRATO_CORRECTO DESC, CNT_CONTRATO ASC) CNT_OK
      FROM
        CNTS_ASU
    )
    , CNTS_PER AS
    (
      SELECT
        CO.ASU_ID
        , CO.ASU_NOMBRE
        , CO.CNT_CONTRATO
        , P.PER_DOC_ID || ' | ' || P.PER_NOM50 PER_NOMBRE
        , ROW_NUMBER () OVER (PARTITION BY CO.ASU_ID, CO.CNT_CONTRATO ORDER BY TO_NUMBER(T.DD_TIN_CODIGO) ASC, CP.CPE_ORDEN ASC, P.PER_ID ASC) RN
      FROM
        CNTS_OK CO
        , #ESQUEMA#.CPE_CONTRATOS_PERSONAS CP
        , #ESQUEMA#.PER_PERSONAS P
        , #ESQUEMA#.DD_TIN_TIPO_INTERVENCION T
      WHERE
        CO.CNT_OK = 1
        AND CO.CNT_ID = CP.CNT_ID
        AND CP.DD_TIN_ID = T.DD_TIN_ID
        AND T.DD_TIN_TITULAR = 1
        AND P.PER_ID = CP.PER_ID
    )
    , NUEVO_NOMBRE_CNTS AS
    (
      SELECT
        ASU_ID
        , ASU_NOMBRE
        , SUBSTR(CNT_CONTRATO || ' | ' || PER_NOMBRE,1,50) NOMBRE_NUEVO
      FROM
        CNTS_PER
      WHERE
        RN = 1
    )
    , ASUNTOS_SOLO1 AS
    (
      SELECT
        ASU_ID
      FROM
        ASU_CNT
      GROUP BY
        ASU_ID
      HAVING
        COUNT(1) = 1
    )
    , CNT_ASU AS
    (
      SELECT
        A.ASU_ID
        , A.ASU_NOMBRE
        , C.CNT_ID
        , LPAD(C.CNT_CONTRATO,16,'0') CNT_CONTRATO
      FROM
        #ESQUEMA#.ASU_ASUNTOS A
        , ASUNTOS_SOLO1 A1C
        , ASU_CNT AC
        , #ESQUEMA#.CNT_CONTRATOS C
      WHERE
        A.ASU_ID = A1C.ASU_ID
        AND A.ASU_ID = AC.ASU_ID
        AND C.CNT_ID = AC.CNT_ID
    )
    , CNT_PER AS
    (
      SELECT
        CO.ASU_ID
        , CO.ASU_NOMBRE
        , CO.CNT_CONTRATO
        , P.PER_DOC_ID || ' | ' || P.PER_NOM50 PER_NOMBRE
        , ROW_NUMBER () OVER (PARTITION BY CO.ASU_ID, CO.CNT_CONTRATO ORDER BY TO_NUMBER(T.DD_TIN_CODIGO) ASC, CP.CPE_ORDEN ASC, P.PER_ID ASC) RN
      FROM
        CNT_ASU CO
        , #ESQUEMA#.CPE_CONTRATOS_PERSONAS CP
        , #ESQUEMA#.PER_PERSONAS P
        , #ESQUEMA#.DD_TIN_TIPO_INTERVENCION T
      WHERE
        CO.CNT_ID = CP.CNT_ID
        AND CP.DD_TIN_ID = T.DD_TIN_ID
        AND T.DD_TIN_TITULAR = 1
        AND P.PER_ID = CP.PER_ID
    )
    , NUEVO_NOMBRE_CNT AS
    (
      SELECT
        ASU_ID
        , ASU_NOMBRE
        , SUBSTR(CNT_CONTRATO || ' | ' || PER_NOMBRE,1,50) NOMBRE_NUEVO
      FROM
        CNT_PER
      WHERE
        RN = 1
    )
    
    SELECT
      *
    FROM
      NUEVO_NOMBRE_CNT
    WHERE
      TRIM(BOTH FROM ASU_NOMBRE) <> TRIM(BOTH FROM NOMBRE_NUEVO)
    UNION
    SELECT
      *
    FROM
      NUEVO_NOMBRE_CNTS
    WHERE
      TRIM(BOTH FROM ASU_NOMBRE) <> TRIM(BOTH FROM NOMBRE_NUEVO)
  ) T2
  ON
  (
    T1.ASU_ID = T2.ASU_ID 
  )
  WHEN MATCHED
    THEN UPDATE
      SET T1.ASU_NOMBRE = T2.NOMBRE_NUEVO
        , T1.ASU_ID_EXTERNO = SUBSTR(T2.NOMBRE_NUEVO,1,16)
        , T1.USUARIOMODIFICAR = 'RECOVERY-257'
        , T1.FECHAMODIFICAR = SYSDATE;

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