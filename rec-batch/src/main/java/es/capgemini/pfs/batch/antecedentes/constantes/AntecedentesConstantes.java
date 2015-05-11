package es.capgemini.pfs.batch.antecedentes.constantes;

/**
 * Interfaz de constantes para el proceso de cálculo de Antecedentes
 * @author Guillem
 *
 */
public interface AntecedentesConstantes {

	/**
	 * Clase de constantes genéricas para el proceso de cálculo de Antecedentes
	 * @author Guillem
	 *
	 */
	public static class Genericas{
		
		public static final String DEVON_TYPE_BATCH_ANTECEDENTES = "devon:type=BatchAntecedentes";
		public static final String FINALIZADO_MSG = " ha finalizado";
		public static final String FALLO_MSG = " ha fallado";
		public static final String RANDOM = "random";
		public static final String CORCHETE_IZQ = "[";
		public static final String CORCHETE_DER = "]";
		public static final String ENTIDAD = "entidad";
		public static final String EXTRACT_TIME = "extractTime";
		public static final String SOURCE_CHANNEL_KEY = "sourceChannel";
		public static final String PCR_CHAIN_CHANNEL = "pcrChainChannel";
		
	}	
	
	/**
	 * Clase de constantes para el proceso de cálculo de Antecedentes
	 * @author Guillem
	 *
	 */
	public static class ProcesoAntecedentes{
		
		public static final String DESCRIPCION_PROCESO_ANTECEDENTES = "Ejecuta el proceso de cálculo de Antecedentes. Se debe indicar el workingCode";
		public static final String PROCESO_ANTECEDENTES_HANDLER = "procesoAntecedentesHandler";
		public static final String PROCESO_ANTECEDENTES_JOBNAME = "procesoAntecedentesJob";
		public static final String INICIO_MSG = "Inicio del proceso de cálculo de Antecedentes ";
		public static final String FIN_MSG = "El proceso de cálculo de Antecedentes para la entidad ";

	}	
	
}