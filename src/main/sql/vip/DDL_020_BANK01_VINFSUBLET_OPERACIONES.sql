--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: DDL creacion vistas para el nuevo informe letrado
--##            CREATE OR REPLACE VIEW VINFSUBLET_OPERACIONES
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  seq_count          NUMBER(3);                    -- Vble. para validar la existencia de las Secuencias.
  table_count        NUMBER(3);                    -- Vble. para validar la existencia de las Tablas.
  v_column_count     NUMBER(3);                    -- Vble. para validar la existencia de las Columnas.
  v_constraint_count NUMBER(3);                    -- Vble. para validar la existencia de las Constraints.
  err_num            NUMBER;                       -- Número de errores
  ERR_MSG            VARCHAR2(2048);               -- Mensaje de error
  V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_MSQL             VARCHAR2(4000 CHAR);
BEGIN

  DBMS_OUTPUT.PUT_LINE('[START] Crear o modificar la vista VINFSUBLET_OPERACIONES');
  
EXECUTE IMMEDIATE '
CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.VINFSUBLET_OPERACIONES AS
WITH
CONTRATOS_PROC AS (
  SELECT /*+ MATERIALIZE */ CEX.CNT_ID, PRC_CEX.PRC_ID
  FROM PRC_CEX
    INNER JOIN CEX_CONTRATOS_EXPEDIENTE CEX ON PRC_CEX.CEX_ID = CEX.CEX_ID
),
FIADORES AS (
  SELECT /*+ MATERIALIZE */ CPE.CNT_ID, PER.PER_NOM50 NOMBRE, TIN.DD_TIN_CODIGO
  FROM CPE_CONTRATOS_PERSONAS CPE
    LEFT JOIN DD_TIN_TIPO_INTERVENCION TIN ON CPE.DD_TIN_ID = TIN.DD_TIN_ID --AND TIN.DD_TIN_CODIGO IN (30, 31)
      LEFT JOIN PER_PERSONAS PER ON CPE.PER_ID = PER.PER_ID
  WHERE TIN.DD_TIN_CODIGO IN (30, 31)
),
MOVS_CONTRATOS AS (
  SELECT /*+ MATERIALIZE */ MOV.CNT_ID, ABS(MOV.MOV_INT_REMUNERATORIOS) + ABS(MOV.MOV_INT_MORATORIOS) DEUDATOTAL
  FROM MOV_MOVIMIENTOS MOV
  WHERE MOV.MOV_FECHA_EXTRACCION = (SELECT /*+ MATERIALIZE */ MAX(MOV_FECHA_EXTRACCION) FROM MOV_MOVIMIENTOS)
    AND  (MOV.MOV_POS_VIVA_VENCIDA + MOV.MOV_POS_VIVA_NO_VENCIDA) > 0
)
SELECT DISTINCT
  SUB.SUB_ID
  ,BIEC.CNT_ID OPER_ID
  ,SUBSTR(CNT.CNT_CONTRATO,11,17) NUM_OPERACION
  ,FIADORES.NOMBRE TITU_FIADORES
  ,CASE WHEN MOVS.DEUDATOTAL IS NULL THEN 0 ELSE MOVS.DEUDATOTAL END RECLAMADO
  ,PROCPADRE.PRC_COD_PROC_EN_JUZGADO || ''/'' || DDJUZ.DD_JUZ_DESCRIPCION || ''/'' || DDTPO.DD_TPO_DESCRIPCION AUTOS 
  ,'''' OBSERVACIONES
FROM SUB_SUBASTA SUB
  LEFT JOIN LOS_LOTE_SUBASTA LOS ON SUB.SUB_ID = LOS.SUB_ID
    LEFT JOIN LOB_LOTE_BIEN LOBI ON LOS.LOS_ID = LOBI.LOS_ID
      LEFT JOIN BIE_CNT BIEC ON LOBI.BIE_ID = BIEC.BIE_ID
        AND NOT BIEC.CNT_ID IN (SELECT CNT_ID
                                                  FROM CONTRATOS_PROC CNTPROC
                                                  WHERE CNTPROC.PRC_ID = SUB.PRC_ID)
        LEFT JOIN CNT_CONTRATOS CNT ON BIEC.CNT_ID = CNT.CNT_ID
          LEFT JOIN FIADORES ON CNT.CNT_ID = FIADORES.CNT_ID
          LEFT JOIN MOVS_CONTRATOS MOVS ON CNT.CNT_ID = MOVS.CNT_ID
          LEFT JOIN CEX_CONTRATOS_EXPEDIENTE CEX ON CNT.CNT_ID = CEX.CNT_ID
            LEFT JOIN PRC_CEX ON CEX.CEX_ID = PRC_CEX.CEX_ID
              LEFT JOIN PRC_PROCEDIMIENTOS PRCPROC ON PRC_CEX.PRC_ID = PRCPROC.PRC_ID
                LEFT JOIN ASU_ASUNTOS ASU ON PRCPROC.ASU_ID = ASU.ASU_ID
                  LEFT JOIN PRC_PROCEDIMIENTOS PROCPADRE ON ASU.ASU_ID = PROCPADRE.ASU_ID AND PROCPADRE.PRC_PRC_ID IS NULL
                    LEFT JOIN DD_JUZ_JUZGADOS_PLAZA DDJUZ ON PROCPADRE.DD_JUZ_ID = DDJUZ.DD_JUZ_ID
                    LEFT JOIN DD_TPO_TIPO_PROCEDIMIENTO DDTPO ON PROCPADRE.DD_TPO_ID = DDTPO.DD_TPO_ID';
                      
EXCEPTION
WHEN OTHERS THEN
  err_num := SQLCODE;
  err_msg := SQLERRM;
  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
  DBMS_OUTPUT.put_line(err_msg);
  ROLLBACK;
  RAISE;
END;
/

EXIT;                      
