package es.pfsgroup.plugin.recobro.bpm.constants;

/**
 * Interfaz de constantes para el BPM de Recobro
 * @author Guillem
 *
 */
public interface RecobroConstantsBPM {

	/**
	 * Clase de constantes genéricas para el BPM de Recobro
	 * @author Guillem
	 *
	 */
	public static class Genericas{
		
		public final static String IDEXPEDIENTE_VARIABLE_NAME_INSTANCE = "idExpediente";
		public final static String AVANZABPM = "avanzaBPM";
		public final static String DECISION = "Decision";
		public final static String FIN = "Fin";
		public final static String ID = "id";
		public final static String CONTRATO = "contrato";
		public final static String CODIGO = "codigo";
		public final static String REC_META_VOL_KO = "REC_META_VOL_KO";
		public final static String REC_META_VOL_OK = "REC_META_VOL_OK";
		public final static String REC_MARCADO_EXP = "REC_MARCADO_EXP";
		public final static String META_VOLANTE_INCUMPLIDA = "Meta volante incumplida: ";
		public final static String META_VOLANTE_CUMPLIDA = "Meta volante cumplida: ";
		public final static String MARCADO_EXPEDIENTE = "Expediente marcado: ";		
		
	}	
	
	/**
	 * Clase de constantes para el manager BPM de Recobro
	 * @author Guillem
	 *
	 */
	public static class ManagerBPM{
		
		public final static String BO_RECOBRO_MANAGER_BPM_COMPROBAR_META_VOLANTE = "recobro.manager.bpm.comprobarMetaVolante";
		public final static String BO_RECOBRO_MANAGER_BPM_MARCAR_EXPEDIENTE_REARQUETIPACION = "recobro.manager.bpm.marcarExpedienteRearquetipacion";
		
	}	
	
}
