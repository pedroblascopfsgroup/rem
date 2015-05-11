package es.pfsgroup.plugin.recovery.masivo.utils;

import java.util.ArrayList;
import java.util.List;

public class MSVTiposInputImpulsables {

	public static List<String> listaInputsImpulsables = new ArrayList<String>();
	static {
		listaInputsImpulsables.add("REQ_PREV_ADM"); // Requerimientos previos,
		listaInputsImpulsables.add("DEM_ADM_TOTAL"); // Admisi�n total de la demanda,
		listaInputsImpulsables.add("DEM_ADM_PARCIAL"); // Admisi�n parcial de la demanda,
		listaInputsImpulsables.add("DEM_ADM_PARCIAL_BATCH"); // Admisi�n parcial de la demanda,
		listaInputsImpulsables.add("DEM_ADM_TOTAL_BATCH"); // Admisi�n total de la demanda,
		listaInputsImpulsables.add("REQ_PAG_POS_LEG"); // Requerimiento pago positivo total,
		listaInputsImpulsables.add("AVERIG_POS_LEG"); // Contestaci�n Oficios de Localizaci�n (Averiguaci�n Positiva),
		listaInputsImpulsables.add("REQ_PAG_POS_CON_PROC_LEG"); // Requerimiento pago positivo con procurador total,
		listaInputsImpulsables.add("REQ_PAG_POS_SIN_PROC_LEG"); // Requerimiento pago positivo sin procurador total,
		listaInputsImpulsables.add("AVERIG_POS_CON_PROC_LEG"); // Contestaci�n Oficios de Localizaci�n (Averiguaci�n Positiva con procurador),
		listaInputsImpulsables.add("REQ_PAG_POS_PARCIAL_CPROC"); // Requerimiento pago positivo parcial (con procurador),
		listaInputsImpulsables.add("REQ_PAG_POS_PARCIAL_SPROC"); // Requerimiento pago positivo parcial (sin procurador),
		listaInputsImpulsables.add("REQ_PAG_POS_TOTAL_CPROC"); // Requerimiento pago positivo total (con proc),
		listaInputsImpulsables.add("REQ_PAG_POS_TOTAL_SPROC"); // Requerimiento pago positivo total (sin proc),
		//listaInputsImpulsables.add("SOL_TAS_COST_POS_TOTAL"); // Resultado tasaci�n cosatas positivo total,
		//listaInputsImpulsables.add("SOL_TAS_COST_POS_PARCIAL"); // Resultado tasaci�n cosatas positivo parcial,
		listaInputsImpulsables.add("REQ_RET_PAGAD_CONF_POS"); // Confirmaci�n pagador positivo,
		listaInputsImpulsables.add("SOL_OFI_LOCALIZA_POS_CPROC"); // Respuesta positiva y sin requerimientos de pago previos en ese domicilio (con procurador),
		listaInputsImpulsables.add("SOL_OFI_LOCALIZA_POS_SPROC"); // Respuesta positiva y sin requerimientos de pago previos en ese domicilio (sin procurador),
		//listaInputsImpulsables.add("LIQ_INT_POS_PARC"); // Liquidaci�n de intereses positivo parcial,
		//listaInputsImpulsables.add("LIQ_INT_POS_TOT"); // Liquidaci�n de intereses positivo total,
		listaInputsImpulsables.add("REQ_PAG_NEG_LEG"); // Requerimiento pago negativo,
		//listaInputsImpulsables.add("AVERIG_NEG_LEG"); // Contestaci�n Oficios de Localizaci�n (Averiguaci�n Negativa),
		listaInputsImpulsables.add("REQ_PAG_NEG_CON_PROC_LEG"); // Requerimiento pago negativo con procurador,
		listaInputsImpulsables.add("REQ_PAG_NEG_SIN_PROC_LEG"); // Requerimiento pago negativo sin procurador,
		listaInputsImpulsables.add("REQ_PAG_NEG_PARCIAL_CPROC"); // Requerimiento pago negativo parcial (con procurador),
		listaInputsImpulsables.add("REQ_PAG_NEG_PARCIAL_SPROC"); // Requerimiento pago negativo parcial (sin procurador),
		listaInputsImpulsables.add("REQ_PAG_NEG_TOTAL_CPROC"); // Requerimiento pago negativo total (con procurador),
		listaInputsImpulsables.add("REQ_PAG_NEG_TOTAL_SPROC"); // Requerimiento pago negativo total (sin procurador),
		//listaInputsImpulsables.add("SOL_TAS_COST_NEG_CPROC"); // Resultado tasaci�n cosatas negativo,
		//listaInputsImpulsables.add("SOL_TAS_COST_NEG_SPROC"); // Resultado tasaci�n cosatas negativo,
		listaInputsImpulsables.add("REQ_RET_PAGAD_CONF_NEG"); // Confirmaci�n pagador negativo,
		listaInputsImpulsables.add("SOL_OFI_LOCALIZA_NEG_PARCIAL_CPROC"); // Respuesta negativa y quedan otros domicilios por intentar notificar (con procurador),
		listaInputsImpulsables.add("SOL_OFI_LOCALIZA_NEG_PARCIAL_SPROC"); // Respuesta negativa y quedan otros domicilios por intentar notificar(sin procurador),
		//listaInputsImpulsables.add("SOL_OFI_LOCALIZA_NEG_TOTAL_CPROC"); // Respuesta negativa y NO Quedan otros domicilios por intentar notificar(con procurador),
		//listaInputsImpulsables.add("SOL_OFI_LOCALIZA_NEG_TOTAL_SPROC"); // Respuesta negativa y NO Quedan otros domicilios por intentar notificar(sin procurador),
		listaInputsImpulsables.add("LIQ_INT_NEG"); // Liquidac�n de intereses negativo,
		listaInputsImpulsables.add("DEM_PRESENTA"); // Demanda presentada,
		listaInputsImpulsables.add("DEM_PRESENTA_BATCH"); // Demanda presentada,
		listaInputsImpulsables.add("AUDE_TOTAL"); // Auto despachando ejecucion total,
		listaInputsImpulsables.add("AUDE_PARCIAL"); // Auto despachando ejecucion parcial,
		listaInputsImpulsables.add("AUDE_PARCIAL_BATCH"); // Auto despachando ejecucion parcial,
		listaInputsImpulsables.add("AUDE_TOTAL_BATCH"); // Auto despachando ejecucion total,
		listaInputsImpulsables.add("SOLICITUD_EMB"); // Solicitud embargo,
		listaInputsImpulsables.add("SOL_OFI_AVERIG_PATRIM_POS"); // Averiguaci�n patrimonial positiva,
		listaInputsImpulsables.add("SOL_OFI_AVERIG_PATRIM_POS_EMB_BIE"); // Averiguacion positiva-embargo bienes,
		listaInputsImpulsables.add("SOL_OFI_AVERIG_PATRIM_POS_EMB_SALAR"); // Averiguacion positiva-embargo salario,
		listaInputsImpulsables.add("SOL_OFI_AVERIG_PATRIM_POS_EMB_BIE_SALAR"); // Averiguacion positiva-embargo salario y bienes,
		listaInputsImpulsables.add("SOL_OFI_AVERIG_PATRIM_NEG"); // Averiguaci�n patrimonial negativa,
		listaInputsImpulsables.add("AVERIG_NEG_CON_PROC_LEG"); // Contestaci�n Oficios de Localizaci�n (Averiguaci�n Negativa con procurador),
		listaInputsImpulsables.add("AVERIG_NEG_SIN_PROC_LEG"); // Contestaci�n Oficios de Localizaci�n (Averiguaci�n Negativa sin procurador),
	}
	
}
