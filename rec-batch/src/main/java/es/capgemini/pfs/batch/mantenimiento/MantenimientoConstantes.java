package es.capgemini.pfs.batch.mantenimiento;

/**
 * Interfaz de constantes para el proceso de mantenimiento
 * @author Javier Ruiz
 *
 */
public interface MantenimientoConstantes {

	/**
	 * Clase de constantes genéricas para el proceso mantenimiento
	 * @author Javier Ruiz
	 *
	 */
	public static class Genericas{
		
		public static final String DEVON_TYPE_BATCH_MANTENIMIENTO = "devon:type=BatchMantenimiento";
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
	 * Clase de constantes para el proceso de mantenimiento
	 * @author Javier Ruiz
	 *
	 */
	public static class ProcesoMantenimiento{
		
		public static final String DESCRIPCION_PROCESO_MANTENIMIENTO = "Ejecuta el proceso de mantenimiento.";
		public static final String PROCESO_MANTENIMIENTO_HANDLER = "procesoMantenimientoHandler";
		public static final String PROCESO_MANTENIMIENTO_JOBNAME = "procesoMantenimientoJob";
		public static final String INICIO_MSG = "Inicio del proceso de mantenimiento ";
		public static final String FIN_MSG = "El proceso de mantenimiento para la entidad ";

	}	
	
}