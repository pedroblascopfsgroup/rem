package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoInputAccionDto;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVSelectorResolInputPorBO;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVSelectoresResolInputPorBO;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

@Component
public class MSVResolucionInputManager implements MSVResolucionInputApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired(required = false)
	@Qualifier("selectorProperty")
	private MSVConfigResolucionesProc mapaResolInputProc;

	@Autowired
	GenericABMDao genericDao;

	@Autowired(required = false)
	MSVSelectoresResolInputPorBO mapaSelectoresBO;

	@Autowired
	Executor executor;

	private final String TIENE_PROCURADOR = "tieneProc";

	private String[] camposTieneProc = { TIENE_PROCURADOR };
	private String[] camposSentido = { "sentido", "d_resultadoPositivo",
			"d_tipoComunicacion", "d_tipoArchivo", "d_tipoOficio",
			"d_tipoComunicacion", "d_tipoVista", "d_tipoSent", "d_tipoSentImp",
			"d_tipoPruebaTestifical", "d_tipoDilFin", "d_tipoAudPrev",
			"d_contratoRecibido", "d_tipoEsperarContinuar",
			"d_tipoAverigPatrim", "d_tipoNotEdict", "d_tipoEmb",
			"d_tipoSuspension", "d_tipoAnotEmb", "d_tipoRenovAnotEmb",
			"d_tipoValidarFichero", "d_tipoTasCos", "d_tipoTasCosRes",
			"d_tipoTasCosVist", "d_tipoReqRetPag", "d_tipoReqRetPagConf",
			"d_tipoTasCosImp", "d_tipoTasCosResVis", "d_tipoLiqInt",
			"d_tipoLiqIntVist", "d_tipoLiqIntResVis", "d_tipoLiqIntResImp",
			"d_tipoLiqIntImp" ,"d_alegInfAdmConcurs" ,"d_tipoResultProp", "d_tipoInformeConResult",
			"d_tipoInfSeccCalif", "d_conforme","d_notificado", "d_admision", "d_resultadoNotificacion", 
			"d_existeOposicion", "d_resultadoResolucionHip"};
	private String[] camposCompleto = { "completo", "d_demandaTotal",
			"d_requerimientoTotal", "d_tipoConsigna", "d_tipoAllanamiento",
			"d_tipoJustGratuita", "d_tipoComparecencia", "d_tipoAude","d_tipoEscrAlegImp" ,
			"d_tasacionCostasTotal", "d_liquidacionInteresesTotal", "d_existeComparecencia", "d_subsanacion"};
	private String[] camposConNuevaFecha ={"conNuevaFecha", "d_fecNuevSeny"};
	private String[] camposRespuesta = { "respuesta", "importeMayor" };
	private String[] camposNotificacion = { "notificacion" };
	private String[] tramiteEmbargo = { "tramiteEmbargo" };

	@Override
	@BusinessOperation(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_PRC)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesProcedimiento(Long idProcedimiento) {
		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		
		if (mapaResolInputProc != null && mapaResolInputProc.getMapaConfigResoluciones() != null) {
			Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			if (!Checks.esNulo(prc)){
				List<String> nodos = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(prc.getProcessBPM());
				if (!Checks.estaVacio(nodos)) {
					String codigoNodo = nodos.get(0);
					String codigoTipoProc = prc.getTipoProcedimiento().getCodigo();
					if (codigoNodo != null && codigoTipoProc != null && mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc) != null) {
						mapaResultados = getTiposResoluciones(codigoNodo, codigoTipoProc);
					}
				}
			 }
		} 
		
		// Retornar set de resultados
		return new HashSet<MSVTipoResolucionDto>(mapaResultados.values());
	}
		
	@Override
	@BusinessOperation(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_SIN_TAREA)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesSinTarea(Long idProcedimiento) {
		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		
		if (mapaResolInputProc != null && mapaResolInputProc.getMapaConfigResoluciones() != null) {
			Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			if (!Checks.esNulo(prc)){
				String codigoTipoProc = prc.getTipoProcedimiento().getCodigo();
				if (codigoTipoProc != null && mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc) != null) {
					mapaResultados = getTiposResoluciones(MSV_NODO_SIN_TAREAS, codigoTipoProc);
				}
			} 
		}
		
		// Retornar set de resultados
		return new HashSet<MSVTipoResolucionDto>(mapaResultados.values());
	}
	
	@Override
	@BusinessOperation(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesTareas(Long idTarea) {

		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		
		// Instanciar la tarea a partir del id que se ha pasado
		TareaExterna tarea = proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		if (tarea != null && mapaResolInputProc != null && mapaResolInputProc.getMapaConfigResoluciones() != null) {
			// Obtener el nodo y el tipo de procedimiento a partir de la tarea
			String codigoNodo = tarea.getTareaProcedimiento().getCodigo();
			String codigoTipoProc = tarea.getTareaProcedimiento().getTipoProcedimiento().getCodigo();

			if (codigoNodo != null && codigoTipoProc != null && mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc) != null) {
				mapaResultados = getTiposResoluciones(codigoNodo, codigoTipoProc);
			}
		}

		// Retornar set de resultados
		return new HashSet<MSVTipoResolucionDto>(mapaResultados.values());
		
	}
	
	@Override
	@BusinessOperation(MSV_BO_OBTENER_TIPOS_RESOLUCIONES_TAREA_COUNT)
	public Set<MSVTipoResolucionDto> obtenerTiposResolucionesTareasCount(Long idTarea) {

		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		
		// Instanciar la tarea a partir del id que se ha pasado
		TareaExterna tarea = proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
		if (tarea != null && mapaResolInputProc != null && mapaResolInputProc.getMapaConfigResoluciones() != null) {
			// Obtener el nodo y el tipo de procedimiento a partir de la tarea
			String codigoNodo = tarea.getTareaProcedimiento().getCodigo();
			String codigoTipoProc = tarea.getTareaProcedimiento().getTipoProcedimiento().getCodigo();

			if (codigoNodo != null && codigoTipoProc != null && mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc) != null) {
				mapaResultados = getTiposResolucionesCount(codigoNodo, codigoTipoProc);
			}
		}

		// Retornar set de resultados
		return new HashSet<MSVTipoResolucionDto>(mapaResultados.values());
		
	}

	private Map<String, MSVTipoResolucionDto> getTiposResoluciones(String codigoNodo, String codigoTipoProc) {
		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		MSVResolucionApi resolucionApi = proxyFactory.proxy(MSVResolucionApi.class);

		// Recorrer tabla de relaciones procedimiento e input para el procedimiento,
		// devolviendo aquellos tipos de inputs que cumplen las condiciones de pertenencia
		List<MSVTipoInputAccionDto> listaRelaciones = obtenerListaRelaciones(codigoNodo, codigoTipoProc);
					
		// A partir de la lista de inputs, recorrer el mapa obtenido a partir
		// del XML y si el input es una alternativa del tipo de resolución
		// añadir el tipo de resolucion a la lista de resultados
		Map<String, List<MSVConfigResolInput>> mapaResoluciones = mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc).getMapaTiposResoluciones();
		
		for (MSVTipoInputAccionDto msvTipoInputAccionDto : listaRelaciones) {
			for (String codigoTipoResolucion : mapaResoluciones.keySet()) {
				for (MSVConfigResolInput config : mapaResoluciones.get(codigoTipoResolucion)) {
					String codigoTipoInputXML = config.getCodigoInput();
					String codigoTipoInputBD = msvTipoInputAccionDto.getCodigoTipoInput();
					if (codigoTipoInputXML.equalsIgnoreCase(codigoTipoInputBD)) {
						MSVDDTipoResolucion tipoResolucion = resolucionApi.getTipoResolucionPorCodigo(codigoTipoResolucion);
						MSVTipoResolucionDto dtoTipoResol;
						// Si el set ya contiene un dto con el mismo tipo de resolución, lo sustituimos por uno
						// nuevo con un tipo de acción más prioritario (INFO < FORWARD < ADVANCE)
						String codTipoResolucion = tipoResolucion.getCodigo();
						if (mapaResultados.containsKey(codTipoResolucion)) {
							dtoTipoResol = mapaResultados.get(codTipoResolucion);
							dtoTipoResol.setCodigoTipoAccion(msvTipoInputAccionDto.getCodigoTipoAccion());
						} else {
							dtoTipoResol = new MSVTipoResolucionDto();
							dtoTipoResol.setIdTipoResolucion(tipoResolucion.getId());
							dtoTipoResol.setCodigoTipoResolucion(tipoResolucion.getCodigo());
							dtoTipoResol.setDescripcionTipoResolucion(tipoResolucion.getDescripcion());
							dtoTipoResol.setCodigoTipoAccion(msvTipoInputAccionDto.getCodigoTipoAccion());
						}
						mapaResultados.put(codTipoResolucion, dtoTipoResol);
						break;
					}
				}
			}
		}
		return mapaResultados;
	}
	
	/**
	 * Como máximo devuelve 2 resultados. Esto se utiliza para esconder el combo o no de resoluciones de la pestaña de tareas 
	 * de los procedimientos.
	 * @param codigoNodo
	 * @param codigoTipoProc
	 * @return
	 */
	private Map<String, MSVTipoResolucionDto> getTiposResolucionesCount(String codigoNodo, String codigoTipoProc) {
		Map<String, MSVTipoResolucionDto> mapaResultados = new HashMap<String, MSVTipoResolucionDto>();
		MSVResolucionApi resolucionApi = proxyFactory.proxy(MSVResolucionApi.class);

		// Recorrer tabla de relaciones procedimiento e input para el procedimiento,
		// devolviendo aquellos tipos de inputs que cumplen las condiciones de pertenencia
		List<MSVTipoInputAccionDto> listaRelaciones = obtenerListaRelaciones(codigoNodo, codigoTipoProc);
					
		// A partir de la lista de inputs, recorrer el mapa obtenido a partir
		// del XML y si el input es una alternativa del tipo de resolución
		// añadir el tipo de resolucion a la lista de resultados
		Map<String, List<MSVConfigResolInput>> mapaResoluciones = mapaResolInputProc.getMapaConfigResoluciones().get(codigoTipoProc).getMapaTiposResoluciones();
		
		for (MSVTipoInputAccionDto msvTipoInputAccionDto : listaRelaciones) {
			for (String codigoTipoResolucion : mapaResoluciones.keySet()) {
				for (MSVConfigResolInput config : mapaResoluciones.get(codigoTipoResolucion)) {
					String codigoTipoInputXML = config.getCodigoInput();
					String codigoTipoInputBD = msvTipoInputAccionDto.getCodigoTipoInput();
					if (codigoTipoInputXML.equalsIgnoreCase(codigoTipoInputBD)) {
						if(mapaResultados.size()<2){
							MSVDDTipoResolucion tipoResolucion = resolucionApi.getTipoResolucionPorCodigo(codigoTipoResolucion);
							MSVTipoResolucionDto dtoTipoResol;
							// Si el set ya contiene un dto con el mismo tipo de resolución, lo sustituimos por uno
							// nuevo con un tipo de acción más prioritario (INFO < FORWARD < ADVANCE)
							String codTipoResolucion = tipoResolucion.getCodigo();
							if (mapaResultados.containsKey(codTipoResolucion)) {
								dtoTipoResol = mapaResultados.get(codTipoResolucion);
								dtoTipoResol.setCodigoTipoAccion(msvTipoInputAccionDto.getCodigoTipoAccion());
							} else {
								dtoTipoResol = new MSVTipoResolucionDto();
								dtoTipoResol.setIdTipoResolucion(tipoResolucion.getId());
								dtoTipoResol.setCodigoTipoResolucion(tipoResolucion.getCodigo());
								dtoTipoResol.setDescripcionTipoResolucion(tipoResolucion.getDescripcion());
								dtoTipoResol.setCodigoTipoAccion(msvTipoInputAccionDto.getCodigoTipoAccion());
							}
							mapaResultados.put(codTipoResolucion, dtoTipoResol);
							if(mapaResultados.size()==2){return mapaResultados;}
							break;
						}
					}
				}
			}
		}
		return mapaResultados;
	}
	
	
	/**
	 * Método que devuelve el tipo de input correspondiente al Tipo de resolución según los datos introducidos.
	 * 
	 * Modificado para que tenga en cuenta una posible función de negocio que pueda determinar el tipo de input según
	 * criterios más complejos
	 * 
	 */
	@Override
	@BusinessOperation(MSV_BO_OBTENER_INPUT_DESDE_RESOLUCION)
	public String obtenerTipoInputParaResolucion(Long idProc,
			String codigoTipoProc, String codigoTipoResolucion,
			Map<String, String> valores) {

		String tipoInput = null;
		if (!Checks.esNulo(mapaSelectoresBO)
				&& mapaSelectoresBO.getMapaSelectoresBO().containsKey(
						codigoTipoResolucion)) {
			MSVSelectorResolInputPorBO selector = mapaSelectoresBO
					.getMapaSelectoresBO().get(codigoTipoResolucion);
			String nombreBO = selector.getNombreBO();
			List<String> listaCodigoTipoInputs = selector
					.getListaCodigosInput();
			String tieneProcurador = "";
			if (valores.containsKey(TIENE_PROCURADOR)) {
				tieneProcurador = valores.get(TIENE_PROCURADOR);
			}
			tipoInput = (String) executor.execute(nombreBO, idProc,
					listaCodigoTipoInputs, tieneProcurador, valores);
		} else if (mapaResolInputProc != null) {
			// Recorrer mapa obtenido a partir del XML y comprobar los valores
			// recibidos en el mapa de valores
			// comparándolos con los valores del mapa
			// Si cumple, se devuelve el input correspondiente
			Map<String, List<MSVConfigResolInput>> mapaResoluciones = mapaResolInputProc
					.getMapaConfigResoluciones().get(codigoTipoProc)
					.getMapaTiposResoluciones();
			MSVConfigResolInput alternativaAComparar = new MSVConfigResolInput();
			for (String key : valores.keySet()) {
				if (esTieneProcurador(key)) {
					alternativaAComparar.setTieneProcurador(valores.get(key));
				}
				if (esNotificacion(key)) {
					alternativaAComparar.setNotificacion(valores.get(key));
				}
				if (esTramiteEmbargo(key)) {
					alternativaAComparar.setTramiteEmbargo(valores.get(key));
				}
				if (esSentido(key)) {
					alternativaAComparar.setSentido(valores.get(key));
				}
				if (esCompleto(key)) {
					alternativaAComparar.setCompleto(valores.get(key));
				}
				if (esCamposConNuevaFecha(key)){
					alternativaAComparar.setConNuevaFecha(valores.get(key));
				}
				if (esRespuesta(key)) {
					alternativaAComparar.setRespuesta(valores.get(key));
				}
				if (esTramiteEmbargo(key)) {
					alternativaAComparar.setTramiteEmbargo(valores.get(key));
				} 
				if (esCamposConNuevaFecha(valores.get(key))) {
					alternativaAComparar.setConNuevaFecha(valores.get(key));
				} 
			}
			for (MSVConfigResolInput config : mapaResoluciones
					.get(codigoTipoResolucion)) {
				if (alternativaAComparar.compatible(config)) {
					tipoInput = config.getCodigoInput();
					break;
				}
			}
		}

		if (tipoInput == null)
			throw new BusinessOperationException(
					"\nNo se encontro un tipo de input en la configuracion XML que cumpla con los datos de entrada.(codigoTipoProc, codigoTipoResolucion, valores)\n",
					codigoTipoProc, codigoTipoResolucion, valores);
		return tipoInput;
	}

	private boolean esCamposConNuevaFecha(String key) {
		return esTipoCampo(key, camposConNuevaFecha);
	}

	private boolean esRespuesta(String key) {
		return esTipoCampo(key, camposRespuesta);
	}

	private boolean esCompleto(String key) {
		return esTipoCampo(key, camposCompleto);
	}

	private boolean esSentido(String key) {
		return esTipoCampo(key, camposSentido);
	}

	private boolean esTieneProcurador(String key) {
		return esTipoCampo(key, camposTieneProc);
	}

	private boolean esNotificacion(String key) {
		return esTipoCampo(key, camposNotificacion);
	}

	private boolean esTramiteEmbargo(String key) {
		return esTipoCampo(key, tramiteEmbargo);
	}

	private boolean esTipoCampo(String key, String[] campos) {
		if (!Checks.esNulo(key)){
			for (int i = 0; i < campos.length; i++) {
				if (key.equalsIgnoreCase(campos[i]))
					return true;
			}
		}
		
		return false;
	}

	@Override
	@BusinessOperation(MSV_BO_OBTENER_TIPO_INPUT_DESDE_NODO)
	public boolean obtenerInputParaNodo(String codigoNodo,
			RecoveryBPMfwkTipoProcInput tipoProcInput) {

		// Se hace la consulta en la tabla y si se dan las condiciones de
		// pertenencia se devuelve el tipo de input

		// String nodosIncluidos = tipoProcInput.getNodesIncluded();
		// String nodosExcluidos = tipoProcInput.getNodesExcluded();
		// boolean resultado = false;
		//
		// if (nodosIncluidos.indexOf(codigoNodo) >= 0) {
		// resultado = true;
		// } else if ((nodosIncluidos.indexOf("ALL") >= 0)
		// && (nodosExcluidos.indexOf(codigoNodo) < 0)) {
		// resultado = true;
		// }

		return tipoProcInput.contieneElNodo(codigoNodo);
	}

	private List<MSVTipoInputAccionDto> obtenerListaRelaciones(String codigoNodo, String codigoTipoProc) {

		List<RecoveryBPMfwkTipoProcInput> listaRelaciones = new ArrayList<RecoveryBPMfwkTipoProcInput>();
		List<MSVTipoInputAccionDto> listaRelacionesResultado = new ArrayList<MSVTipoInputAccionDto>();

		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", codigoTipoProc);

		listaRelaciones = genericDao.getList(RecoveryBPMfwkTipoProcInput.class,	f1);

		for (RecoveryBPMfwkTipoProcInput tipoProcInput : listaRelaciones) {
			if (obtenerInputParaNodo(codigoNodo, tipoProcInput)) {
				MSVTipoInputAccionDto dto = new MSVTipoInputAccionDto();
				dto.setCodigoTipoInput(tipoProcInput.getTipoInput().getCodigo());
				dto.setCodigoTipoAccion(tipoProcInput.getTipoAccion()
						.getCodigo());
				listaRelacionesResultado.add(dto);
			}
		}

		return listaRelacionesResultado;

	}

	@Override
	@BusinessOperation(MSV_BO_OBTENER_RESOLUCION_DESDE_INPUT)
	public String obtenerTipoResolucionDeInput(String codigoTipoProc,
			String codigoTipoInput) {

		String tipoResolucion = null;
		if (mapaResolInputProc != null) {
			// Recorrer mapa obtenido a partir del XML y comprobar los valores
			// recibidos en el mapa de valores
			// comparándolos con los valores del mapa
			// Si cumple, se devuelve el input correspondiente
			Map<String, List<MSVConfigResolInput>> mapaResoluciones = mapaResolInputProc
					.getMapaConfigResoluciones().get(codigoTipoProc)
					.getMapaTiposResoluciones();

			Entry<String, List<MSVConfigResolInput>> configResolucion = null;
			Iterator<Entry<String, List<MSVConfigResolInput>>> it = mapaResoluciones
					.entrySet().iterator();
			while (it.hasNext()) {
				configResolucion = (Entry<String, List<MSVConfigResolInput>>) it
						.next();

				for (MSVConfigResolInput config : configResolucion.getValue()) {
					if (codigoTipoInput.equals(config.getCodigoInput())) {
						tipoResolucion = configResolucion.getKey();
						break;
					}
				}
				if (!Checks.esNulo(tipoResolucion))
					break;
			}
		}
		if (tipoResolucion == null)
			throw new BusinessOperationException(
					"\nNo se encontro un tipo de resolucion en la configuracion XML que cumpla con los datos de entrada.(codigoTipoProc, codigoTipoInput)\n",
					codigoTipoProc, codigoTipoInput);
		return tipoResolucion;
	}

	public MSVConfigResolucionesProc getMapaResolInputProc() {
		return mapaResolInputProc;
	}

	public void setMapaResolInputProc(
			MSVConfigResolucionesProc mapaResolInputProc) {
		this.mapaResolInputProc = mapaResolInputProc;
	}
}
