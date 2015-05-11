package es.capgemini.pfs.batch.recobro.constantes;

/**
 * Interfaz de constantes para el m�dulo de Recobro de Agencias
 * @author Guillem
 *
 */
public interface RecobroConstantes {

	/**
	 * Clase de constantes gen�ricas para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class Genericas{
		
		public static final String DEVON_TYPE_BATCH_RECOBRO = "devon:type=BatchRecobro";
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
	 * Clase de constantes del proceso de Marcado de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoMarcadoExpedientes{
		
		public static final String DESCRIPCION_PROCESO_MARCADO_EXPEDIENTES = "Ejecuta el proceso de Marcado de Expedientes correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_MARCADO_EXPEDIENTES_RECOBRO_HANDLER = "procesoMarcadoExpedientesRecobroHandler";
		public static final String PROCESO_MARCADO_EXPEDIENTES_JOBNAME = "procesoMarcadoExpedientesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Marcado de Expedientes de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Marcado de Expedientes de Agencias de Recobro para la entidad ";

	}	
	
	/**
	 * Clase de constantes del proceso de Limpieza de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoLimpiezaExpedientes{
		
		public static final String DESCRIPCION_PROCESO_LIMPIEZA_EXPEDIENTES = "Ejecuta el proceso de Limpieza de Expedientes correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_LIMPIEZA_EXPEDIENTES_RECOBRO_HANDLER = "procesoLimpiezaExpedientesRecobroHandler";
		public static final String PROCESO_LIMPIEZA_EXPEDIENTES_JOBNAME = "procesoLimpiezaExpedientesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Limpieza de Expedientes de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Limpieza de Expedientes de Agencias de Recobro para la entidad ";
			
	}	

	/**
	 * Clase de constantes del proceso de Revisi�n de Expedientes Activos para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoRevisionExpedientesActivos{
		
		public static final String DESCRIPCION_PROCESO_REVISION_EXPEDIENTES_ACTIVOS = "Ejecuta el proceso de Revisi�n de Expedientes Activos correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_REVISION_EXPEDIENTES_ACTIVOS_RECOBRO_HANDLER = "procesoRevisionExpedientesActivosRecobroHandler";
		public static final String PROCESO_REVISION_EXPEDIENTES_ACTIVOS_JOBNAME = "procesoRevisionExpedientesActivosJob";
		public static final String INICIO_MSG = "Inicio del proceso de Revisi�n de Expedientes Activos de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Revisi�n de Expedientes Activos de Agencias de Recobro para la entidad ";
			
	}
	
	/**
	 * Clase de constantes del proceso de Rearquetipaci�n de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoRearquetipacionExpedientes{
		
		public static final String DESCRIPCION_PROCESO_REARQUETIPACION_EXPEDIENTES = "Ejecuta el proceso de Rearquetipaci�n de Expedientes correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_REARQUETIPACION_EXPEDIENTES_RECOBRO_HANDLER = "procesoRearquetipacionExpedientesRecobroHandler";
		public static final String PROCESO_REARQUETIPACION_EXPEDIENTES_JOBNAME = "procesoRearquetipacionExpedientesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Rearquetipaci�n de Expedientes de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Rearquetipaci�n de Expedientes de Agencias de Recobro para la entidad ";
			
	}	
	
	/**
	 * Clase de constantes del proceso de Arquetipado para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoArquetipado{
		
		public static final String DESCRIPCION_PROCESO_ARQUETIPADO = "Ejecuta el proceso de Arquetipado correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_ARQUETIPADO_RECOBRO_HANDLER = "procesoArquetipadoRecobroHandler";
		public static final String PROCESO_ARQUETIPADO_JOBNAME = "procesoArquetipadoJob";
		public static final String INICIO_MSG = "Inicio del proceso de Arquetipado de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Arquetipado de Agencias de Recobro para la entidad ";

	}
	
	/**
	 * Clase de constantes del proceso de Arquetipado para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoArquetipadoSimulacion{
		
		public static final String DESCRIPCION_PROCESO_ARQUETIPADO_SIMULACION = "Ejecuta el proceso de Arquetipado correspondiente a la simulaci�n de las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_ARQUETIPADO_SIMULACION_RECOBRO_HANDLER = "procesoArquetipadoSimulacionRecobroHandler";
		public static final String PROCESO_ARQUETIPADO_SIMULACION_JOBNAME = "procesoArquetipadoSimulacionJob";
		public static final String INICIO_MSG = "Inicio del proceso de Arquetipado de la simulacion de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Arquetipado de la simulacion de las Agencias de Recobro para la entidad ";

	}
	
	/**
	 * Clase de constantes del proceso de Generaci�n de Expedientes para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoGeneracionExpedientes{
		
		public static final String DESCRIPCION_PROCESO_GENERACION_EXPEDIENTES = "Ejecuta el proceso de Generaci�n de Expedientes correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_GENERACION_EXPEDIENTES_RECOBRO_HANDLER = "procesoGeneracionExpedientesRecobroHandler";
		public static final String PROCESO_GENERACION_EXPEDIENTES_JOBNAME = "procesoGeneracionExpedientesJob";
		public static final String INICIO_MSG = "Inicio del proceso de Generaci�n de Expedientes de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Generaci�n de Expedientes de Agencias de Recobro para la entidad ";
			
	}
	
	/**
	 * Clase de constantes del proceso de Reparto para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoReparto{
		
		public static final String DESCRIPCION_PROCESO_REPARTO = "Ejecuta el proceso de Reparto correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_REPARTO_RECOBRO_HANDLER = "procesoRepartoRecobroHandler";
		public static final String PROCESO_REPARTO_JOBNAME = "procesoRepartoJob";
		public static final String INICIO_MSG = "Inicio del proceso de Reparto de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Reparto de Agencias de Recobro para la entidad ";

	}
	
	/**
	 * Clase de constantes del proceso de Persistencia Previa Env�o para el m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class ProcesoPersistenciaPreviaEnvio{
		
		public static final String DESCRIPCION_PROCESO_PERSISTENCIA_PREVIA_ENVIO = "Ejecuta el proceso de Persistencia Previa Env�o correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_PERSISTENCIA_PREVIA_ENVIO_RECOBRO_HANDLER = "procesoPersistenciaPreviaEnvioRecobroHandler";
		public static final String PROCESO_PERSISTENCIA_PREVIA_ENVIO_JOBNAME = "procesoPersistenciaPreviaEnvioJob";
		public static final String INICIO_MSG = "Inicio del proceso de Persistencia Previa Env�o de Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Persistencia Previa Env�o de Agencias de Recobro para la entidad ";

	}
	
	/**
	 * Clase de constantes del proceso de Facturacion para el m�dulo batch de Recobro de Agencias
	 * @author Javier
	 *
	 */
	public static class ProcesoFacturacion{
		
		public static final String DESCRIPCION_PROCESO_FACTURACION = "Ejecuta el proceso de Facturaci�n correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_FACTURACION_RECOBRO_HANDLER = "procesoFacturacionRecobroHandler";
		public static final String PROCESO_FACTURACION_JOBNAME = "procesoFacturacionJob";
		public static final String INICIO_MSG = "Inicio del proceso de Facturacion a Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Facturacion a Agencias de Recobro para la entidad ";
	}
	
	/**
	 * Clase de constantes del proceso INDEPENDIENTE de PreProcesado de los Cobros de Recobro para la posterior facturaci�n a Agencias
	 * @author Javier
	 *
	 */
	public static class PreProcesadoIndependienteCobros{
		
		public static final String DESCRIPCION_PREPROCESADO_INDEPENDIENTE_COBROS = "Ejecuta INDEPENDIENTEMENTE el preproceso de los cobros, para su posterior facturaci�n a las agencias. Se debe indicar el workingCode";
		public static final String PROCESO_PREPROCESADO_INDEPENDIENTE_COBROS_RECOBRO_HANDLER = "procesoIndependientePreProcesadoCobrosRecobroHandler";
		public static final String PROCESO_PREPROCESADO_INDEPENDIENTE_COBROS_RECOBRO_JOBNAME = "procesoPreProcesadoCobrosJob";
		public static final String INICIO_MSG = "Inicio del proceso INDEPENDIENTE de preprocesado de Cobros de Recobro ";
		public static final String FIN_MSG = "El proceso de preprocesado INDEPENDIENTE de Cobros de Recobro para la entidad ha finalizado ";
	}	
	
	/**
	 * Clase de constantes del proceso de PreProcesado de los Cobros de Recobro para la posterior facturaci�n a Agencias
	 * @author Javier
	 *
	 */
	public static class PreProcesadoCobros{
		
		public static final String DESCRIPCION_PREPROCESADO_COBROS = "Ejecuta el preproceso de los cobros, para su posterior facturaci�n a las agencias. Se debe indicar el workingCode";
		public static final String PROCESO_PREPROCESADO_COBROS_RECOBRO_HANDLER = "procesoPreProcesadoCobrosRecobroHandler";
		public static final String PROCESO_PREPROCESADO_COBROS_RECOBRO_JOBNAME = "procesoPreProcesadoCobrosJob";
		public static final String INICIO_MSG = "Inicio del proceso de preprocesado de Cobros de Recobro ";
		public static final String FIN_MSG = "El proceso de preprocesado de Cobros de Recobro para la entidad ha finalizado ";
	}	
	
	/**
	 * Clase de constantes para el c�lculo de la Facturacion del m�dulo batch de Recobro de Agencias
	 * @author Guillem
	 *
	 */
	public static class CalculoFacturacion{
		
		public static final String DESCRIPCION_PROCESO_FACTURACION = "Ejecuta el proceso de Facturaci�n correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_FACTURACION_RECOBRO_HANDLER = "procesoFacturacionRecobroHandler";
		public static final String PROCESO_FACTURACION_JOBNAME = "procesoFacturacionJob";
		public static final String INICIO_MSG = "Inicio del proceso de Facturacion a Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Facturacion a Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Preparaci�n de la Simulaci�n 
	 * @author Guillem
	 *
	 */
	public static class PreparacionSimulacion{
		
		public static final String DESCRIPCION_PROCESO_PREPARACION_SIMULACION_RECOBRO = "Ejecuta el proceso de Preparaci�n de la Simulaci�n correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_PREPARACION_SIMULACION_RECOBRO_HANDLER = "procesoPreparacionSimulacionRecobroHandler";
		public static final String PROCESO_PREPARACION_SIMULACION_RECOBRO_JOBNAME = "procesoPreparacionSimulacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Preparaci�n de la Simulaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Preparaci�n de la Simulaci�n de las Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Generaci�n y Persistencia del informe de la Simulaci�n 
	 * @author Guillem
	 *
	 */
	public static class GeneracionYPersistenciaInformeSimulacion{
		
		public static final String DESCRIPCION_PROCESO_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO = "Ejecuta el proceso de Generaci�n y Persistencia del informe de la Simulaci�n correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_PREPARACION_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO_HANDLER = "procesoGeneracionPersistenciaInformeSimulacionRecobroHandler";
		public static final String PROCESO_PREPARACION_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO_JOBNAME = "procesoGeneracionPersistenciaInformeSimulacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Generaci�n y Persistencia del informe de la Simulaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Generaci�n y Persistencia del informe de la Simulaci�n de las Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Preparaci�n del Batch de Recobro
	 * @author Guillem
	 *
	 */
	public static class PreparacionRecobro{
		
		public static final String DESCRIPCION_PROCESO_PREPARACION_RECOBRO = "Ejecuta el proceso de Preparaci�n de las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_PREPARACION_RECOBRO_HANDLER = "procesoPreparacionRecobroHandler";
		public static final String PROCESO_PREPARACION_RECOBRO_JOBNAME = "procesoPreparacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Preparaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Preparaci�n de las Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Historizaci�n del Batch de Recobro
	 * @author Guillem
	 *
	 */
	public static class HistorizacionRecobro{
		
		public static final String DESCRIPCION_PROCESO_HISTORIZACION_RECOBRO = "Ejecuta el proceso de Historizaci�n de las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_HISTORIZACION_RECOBRO_HANDLER = "procesoHistorizacionRecobroHandler";
		public static final String PROCESO_HISTORIZACION_RECOBRO_JOBNAME = "procesoHistorizacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Historizaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Historizacion de las Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Ranking del Batch de Recobro
	 * @author Guillem
	 *
	 */
	public static class ProcesoRanking{
		
		public static final String DESCRIPCION_PROCESO_RANKING = "Ejecuta el proceso de Ranking de las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_RANKING_HANDLER = "procesoRankingHandler";
		public static final String PROCESO_RANKING_JOBNAME = "procesoRankingJob";
		public static final String INICIO_MSG = "Inicio del proceso de Ranking de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Ranking de las Agencias de Recobro para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Control de la Simulaci�n 
	 * @author Guillem
	 *
	 */
	public static class ControlSimulacion{
		
		public static final String DESCRIPCION_PROCESO_CONTROL_SIMULACION_RECOBRO = "Ejecuta el proceso de Control de la Simulaci�n correspondiente a las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_CONTROL_RECOBRO_HANDLER = "procesoControlSimulacionRecobroHandler";
		public static final String PROCESO_CONTROL_RECOBRO_JOBNAME = "procesoControlSimulacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Control de la Simulaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Control de la Simulaci�n de las Agencias de Recobro para la entidad ";
		// Esas constantes se usan �nicamente para el proceso que genera la excel de simulaci�n y la guarda en el disco
		public static final String DESCRIPCION_GUARDAR_EXCEL_SIMULACION_EN_DISCO = "Genera la excel de Simulaci�n de Recobro y la persiste en el File System";
		public static final String PROCESO_GUARDADO_EXCEL_SIMULACION_HANDLER = "procesoGuardadoExcelSimulacionHandler";
		public static final String PROCESO_GUARDADO_EXCEL_SIMULACION_JOBNAME = "procesoGuardadoExcelSimulacionJob";
	}	
	
	/**
	 * Clase de constantes para el proceso de Historizaci�n de la Facturaci�n
	 * @author Guillem
	 *
	 */
	public static class HistorizacionFacturacion{
		
		public static final String DESCRIPCION_PROCESO_HISTORIZACION_FACTURACION = "Ejecuta el proceso de Historizaci�n de la Facturaci�n. Se debe indicar el workingCode";
		public static final String PROCESO_HISTORIZACION_FACTURACION_HANDLER = "procesoHistorizacionFacturacionHandler";
		public static final String PROCESO_HISTORIZACION_FACTURACION_JOBNAME = "procesoHistorizacionFacturacionJob";
		public static final String INICIO_MSG = "Inicio del proceso de Historizaci�n de la Facturaci�n ";
		public static final String FIN_MSG = "El proceso de Historizacion de la Facturaci�n para la entidad ";
	}	
	
	/**
	 * Clase de constantes para el proceso de Validacion del Batch de Recobro
	 * @author Guillem
	 *
	 */
	public static class ValidacionRecobro{
		
		public static final String DESCRIPCION_PROCESO_VALIDACION_RECOBRO = "Ejecuta el proceso de Validaci�n de las Agencias de Recobro. Se debe indicar el workingCode";
		public static final String PROCESO_VALIDACION_RECOBRO_HANDLER = "procesoValidacionRecobroHandler";
		public static final String PROCESO_VALIDACION_RECOBRO_JOBNAME = "procesoValidacionRecobroJob";
		public static final String INICIO_MSG = "Inicio del proceso de Validaci�n de las Agencias de Recobro ";
		public static final String FIN_MSG = "El proceso de Validaci�n de las Agencias de Recobro para la entidad ";
	}	
	
}