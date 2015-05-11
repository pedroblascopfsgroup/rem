package es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl.dinamicFields;

import java.util.HashMap;
import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAdmisionDemandaColumns;

/**
 * Clase que relaciona los campos dinámicos con las columnas del excel, en caso de querer mantener los campos del input original
 * @author carlos
 *
 */
public class MSVAdmisionDemandaDinamicFields {
	public static final String ID_ASUNTO = "idAsunto";
	
	@SuppressWarnings("serial")
	private static final Map<String, String> fields = new HashMap<String, String>() {
	{
		put(MSVAdmisionDemandaColumns.NUM_NOVA,MSVAdmisionDemandaColumns.NUM_NOVA);
		put(ID_ASUNTO, ID_ASUNTO);
		put(MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO,MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO);
		put(MSVAdmisionDemandaColumns.FECHA_RESOLUCION,"d_fecResolucionDemanda");
		put(MSVAdmisionDemandaColumns.FECHA_NOTIFICACION,"d_fecRecepResolDemanda");
		put(MSVAdmisionDemandaColumns.TIPO_ADMISION,"d_demandaTotal");
		put(MSVAdmisionDemandaColumns.PLAZO_IMPUGNACION,"d_plazoImpugnacion");
		put(MSVAdmisionDemandaColumns.PRINCIPAL,"d_cuantiaDemandada");
		put(MSVAdmisionDemandaColumns.NUM_AUTOS,"d_numAutos");
		put(MSVAdmisionDemandaColumns.PARTIDO_JUDICIAL,"d_plaza");
		put(MSVAdmisionDemandaColumns.JUZGADO,"d_juzgado");
		put(MSVAdmisionDemandaColumns.OBSERVACIONES,"d_observaciones");
		put(MSVProcesoManager.COLUMNA_NUMERO_FILA,MSVProcesoManager.COLUMNA_NUMERO_FILA);
		
		//Especificas para Autodespachando Ejecución
		put(MSVAdmisionDemandaColumns.FECHA_RESOLUCION+"_AUDE","d_fecResolucionAude");
		put(MSVAdmisionDemandaColumns.FECHA_NOTIFICACION+"_AUDE","d_fecRecepResolAude");
		put(MSVAdmisionDemandaColumns.TIPO_ADMISION+"_AUDE","d_tipoAude");
	}};

	public static Map<String, String> getFields() {
		return fields;
	}
}
