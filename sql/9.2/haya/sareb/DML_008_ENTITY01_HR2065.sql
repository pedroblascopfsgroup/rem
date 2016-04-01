--/*
--##########################################
--## AUTOR=Daniel Albert Pérez
--## FECHA_CREACION=20160318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2065
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables
    
 BEGIN
    
    DBMS_OUTPUT.put_line('- INICIO PROCESO -');

    V_MSQL := 'MERGE INTO
  '||V_ESQUEMA||'.PCO_BUR_ENVIO T1
USING
(
  SELECT
    PCO_BUR_ENVIO_ID
    , DIR_ID_PUESTA
    , DIR_ID_CORRECTA
  FROM
  (
    SELECT
      BUR.PCO_BUR_BUROFAX_ID
      , BUROS.PCO_BUR_ENVIO_ID
      , BUROS.DIR_ID DIR_ID_PUESTA
      , DIR.DIR_ID DIR_ID_CORRECTA
      , ROW_NUMBER() OVER(PARTITION BY BUR.PCO_BUR_BUROFAX_ID ORDER BY DIR.DIR_ID, DIR.TPD_ID ASC) RN
    FROM
    (
      SELECT
        BUR.PCO_BUR_BUROFAX_ID
        , ENV.PCO_BUR_ENVIO_ID
        , BUR.PCO_PRC_ID
        , BUR.PER_ID
        , ENV.DIR_ID
      FROM
        '||V_ESQUEMA||'.PCO_BUR_ENVIO ENV
      INNER JOIN
        '||V_ESQUEMA||'.PCO_BUR_BUROFAX BUR
        ON BUR.PCO_BUR_BUROFAX_ID = ENV.PCO_BUR_BUROFAX_ID
      LEFT JOIN
        '||V_ESQUEMA||'.DIR_PER DPE
        ON DPE.PER_ID = BUR.PER_ID
      WHERE
        BUR.USUARIOCREAR = ''MIGRAPCO''
        AND NOT EXISTS 
          (
            SELECT 1 FROM '||V_ESQUEMA||'.DIR_PER WHERE DIR_ID = ENV.DIR_ID AND PER_ID = BUR.PER_ID
          )
      GROUP BY
        BUR.PCO_BUR_BUROFAX_ID
        , ENV.PCO_BUR_ENVIO_ID
        , BUR.PCO_PRC_ID
        , BUR.PER_ID
        , ENV.DIR_ID
      ORDER BY
        BUR.PCO_BUR_BUROFAX_ID
    ) BUROS
    INNER JOIN
      '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
      ON PCO.PCO_PRC_ID = BUROS.PCO_PRC_ID
    INNER JOIN
      '||V_ESQUEMA||'.PCO_BUR_BUROFAX BUR
      ON BUR.PCO_BUR_BUROFAX_ID = BUROS.PCO_BUR_BUROFAX_ID
    INNER JOIN
      '||V_ESQUEMA||'.MIG_EXPEDIENTES_NOTIFICACIONES MIG
      ON TO_CHAR(MIG.MIG_ID_EXP_NOT) = BUR.USUARIOMODIFICAR
    INNER JOIN
      '||V_ESQUEMA||'.DIR_DIRECCIONES DIR
      ON DIR.DIR_DOM_N = MIG.NUM_DOMICILIO
        AND DIR.DIR_DOMICILIO = MIG.NOMBRE_VIA
        AND DIR.DIR_CODIGO_POSTAL = MIG.CODIGO_POSTAL
    INNER JOIN
      '||V_ESQUEMA||'.DIR_PER DPE
      ON DPE.PER_ID = BUROS.PER_ID
        AND DPE.DIR_ID = DIR.DIR_ID
    ORDER BY
      BUR.PCO_BUR_BUROFAX_ID
  )
  WHERE
    RN = 1
) T2
ON
(
  T2.PCO_BUR_ENVIO_ID = T1.PCO_BUR_ENVIO_ID
)
WHEN MATCHED
  THEN UPDATE
    SET T1.DIR_ID = T2.DIR_ID_CORRECTA';
    
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.put_line('- FIN PROCESO -');
    
 EXCEPTION

    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
