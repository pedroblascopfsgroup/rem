select DISTINCT CDM.CASO_NOVA "CASO_NOVA", PEX.PRC_ID "PRC_ID", ASU.ASU_ID "ASU_ID", ADD_CARTERA.IAC_VALUE "CARTERA",
CAR.CEDENTE "cedente", concat(to_char(ASU.ASU_ID), to_char(sysdate, 'hhmmss')) "codigoBarras",
concat(to_char(CNT.CNT_ID), CONCAT('/', CNT.CNT_CONTRATO)) "contrato_caso",
(select sum(abs(prc.prc_saldo_recuperacion)) from prc_procedimientos prc2 where prc2.asu_id=asu.ASU_ID  and prc2.borrado = 0 and prc2.PRC_PRC_ID is null and prc2.dd_epr_id <> '9' group by prc.asu_id)  "cuantiapago",
rowconcat(concat('select per.per_nom50 from per_personas per inner join prc_per ppe on ppe.per_id=per.per_id where per.borrado=0 and ppe.prc_id=', prc.prc_id)) "demandado",
to_char(sysdate, 'dd/MM/yyyy') "fecha", 
car.FECHACESION "fecha_cesion_deuda", 
car.FECHACESION "fecha_compra_deuda", 
car.FECHANOTIFIC "fecha_notificacion_cesion",
JUZ.DD_JUZ_DESCRIPCION "juzgado",
obtenerListaDeudores(obtenerProc(asu.ASU_ID)) "listaDeudores",
CAR.NOTARIO "notario_compra_deuda",
CNT.CNT_CONTRATO "num_contrato",
PLA.DD_PLA_DESCRIPCION "plaza",
PRC.PRC_SALDO_RECUPERACION * 0.3 "presup_intereses",
CAR.PROTOCOLO "protocolo_notarial_compra",
obtenerTablaPersonasAfectadas(obtenerProc(asu.ASU_ID)) "tablaPersonasAfectadas",
USU.USU_NOMBRE || ' ' || USU.USU_APELLIDO1 || ' ' || USU.USU_APELLIDO2 "procurador"
from CDM_CARGA_DEMANDAS_MASIVAS CDM
LEFT JOIN CNT_CONTRATOS CNT ON CDM.CASO_NOVA=CNT.CNT_CONTRATO
LEFT JOIN CEX_CONTRATOS_EXPEDIENTE CEX ON CNT.CNT_ID=CEX.CNT_ID
LEFT JOIN PRC_CEX PEX ON PEX.CEX_ID=CEX.CEX_ID
LEFT JOIN PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PEX.PRC_ID
LEFT JOIN ASU_ASUNTOS ASU ON ASU.ASU_ID=PRC.ASU_ID
LEFT JOIN EXT_IAC_INFO_ADD_CONTRATO ADD_CARTERA ON (CNT.CNT_ID=ADD_CARTERA.CNT_ID AND ADD_CARTERA.DD_IFC_ID=35)
LEFT JOIN CAR_CARTERA CAR ON (CAR.CAR_DESCRIPCION=ADD_CARTERA.IAC_VALUE)
LEFT JOIN DD_JUZ_JUZGADOS_PLAZA JUZ ON (JUZ.DD_JUZ_ID=PRC.DD_JUZ_ID)
LEFT JOIN DD_PLA_PLAZAS PLA ON (PLA.DD_PLA_ID=JUZ.DD_PLA_ID)
LEFT JOIN USD_USUARIOS_DESPACHOS USD ON (USD.USD_ID=ASU.USD_ID)
LEFT JOIN LINMASTER.USU_USUARIOS USU ON (USU.USU_ID=USD.USU_ID)
WHERE CNT.BORRADO=0 AND CEX.BORRADO=0 AND PRC.BORRADO=0 
and prc.prc_id = obtenerProc(asu.ASU_ID);