package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.jamonapi.utils.Logger;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoImpulsoAutomaticoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVPlazaCodigoPostalDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoImpulsoDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfImpulsoAutomatico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVImpulsoAutomaticoGenerado;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoImpulsoAutomatico;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVValidadorImpulsosAutomaticos;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasApi;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

@SuppressWarnings("deprecation")
@Component
@Transactional(readOnly = false)
public class MSVProcesoImpulsoAutomaticoManager implements
		MSVProcesoImpulsoAutomaticoApi {

	private static final String IMPULSO_PROCESAL_GENERADO_AUTOMATICAMENTE = "Impulso procesal generado automáticamente";

	static final private String CODIGO_INPUT_IMPULSO = "IMPULSO_PROC";
	static final private String CODIGO_INPUT_IMPULSO_BATCH = "IMPULSO_PROC_BATCH";
	
	private final static String PROCURADOR_VACIO = "PR000000";
	
	private static final String CODIGO_PLANTILLA_IMPULSO_CPROC = "IMPULSO_CPROC";
	private static final String CODIGO_PLANTILLA_IMPULSO_SPROC = "IMPULSO_SPROC";

	private static final String CAMPO_DINAMICO_OBSERVACIONES = "d_observaciones";
	private static final String CAMPO_DINAMICO_FECHA_RECEP = "d_fecRecepResolImpulso";
	private static final String CAMPO_DINAMICO_FECHA_RESOL = "d_fecResolucionImpulso";
	private static final String CAMPO_DINAMICO_ID_ASUNTO = "idAsunto";
	private static final String CAMPO_DINAMICO_NUM_AUTOS = "d_numAutos";
	private static final String[] camposDinamicosInputImpulso = { CAMPO_DINAMICO_OBSERVACIONES, 
		CAMPO_DINAMICO_FECHA_RECEP, CAMPO_DINAMICO_FECHA_RESOL, 
		CAMPO_DINAMICO_ID_ASUNTO, CAMPO_DINAMICO_NUM_AUTOS};

	static final private String NUMERO_DIAS_PROCESO_IMPULSOS = "proceso.impulsos.numero.dias";
	static final private String RUTA_CON_PROC_PROCESO_IMPULSOS = "proceso.impulsos.ruta_con_proc";
	static final private String RUTA_SIN_PROC_PROCESO_IMPULSOS = "proceso.impulsos.ruta_sin_proc";
	static final private String RUTA_RECHAZOS_PROC_PROCESO_IMPULSOS = "proceso.impulsos.ruta_rechazos";

	public static final String TIPO_ADICIONAL_CARTERA = "char_extra5";

	private final Log logger = LogFactory.getLog(getClass());

	@Resource(name = "appProperties")
	private Properties appProperties;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MSVProcesoImpulsoDao procesoImpulsoDao;
	
	@Autowired
	private MSVPlazaCodigoPostalDao plazaCodigoDao;
	
	// Número de días a procesar, por defecto, el procesamiento será semanal
	@SuppressWarnings("unused")
	private int numeroDiasProceso = 7;
	// Ruta tamporal donde se dejarán los escritos con procurador 
	private String rutaConProcProceso = "/tmp/impulsos/con_proc";
	// Ruta tamporal donde se dejarán los escritos sin procurador 
	private String rutaSinProcProceso = "/tmp/impulsos/sin_proc";
	// Ruta tamporal donde se dejarán los ficheros de rechazos 
	private String rutaRechazosProceso = "/tmp/impulsos/rechazos";
	
	private void inicializacionPropiedades() {
		if (appProperties.getProperty(NUMERO_DIAS_PROCESO_IMPULSOS) != null) {
			numeroDiasProceso = Integer.parseInt(appProperties.getProperty(NUMERO_DIAS_PROCESO_IMPULSOS));
		}
		if (appProperties.getProperty(RUTA_CON_PROC_PROCESO_IMPULSOS) != null) {
			rutaConProcProceso = appProperties.getProperty(RUTA_CON_PROC_PROCESO_IMPULSOS);
		}
		if (appProperties.getProperty(RUTA_SIN_PROC_PROCESO_IMPULSOS) != null) {
			rutaSinProcProceso = appProperties.getProperty(RUTA_SIN_PROC_PROCESO_IMPULSOS);
		}
		if (appProperties.getProperty(RUTA_RECHAZOS_PROC_PROCESO_IMPULSOS) != null) {
			rutaRechazosProceso = appProperties.getProperty(RUTA_RECHAZOS_PROC_PROCESO_IMPULSOS);
		}
	}
	
	@Override
	@BusinessOperation(BO_BUSQUEDA_IMPULSOS_AUTOMATICOS)
	public void procesadoPeriodico() {

		inicializacionPropiedades();

		Date fechaProceso = obtenerFechaActual();
		
		// Bucle sobre las configuraciones de impulso automático existentes
		List<MSVConfImpulsoAutomatico> listaConfiguraciones = obtenerListaConfImpulsoAutomatico();
		for (MSVConfImpulsoAutomatico configuracion : listaConfiguraciones) {
			List<MSVImpulsoAutomaticoGenerado> listaImpulsos = new ArrayList<MSVImpulsoAutomaticoGenerado>();

			// Bucle sobre las tareas que cumplen los requisitos de
			// la configuración del impulso automático actual
			// La consulta ha de tener en cuenta si la última resolución es una de las que está
			// en la lista de resoluciones a tener en cuenta
			List<EXTTareaExterna> listaTareas = obtenerListaTareasAImpulsar(
					configuracion, fechaProceso);
			for (EXTTareaExterna tareaExterna : listaTareas) {
				
				try {
					// Procesar tarea
					MSVImpulsoAutomaticoGenerado impulso = procesarTarea(
							configuracion, fechaProceso, tareaExterna);
	
					// Guardar impulso generado
					impulso = guardarImpulsoGenerado(impulso);
	
					// Ponemos el impulso en la lista
					listaImpulsos.add(impulso);
				} catch (Exception e) {
					logger.error("[Procesado de impulsos automaticos] Excepcion al procesar la tarea "
									+ tareaExterna.getId()
									+ ": "
									+ e.getMessage()
									+ " (El proceso continua para el resto de las tareas");
				}
			}

			if (listaImpulsos.size() > 0) {
				// Generar fichero Excel de errores (compartido por todas las plazas)
				String nombreFicheroErrores = generarExcelErrores(fechaProceso, listaImpulsos);

				Map<String, List<MSVImpulsoAutomaticoGenerado>> mapaPlazasImpulsos =
						separarImpulsosPorPlazas(listaImpulsos);
				
				// Recorrer el mapa de plazas/listas de impulsos y generar un proceso
				// por cada elemento del mapa
				for (String clavePlaza : mapaPlazasImpulsos.keySet()) {
					List<MSVImpulsoAutomaticoGenerado> listaImpulsosPlaza =
							mapaPlazasImpulsos.get(clavePlaza);
					
					// Generar fichero Excel de resultados
					String nombreFicheroResultados = generarExcelResultados(
							clavePlaza, configuracion.getConProcurador(),
							fechaProceso, listaImpulsosPlaza);

					// Copiar y comprimir Ficheros
					copiarYComprimirFicheros(clavePlaza, 
							configuracion.getConProcurador(), 
							nombreFicheroResultados, 
							listaImpulsosPlaza);

					// Guardar datos del proceso del impulso/fecha
					guardarDatosProcesoImpulsoAutomatico(configuracion, fechaProceso, 
							listaImpulsosPlaza, nombreFicheroResultados, nombreFicheroErrores);

				}
			}

		}
	}

	// ****************************************************

	/**
	 * Separamos la lista de Impulsos por plazas
	 * 
	 * @param listaImpulsos
	 * @return mapa de listas de impulsos por cada plaza
	 */
	private Map<String, List<MSVImpulsoAutomaticoGenerado>> separarImpulsosPorPlazas(
			List<MSVImpulsoAutomaticoGenerado> listaImpulsos) {
		
		Map<String, List<MSVImpulsoAutomaticoGenerado>> mapaImpulsosPorPlazas =
				new ConcurrentHashMap<String, List<MSVImpulsoAutomaticoGenerado>> ();
		
		for (MSVImpulsoAutomaticoGenerado impulso : listaImpulsos) {
			TipoPlaza plaza = impulso.getPlaza();
			String nombrePlaza = "SINPLAZA";
			if (plaza != null && plaza.getDescripcionLarga() != null) {
				nombrePlaza = plaza.getDescripcionLarga();
			}
			nombrePlaza = corregirNombrePlaza(nombrePlaza);
			if (mapaImpulsosPorPlazas.containsKey(nombrePlaza)) {
				mapaImpulsosPorPlazas.get(nombrePlaza).add(impulso);
			} else {
				List<MSVImpulsoAutomaticoGenerado> listaImpulsosPlaza =
						new ArrayList<MSVImpulsoAutomaticoGenerado>();
				listaImpulsosPlaza.add(impulso);
				mapaImpulsosPorPlazas.put(nombrePlaza, listaImpulsosPlaza);
			}
		}
		return mapaImpulsosPorPlazas;

	}

	/**
	 * Devuelve la lista de configuraciones de impulso automático existentes
	 * 
	 * @return lista de configuraciones existentes
	 */
	private List<MSVConfImpulsoAutomatico> obtenerListaConfImpulsoAutomatico() {

		List<MSVConfImpulsoAutomatico> listaConfiguraciones =
				genericDao.getList(MSVConfImpulsoAutomatico.class);
		return listaConfiguraciones;
	}

	/**
	 * Obtiene la fecha actual sin horas
	 * 
	 * @return fecha actual
	 */
	private Date obtenerFechaActual() {
		Calendar hoy = new GregorianCalendar();
		hoy.set(hoy.get(Calendar.YEAR), hoy.get(Calendar.MONTH), hoy.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		return hoy.getTime();
	}

	/**
	 * Buscar la lista de tareas activas que cumplan los criterios especificados en el parámetro configuracion
	 * cumpliendo, además, que la última resolución debe ser una de las especificadas en la lista estática
	 * 
	 * La fecha sobre la que se va a efectuar la comprobación es la que se pasa como parámetro
	 * 
	 * @param configuracion
	 * @param fecha
	 * @return lista tareas externas
	 */
	private List<EXTTareaExterna> obtenerListaTareasAImpulsar(
			MSVConfImpulsoAutomatico configuracion, Date fecha) {
		
		Long idTipoProcedimiento = configuracion.getTipoJuicio().getTipoProcedimiento().getId();
		Long idTareaProcedimiento = configuracion.getTareaProcedimiento().getId();
		Long idDespacho = configuracion.getDespacho().getId();
		String cartera = configuracion.getCartera();
		
		// Realizar la búsqueda mediante procesoImpulsoDao
		List<EXTTareaExterna> listaTareasIntermedia = procesoImpulsoDao
				.obtenerListaTareasExternasAImpulsar(idTipoProcedimiento,
						idTareaProcedimiento, idDespacho);
		List<EXTTareaExterna> listaTareasResultado = new ArrayList<EXTTareaExterna>();
		
		logger.info("[Procesado de impulsos automaticos] obtenerListaTareasAImpulsar(" +
				configuracion.getId() + "," + fecha.toString() + 
				": tamanyo lista impulsos intermedia " + listaTareasIntermedia.size());
		
		// Recorrer la lista de tareas devuelta por la búsqueda 
		// y aplicar filtros adicionales:
		for (EXTTareaExterna tareaExterna : listaTareasIntermedia) {
			Procedimiento proc = obtenerProcedimiento(tareaExterna);
			if (proc != null) {
				Asunto asunto = proc.getAsunto();
				if (asunto != null) {
					// Comprobar si la cartera del contrato se corresponde con la del filtro
					if (comprobarCartera(asunto, cartera)) {
						// Obtenemos la lista de resoluciones asociadas al procedimiento ordenadas por fecha descendiente
						// Esta lista se usa en la comprobación de dos condiciones necesarias
						List<RecoveryBPMfwkInput> listaResoluciones = obtenerListaResolucionesOrdenadasPorFechaDesc(proc);
						if (listaResoluciones.size() > 0) {
							// Condiciones adicionales:
							//  - Se corresponde con el Con/Sin Procurador
							//  - Última resolución debe ser una de la lista estática (*)
							//  - Última resolución en plazo (según configuración)
							//  - Último impulso en plazo (según configuración)
							if (compruebaConSinProcurador(asunto, configuracion.getConProcurador()) && 
									compruebaUltimaResolucion(listaResoluciones, fecha, configuracion.getOperUltimaResol(), configuracion.getNumDiasUltimaResol()) &&
									compruebaUltimoImpulso(listaResoluciones, fecha, configuracion.getOperUltimoImpulso(), configuracion.getNumDiasUltimoImpulso())) {
								listaTareasResultado.add(tareaExterna);
							}
						} else {
							//Si no tiene resoluciones anteriores, lo damos por bueno si cumple la condición
							// de con procurador / sin procurador
							if (compruebaConSinProcurador(asunto, configuracion.getConProcurador())) {
								listaTareasResultado.add(tareaExterna);
							}
						}
					}
				}
			}
		}
		
		logger.info("[Procesado de impulsos automaticos] obtenerListaTareasAImpulsar(" +
				configuracion.getId() + "," + fecha.toString() + 
				": tamanyo lista impulsos definitiva " + listaTareasResultado.size());
		
		return listaTareasResultado;
	}

	private boolean comprobarCartera(Asunto asunto, String cartera) {
		EXTContrato contrato = null;
		
		try {
			contrato = (EXTContrato) (asunto.getContratos().toArray()[0]);
		} catch (Exception e) {
		}
		if (contrato != null) {
			Long idContrato = contrato.getId();
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoInfoContrato.codigo", TIPO_ADICIONAL_CARTERA);
			EXTInfoAdicionalContrato adicional = genericDao.get(
					EXTInfoAdicionalContrato.class, f1, f2);
			if (adicional != null) {
				return (cartera.equalsIgnoreCase(adicional.getValue()));
			}			
		}
		return false;
	}

	@SuppressWarnings("unused")
	private boolean esGestorDespacho(Long idAsunto, Long idDespacho) {
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS,
				"asunto.id", 
				idAsunto);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS,
				"gestor.despachoExterno.id", 
				idDespacho);
		Filter filtro3 = genericDao.createFilter(FilterType.EQUALS,
				"tipoGestor.codigo", 
				EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		if (genericDao.get(EXTGestorAdicionalAsunto.class, filtro1, filtro2, filtro3) != null) {
			return true;
		}
		return false;
	}

	/**
	 * Comprueba si el asunto de la tarea cumple la condición especificada
	 * por conProcurador
	 *  
	 * @param asunto
	 * @param conProcurador
	 * @return boolean
	 */
	private boolean compruebaConSinProcurador(Asunto asunto, Boolean conProcurador) {
		
		Long idAsunto = asunto.getId();
		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
		Filter filtroTipoProcurador = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR);
		EXTGestorAdicionalAsunto procurador = genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoProcurador);
		
		boolean hayProcurador = true;
		if (procurador == null || PROCURADOR_VACIO.equals(procurador.getGestor().getUsuario().getUsername())) {
			hayProcurador = false;
		}
		
		return (hayProcurador == conProcurador.booleanValue());
		
	}

	/**
	 * Obtiene lista de resoluciones asociadas al procedimiento 
	 * 		al cual pertenece la tarea externa, 
	 * 		ordenadas de más reciente a más antigua
	 * @param tareaExterna
	 * @return lista 
	 */
	private List<RecoveryBPMfwkInput> obtenerListaResolucionesOrdenadasPorFechaDesc(Procedimiento proc) {

		// Consultamos la última resolución (último input) asociadas al procedimiento
		Filter filtroProc = genericDao.createFilter(FilterType.EQUALS,
				"idProcedimiento", proc.getId());
		Order orderFechaDesc = new Order(OrderType.DESC,"auditoria.fechaCrear"); 
		return genericDao.getListOrdered(RecoveryBPMfwkInput.class, 
				orderFechaDesc, filtroProc);
		
	}
	
	/**
	 * Comprueba si la última resolución es una de las marcadas como para hacer seguimiento (*)
	 *  y si la fecha de la última resolución cumple la condición especificada por los
	 *  parámetros operUltimaResol y numDiasUltimaResol
	 *  
	 *  (*) Solamente podrán ser impulsados los asuntos cuyas últimas resoluciones sean susceptibles de impulso
	 *		Requerimientos previos
	 *		Admisiones a tramite
	 *		Requerimientos positivos
	 *		Diligencias Negativas 
	 *		Demanda presentadas
	 *		Auto Despachando Ejecucion
	 *		Solicitud de embargo
	 *		Averiguacion patrimonial
	 *
	 * @param listaResoluciones
	 * @param fechaProceso
	 * @param operUltimaResol
	 * @param numDiasUltimaResol
	 * @return
	 */
	private boolean compruebaUltimaResolucion(List<RecoveryBPMfwkInput> listaResoluciones,
			Date fechaProceso, String operUltimaResol, Integer numDiasUltimaResol) {
		
		boolean ok = false;
		
		if (listaResoluciones == null || listaResoluciones.size() == 0) {
			ok = true;
		} else {
			RecoveryBPMfwkInput ultimaResolucion = listaResoluciones.get(0);
			//Comprobamos que la fecha cumpla las condición operUltimaResol y numDiasUltimaResol
			Date fechaUltimaResolucion = obtenerFechaResolucion(ultimaResolucion);
			ok = comprobarFechaEnPlazo(fechaProceso, fechaUltimaResolucion, operUltimaResol, numDiasUltimaResol);
		}
		return ok;
		
	}

	private boolean comprobarFechaEnPlazo(Date fechaProceso, Date fechaUltimaResolucion,
			String operUltimaResol, Integer numDiasUltimaResol) {
		
		boolean ok = false;
		
		Calendar calProceso = new GregorianCalendar();
		calProceso.setTime(fechaProceso);
		
		Calendar calResolucion = new GregorianCalendar();
		calResolucion.setTime(fechaUltimaResolucion);
		calResolucion.add(Calendar.DAY_OF_YEAR, numDiasUltimaResol);
		//Quitamos la hora, minutos, segundos
		calResolucion.set(calResolucion.get(Calendar.YEAR), calResolucion.get(Calendar.MONTH), calResolucion.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
		
		if (operUltimaResol.equals("<")) {
			ok = (calProceso.compareTo(calResolucion)<0);
		} else if (operUltimaResol.equals("<=")) {
			ok = (calProceso.compareTo(calResolucion)<=0);
		} else if (operUltimaResol.equals("=")) {
			ok = (calProceso.compareTo(calResolucion)==0);
		} else if (operUltimaResol.equals(">=")) {
			ok = (calProceso.compareTo(calResolucion)>=0);
		} else if (operUltimaResol.equals(">")) {
			ok = (calProceso.compareTo(calResolucion)>0);
		}
		return ok;
	}

	private Date obtenerFechaResolucion(RecoveryBPMfwkInput ultimaResolucion) {
		
		//TODO: Tener en cuenta las fechas de los valores del input
		//De momento, devolvemos la fecha de alta registrada para el input
		return ultimaResolucion.getAuditoria().getFechaCrear();
	}

	/**
	 * Comprueba si el último impulso la condición especificada por los
	 *  parámetros operUltimoImpulso y numDiasUltimoImpulso
	 *  
	 * @param listaResoluciones
	 * @param fechaProceso
	 * @param operUltimoImpulso
	 * @param numDiasUltimoImpulso
	 * @return
	 */
	private boolean compruebaUltimoImpulso(List<RecoveryBPMfwkInput> listaResoluciones,
			Date fechaProceso, String operUltimoImpulso, Integer numDiasUltimoImpulso) {

		boolean ok = false;
		
		if (listaResoluciones == null || listaResoluciones.size() == 0) {
			ok = true;
		} else {
			RecoveryBPMfwkInput ultimoImpulso = null;
			for (RecoveryBPMfwkInput input : listaResoluciones) {
				if (input.getCodigoTipoInput().equals(CODIGO_INPUT_IMPULSO) || 
						input.getCodigoTipoInput().equals(CODIGO_INPUT_IMPULSO_BATCH)) {
					ultimoImpulso = input;
					break;
				}
			}
			if (ultimoImpulso == null) {
				ok = true;
			} else {
				//Y comprobamos que la fecha cumpla las condición operUltimoImpulso y numDiasUltimoImpulso
				Date fechaUltimoImpulso = obtenerFechaResolucion(ultimoImpulso);
				ok = comprobarFechaEnPlazo(fechaProceso, fechaUltimoImpulso, operUltimoImpulso, numDiasUltimoImpulso);
			}
		}
		return ok;

	}

	/**
	 * Crear el input correspondiente de Impulso y asociarlo a la tarea actual
	 * 
	 * @param tareaExterna
	 * @return input creado
	 */
	private RecoveryBPMfwkInput registrarResolucionImpulso(
			EXTTareaExterna tareaExterna, Date fechaProceso) {

		RecoveryBPMfwkDDTipoInput tipoInput = obtenerTipoInputImpulso();
		RecoveryBPMfwkInputDto inputDto = populateInputDto(tipoInput, tareaExterna, fechaProceso);
		Long idInput = proxyFactory.proxy(RecoveryBPMfwkRunApi.class).procesaInput(inputDto);
		if ((!Checks.esNulo(idInput)) && (!Checks.esNulo(tareaExterna))) {
			proxyFactory.proxy(RecoveryBPMfwkInputsTareasApi.class).save(idInput, tareaExterna.getId());
		}
		RecoveryBPMfwkInput input = obtenerInput(idInput);
		return input;

	}
	
	private RecoveryBPMfwkInput obtenerInput(Long idInput) {

		Filter filtroInput = genericDao.createFilter(FilterType.EQUALS, "id", idInput);
		RecoveryBPMfwkInput inputImpulso = genericDao.get(RecoveryBPMfwkInput.class, filtroInput);
		return inputImpulso;

	}

	private RecoveryBPMfwkInputDto populateInputDto(
			RecoveryBPMfwkDDTipoInput tipoInput, EXTTareaExterna tareaExterna, Date fechaProceso) {
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		
		RecoveryBPMfwkInputDto inputDto = new RecoveryBPMfwkInputDto();
		
		Procedimiento prc = tareaExterna.getTareaPadre().getProcedimiento();
		Long idAsunto = null;
		Long idProcedimiento = null;
		if(prc != null){
			idAsunto = prc.getAsunto().getId();
			idProcedimiento = prc.getId();
		}
		inputDto.setCodigoTipoInput(tipoInput.getCodigo());
		inputDto.setIdProcedimiento(idProcedimiento);

		Map<String, Object> mapa = new HashMap<String, Object>();
		for (int i = 0; i < camposDinamicosInputImpulso.length; i++) {
			String valor = "";
			if (CAMPO_DINAMICO_OBSERVACIONES.equals(camposDinamicosInputImpulso[i])) {
				valor = IMPULSO_PROCESAL_GENERADO_AUTOMATICAMENTE;
			} else if (CAMPO_DINAMICO_FECHA_RECEP.equals(camposDinamicosInputImpulso[i])) {
				valor = df.format(new Date());
			} else if (CAMPO_DINAMICO_FECHA_RESOL.equals(camposDinamicosInputImpulso[i])) {
				valor = df.format(fechaProceso);
			} else if (CAMPO_DINAMICO_ID_ASUNTO.equals(camposDinamicosInputImpulso[i])) {
				valor = idAsunto.toString();
			} else if (CAMPO_DINAMICO_NUM_AUTOS.equals(camposDinamicosInputImpulso[i])) {
				valor = prc.getCodigoProcedimientoEnJuzgado();
			}
			mapa.put(camposDinamicosInputImpulso[i], valor);
		}
		inputDto.setDatos(mapa);

		return inputDto;
	}

	private RecoveryBPMfwkDDTipoInput obtenerTipoInputImpulso() {

		Filter filtroTipoInput = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_INPUT_IMPULSO);
		RecoveryBPMfwkDDTipoInput tipoInputImpulso = genericDao.get(RecoveryBPMfwkDDTipoInput.class, filtroTipoInput);
		return tipoInputImpulso;
		
	}

	private MSVImpulsoAutomaticoGenerado guardarImpulsoGenerado(
			MSVImpulsoAutomaticoGenerado impulso) {

		return genericDao.save(MSVImpulsoAutomaticoGenerado.class, impulso);

	}

	/**
	 * Compone nombre del fichero de resultados y lo genera
	 * 
	 * @param nombrePlaza
	 * @param conProcurador
	 * @param fechaProceso
	 * @param listaImpulsos
	 * @return
	 */
	private String generarExcelResultados(
			String nombrePlaza, Boolean conProcurador, Date fechaProceso, List<MSVImpulsoAutomaticoGenerado> listaImpulsos) {

		String nombreFicheroResultados = componerNombreFicheroResultados(nombrePlaza, conProcurador, fechaProceso);
		List<String> cabeceras = new ArrayList<String>();
		cabeceras.add("Nº caso");
		cabeceras.add("Nombre del fichero generado");
		List<List<String>> listaValores = new ArrayList<List<String>>();

		for (MSVImpulsoAutomaticoGenerado impulso : listaImpulsos) {
			if ("".equals(impulso.getDescripcionError())) {
				List<String> filaValores = new ArrayList<String>();
				filaValores.add(impulso.getCasoNova());
				filaValores.add(impulso.getDocumentoGenerado());
				listaValores.add(filaValores);
			}
		}
		
		MSVHojaExcel excel = new MSVHojaExcel();
		String rutaFicheroResultados = 
				(conProcurador ? rutaConProcProceso + File.separator + nombrePlaza : rutaSinProcProceso)
				+ File.separator;
		makeDir(rutaFicheroResultados);
		excel.crearNuevoExcel(rutaFicheroResultados + nombreFicheroResultados, cabeceras, listaValores,true);
		
		return nombreFicheroResultados;
	}

	private String componerNombreFicheroResultados(String nombrePlaza,
			Boolean conProcurador, Date fechaProceso) {
		// Plaza_Impulsos_con_Procurador_yyyyMMdd.xls / Plaza_Impulsos_sin_Procurador_yyyyMMdd.xls
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String resultado = nombrePlaza + "_Impulsos" +
				(conProcurador ? "_con_Procurador_" : "_sin_Procurador_") +
				df.format(fechaProceso) + ".xls";
		return resultado;
	}

	/**
	 * Compone nombre del fichero de errores y lo genera
	 * 
	 * @param fechaProceso
	 * @param listaImpulsos
	 * @return
	 */
	private String generarExcelErrores(Date fechaProceso,
			List<MSVImpulsoAutomaticoGenerado> listaImpulsos) {
		
		String nombreFicheroErrores = componerNombreFicheroErrores(fechaProceso);
		List<String> cabeceras = new ArrayList<String>();
		cabeceras.add("Nº caso");
		cabeceras.add("Tipo de error");
		List<List<String>> listaValores = new ArrayList<List<String>>();

		for (MSVImpulsoAutomaticoGenerado impulso : listaImpulsos) {
			if (!"".equals(impulso.getDescripcionError())) {
				List<String> filaValores = new ArrayList<String>();
				filaValores.add(impulso.getCasoNova());
				filaValores.add(impulso.getDescripcionError());
				listaValores.add(filaValores);
			}
		}
		
		MSVHojaExcel excel = new MSVHojaExcel();
		String rutaFicheroErrores = rutaRechazosProceso + File.separator;
		makeDir(rutaFicheroErrores);
		excel.crearNuevoExcel(rutaFicheroErrores + nombreFicheroErrores, cabeceras, listaValores,true);
		
		return nombreFicheroErrores;
	}

	private String componerNombreFicheroErrores(Date fechaProceso) {
		// Impulsos_Rechazados_yyyyMMdd.xls
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String resultado = "Impulsos_Rechazados_" + df.format(fechaProceso) + ".xls";
		return resultado;
	}


	private void copiarYComprimirFicheros(String clavePlaza,
			Boolean conProcurador, String nombreFicheroResultados,
			List<MSVImpulsoAutomaticoGenerado> listaImpulsosPlaza) {
		
		boolean existenAdjuntos = false;
		
		//Comprobar si la lista de impulsos tiene algún escrito a comprimir
		for (MSVImpulsoAutomaticoGenerado impulsoGenerado : listaImpulsosPlaza) {
			if (impulsoGenerado.getAdjunto() != null) {
				existenAdjuntos = true;
				break;
			}
		}
		
		if (existenAdjuntos) {
			// Componer nombre de fichero zip
			String nombreFicheroZip = nombreFicheroResultados.replaceAll("\\.xls", ".zip");
			
			// Recorrer la lista de impulsos, extraer el escrito asociado y 
			// comprimirlo en el fichero zip
			String rutaFicheros = (conProcurador ? rutaConProcProceso + File.separator + clavePlaza : rutaSinProcProceso)
					+ File.separator;
			makeDir(rutaFicheros);
			String rutaNombre = rutaFicheros+nombreFicheroZip;

			// Creamos un fichero temporal para si existe añadir los ficheros
			String rutaNombreTMP = rutaNombre + ".tmp.zip";
			File fileZip = new File(rutaNombre);
			
			
	        
			final int BUFFER_SIZE = 1024;
			
			FileInputStream fis = null;
			FileOutputStream fos = null;
			ZipOutputStream zipos = null;
			
			byte[] buffer = new byte[BUFFER_SIZE];
			
			try {
				fos = new FileOutputStream(rutaNombreTMP);
				zipos = new ZipOutputStream(fos);
			} catch (FileNotFoundException e1) {
				logger.error("[MSVProcesoImpulsoAutomaticoManager.copiarYComprimirFicheros]: " + e1.getMessage());
				e1.printStackTrace();
			}
			
			
			try {
				// Si existe el zip se copia al tmp
				if (fileZip.exists()) {
					ZipFile fileLocal = new ZipFile(rutaNombre);					
					Enumeration<? extends ZipEntry> entries = fileLocal.entries();
					while (entries.hasMoreElements()) {
						ZipEntry e = entries.nextElement();
						zipos.putNextEntry(e);
						if (!e.isDirectory()) {
							copy(fileLocal.getInputStream(e), zipos, buffer);
						}
						zipos.closeEntry();
					}
					fileLocal.close();
				}
				
				if (zipos != null) {
					for (MSVImpulsoAutomaticoGenerado impulso : listaImpulsosPlaza) {
						if (impulso.getAdjunto() != null) {
							File fileToZip = impulso.getAdjunto().getFileItem().getFile();
							try {
								fis = new FileInputStream(fileToZip);				
								ZipEntry zipEntry = new ZipEntry(impulso.getDocumentoGenerado());
								zipos.putNextEntry(zipEntry);
							
//								int len = 0;
//								
//								while ((len = fis.read(buffer, 0, BUFFER_SIZE)) != -1)
//									zipos.write(buffer, 0, len);
								
								copy(fis, zipos, buffer);
								
								// volcar la memoria al disco
								zipos.flush();
								fis.close();
							} catch (Exception e) {
								//No hacemos nada - duplicacion de fichero
								logger.info("[MSVProcesoImpulsoAutomaticoManager.copiarYComprimirFicheros]: " + e.getMessage());
							}
						}
					}
					// cerramos los files
					zipos.close();			
					fos.close();
					
					// Hacemos que el fileTMP sea el fileFinal
	                if (fileZip.exists()) fileZip.delete();
	                File fileTMP = new File(rutaNombreTMP);
	                fileTMP.renameTo(fileZip);
				}
			} catch (IOException e) {
				logger.error("[MSVProcesoImpulsoAutomaticoManager.copiarYComprimirFicheros]: " + e.getMessage());
				e.printStackTrace();
			}				
		}

	}

	private void guardarDatosProcesoImpulsoAutomatico(
			MSVConfImpulsoAutomatico configuracion, Date fechaProceso, 
			List<MSVImpulsoAutomaticoGenerado> listaImpulsos,
			String nombreFicheroResultados,
			String nombreFicheroErrores) {
		
		MSVProcesoImpulsoAutomatico proceso = new MSVProcesoImpulsoAutomatico();
		proceso.setConfImpulso(configuracion);
		proceso.setEstado(MSVProcesoImpulsoAutomatico.ESTADO_FINALIZADO);
		proceso.setFechaProceso(fechaProceso);
		proceso.setFicheroErrores(nombreFicheroErrores);
		proceso.setFicheroResultados(nombreFicheroResultados);
		genericDao.save(MSVProcesoImpulsoAutomatico.class, proceso);
		
		for (MSVImpulsoAutomaticoGenerado impulso : listaImpulsos) {
			impulso.setProcesoImpulso(proceso);
			genericDao.save(MSVImpulsoAutomaticoGenerado.class, impulso);
		}

	}

	// *******************************************

	private MSVImpulsoAutomaticoGenerado procesarTarea(
			MSVConfImpulsoAutomatico configuracion, Date fecha,
			EXTTareaExterna tareaExterna) {

		MSVImpulsoAutomaticoGenerado impulso = new MSVImpulsoAutomaticoGenerado();

		// Nombre que ha de tener el escrito
		String nombreEscrito = "";

		Adjunto adjunto = null;
		RecoveryBPMfwkInput input = null;
		TipoPlaza plaza = obtenerPlaza(tareaExterna);
		Procedimiento procedimiento = obtenerProcedimiento(tareaExterna);
		String resultado = MSVImpulsoAutomaticoGenerado.RESULTADO_ERROR;

		// Obtener los valores de los campos que son necesarios 
		MSVValidadorImpulsosAutomaticos validador = new MSVValidadorImpulsosAutomaticos(
				procedimiento, configuracion.getConProcurador(), 
				genericDao, fecha, procesoImpulsoDao, tareaExterna);
		Map<String, String> mapaValoresPrecalculados = validador.obtenerValoresPrecalculados();
		
		// Comprobar si la tarea tiene errores que impidan
		// la generación del escrito
		String descripcionError = validador.comprobarErrores();
		
		String casoNova = "";
		if (mapaValoresPrecalculados.containsKey(MSVValidadorImpulsosAutomaticos.CAMPO_CASO_NOVA)) {
			casoNova = mapaValoresPrecalculados.get(MSVValidadorImpulsosAutomaticos.CAMPO_CASO_NOVA);
		}

		// Si no hay errores seguimos con el proceso
		if ("".equals(descripcionError)) {

			nombreEscrito = componerNombreEscrito(mapaValoresPrecalculados.get(MSVValidadorImpulsosAutomaticos.CAMPO_PLAZA),
						mapaValoresPrecalculados.get(MSVValidadorImpulsosAutomaticos.CAMPO_CASO_NOVA),
						configuracion.getConProcurador(), fecha);

			// Si no hay errores, generar el escrito de impulso procesal
			// teniendo en cuenta si es Con Procurador o Sin Procurador
			adjunto = generarEscritoImpulsoProcesal(mapaValoresPrecalculados,
					configuracion.getConProcurador(), procedimiento);

			// Renombrar el escrito recién generado
			renombrarEscritoImpulsoProcesal(adjunto.getId(), nombreEscrito);

			// Registrar resolución del impulso con la tarea
			input = registrarResolucionImpulso(tareaExterna, fecha);

			resultado = MSVImpulsoAutomaticoGenerado.RESULTADO_OK;

			impulso.setDescripcionError(descripcionError);
			impulso.setDocumentoGenerado(nombreEscrito);
			impulso.setAdjunto(adjunto);
			impulso.setInput(input);
		} else {
			resultado = MSVImpulsoAutomaticoGenerado.RESULTADO_ERROR;
			impulso.setDescripcionError(descripcionError);
			impulso.setDocumentoGenerado("");
			impulso.setAdjunto(null);
			impulso.setInput(null);
		}

		impulso.setPlaza(plaza);
		impulso.setCasoNova(casoNova);
		impulso.setProcedimiento(procedimiento);
		impulso.setResultado(resultado);
		impulso.setTarea(tareaExterna);
		return impulso;
	}

	private String componerNombreEscrito(String nombrePlaza, String numCaso, Boolean conProcurador, Date fechaProceso) {
		
		String resultado = corregirNombrePlaza(nombrePlaza);
		resultado = resultado + "_" + numCaso; 
		resultado = resultado + "_Impulso_"; 
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		resultado = resultado + df.format(fechaProceso);
		if (conProcurador) {
			resultado = resultado + "_cproc.rtf"; 
		} else {
			resultado = resultado + "_sproc.rtf"; 
		}
		return resultado;
	}

	private String corregirNombrePlaza(String nombrePlaza) {
		final char defCar = '-';
		final String defStr = String.valueOf(defCar);
		String resultado = nombrePlaza.toUpperCase();
		resultado = resultado.replaceAll(" ", "-");
		resultado = resultado.replaceAll("'", "-");
		resultado = resultado.replace("/", "-");
		resultado = resultado.replaceAll("À", "A").replace("Á", "A");
		resultado = resultado.replaceAll("È", "E").replace("É", "E");
		resultado = resultado.replace("Í", "I");
		resultado = resultado.replaceAll("Ò", "O").replace("Ó", "O");
		resultado = resultado.replaceAll("Ü", "U").replaceAll("Ù", "U");
		resultado = resultado.replace("Ñ", "N");
		resultado = resultado.replace("Ç", "C");
		resultado = resultado.replaceAll("\\?", defStr).replace("\\*", defStr);
		for (int i=0 ; i<resultado.length() ; i++) {
			char c = resultado.charAt(i);
			if (Character.getType(c) == Character.OTHER_SYMBOL) {
				resultado = resultado.replace(c, defCar);
			}
		}
		return resultado;
	}

	@SuppressWarnings({ "unused", "unchecked" })
	private Adjunto generarEscritoImpulsoProcesal(Map<String, String> mapaValoresPrecalculados,
			Boolean conProcurador, Procedimiento procedimiento) {

		String tipoEntidad = RecoveryBPMfwkInputGenDocExecutor.ENTIDAD_EXT_ASUNTO;
		String codigoPlantilla = "";
		if (conProcurador) {
			codigoPlantilla = CODIGO_PLANTILLA_IMPULSO_CPROC;
		} else {
			codigoPlantilla = CODIGO_PLANTILLA_IMPULSO_SPROC;
		}
		
		Map<String, Object> mapaValoresObjetos = new HashMap<String,Object>();
		for (String clave : mapaValoresPrecalculados.keySet()) {
			mapaValoresObjetos.put(clave, mapaValoresPrecalculados.get(clave));
		}
		GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto(tipoEntidad, codigoPlantilla,
				procedimiento.getAsunto().getId(), procedimiento);
		FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class).generarEscritoEditable(
				generarEscritoDto, mapaValoresObjetos);

		//Recuperar el adjunto y devolverlo
		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", procedimiento.getAsunto().getId());
		Order ordenMasReciente = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<AdjuntoAsunto> listaAdjuntos = genericDao.getListOrdered(AdjuntoAsunto.class, ordenMasReciente, filtroAsunto);
		if (listaAdjuntos != null && listaAdjuntos.size() > 0) {
			return listaAdjuntos.get(0).getAdjunto();
		} else {
			return null;
		}
		
	}

	private void renombrarEscritoImpulsoProcesal(Long id, String nombreEscrito) {
		
		Filter filtroIdAdjunto = genericDao.createFilter(FilterType.EQUALS, "adjunto.id", id);
		AdjuntoAsunto aa = genericDao.get(AdjuntoAsunto.class, filtroIdAdjunto);
		if (aa != null) {
			aa.setNombre(nombreEscrito);
			genericDao.save(AdjuntoAsunto.class, aa);
		}

	}

	private Procedimiento obtenerProcedimiento(EXTTareaExterna tareaExterna) {

		Procedimiento procedimiento = null;

		try {
			procedimiento = tareaExterna.getTareaPadre().getProcedimiento();
		} catch (NullPointerException e) {
			Logger.logInfo("[MSVProcesoImpulsoAutomaticoManager] Procedimiento no encontrado para la tarea "
					+ tareaExterna.getId());
		}
		return procedimiento;
	}

	private TipoPlaza obtenerPlaza(EXTTareaExterna tareaExterna) {

		TipoPlaza plaza = null;
		try {
			plaza = tareaExterna.getTareaPadre().getProcedimiento()
					.getJuzgado().getPlaza();
		} catch (NullPointerException e) {
			Logger.logInfo("[MSVProcesoImpulsoAutomaticoManager] Plaza no encontrada para la tarea "
					+ tareaExterna.getId());
		}
		// En caso que no tenga plaza
		if (plaza == null && 
				tareaExterna.getTareaPadre() != null &&
				tareaExterna.getTareaPadre().getProcedimiento() != null) {
			// Obtenemos primera dirección del primer titular
			Direccion direccion = obtenerDireccionPrimerTitular(tareaExterna.getTareaPadre().getProcedimiento());
			// Y a partir del CP, obtenemos la plaza
			if (direccion != null) {
				plaza = obtenerPlazaDesdeDireccion(direccion.getId());
			}
		}

		return plaza;
	}

	private TipoPlaza obtenerPlazaDesdeDireccion(Long idDireccion) {
		String nomPlaza = plazaCodigoDao.obtenerNombrePlazaDeCP(idDireccion);
		TipoPlaza plaza = null;
		if (nomPlaza != null) {
			Filter filtroPlaza = genericDao.createFilter(FilterType.EQUALS, "descripcionLarga", nomPlaza);
			plaza = genericDao.get(TipoPlaza.class, filtroPlaza);
		}
		return plaza;
	}

	private Direccion obtenerDireccionPrimerTitular(Procedimiento proc) {
		Direccion resultado = null;
		if (proc != null && proc.getAsunto() != null
				&& proc.getAsunto().getContratos() != null
				&& proc.getAsunto().getContratos().iterator() != null
				&& proc.getAsunto().getContratos().iterator().next() != null) {
			Contrato contrato = proc.getAsunto().getContratos().iterator().next();
			Persona titular = null;
			List<Direccion> listaDirecciones = null;
			titular = (contrato == null ? null : contrato.getPrimerTitular());
			listaDirecciones = (titular == null ? null : titular.getDirecciones());
			resultado = (listaDirecciones == null ? null
					: (listaDirecciones.size() > 0 ? listaDirecciones.get(0) : null));
		}
		return resultado;
	}

    private boolean makeDir(String rutaFicheros) {
    	
    	boolean ok = true;

    	//Comprobar si existe el directorio, si no crearlo
		File directorio = new File(rutaFicheros);
		if (!directorio.exists()) {
			ok = directorio.mkdirs();
		}
		
		return ok;
    }

    private static void copy(InputStream input, OutputStream output, byte[] buffer) throws IOException {
        int bytesRead;
        while ((bytesRead = input.read(buffer))!= -1) {
            output.write(buffer, 0, bytesRead);
        }
    }

}
