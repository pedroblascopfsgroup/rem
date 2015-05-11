--/*
--##########################################
--## Author: #AUTOR# 
--## Finalidad: DDL creacion vistas para el nuevo informe letrado
--##            CREATE OR REPLACE VIEW VINFSUBLET_BIENES
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
  err_msg            VARCHAR2(2048);               -- Mensaje de error
  V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_MSQL             VARCHAR2(4000 CHAR);
BEGIN

  DBMS_OUTPUT.PUT_LINE('[START] Crear o modificar la vista VINFSUBLET_BIENES');

EXECUTE IMMEDIATE '
CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.VINFSUBLET_BIENES AS
WITH
CARGAS_ANTERIORES AS (
  SELECT /*+ MATERIALIZE */ DISTINCT BIECAR.BIE_ID, BIECAR.BIE_CAR_IMPORTE_REGISTRAL
  FROM BIE_CAR_CARGAS BIECAR
    LEFT JOIN DD_TPC_TIPO_CARGA TPC ON BIECAR.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''ANT''
  WHERE BIECAR.BORRADO = 0
),
CARGAS_POSTERIORES AS (
  SELECT /*+ MATERIALIZE */ DISTINCT BIECAR.BIE_ID, BIECAR.BIE_CAR_IMPORTE_REGISTRAL
  FROM BIE_CAR_CARGAS BIECAR
    LEFT JOIN DD_TPC_TIPO_CARGA TPC ON BIECAR.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''POS''
  WHERE BIECAR.BORRADO = 0
)
SELECT DISTINCT
  SUB.SUB_ID
  ,BIE.BIE_ID
  ,BIELOC.BIE_LOC_DIRECCION DOMICILIO
  ,BIE.BIE_DESCRIPCION DESCRIPCION
  ,BIE.BIE_DATOS_REGISTRALES DATOS_REGISTRALES
  ,BIECARANT.BIE_CAR_IMPORTE_REGISTRAL CARGAS_ANTERIORES
  ,BIECARPOS.BIE_CAR_IMPORTE_REGISTRAL CARGAS_POSTERIORES
  ,CASE BIE_VIVIENDA_HABITUAL WHEN 1 THEN ''SI'' WHEN 0 THEN ''NO'' ELSE '''' END VIVIENDA_HABITUAL
  ,DD_SPO.DD_SPO_DESCRIPCION SITUACION_POSESORIA
  ,NULL TPO_SUBASTA
FROM SUB_SUBASTA SUB
  LEFT JOIN LOS_LOTE_SUBASTA LOS ON SUB.SUB_ID = LOS.SUB_ID
    LEFT JOIN LOB_LOTE_BIEN LOBLOTE ON LOS.LOS_ID = LOBLOTE.LOS_ID
      LEFT JOIN BIE_BIEN BIE ON LOBLOTE.BIE_ID = BIE.BIE_ID
        LEFT JOIN BIE_LOCALIZACION BIELOC ON BIE.BIE_ID = BIELOC.BIE_ID
        LEFT JOIN DD_SPO_SITUACION_POSESORIA DD_SPO ON BIE.DD_SPO_ID = DD_SPO.DD_SPO_ID
        LEFT JOIN CARGAS_ANTERIORES BIECARANT ON BIE.BIE_ID = BIECARANT.BIE_ID
        LEFT JOIN CARGAS_POSTERIORES BIECARPOS ON BIE.BIE_ID = BIECARPOS.BIE_ID';
  
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
  
