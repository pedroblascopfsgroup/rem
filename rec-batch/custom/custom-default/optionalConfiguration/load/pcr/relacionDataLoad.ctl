LOAD DATA
TRUNCATE INTO TABLE TMP_CNT_PER
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(TMP_CNT_PER_ID                    SEQUENCE,
TMP_CNT_PER_FECHA_EXTRACCION      DATE "DDMMYYYY",
TMP_CNT_PER_COD_ENTIDAD,
TMP_CNT_PER_COD_OFICINA,
TMP_CNT_PER_CONTRATO,
TMP_CNT_PER_COD_CLIENTE,
TMP_CNT_PER_TIPO_INTERVENCION     "trim(:TMP_CNT_PER_TIPO_INTERVENCION)",
TMP_CNT_PER_ORDEN,
TMP_CNT_PER_NUM_EXTRA1            "to_number(:TMP_CNT_PER_NUM_EXTRA1,'999999999999.99')",
TMP_CNT_PER_NUM_EXTRA2            "to_number(:TMP_CNT_PER_NUM_EXTRA2,'999999999999.99')",
TMP_CNT_PER_DATE_EXTRA1           DATE "DDMMYYYY" nullif (TMP_CNT_PER_DATE_EXTRA1=BLANKS),
TMP_CNT_PER_DATE_EXTRA2           DATE "DDMMYYYY" nullif (TMP_CNT_PER_DATE_EXTRA2=BLANKS),
TMP_CNT_PER_FLAG_EXTRA1           "trim(:TMP_CNT_PER_FLAG_EXTRA1)",
TMP_CNT_PER_FLAG_EXTRA2           "trim(:TMP_CNT_PER_FLAG_EXTRA2)",
TMP_CNT_PER_CHAR_EXTRA1           "trim(:TMP_CNT_PER_CHAR_EXTRA1)",
TMP_CNT_PER_CHAR_EXTRA2           "trim(:TMP_CNT_PER_CHAR_EXTRA2)",
TMP_CNT_PER_LCHAR_EXTRA1          "trim(:TMP_CNT_PER_LCHAR_EXTRA1)",
TMP_CNT_PER_LCHAR_EXTRA2          "trim(:TMP_CNT_PER_LCHAR_EXTRA2)",
TMP_CNT_PER_FECHA_CARGA           SYSDATE,
TMP_CNT_PER_FICHERO_CARGA         "to_char('XXXXXXXX')",
USUARIOCREAR                      "to_char('BATCH_USER')",
FECHACREAR                        "cast(sysdate as timestamp)",
VERSION "0",
BORRADO  "0")


