package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.genericlistener.GenerarTransicionListener;
import es.pfsgroup.plugin.rem.api.ActivoRequisitoTareaApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTareasManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationService;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationServiceFactoryApi;
import es.pfsgroup.plugin.rem.model.ActivoRequisitoTarea;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CampoTareaNoEncontradaException;

public class ActivoGenericEnterActionHandler extends ActivoGenericActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;

	private TipoCalculo tipoCalculoVencimiento = null;
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaManagerApi;
	
	@Autowired
	ActivoRequisitoTareaApi activoRequisitoTareaApi;
	
	@Autowired
	JBPMActivoTareasManagerApi jbpmActivoTareasManagerApi;
	
	@Autowired
	private List<GenerarTransicionListener> listeners;

	@Autowired
	PlazoAssignationServiceFactoryApi plazoAssignationServiceFactoryApi;

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @param delegateTransitionClass
	 *            delegateTransitionClass
	 * @param delegateSpecificClass
	 *            delegateSpecificClass
	 * @throws Exception
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
		printInfoNode("Entra nodo", executionContext);
		TareaExternaApi tareaExternaManager = proxyFactory.proxy(TareaExternaApi.class);

		// Cambiamos el nombre de la variable listado de tareas para que no se
		// solapen los nodos en un fork
		Object listadoTareas = getVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS, executionContext);
		if (listadoTareas != null) {
			setVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + getNombreNodo(executionContext), listadoTareas, executionContext);
			setVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS, null, executionContext);
		}

		if (debeCrearTareaProcedimiento(executionContext)) {
		
			generaTransicionesAutomaticas(executionContext);
			Long idTarea = procesarTarea(executionContext);
			generarTimerTareaActivo(idTarea, executionContext);
			asignaUsuario(idTarea);

			if (tieneProcesoBpmAsociado(executionContext)) {
				lanzaNuevoBpmHijo(executionContext);

				// No se quiere ver la tarea de lanzado un BPM externo
				tareaExternaManager.borrar(tareaExternaManager.get(idTarea));
			}

			generaTrancisionesDeAlerta(executionContext); // Necesita de la
															// fecha de
															// vencimiento de la
															// tarea
			
			
			enviaNotificacion(idTarea);
		}

		// Llamamos al nodo genérico de transición
		if (delegateTransitionClass != null && delegateTransitionClass instanceof ActivoJBPMEnterEventHandler) {
			((ActivoJBPMEnterEventHandler) delegateTransitionClass).onEnter(executionContext);
		}

		// Llamamos al nodo específico
		if (delegateSpecificClass != null && delegateSpecificClass instanceof ActivoJBPMEnterEventHandler) {
			((ActivoJBPMEnterEventHandler) delegateSpecificClass).onEnter(executionContext);
		}
		
		
	}
	
	/**
	 * Genera transiciones automáticamente en los nodos, sólo si no existen.
	 * Para crear una transición impementar la interfaz {@link GenerarTransicionListener}
	 * 
	 * @param executionContext ExecutionContext
	 */
	private void generaTransicionesAutomaticas(ExecutionContext executionContext) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(GenerarTransicionListener.CLAVE_EXECUTION_CONTEXT, executionContext);
		
		//Ejecutamos los listeners que generan transiciones automáticas.
		if (listeners != null) {
			for (GenerarTransicionListener l : listeners) {
				l.fireEvent(map);
			}
		}
	}
	
	
	

	/**
	 * PONER JAVADOC FO.
	 */
	protected void generaTrancisionesDeAlerta(ExecutionContext executionContext) {
		if (existeTransicionDeAlerta(executionContext) && !existeTimerDeAlerta(executionContext)) {
			creaTimerDeAlerta(getTareaExterna(executionContext).getTareaPadre(), executionContext);
			if (logger.isDebugEnabled()) {
				logger.debug("\tCreamos timer de alerta para esta tarea");
			}
		}
	}

	/***
	 * 
	 * Crea y lanza una excepción {@link CampoTareaNoEncontradaException} para
	 * poder completar los datos que faltan
	 * 
	 * @param tokenIdBPM
	 *            identificador del bpm que se esta ejecutando
	 * @param idProcedimiento
	 *            Identificador del procedimiento
	 * @param requisitoTarea
	 *            RequisitoTarea que no se ha cumplido
	 * 
	 * @throws CampoTareaNoEncontradaException
	 * 
	 * **/
	private void lanzarExcepcionPlazoTarea(Long tokenIdBPM, Long idActivoTramite, ActivoRequisitoTarea requisitoTarea) throws Exception {
		String tarea = "";
		String tareaDescripcion = "";
		String campoDescripcion = "";
		String campo = "";
		Long idTareaExterna = 0L;
		try {

			tarea = requisitoTarea.getTareaProcedimientoRequerida().getCodigo();
			tareaDescripcion = requisitoTarea.getTareaProcedimientoRequerida().getDescripcion();
			campo = requisitoTarea.getCampoRequerido().getNombre();
			campoDescripcion = requisitoTarea.getCampoRequerido().getLabel();

			//List<TareaExterna> lista = (List<TareaExterna>) executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO, idProcedimiento);
			List<TareaExterna> lista =  activoTareaExternaManagerApi.getTareasByIdTramite(idActivoTramite);
					
			for (TareaExterna tax : lista) {
				if (tax.getTareaProcedimiento().getCodigo().equalsIgnoreCase(tarea) && idTareaExterna < tax.getId())
					idTareaExterna = tax.getId();
			}

		} catch (Exception e2) {
			throw new UserException("bpm.error.script");
		}

		throw new CampoTareaNoEncontradaException(campoDescripcion, tareaDescripcion, idTareaExterna, tokenIdBPM, idActivoTramite, campo, tarea);
	}

	/**
	 * Crea una tarea externa en BD.
	 * 
	 * @throws Exception
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	private Long procesarTarea(ExecutionContext executionContext) throws Exception {

		TareaExternaApi tareaExternaManager = proxyFactory.proxy(TareaExternaApi.class);

		// Recogemos el procedimiento del contexto
		ActivoTramite activoTramite = this.getActivoTramite(executionContext);
		//Procedimiento procedimiento = getProcedimiento(executionContext);
		Long idActivoTramite = activoTramite.getId();

		// Buscamos la tarea perteneciente a ese procedimiento con el código
		// tarea y el idTipoProcedimiento y extraemos su ID tarea
		TareaProcedimiento tareaProcedimiento = this.getTareaProcedimiento(executionContext);

		Long idTareaProcedimiento = tareaProcedimiento.getId();

		// comprobamos que se cumplen los requisitos de plazos siempre que no
		// estemos ante una reentrada
		boolean reentrada = this.detectaReentrada(executionContext);
		if (!reentrada) {
			ActivoRequisitoTarea requisito = activoRequisitoTareaApi.existeRequisito(idTareaProcedimiento);
			if (requisito != null) {
				//TODO: este método no va a funcionar porque usa el procedimiento padre.
				
				boolean cumpleRequisito = activoRequisitoTareaApi.comprobarRequisito(requisito, idActivoTramite);
				if (!cumpleRequisito) {
					lanzarExcepcionPlazoTarea(getTokenId(executionContext), idActivoTramite, requisito);
				}
			}
		}
		String nombreTarea = tareaProcedimiento.getDescripcion();

		// Creamos una nueva tarea extendida con el idProcedimiento y el
		// idTipoTarea y el timer asociado
		// Por defecto la tarea será para un gestor
		
		
		//TODO:aqui se elige el subtipo de tarea. Hay que adaptarlo a los activos. 
		String subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR;

		// Si está marcada como supervisor se cambia el subtipo tarea
		if (tareaProcedimiento.getSupervisor()) {
			subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR;
		}

		// DIANA -- NUEVOS PROCEDIMIENTOS ASIGNADOS A OTRO TIPO DE GESTOR
		// verificamos que la tarea no sea de otro tipo de gestor

		if (tareaProcedimiento instanceof EXTTareaProcedimiento) {
			EXTTareaProcedimiento tp = (EXTTareaProcedimiento) tareaProcedimiento;

			if (!Checks.esNulo(tp.getSubtipoTareaNotificacion())) {
				subtipoTarea = tp.getSubtipoTareaNotificacion().getCodigoSubtarea();
			} else {

				if (!Checks.esNulo(tp.getTipoGestor())) {
					if ((tp.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP))) {
						subtipoTarea = EXTSubtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE;
					}
					if ((tp.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP))) {
						subtipoTarea = EXTSubtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE;
					}

				}
			}
		}

//		TipoJuzgado juzgado = null;
//		TipoPlaza plaza = null;
//
//		juzgado = procedimiento.getJuzgado();
//		if (juzgado != null)
//			plaza = juzgado.getPlaza();
//
//		Long idTipoPlaza = null;
//		Long idTipoJuzgado = null;
//
//		if (juzgado != null)
//			idTipoJuzgado = juzgado.getId();
//		if (plaza != null)
//			idTipoPlaza = plaza.getId();

		//Long plazoTarea = getPlazoTareaPorTipoTarea(idTipoPlaza, idTareaProcedimiento, idTipoJuzgado, idProcedimiento, getTokenId(executionContext));
		
		//Long plazoTarea = jbpmActivoTareasManagerApi.getPlazoTarea(idTareaProcedimiento, idActivoTramite);
		
    	PlazoAssignationService plazoAssignationService = plazoAssignationServiceFactoryApi.getService(tareaProcedimiento.getCodigo());
		Long plazoTarea = plazoAssignationService.getPlazoTarea(idTareaProcedimiento, idActivoTramite);
		
		
		HashMap<String, Object> valores = new HashMap<String, Object>();
		valores.put("codigoSubtipoTarea", subtipoTarea);
		valores.put("plazo", plazoTarea);
		valores.put("descripcion", nombreTarea);
		valores.put("idProcedimiento", idActivoTramite);
		valores.put("idActivoTramite", idActivoTramite);
		valores.put("idTareaProcedimiento", idTareaProcedimiento);
		valores.put("tokenIdBpm", getTokenId(executionContext));
		valores.put("tipoCalculo", TipoCalculo.NO_SALTAR_AGOSTO);
		
		EXTDtoCrearTareaExterna dto = new ActivoDtoCrearTareaExterna(valores);
		//EXTDtoCrearTareaExterna dto = DynamicDtoUtils.create(EXTDtoCrearTareaExterna.class, valores);
		Long idTarea = tareaExternaManager.crearTareaExternaDto(dto);

		// Si el BPM está detenido, detenemos la nueva tarea creada
		if (isBPMDetenido(executionContext)) {
			tareaExternaManager.detener(tareaExternaManager.get(idTarea));
		}

		// Guardamos el id de la tarea externa de este nodo por si
		// necesit�ramos recuperarla posteriormente (generalmente en timers)
		// NOTA. Si pasa dos veces por el mismo nodo se quedar� la �ltima ID
		// de tarea (no pasa nada porque no habr�n dos tareas iguales
		// ejecutandose en paralelo)
        //NOTA2. La NOTA no es cierto. Cuando tenemos tareas replicadas no recupera bien el Id de la tarea externa que corresponde al contexto BPM en el que estamos. 
        // Dado que la variable idNombreTarea se va reemplazando cada vez que se inicia la misma tarea y por eso se queda con la última.
        // Ahora se guarda una variable por cada tarea-token de modo que tendremos una variable por cada instancia de la tarea Externa.
		// Mantengo la anterior forma por si se utiliza en algún otro punto de la aplicación como timers.
        String varName = String.format("id%s.%d", getNombreNodo(executionContext), getTokenId(executionContext));
		setVariable(varName, idTarea, executionContext);

		if (logger.isDebugEnabled()) {
			logger.debug("\tCreamos la tarea: " + getNombreNodo(executionContext));
		}

		return idTarea;
	}
	
//	/**
//	 * Método que indica si se han de derivar al nuevo procedimiento los bienes
//	 * asociados en el procedimiento padre. 
//	 */
//	private boolean isTramitesExcluidos(ExecutionContext executionContext) {
//		
//		/**
//		 * Para el caso de subasta BANKIA y subasta SAREB, en caso de venir de
//		 * la tarea registrar acta de subasta, NO se deben derivar los bienes,
//		 * ya que existe otro método de asignar los bienes asociados
//		 * correspondientes
//		 */
//		if(executionContext.getNode().getName().contains("BPMTramiteAdjudicacionV4")){
//			return true;
//		}
//		
//		return false;
//	}

	/**
	 * @param tipoCalculoVencimiento the tipoCalculoVencimiento to set
	 * @throws Exception 
	 */
	public void setTipoCalculoVencimiento(String tipoCalculoVencimiento) throws IllegalArgumentException {
		try {
			this.tipoCalculoVencimiento = TipoCalculo.valueOf(tipoCalculoVencimiento);
		} catch (IllegalArgumentException e) {
			logger.error("El tipoCalculo configurado no existe, los disponibles son: " + Arrays.deepToString(TipoCalculo.values()));
			throw e;
		}
	}
}
