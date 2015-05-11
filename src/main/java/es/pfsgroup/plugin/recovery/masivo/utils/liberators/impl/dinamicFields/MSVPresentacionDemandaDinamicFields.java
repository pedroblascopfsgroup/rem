package es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl.dinamicFields;

import java.util.HashMap;
import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVPresentacionDemandaColumns;

/**
 * Clase que relaciona los campos dinámicos con las columnas del excel, en caso de querer mantener los campos del input original
 * @author carlos
 *
 */
public class MSVPresentacionDemandaDinamicFields {
	public static final String ID_ASUNTO = "idAsunto";
	public static final String NUM_AUTO = "d_numAutos";
	
	@SuppressWarnings("serial")
	private static final Map<String, String> fields = new HashMap<String, String>() {
	{
		put(ID_ASUNTO, ID_ASUNTO);
		put(NUM_AUTO, NUM_AUTO);
		put(MSVPresentacionDemandaColumns.OBSERVACIONES,"d_observaciones");
		put(MSVPresentacionDemandaColumns.FECHA_PRESENTACION,"d_fecPresentacionDemanda");
		put(MSVPresentacionDemandaColumns.FECHA_NOTIFICACION,"d_fecRecepPresentacionDemanda");
		put(MSVProcesoManager.COLUMNA_NUMERO_FILA,MSVProcesoManager.COLUMNA_NUMERO_FILA);
		put(MSVPresentacionDemandaColumns.NUM_NOVA,MSVPresentacionDemandaColumns.NUM_NOVA);
		put(MSVPresentacionDemandaColumns.TIPO_PROCEDIMIENTO,MSVPresentacionDemandaColumns.TIPO_PROCEDIMIENTO);
		put(MSVPresentacionDemandaColumns.PRINCIPAL,MSVPresentacionDemandaColumns.PRINCIPAL);
		put(MSVPresentacionDemandaColumns.PARTIDO_JUDICIAL,MSVPresentacionDemandaColumns.PARTIDO_JUDICIAL);
	}};

	public static Map<String, String> getFields() {
		return fields;
	}
}
