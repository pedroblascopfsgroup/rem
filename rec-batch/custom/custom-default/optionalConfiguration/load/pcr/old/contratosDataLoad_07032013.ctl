LOAD DATA
TRUNCATE INTO TABLE TMP_CNT_CONTRATOS
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(TMP_CNT_ID SEQUENCE,
TMP_CNT_FECHA_EXTRACCION DATE "DDMMYYYY", 
TMP_CNT_COD_ENTIDAD,
TMP_CNT_COD_OFICINA,
TMP_CNT_COD_CENTRO,
TMP_CNT_CONTRATO, 
TMP_CNT_MONEDA,
TMP_CNT_POS_VIVA_NO_VENCIDA "to_number(:TMP_CNT_POS_VIVA_NO_VENCIDA,'99999999999999.99')",
TMP_CNT_POS_VIVA_VENCIDA "to_number(:TMP_CNT_POS_VIVA_VENCIDA,'99999999999999.99')", 
TMP_CNT_FECHA_POS_VENCIDA DATE "DDMMYYYY",
TMP_CNT_SALDO_DUDOSO "to_number(:TMP_CNT_SALDO_DUDOSO,'99999999999999.99')",
TMP_CNT_FECHA_DUDOSO DATE "DDMMYYYY",
TMP_CNT_ESTADO_FINANCIERO,
TMP_CNT_ESTADO_FINANCIERO_ANT,
TMP_CNT_FECHA_ESTADO_FINANC DATE "DDMMYYYY",
TMP_CNT_FECHA_ESTADO_FINAN_ANT DATE "DDMMYYYY",
TMP_CNT_PROVISION "to_number(:TMP_CNT_PROVISION,'99999999999999.99')",
TMP_ESTADO_CONTRATO,
TMP_FECHA_ESTADO_CONTRATO DATE "DDMMYYYY",
TMP_CNT_TIPO_PRODUCTO "trim(:TMP_CNT_TIPO_PRODUCTO)",
TMP_CNT_INT_REMUNERATORIOS "to_number(:TMP_CNT_INT_REMUNERATORIOS,'99999999999999.99')",		
TMP_CNT_INT_MORATORIOS "to_number(:TMP_CNT_INT_MORATORIOS,'99999999999999.99')",
TMP_CNT_COMISIONES "to_number(:TMP_CNT_COMISIONES,'99999999999999.99')",
TMP_CNT_GASTOS "to_number(:TMP_CNT_GASTOS,'99999999999999.99')",
TMP_CNT_FECHA_CREA_CNT DATE "DDMMYYYY",
TMP_CNT_RIESGO "to_number(:TMP_CNT_RIESGO,'99999999999999.99')",
TMP_CNT_DEUDA_IRREGULAR "to_number(:TMP_CNT_DEUDA_IRREGULAR,'99999999999999.99')",
TMP_CNT_DISPUESTO "to_number(:TMP_CNT_DISPUESTO,'99999999999999.99')",
TMP_CNT_SALDO_PASIVO "to_number(:TMP_CNT_SALDO_PASIVO,'99999999999999.99')",
TMP_CNT_LIMITE_INI "to_number(:TMP_CNT_LIMITE_INI,'99999999999999.99')",
TMP_CNT_LIMITE_FIN "to_number(:TMP_CNT_LIMITE_FIN,'99999999999999.99')",
TMP_CNT_RIESGO_GARANT "to_number(:TMP_CNT_RIESGO_GARANT,'99999999999999.99')",
TMP_CNT_SALDO_EXCE "to_number(:TMP_CNT_SALDO_EXCE,'99999999999999.99')",
TMP_CNT_LTV_INI,
TMP_CNT_LTV_FIN,
TMP_CNT_LIMITE_DESC "to_number(:TMP_CNT_LIMITE_DESC,'99999999999999.99')",
TMP_CNT_NUM_EXTRA1 "to_number(:TMP_CNT_NUM_EXTRA1,'99999999999999.99')",
TMP_CNT_NUM_EXTRA2 "to_number(:TMP_CNT_NUM_EXTRA2,'99999999999999.99')",
TMP_CNT_NUM_EXTRA3 "to_number(:TMP_CNT_NUM_EXTRA3,'99999999999999.99')",
TMP_CNT_NUM_EXTRA4 "to_number(:TMP_CNT_NUM_EXTRA4,'99999999999999.99')",
TMP_CNT_NUM_EXTRA5 "to_number(:TMP_CNT_NUM_EXTRA5,'99999999999999.99')",
TMP_CNT_NUM_EXTRA6 "to_number(:TMP_CNT_NUM_EXTRA6,'99999999999999.99')",
TMP_CNT_NUM_EXTRA7 "to_number(:TMP_CNT_NUM_EXTRA7,'99999999999999.99')",
TMP_CNT_NUM_EXTRA8 "to_number(:TMP_CNT_NUM_EXTRA8,'99999999999999.99')",
TMP_CNT_NUM_EXTRA9 "to_number(:TMP_CNT_NUM_EXTRA9,'99999999999999.99')",
TMP_CNT_NUM_EXTRA10 "to_number(:TMP_CNT_NUM_EXTRA10,'99999999999999.99')",
TMP_CNT_FINALIDAD_OFI,
TMP_CNT_FINALIDAD_CON,
TMP_CNT_GARANTIA_1,
TMP_CNT_GARANTIA_2,
TMP_CNT_CATALOGO_1,
TMP_CNT_CATALOGO_2,
TMP_CNT_CATALOGO_3,
TMP_CNT_CATALOGO_4,
TMP_CNT_CATALOGO_5,
TMP_CNT_CATALOGO_6,
TMP_CNT_FECHA_CONSTITUCION	DATE "DDMMYYYY",
TMP_CNT_FECHA_VENC	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA1	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA2	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA3	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA4	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA5	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA6	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA7	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA8	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA9	DATE "DDMMYYYY",
TMP_CNT_DATE_EXTRA10	DATE "DDMMYYYY",
TMP_CNT_FLAG_EXTRA1,
TMP_CNT_FLAG_EXTRA2,
TMP_CNT_FLAG_EXTRA3,
TMP_CNT_FLAG_EXTRA4,
TMP_CNT_FLAG_EXTRA5,
TMP_CNT_FLAG_EXTRA6,
TMP_CNT_FLAG_EXTRA7,
TMP_CNT_FLAG_EXTRA8,
TMP_CNT_FLAG_EXTRA9,
TMP_CNT_FLAG_EXTRA10,
TMP_CNT_COD_CENTRO_OP,
TMP_CNT_COD_OFI_OP,
TMP_CNT_COD_ENTIDAD_CONTEN,
TMP_CNT_COD_OFICINA_CONTEN,
TMP_CNT_NUM_CONTRATO_CONTEN,
TMP_CNT_CHAR_EXTRA1,
TMP_CNT_CHAR_EXTRA2,
TMP_CNT_CHAR_EXTRA3,
TMP_CNT_CHAR_EXTRA4,
TMP_CNT_CHAR_EXTRA5,
TMP_CNT_CHAR_EXTRA6,
TMP_CNT_CHAR_EXTRA7,
TMP_CNT_CHAR_EXTRA8     "trim(:TMP_CNT_CHAR_EXTRA8)",
TMP_CNT_CHAR_EXTRA9,
TMP_CNT_CHAR_EXTRA10,
TMP_CNT_LCHAR_EXTRA1,
TMP_CNT_LCHAR_EXTRA2,
TMP_CNT_LCHAR_EXTRA3,
TMP_CNT_LCHAR_EXTRA4,
TMP_CNT_LCHAR_EXTRA5,
TMP_CNT_LCHAR_EXTRA6,
TMP_CNT_LCHAR_EXTRA7,
TMP_CNT_LCHAR_EXTRA8,
TMP_CNT_LCHAR_EXTRA9,
TMP_CNT_LCHAR_EXTRA10,
TMP_CNT_NUM_EXTRA11 "to_number(:TMP_CNT_NUM_EXTRA11,'99999999999999.99')",
TMP_CNT_NUM_EXTRA12 "to_number(:TMP_CNT_NUM_EXTRA12,'99999999999999.99')",
TMP_CNT_NUM_EXTRA13 "to_number(:TMP_CNT_NUM_EXTRA13,'99999999999999.99')",
TMP_CNT_NUM_EXTRA14 "to_number(:TMP_CNT_NUM_EXTRA14,'99999999999999.99')",
TMP_CNT_NUM_EXTRA15 "to_number(:TMP_CNT_NUM_EXTRA15,'99999999999999.99')",
TMP_CNT_FECHA_CARGA SYSDATE,
TMP_CNT_FICHERO_CARGA "to_char('XXXXXXXX')",
FECHACREAR    "cast(sysdate as timestamp)",
USUARIOCREAR	"to_char('BATCH_USER')",
VERSION "0",
BORRADO  "0"
)
