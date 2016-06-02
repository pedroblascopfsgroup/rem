package es.pfsgroup.recovery.batch.recuperaciones.constantes;

public interface RecuperacionesConstantes {
	
	public static class Genericas{
		
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
	
	public static class ProcesoArquetipadoRecuperaciones {
		public static final String DESCRIPCION_PROCESO_ARQUETIPADO_RECUPERACIONES = "Ejecuta el proceso de Arquetipado correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_ARQUETIPADO_RECUPERACIONES_HANDLER = "procesoArquetipadoRecuperacionesHandler";
		public static final String PROCESO_ARQUETIPADO_RECUPERACIONES_JOBNAME = "procesoArquetipadoRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Arquetipado de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de Arquetipado de Recuperaci贸n para la entidad ";

	}
	
	public static class ProcesoCreacionClientesRecuperaciones {
		public static final String DESCRIPCION_PROCESO_CREACION_CLIENTES_RECUPERACIONES = "Ejecuta el proceso de creaci贸n clientes correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_CREACION_CLIENTES_RECUPERACIONES_HANDLER = "procesoCreacionClientesRecuperacionesHandler";
		public static final String PROCESO_CREACION_CLIENTES_RECUPERACIONES_JOBNAME = "procesoCreacionClientesRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Creaci贸n clientes de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de Creaci贸n clientes de Recuperaci贸n para la entidad ";
	}
	
	public static class ProcesoCreacionExpedientesRecuperaciones {
		public static final String DESCRIPCION_PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES = "Ejecuta el proceso de creaci贸n expedientes correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_HANDLER = "procesoCreacionExpedientesRecuperacionesHandler";
		public static final String PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_JOBNAME = "procesoCreacionExpedientesRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Creaci贸n expedientes de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de Creaci贸n expedientes de Recuperaci贸n para la entidad ";
	}
	
	public static class ProcesoCreacionExpedientesRecuperacionesETL {
		public static final String DESCRIPCION_PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL = "Ejecuta el proceso de creaci贸n expedientes correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL_HANDLER = "procesoCreacionExpedientesRecuperacionesETLHandler";
		public static final String PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL_JOBNAME = "procesoCreacionExpedientesRecuperacionesETLJob";
		public static final String INICIO_MSG = "Inicio del proceso de Creaci髇 expedientes de Recuperaci髇 ";
		public static final String FIN_MSG = "El proceso de Creaci髇 expedientes de Recuperaci髇 para la entidad ";
	}

	public static class ProcesoRevisionClientesRecuperaciones {
		public static final String DESCRIPCION_PROCESO_REVISION_CLIENTES_RECUPERACIONES = "Ejecuta el proceso de revisi贸n de clientes correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_REVISION_CLIENTES_RECUPERACIONES_HANDLER = "procesoRevisionClientesRecuperacionesHandler";
		public static final String PROCESO_REVISION_CLIENTES_RECUPERACIONES_JOBNAME = "procesoRevisionClientesRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de revisi贸n de clientes de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de revisi贸n de clientes de Recuperaci贸n para la entidad ";
	}
	
	public static class ProcesoRevisionExpedientesRecuperaciones {
		public static final String DESCRIPCION_PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES = "Ejecuta el proceso de revisi贸n de expedientes correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES_HANDLER = "procesoRevisionExpedientesRecuperacionesHandler";
		public static final String PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES_JOBNAME = "procesoRevisionExpedientesRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de revisi贸n de expedientes de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de revisi贸n de expedientes de Recuperaci贸n para la entidad ";
	}
	
	public static class ProcesoHistorizarArquetipadoRecuperaciones {
		public static final String DESCRIPCION_PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES = "Ejecuta el proceso de historizaci贸n del Arquetipado correspondiente a los expedientes de Recuperaci贸n. Se debe indicar el workingCode";
		public static final String PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES_HANDLER = "procesoHistorizarArquetipadoRecuperacionesHandler";
		public static final String PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES_JOBNAME = "procesoHistorizarArquetipadoRecuperacionesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Historizaci贸n del Arquetipado de Recuperaci贸n ";
		public static final String FIN_MSG = "El proceso de historizaci贸n del Arquetipado de Recuperaci贸n para la entidad ";

	}
	
}