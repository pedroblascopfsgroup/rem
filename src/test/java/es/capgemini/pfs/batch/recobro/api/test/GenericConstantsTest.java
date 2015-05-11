package es.capgemini.pfs.batch.recobro.api.test;

/**
 * Clase de constantes gen�ricas para todos los tests
 * @author Guillem
 *
 */
public interface GenericConstantsTest {

	/**
	 * Clase de constantes gen�ricas para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class Genericas{
		
		public static final String EXCEPTION_GENERIC_TEST_LOAD_DATA_TEST = "Se ha producido una excepci�n en el m�todo LoadDataTest de la clase GenericTest: ";		
		public static final String EXCEPTION_GENERIC_TEST_VALIDATION_DATA_TEST = "Se ha producido una excepci�n en el m�todo ValidationDataTest de la clase GenericTest: ";
		public static final String EXCEPTION_GENERIC_TEST_POST_DATA_TEST = "Se ha producido una excepci�n en el m�todo PostDataTest de la clase GenericTest: ";
		public static final String EXCEPTION_GENERIC_TEST_INIT_TEST_LOG = "Se ha producido una excepci�n en el m�todo initTestLog de la clase GenericTest: ";
		public static final String EXCEPTION_GENERIC_TEST_FINALIZE_TEST_LOG = "Se ha producido una excepci�n en el m�todo finalizeTestLog de la clase GenericTest: ";
		public static final String EXCEPTION_GENERIC_TEST_GET_JOB = "Se ha producido una excepci�n en el m�todo getJob de la clase GenericTest: ";
		public static final String ASTERISC_LINE = "**********************************************";
		public static final String NO_CONFIG_LOAD_DATA = "El bean de configuraci�n del entorno del proceso es nulo. No se realiza ninguna acci�n de preparaci�n de entorno.";
		public static final String CONFIG_LOAD_DATA_OK = "El bean de configuraci�n del entorno del proceso existe. Realizando acciones de preparaci�n de entono.";
		public static final String NO_LOAD_DATA_SCRIPT_FOUND = "No se han encontrado scripts de carga de datos para la preparaci�n del entorno.";		
		public static final String LOADING_SCRIPT = "Cargando el script de carga de datos con ruta: ";
		public static final String NO_CONFIG_VALIDATION_DATA = "El bean de validaci�n del proceso es nulo. No se realiza ninguna acci�n de validaci�n del proceso.";
		public static final String CONFIG_VALIDATION_DATA_OK = "El bean de validaci�n del proceso existe. Realizando acciones de validaci�n del proceso.";		
		public static final String NO_CONFIG_POST_DATA = "El bean de limpieza del entorno del proceso es nulo. No se realiza ninguna acci�n de limpieza del entorno.";
		public static final String CONFIG_POST_DATA_OK = "El bean de limpieza del entorno del proceso existe. Realizando acciones de limpieza del entono.";
		public static final String NO_POST_DATA_SCRIPT_FOUND = "No se han encontrado scripts de borrado de datos para la limpieza del entorno.";			
		public static final String NO_VALIDATION_DATA_SCRIPT_FOUND = "No se han encontrado scripts de validaci�n de datos para la validaci�n del job.";
		public static final String WORKING_CODE_NULO_O_VACIO = "No se puede inicializar el job porque el Working Code es nulo o vac�o.";
		public static final String INICIO_PREPARACION_ENTORNO = "****  INICIO DE LA PREPARACI�N DEL ENTORNO ****";
		public static final String INICIO_VALIDACION_ENTORNO  = "****  INICIO DE LA VALIDACI�N DEL ENTORNO  ****";
		public static final String INICIO_LIMPIEZA_ENTORNO    = "****  INICIO DE LA LIMPIEZA DEL ENTORNO    ****";
		public static final String INCIO_TEST					= "****        INICIO DEL TEST DEL JOB        ****";
		public static final String FICHERO_CONTEXTO_SPRING = "classpath:ac-application-config.xml";
		public static final String TIPO_SQL_NULO_O_NO_VALIDO = "El tipo de SQL es nulo o no es un tipo v�lido.";
		public static final String ACCION_VALIDACION = "La acci�n de validaci�n con texto: ";
		public static final String RESULTADO_ESPERADO = " Resultado esperado: ";
		public static final String RESULTADO_OBTENIDO = " Resultado obtenido: ";
		public static final String ACCION_REALIZADA = "La acci�n ejecutada con texto: ";
		public static final String HA_FALLADO = " ha finalizado err�neamente debido a la siguiente excepcion: ";
		public static final String RECOBRO_TEST = "             TEST DE RECOBRO";
		public static final String INICIO_TEST = "Inicio del Test: ";
		public static final String FIN_TEST = "Fin del Test: ";
		public static final String CLAS_TEST = " de la Clase: ";
		public static final String DOT = ".";
		public static final String EMPTY = "";
		public static final String SQL = "sql";
		public static final String VALUE = "value";
		public static final String MSG = "msg";
		public static final String EXPECTED = "expected";
		public static final String TYPE = "type";
		public static final String UPDATE = "UPDATE";
		public static final String INSERT = "INSERT";
		public static final String EXECUTE = "EXECUTE";
		public static final String CREATE = "CREATE";
		public static final String DROP = "DROP";
		public static final String COUNT = "COUNT";
		public static final String FINALIZADO_MSG = " ha finalizado.";
		public static final String FALLO_MSG = " ha fallado";
		public static final String RANDOM = "random";
		public static final String CORCHETE_IZQ = "[";
		public static final String CORCHETE_DER = "]";
		public static final String ENTIDAD_9999 = "9999";
		public static final String ENTIDAD = "entidad";
		public static final String EXTRACT_TIME = "extractTime";
		public static final String SOURCE_CHANNEL_KEY = "sourceChannel";
		public static final String PCR_CHAIN_CHANNEL = "pcrChainChannel";
		
	}	
	
	/**
	 * Clase de constantes del proceso de Marcado de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoMarcadoExpedientes{		
		public static final String PROCESO_MARCADO_EXPEDIENTES_JOBNAME = "procesoMarcadoExpedientesJob";
	}	
	
	/**
	 * Clase de constantes del proceso de Limpieza de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoLimpiezaExpedientes{
		public static final String PROCESO_LIMPIEZA_EXPEDIENTES_JOBNAME = "procesoLimpiezaExpedientesJob";
	}	

	/**
	 * Clase de constantes del proceso de Revisi�n de Expedientes Activos para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoRevisionExpedientesActivos{
		public static final String PROCESO_REVISION_EXPEDIENTES_ACTIVOS_JOBNAME = "procesoRevisionExpedientesActivosJob";
	}
	
	/**
	 * Clase de constantes del proceso de Rearquetipaci�n de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoRearquetipacionExpedientes{
		public static final String PROCESO_REARQUETIPACION_EXPEDIENTES_JOBNAME = "procesoRearquetipacionExpedientesJob";
	}	
	
	/**
	 * Clase de constantes del proceso de Arquetipado para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoArquetipado{
		public static final String PROCESO_ARQUETIPADO_JOBNAME = "procesoArquetipadoJob";
	}
	
	/**
	 * Clase de constantes del proceso de Generaci�n de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoGeneracionExpedientes{
		public static final String PROCESO_GENERACION_EXPEDIENTES_JOBNAME = "procesoGeneracionExpedientesJob";
	}
	
	/**
	 * Clase de constantes del proceso de Reparto para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoReparto{
		public static final String PROCESO_REPARTO_JOBNAME = "procesoRepartoJob";
	}
	
	/**
	 * Clase de constantes del proceso de Persistencia Previa Env�o para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoPersistenciaPreviaEnvio{
		public static final String PROCESO_PERSISTENCIA_PREVIA_ENVIO_JOBNAME = "procesoPersistenciaPreviaEnvioJob";
	}
	
	/**
	 * Clase de constantes del proceso de Generacion de Ficheros para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoGeneracionFicheros{
		public static final String PROCESO_GENERACION_FICHEROS_JOBNAME = "procesoGeneracionFicherosJob";
	}
	
}
