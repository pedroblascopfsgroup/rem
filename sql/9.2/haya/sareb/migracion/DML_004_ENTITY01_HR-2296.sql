--/*
--##########################################
--## AUTOR=DANIEL ALBERT PEREZ
--## FECHA_CREACION=20160428
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2296
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado contratos Migración PCO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_MSQL VARCHAR(32000);   
    V_MSQL_RESULT VARCHAR(32000);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- Configuracion Esquema
    
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
    TYPE T_TABLAS IS TABLE OF VARCHAR2(300);
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/


                       

--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
 -- Vble. para loop
   V_TEMP_TABLAS  T_TABLAS;
 -- Vble. para almacenar esquema
   V_TEMP_ESQUEMA  VARCHAR(30);
 --  F T_ARRAY_TABLAS;

BEGIN

DBMS_OUTPUT.ENABLE(1000000);

--##########################################
--## TRUNCADO DE TABLAS
--##########################################
  
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**BORRADO LÓGICO**' );
  DBMS_OUTPUT.PUT_LINE('********************' );

EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.CNT_CONTRATOS SET BORRADO=1, USUARIOBORRAR=''HR-2296'', FECHABORRAR = SYSDATE WHERE CNT_ID IN  (
  6254705,
  6284449,
  6295994,
  6295993,
  6287901,
  6306477,
  6306335,
  6306244,
  6306243,
  6306242,
  6306241,
  6306240,
  6306239,
  6306238,
  6306237,
  6306236,
  6301422,
  6301421,
  6301420,
  6299998,
  6299997,
  6299996,
  6286933,
  6286932,
  6286931,
  6286930,
  6286929,
  6286928,
  6286927,
  6281320,
  6281319,
  6281318,
  6281317,
  6281316,
  6281315,
  6281314,
  6281313,
  6273479,
  6273478,
  6273477,
  6266981,
  6291833,
  6278129,
  6275199,
  6258482,
  6291834,
  6292789,
  6275200,
  6292788,
  6260591,
  6247858,
  6290804,
  6285509,
  6278796,
  6257349,
  6294919,
  6274393,
  6276819,
  6248599,
  6286351,
  6265591,
  6247123,
  6307157,
  6263998,
  6296654,
  6263600,
  6261239,
  6284446,
  6264002,
  6282294,
  6294440,
  6279390,
  6282611,
  6284691,
  6284274,
  6269918,
  6284273,
  6310408,
  6264010,
  6264009,
  6253197,
  6247653,
  6282923,
  6274740,
  6268341,
  6248994,
  6266086,
  6291281,
  6290701,
  6263080,
  6290993,
  6294729,
  6306590,
  6288396,
  6265394,
  6300724,
  6257315,
  6260185,
  6290504,
  6299783,
  1000000000000168,
  1000000000000278,
  1000000000000161,
  6308653,
  6301079,
  6255462,
  6290975,
  6263459,
  6247802,
  6275900,
  6309416,
  6291067,
  6291066,
  6291065,
  6273230,
  6273229,
  6258118,
  6254541,
  6256505,
  6299365,
  6303196,
  6303195,
  6303194,
  6303193,
  6282813,
  6282812,
  6271182,
  6271181,
  6269301,
  6291006,
  6269299,
  6246674,
  6272537,
  6310612,
  6253193,
  6306608,
  6296121,
  6264015,
  6268096,
  6275895,
  6247359,
  6290500,
  6247545,
  6282309,
  6282859,
  6281100,
  6252665,
  6256272,
  6251933,
  6248829,
  6248898,
  6257311
) '; -- CNT_ID CALCULADOS.

  V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''';   

  DBMS_OUTPUT.PUT_LINE('CONTRATOS BORRADOS' );
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);

EXECUTE IMMEDIATE  '
MERGE INTO '||V_ESQUEMA||'.PER_PERSONAS A
USING(
SELECT PER.PER_ID from '||V_ESQUEMA||'.PER_PERSONAS PER
WHERE PER_ID IN (
3989334,
3990107,
3993534,
3994525,
3995169,
3995296,
3995376,
3996984,
3997102,
4000682,
4001829,
4003578,
4004719,
4005863,
4007159
)
)B
ON ( A.PER_ID=B.PER_ID ) WHEN MATCHED THEN UPDATE SET BORRADO=1, USUARIOBORRAR=''HR-2296'', FECHABORRAR =SYSDATE';

  V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''';   

  DBMS_OUTPUT.PUT_LINE('PER BORRADOS' );
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE CNT_ID IN 
  (SELECT CNT_ID FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE BORRADO=1 AND USUARIOBORRAR=''HR-2296'' )'; -- CNT_ID Y PER_ID CALCULADOS

EXECUTE IMMEDIATE  '
MERGE INTO '||V_ESQUEMA||'.BIE_BIEN A
USING(
select BIE.BIE_ID from '||V_ESQUEMA||'.BIE_BIEN BIE
inner join '||V_ESQUEMA||'.BIE_CNT BCT on BIE.BIE_ID = BCT.BIE_ID
inner join '||V_ESQUEMA||'.CNT_CONTRATOS cnt on BCT.CNT_ID = cnt.CNT_ID and cnt.borrado=1 AND CNT.USUARIOBORRAR=''HR-2296''
minus 
select BIE.BIE_ID from '||V_ESQUEMA||'.BIE_BIEN BIE
inner join '||V_ESQUEMA||'.BIE_CNT BCT on BIE.BIE_ID = BCT.BIE_ID
inner join '||V_ESQUEMA||'.CNT_CONTRATOS cnt on BCT.CNT_ID = cnt.CNT_ID and cnt.borrado=0
)B
ON ( A.BIE_ID=B.BIE_ID ) WHEN MATCHED THEN UPDATE SET BORRADO=1, USUARIOBORRAR=''HR-2296''
';

  V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''';   

  DBMS_OUTPUT.PUT_LINE('BIENES BORRADOS');
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_CNT SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE CNT_ID IN ( SELECT CNT_ID FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_PER SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'DELETE FROM  '||V_ESQUEMA||'.LOB_LOTE_BIEN WHERE BIE_ID IN (SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296'')';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_CAR_CARGAS SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_VALORACIONES SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_ADICIONAL SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_LOCALIZACION SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'DELETE FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS WHERE BIE_ID IN (SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'DELETE FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS WHERE PER_ID IN (SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE CNT_ID IN ( SELECT CNT_ID FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) AND USUARIOCREAR = ''MIGRAPCO'' ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.TEL_PER SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.PER_GCL SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.PER_GCL SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) ';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.CLI_CLIENTES SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE PER_ID IN ( SELECT PER_ID FROM '||V_ESQUEMA||'.PER_PERSONAS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE  'UPDATE  '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE SET BORRADO=1, USUARIOBORRAR=''HR-2296'' WHERE CNT_ID IN ( SELECT CNT_ID FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE borrado=1 AND USUARIOBORRAR=''HR-2296''  ) AND USUARIOCREAR = ''MIGRAPCO''';

  DBMS_OUTPUT.PUT_LINE('DOCUMENTOS BORRADOS');
  V_MSQL:= 
    '
      MERGE INTO '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS B
      USING
      (
        SELECT DISTINCT
          PCO.PCO_PRC_ID
          , CNT.CNT_ID
        FROM
          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
        INNER JOIN
          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
          ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
        INNER JOIN
          '||V_ESQUEMA||'.PRC_CEX
          ON PRC_CEX.CEX_ID = CEX.CEX_ID
        INNER JOIN
          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
          ON PRC.PRC_ID = PRC_CEX.PRC_ID
        INNER JOIN
          '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
          ON PCO.PRC_ID = PRC.PRC_ID
        WHERE
          CNT.BORRADO = 1
          AND
          CNT.USUARIOBORRAR=''HR-2296''
      ) PCO
      ON
      (
        PCO.PCO_PRC_ID = B.PCO_PRC_ID AND PCO.CNT_ID = B.PCO_DOC_PDD_UG_ID
      )
      WHEN MATCHED
        THEN UPDATE
          SET BORRADO = 1
              , USUARIOBORRAR = ''HR-2296''
              , FECHABORRAR = SYSDATE
    ';
  EXECUTE IMMEDIATE (V_MSQL); 
  V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS WHERE BORRADO=1 AND USUARIOBORRAR=''HR-2296''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES SET BORRADO = 1, USUARIOBORRAR = ''HR-2296'', FECHABORRAR = SYSDATE WHERE PCO_DOC_PDD_ID IN (SELECT PCO_DOC_PDD_ID FROM '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296'')';
  
  DBMS_OUTPUT.PUT_LINE('LIQUIDACIONES BORRADAS');
  EXECUTE IMMEDIATE
    '
      MERGE INTO '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES B
      USING
      (
        SELECT DISTINCT
          PCO.PCO_PRC_ID
          , CNT.CNT_ID
        FROM
          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
        INNER JOIN
          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
          ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
        INNER JOIN
          '||V_ESQUEMA||'.PRC_CEX
          ON PRC_CEX.CEX_ID = CEX.CEX_ID
        INNER JOIN
          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
          ON PRC.PRC_ID = PRC_CEX.PRC_ID
        INNER JOIN
          '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
          ON PCO.PRC_ID = PRC.PRC_ID
        WHERE
          CNT.BORRADO = 1
          AND
          CNT.USUARIOBORRAR=''HR-2296''
      ) PCO
      ON
      (
        PCO.PCO_PRC_ID = B.PCO_PRC_ID AND PCO.CNT_ID = B.CNT_ID
      )
      WHEN MATCHED
        THEN UPDATE
          SET BORRADO = 1
              , USUARIOBORRAR = ''HR-2296''
              , FECHABORRAR = SYSDATE
    ';
  V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES WHERE BORRADO=1 AND USUARIOBORRAR=''HR-2296''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);
  
  DBMS_OUTPUT.PUT_LINE('BUROFAXES BORRADOS');
  EXECUTE IMMEDIATE
    '
      MERGE INTO '||V_ESQUEMA||'.PCO_BUR_BUROFAX B
      USING
      (
        SELECT DISTINCT
          PCO.PCO_PRC_ID
          , CNT.CNT_ID
        FROM
          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
        INNER JOIN
          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
          ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
        INNER JOIN
          '||V_ESQUEMA||'.PRC_CEX
          ON PRC_CEX.CEX_ID = CEX.CEX_ID
        INNER JOIN
          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
          ON PRC.PRC_ID = PRC_CEX.PRC_ID
        INNER JOIN
          '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
          ON PCO.PRC_ID = PRC.PRC_ID
        WHERE
          CNT.BORRADO = 1
          AND
          CNT.USUARIOBORRAR=''HR-2296''
      ) PCO
      ON
      (
        PCO.PCO_PRC_ID = B.PCO_PRC_ID AND PCO.CNT_ID = B.CNT_ID 
      )
      WHEN MATCHED
        THEN UPDATE
          SET BORRADO = 1
              , USUARIOBORRAR = ''HR-2296''
              , FECHABORRAR = SYSDATE
    ';
  V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX WHERE BORRADO=1 AND USUARIOBORRAR=''HR-2296''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.PCO_BUR_ENVIO SET BORRADO = 1, USUARIOBORRAR = ''HR-2296'', FECHABORRAR = SYSDATE WHERE PCO_BUR_BUROFAX_ID IN (SELECT PCO_BUR_BUROFAX_ID FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296'')';
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.PCO_BUR_ENVIO_INTEGRACION SET BORRADO = 1, USUARIOBORRAR = ''HR-2296'', FECHABORRAR = SYSDATE WHERE PCO_BUR_ENVIO_ID IN (SELECT PCO_BUR_ENVIO_ID FROM '||V_ESQUEMA||'.PCO_BUR_ENVIO WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296'')';
  
  DBMS_OUTPUT.PUT_LINE('OBSERVACIONES BORRADAS');
  EXECUTE IMMEDIATE
    '
      MERGE INTO '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES B
      USING
      (
        SELECT DISTINCT
          PCO.PCO_PRC_ID
          , SUBSTR(CNT.CNT_CONTRATO,11,17) CNT_CONTRATO
        FROM
          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
        INNER JOIN
          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
          ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
        INNER JOIN
          '||V_ESQUEMA||'.PRC_CEX
          ON PRC_CEX.CEX_ID = CEX.CEX_ID
        INNER JOIN
          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
          ON PRC.PRC_ID = PRC_CEX.PRC_ID
        INNER JOIN
          '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
          ON PCO.PRC_ID = PRC.PRC_ID
        WHERE
          CNT.BORRADO = 1
          AND
          CNT.USUARIOBORRAR=''HR-2296''
      ) PCO
      ON
      (
        PCO.PCO_PRC_ID = B.PCO_PRC_ID AND SUBSTR(B.PCO_OBS_TEXTO_ANOTACION,1,17) = PCO.CNT_CONTRATO
      )
      WHEN MATCHED
        THEN UPDATE
          SET BORRADO = 1
              , USUARIOBORRAR = ''HR-2296''
              , FECHABORRAR = SYSDATE
    ';
  V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES WHERE BORRADO=1 AND USUARIOBORRAR=''HR-2296''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE(V_MSQL_RESULT);   
  
  EXECUTE IMMEDIATE  'DELETE FROM '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296''';
  
  EXECUTE IMMEDIATE  'DELETE FROM '||V_ESQUEMA||'.PRC_PER WHERE (PRC_ID, PER_ID) IN 
    (
        SELECT 
          PRC_ID
          , PER_ID 
        FROM
        ( 
          SELECT DISTINCT
            PRC_PER_BK.PRC_ID
            , PRC_PER_BK.PER_ID
            , CNT.CNT_ID
            , CPE.BORRADO
          FROM 
            '||V_ESQUEMA||'.CNT_CONTRATOS CNT
          INNER JOIN
            '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
            ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
          INNER JOIN
            '||V_ESQUEMA||'.ASU_ASUNTOS ASU
            ON CEX.EXP_ID = ASU.EXP_ID
          INNER JOIN
            '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
            ON PRC.ASU_ID = ASU.ASU_ID
          INNER JOIN
            '||V_ESQUEMA||'.PRC_PER PRC_PER_BK
            ON PRC_PER_BK.PRC_ID = PRC.PRC_ID
          INNER JOIN
            '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
            ON CPE.CNT_ID = CNT.CNT_ID AND CPE.PER_ID = PRC_PER_BK.PER_ID
        ) 
        WHERE 
          BORRADO = 1 
        GROUP BY 
          PRC_ID
          , PER_ID
        MINUS
        SELECT 
          PRC_ID
          , PER_ID 
        FROM
        ( 
          SELECT DISTINCT
            PRC_PER_BK.PRC_ID
            , PRC_PER_BK.PER_ID
            , CNT.CNT_ID
            , CPE.BORRADO
          FROM 
            '||V_ESQUEMA||'.CNT_CONTRATOS CNT
          INNER JOIN
            '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
            ON CEX.CNT_ID = CNT.CNT_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
          INNER JOIN
            '||V_ESQUEMA||'.ASU_ASUNTOS ASU
            ON CEX.EXP_ID = ASU.EXP_ID
          INNER JOIN
            '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
            ON PRC.ASU_ID = ASU.ASU_ID
          INNER JOIN
            '||V_ESQUEMA||'.PRC_PER PRC_PER_BK
            ON PRC_PER_BK.PRC_ID = PRC.PRC_ID
          INNER JOIN
            '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
            ON CPE.CNT_ID = CNT.CNT_ID AND CPE.PER_ID = PRC_PER_BK.PER_ID
        ) 
        WHERE 
          BORRADO = 0
        GROUP BY 
          PRC_ID
          , PER_ID
    )';
  
  EXECUTE IMMEDIATE '
                    MERGE INTO
                      '||V_ESQUEMA||'.ASU_ASUNTOS T1
                    USING
                    (
                      SELECT
                        ASU_ID
                        , ASU_NOMBRE
                        , NOMBRE_ASUNTO_PROPUESTO
                      FROM
                      (
                        SELECT
                          ASU_ID
                          , ASU_NOMBRE
                          , NOMBRE_ASUNTO_PROPUESTO
                          , ROW_NUMBER() OVER (PARTITION BY ASU_ID ORDER BY DD_TIN_ID, CPE_ORDEN DESC) RANKING_PERSONAS
                        FROM
                        (
                          SELECT DISTINCT
                            ASU.ASU_ID
                            , ASU.ASU_NOMBRE
                            , CNT.CNT_ID
                            , MOV.MOV_POS_VIVA_NO_VENCIDA + MOV.MOV_POS_VIVA_VENCIDA
                            , PER.PER_DOC_ID || '' '' ||PER.PER_NOM50 NOMBRE_ASUNTO_PROPUESTO
                            , CPE.CPE_ORDEN
                            , CPE.DD_TIN_ID
                            , TIN.DD_TIN_DESCRIPCION
                            , RANK() OVER (PARTITION BY ASU.ASU_ID ORDER BY MOV.MOV_POS_VIVA_NO_VENCIDA + MOV.MOV_POS_VIVA_VENCIDA, MOV.MOV_ID DESC) RANKING_CONTRATO
                          FROM
                            '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                          INNER JOIN
                            '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                            ON PRC.ASU_ID = ASU.ASU_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.PRC_CEX
                            ON PRC_CEX.PRC_ID = PRC.PRC_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                            ON PRC_CEX.CEX_ID = CEX.CEX_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.CNT_CONTRATOS CNT
                            ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
                          INNER JOIN
                            '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
                            ON CPE.CNT_ID = CNT.CNT_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.PER_PERSONAS PER
                            ON CPE.PER_ID = PER.PER_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN
                            ON TIN.DD_TIN_ID = CPE.DD_TIN_ID
                          INNER JOIN
                            '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV
                            ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION
                          WHERE
                            ASU.ASU_ID IN
                            (
                              SELECT DISTINCT
                                ASU.ASU_ID
                              FROM
                                '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                              INNER JOIN
                                '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                                ON PRC.ASU_ID = ASU.ASU_ID
                              INNER JOIN
                                '||V_ESQUEMA||'.PRC_CEX
                                ON PRC_CEX.PRC_ID = PRC.PRC_ID
                              INNER JOIN
                                '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                                ON CEX.CEX_ID = PRC_CEX.CEX_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
                              INNER JOIN
                                '||V_ESQUEMA||'.CNT_CONTRATOS CNT
                                ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 1 AND CNT.USUARIOBORRAR = ''HR-2296''
                            )
                        )
                        WHERE
                          RANKING_CONTRATO = 1
                      )
                      WHERE
                        RANKING_PERSONAS = 1
                    ) T2
                    ON
                    (
                      T1.ASU_ID = T2.ASU_ID
                    )
                    WHEN MATCHED
                      THEN UPDATE
                        SET T1.ASU_NOMBRE = SUBSTR(SUBSTR(T2.ASU_NOMBRE,1,10)||T2.NOMBRE_ASUNTO_PROPUESTO,1,50)
                    ';
  
  EXECUTE IMMEDIATE '
                      MERGE INTO
                        '||V_ESQUEMA||'.EXP_EXPEDIENTES T1
                      USING
                      (
                        SELECT
                          ASU_ID
                          , EXP_ID
                          , ASU_NOMBRE
                        FROM
                          '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                        WHERE
                          USUARIOCREAR = ''MIGRAPCO''
                      ) T2
                      ON
                      (
                        T1.EXP_ID = T2.EXP_ID AND T1.USUARIOCREAR = ''MIGRAPCO''
                      )
                      WHEN MATCHED
                        THEN UPDATE
                          SET T1.EXP_DESCRIPCION = T2.ASU_NOMBRE
                    ';
  
  EXECUTE IMMEDIATE '
                      MERGE INTO
                        '||V_ESQUEMA||'.PRB_PRC_BIE T1
                      USING
                      (
                        SELECT DISTINCT
                          PRB.PRC_ID
                          , PRB.BIE_ID
                        FROM 
                          '||V_ESQUEMA||'.PRB_PRC_BIE PRB 
                        INNER JOIN 
                          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC 
                          ON PRC.PRC_ID = PRB.PRC_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.PRC_CEX PC
                          ON PC.PRC_ID = PRC.PRC_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                          ON PC.CEX_ID = CEX.CEX_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
                        INNER JOIN 
                          '||V_ESQUEMA||'.BIE_CNT BC 
                          ON PRB.BIE_ID = BC.BIE_ID 
                        INNER JOIN 
                          '||V_ESQUEMA||'.CNT_CONTRATOS CNT 
                          ON CNT.CNT_ID = BC.CNT_ID 
                            AND CNT.CNT_ID = CEX.CNT_ID
                            AND CNT.BORRADO = 1 
                            AND CNT.USUARIOBORRAR = ''HR-2296''
                      ) T2
                      ON
                      (
                        T1.PRC_ID = T2.PRC_ID AND T1.BIE_ID = T2.BIE_ID
                      )
                      WHEN MATCHED
                        THEN UPDATE
                          SET T1.BORRADO = 1
                              , T1.USUARIOBORRAR = ''HR-2296''
                    ';
  
  EXECUTE IMMEDIATE  '
                      MERGE INTO 
                        '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE T1
                      USING
                      (
                        SELECT
                          ASU.ASU_NOMBRE
                          , CNT.CNT_ID
                          , MOV.MOV_POS_VIVA_NO_VENCIDA + MOV.MOV_POS_VIVA_VENCIDA POSICION_VIVA
                          , CEX.CEX_ID
                          , CEX.CEX_PASE
                          , ROW_NUMBER() OVER(PARTITION BY ASU.ASU_NOMBRE ORDER BY MOV.MOV_POS_VIVA_NO_VENCIDA + MOV.MOV_POS_VIVA_VENCIDA DESC, MOV.CNT_ID ASC) NUMERO
                        FROM 
                          '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                        INNER JOIN
                          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                          ON PRC.ASU_ID = ASU.ASU_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.PRC_CEX
                          ON PRC_CEX.PRC_ID = PRC.PRC_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                          ON PRC_CEX.CEX_ID = CEX.CEX_ID AND CEX.USUARIOCREAR = ''MIGRAPCO''
                        INNER JOIN
                          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
                          ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
                        INNER JOIN
                          '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV
                          ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION
                        WHERE 
                          ASU.ASU_ID IN 
                          (
                            SELECT ASU_ID FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS WHERE PRC_ID IN (SELECT PRC_ID FROM '||V_ESQUEMA||'.PRC_CEX WHERE CEX_ID IN (SELECT CEX_ID FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296''))
                          )
                        ORDER BY
                          ASU.ASU_NOMBRE
                      ) T2
                      ON
                      (
                        T1.CEX_ID = T2.CEX_ID AND T2.NUMERO = 1
                      )
                      WHEN MATCHED
                        THEN UPDATE
                          SET CEX_PASE = 1
                      ';
  
  EXECUTE IMMEDIATE '
                      MERGE INTO 
                        '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE T1
                      USING
                      (
                        SELECT
                          ASU.ASU_NOMBRE
                          , PRC.PRC_ID
                          , CEX.EXP_ID
                          , PEX.PEX_ID
                          , ROW_NUMBER() OVER(PARTITION BY ASU.ASU_NOMBRE ORDER BY CPE.CPE_ORDEN ASC, CPE.DD_TIN_ID ASC) NUMERO
                        FROM 
                          '||V_ESQUEMA||'.ASU_ASUNTOS ASU
                        INNER JOIN
                          '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                          ON PRC.ASU_ID = ASU.ASU_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.PRC_CEX
                          ON PRC_CEX.PRC_ID = PRC.PRC_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                          ON PRC_CEX.CEX_ID = CEX.CEX_ID AND CEX.USUARIOCREAR = ''MIGRAPCO'' AND CEX.CEX_PASE = 1
                        INNER JOIN
                          '||V_ESQUEMA||'.CNT_CONTRATOS CNT
                          ON CNT.CNT_ID = CEX.CNT_ID AND CNT.BORRADO = 0
                        INNER JOIN
                          '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
                          ON CPE.CNT_ID = CNT.CNT_ID AND CPE.BORRADO = 0
                        INNER JOIN
                          '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN
                          ON TIN.DD_TIN_TITULAR = 1 AND TIN.DD_TIN_ID = CPE.DD_TIN_ID
                        INNER JOIN
                          '||V_ESQUEMA||'.PER_PERSONAS PER
                          ON PER.PER_ID = CPE.PER_ID AND PER.BORRADO = 0
                        INNER JOIN
                          '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX
                          ON PEX.PER_ID = PER.PER_ID AND PEX.EXP_ID = CEX.EXP_ID
                        WHERE 
                          ASU.ASU_ID IN 
                          (
                            SELECT ASU_ID FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS WHERE PRC_ID IN (SELECT PRC_ID FROM '||V_ESQUEMA||'.PRC_CEX WHERE CEX_ID IN (SELECT CEX_ID FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296''))
                          )
                        ORDER BY
                          ASU.ASU_NOMBRE
                      ) T2
                      ON
                      (
                        T1.PEX_ID = T2.PEX_ID AND T2.NUMERO = 1
                      )
                      WHEN MATCHED
                        THEN UPDATE
                          SET PEX_PASE = 1
                    ';

  EXECUTE IMMEDIATE  'DELETE FROM '||V_ESQUEMA||'.PRC_CEX WHERE CEX_ID IN ( SELECT CEX_ID FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE WHERE BORRADO = 1 AND USUARIOBORRAR = ''HR-2296'' )';
  
  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );
  
COMMIT;

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
  
END;
/
EXIT
