package es.pfsgroup.plugin.recovery.masivo;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.expediente.EventoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVHistoricoTareasApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistItemResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoAsuntoViewDtoComparator;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoAsuntoViewDtoComparator.MSVNullsOrder;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoAsuntoViewDtoComparator.MSVSortOrder;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaAsuntoDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVHistoricoTareaDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesBatch;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDatoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procesosJudiciales.model.EXTTipoJuzgado;

@Component
public class MSVHistoricoTareasManager implements MSVHistoricoTareasApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private TipoProcedimientoDao tipoProcedimientoDao;

	@Autowired
	private MSVConfigResolucionesBatch mapaResolInputBatch;
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	@BusinessOperation(MSV_GET_HTCO_BY_TAR)
	public List<MSVHistoricoTareaDto> getHistoricoPorTareas(Long idProcedimiento) throws IllegalAccessException, InvocationTargetException {
		
		List<EXTHistoricoProcedimiento> lstEXTHistoricoProcedimiento = proxyFactory.proxy(EXTHistoricoProcedimientoApi.class).getListByProcedimientoEXT(idProcedimiento);
		List<MSVHistoricoTareaDto> msvHistoricoTareasDto = getHistoricoTareas(lstEXTHistoricoProcedimiento); 
		
		return msvHistoricoTareasDto;
	}

	
	private List<MSVHistoricoTareaDto> getHistoricoTareas(List<EXTHistoricoProcedimiento> lstEXTHistoricoProcedimiento) throws IllegalAccessException, InvocationTargetException {

		List<MSVHistoricoTareaDto> msvHistoricoTareasDto = new ArrayList<MSVHistoricoTareaDto>();
		
		for (EXTHistoricoProcedimiento extHistoricoProcedimiento : lstEXTHistoricoProcedimiento) {
			MSVHistoricoTareaDto msvHistoricoTareaDto = new MSVHistoricoTareaDto();
			BeanUtils.copyProperties(msvHistoricoTareaDto, extHistoricoProcedimiento);

			msvHistoricoTareaDto.setUsuario(usuarioManager.getByUsername(msvHistoricoTareaDto.getNombreUsuario()));
		
			if ((HistoricoProcedimiento.TIPO_ENTIDAD_TAREA.equals(msvHistoricoTareaDto.getTipoEntidad()) 
					&& (!Checks.esNulo(msvHistoricoTareaDto.getIdEntidad())))) {
				TareaNotificacion tareaNotificacion = proxyFactory.proxy(TareaNotificacionApi.class).get(msvHistoricoTareaDto.getIdEntidad()); 
				Long tareaExternaId = tareaNotificacion.getTareaExterna().getId();
				
				if (!Checks.esNulo(tareaExternaId))	msvHistoricoTareaDto.setResoluciones(buscaResolucion(tareaExternaId));
				
				msvHistoricoTareasDto.add(msvHistoricoTareaDto);
			} else if (!Checks.esNulo(msvHistoricoTareaDto.getIdEntidad())) {
				msvHistoricoTareasDto.add(msvHistoricoTareaDto);
			} 
		}
		
		return msvHistoricoTareasDto;
	}
	
	@Override
	@BusinessOperation(MSV_GET_HTCO_BY_RES)
	public List<MSVHistoricoResolucionDto> getHistoricoPorResolucion(Long idProcedimiento) throws IllegalAccessException, InvocationTargetException {
		List<MSVHistoricoResolucionDto> msvHistoricoResolucionesDto = new ArrayList<MSVHistoricoResolucionDto>();
		
		
		String codigoTipoProc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento).getTipoProcedimiento().getCodigo();
		
		List<RecoveryBPMfwkInput> inputs = proxyFactory.proxy(RecoveryBPMFwkProcessApi.class).getInputsForPrc(idProcedimiento);
		for (RecoveryBPMfwkInput input : inputs) {
			MSVHistoricoResolucionDto msvHistoReso = setHistoricoResolucionDto(codigoTipoProc, input);
			if (!Checks.esNulo(msvHistoReso)) {
				msvHistoricoResolucionesDto.add(msvHistoReso);
			}
		}
		
		return msvHistoricoResolucionesDto;
	}

	
	
	public List<MSVHistoricoResolucionDto> buscaResolucion(Long idTareaExterna) {
		List<MSVHistoricoResolucionDto> msvHistoricoResolucionesDto = new ArrayList<MSVHistoricoResolucionDto>();

		TareaExterna tarea = proxyFactory.proxy(TareaExternaApi.class).get(idTareaExterna);
		String codigoTipoProc = tarea.getTareaPadre().getProcedimiento().getTipoProcedimiento().getCodigo();
		
		List<RecoveryBPMfwkInput> inputs = proxyFactory.proxy(RecoveryBPMfwkInputsTareasApi.class).getInputsByTarea(idTareaExterna);
		
		for (RecoveryBPMfwkInput input : inputs) {
			msvHistoricoResolucionesDto.add(setHistoricoResolucionDto(codigoTipoProc, input));
		}
		return msvHistoricoResolucionesDto;
	}

	/**
	 * Obitiene el tipo de Resolucion a partir del código del input y código procedimiento
	 * @return
	 */
	private MSVDDTipoResolucion getTipoResolucion(String codigoTipoProc, String codigoInput) {
		String codTipoResolucion = "";
		if (isTipoInputBatch(codigoInput)) {
			//Buscar tipo de resolución a partir de tipo de input batch
			codTipoResolucion = obtenerTipoResolucionDeInputBatch(codigoInput);
		} else {
			//Buscar tipo de resolución a partir de fichero XML de mapeo de inputs/resoluciones
			codTipoResolucion = proxyFactory.proxy(MSVResolucionInputApi.class).obtenerTipoResolucionDeInput(codigoTipoProc, codigoInput);
		}
		if (codTipoResolucion == null || "".equals(codTipoResolucion)) {
			return null;
		} else {
			return proxyFactory.proxy(MSVResolucionApi.class).getTipoResolucionPorCodigo(codTipoResolucion);
		}
	}
	
	/**
	 * Recupera código de resolución asociado al código de tipo de input que se pasa como parámetro
	 * (sirve sólo para los inputs de tipo Batch
	 * @param codigoInput
	 * @return String código de resolución asociado al tipo de input 
	 */
	private String obtenerTipoResolucionDeInputBatch(String codigoInput) {
		return (mapaResolInputBatch.getMapaConfigResolucionesBatch().get(codigoInput));
	}


	/**
	 * Comprueba si el input introducido es de tipo Batch
	 * @param codigoInput
	 * @return
	 */
	private boolean isTipoInputBatch(String codigoInput) {
		return (mapaResolInputBatch.getMapaConfigResolucionesBatch().containsKey(codigoInput));
	}


	/**
	 * Rellena el dto de historicoResoluciones
	 * @param codigoTipoProc
	 * @param input
	 * @return
	 */
	private MSVHistoricoResolucionDto setHistoricoResolucionDto(String codigoTipoProc, RecoveryBPMfwkInput input) {
		MSVHistoricoResolucionDto msvHistoricoResolucionDto = new MSVHistoricoResolucionDto();
		msvHistoricoResolucionDto.setId(input.getId());
		
		try {
			msvHistoricoResolucionDto.setTipo(getTipoResolucion(codigoTipoProc, input.getTipo().getCodigo()));		
			TipoProcedimiento tipoPrc = tipoProcedimientoDao.getByCodigo(codigoTipoProc);
			if (!Checks.esNulo(tipoPrc)) {
				msvHistoricoResolucionDto.setTipoProcedimiento(tipoPrc.getDescripcion());
			}
		} catch (Exception e) {
			//TODO - En caso de que se haga de forma masiva no existe el tipo de resolución (Ahora se devuelve null y no se pinta la resolución)
			e.printStackTrace();
			logger.error(e);
			return null;
		}
		
		for (RecoveryBPMfwkDatoInput dato : input.getDatosPersistidos()) {
			if ("d_observaciones".equals(dato.getNombre())) {
				msvHistoricoResolucionDto.setObservaciones(dato.getValor());				
			}
			if ("d_numAutos".equals(dato.getNombre())) {
				msvHistoricoResolucionDto.setNumAuto(dato.getValor());
			}
//			if ("d_plaza".equals(dato.getNombre())) {
////				msvHistoricoResolucionDto.setPlaza());
//			}
			if ("d_juzgado".equals(dato.getNombre())) {
				if (!Checks.esNulo(dato.getValor())) {
					EXTTipoJuzgado juzgado=genericDao.get(EXTTipoJuzgado.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dato.getValor()));
					if (!Checks.esNulo(juzgado)) {
						msvHistoricoResolucionDto.setJuzgado(juzgado.getDescripcion());
						if (!Checks.esNulo(juzgado.getPlaza())) {
							msvHistoricoResolucionDto.setPlaza(juzgado.getPlaza().getDescripcion());
						}
					}
				}
			}
		}
		msvHistoricoResolucionDto.setUsuario(usuarioManager.getByUsername(input.getAuditoria().getUsuarioCrear()));
		msvHistoricoResolucionDto.setFechaCarga(input.getAuditoria().getFechaCrear());
		
		return msvHistoricoResolucionDto;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(MSV_GET_HTCO_BY_TAR_ASU)
	public List<MSVHistoricoTareaAsuntoDto> getHistoricoPorTareasAsunto(
			Long idAsunto) throws IllegalAccessException,
			InvocationTargetException {
		List<MSVHistoricoTareaAsuntoDto> historico = new ArrayList<MSVHistoricoTareaAsuntoDto>();
		try {
			List<? extends HistoricoAsuntoInfo> tareas = (List<? extends HistoricoAsuntoInfo>) executor.execute(AsuntoApi.BO_CORE_ASUNTO_GET_EXT_HISTORICO_ASUNTO, idAsunto);
			List<Evento> eventos = proxyFactory.proxy(EventoApi.class).getEventosAsunto(idAsunto);

			historico = juntaYOrdena(tareas, eventos);
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		}
		
		return historico;
	}
	
	private List<MSVHistoricoTareaAsuntoDto> juntaYOrdena(List<? extends HistoricoAsuntoInfo> tareas, List<Evento> eventos) {
		List<MSVHistoricoTareaAsuntoDto> lista = new ArrayList<MSVHistoricoTareaAsuntoDto>();
		if (!Checks.estaVacio(tareas)) {
			lista.addAll(transfoma(tareas));
		}

		if (!Checks.estaVacio(eventos)) {
			lista.addAll(transforma(eventos));
		}
		Collections.sort(lista, new MSVHistoricoAsuntoViewDtoComparator(MSVSortOrder.ASCENDING, MSVSortOrder.ASCENDING, MSVNullsOrder.LAST));
		return lista;
	}
	
	private Collection<? extends MSVHistoricoTareaAsuntoDto> transforma(List<Evento> eventos) {
		List<MSVHistoricoTareaAsuntoDto> result = new ArrayList<MSVHistoricoTareaAsuntoDto>();

		for (Evento e : eventos) {
			result.add(new MSVHistoricoTareaAsuntoDto(e));
		}

		return result;
	}

	private Collection<? extends MSVHistoricoTareaAsuntoDto> transfoma(List<? extends HistoricoAsuntoInfo> tareas) {
		List<MSVHistoricoTareaAsuntoDto> result = new ArrayList<MSVHistoricoTareaAsuntoDto>();
		
		Map<Long,MSVHistoricoTareaAsuntoDto> acuerdos = new HashMap<Long, MSVHistoricoTareaAsuntoDto>();

		for (HistoricoAsuntoInfo t : tareas) {
			Usuario usuario = usuarioManager.getByUsername(t.getTarea().getNombreUsuario());
			if (Checks.esNulo(usuario) && !("".equals(t.getTarea().getNombreUsuario()))) {
				usuario = new Usuario();
				usuario.setNombre(t.getTarea().getNombreUsuario());
			}
			//Obtengo la tarea externa para buscar la resolucion
			if ((HistoricoProcedimiento.TIPO_ENTIDAD_TAREA.equals(t.getTarea().getTipoEntidad()) 
					&& (!Checks.esNulo(t.getTarea().getIdEntidad())))) {
			TareaNotificacion tareaNotificacion = proxyFactory.proxy(TareaNotificacionApi.class).get(t.getTarea().getIdEntidad()); 
				Long tareaExternaId = tareaNotificacion.getTareaExterna().getId();
				
				List<MSVHistoricoResolucionDto> msvHistoricoResoluciones = new ArrayList<MSVHistoricoResolucionDto>(); 
				if (!Checks.esNulo(tareaExternaId))	{ 
					msvHistoricoResoluciones = buscaResolucion(tareaExternaId);
				}
				result.add(new MSVHistoricoTareaAsuntoDto(t,msvHistoricoResoluciones,usuario));
			} else {
				if (HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_ACUERDO.equals(t.getTarea().getTipoEntidad()) ||
						HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_ACUERDO.equals(t.getTarea().getTipoEntidad())) {
					//En caso de ser acuerdo solo se muestra una vez, se elimina el procedimiento y se añade al grupo Acuerdos "_A"
					t.setProcedimiento(null);
					t.setGroup("ACU");
					acuerdos.put(t.getTarea().getIdEntidad(), new MSVHistoricoTareaAsuntoDto(t,null,usuario));
				} else {
					result.add(new MSVHistoricoTareaAsuntoDto(t,null,usuario));
				}
			}
		}

		for (MSVHistoricoTareaAsuntoDto acuerdo: acuerdos.values()) {
			//Se añaden los acuerdos al list de resultado
			result.add(acuerdo);
		}
		
		return result;
	}
	
	@Override
	@BusinessOperation(MSV_GET_HTCO_BY_RES_ASU)
	public List<MSVHistoricoResolucionDto> getHistoricoPorResolucionAsunto(Long idAsunto) throws IllegalAccessException, InvocationTargetException {
		List<MSVHistoricoResolucionDto> result = new ArrayList<MSVHistoricoResolucionDto>();
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		Collections.sort(asunto.getProcedimientos());
		for (Procedimiento procedimiento : asunto.getProcedimientos()) {
			result.addAll(this.getHistoricoPorResolucion(procedimiento.getId()));
		}
			
		return result;
	}

	@Override
	@BusinessOperation(MSV_GET_ITEMS_DETALLE_INPUT)
	public List<MSVHistItemResolucionDto> getItemsDetalleInput(RecoveryBPMfwkInput input) {
		List<MSVHistItemResolucionDto> items = new ArrayList<MSVHistItemResolucionDto>();
    	
		if (!Checks.esNulo(input)) {
			int i = 0;
			for(RecoveryBPMfwkDatoInput datos : input.getDatosPersistidos()) {
				MSVHistItemResolucionDto item = new MSVHistItemResolucionDto();
			    	item.setLabel(datos.getNombre());
			    	item.setNombre(datos.getNombre());
			    	item.setOrder(i);
			    	item.setValue(datos.getValor());
			    	item.setType("text");
			    items.add(item);
			    i++;
			}
		}
	    return items;
	}
		
}
