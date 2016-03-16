package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.acuerdo.CumplimientoAcuerdoDto;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.registro.CumplimientoAcuerdoListener;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesAExplorarExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesRealizadasExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesAExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Service
public class PropuestaManager implements PropuestaApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ExpedienteDao expedienteDao;

	@Autowired
	private AcuerdoDao acuerdoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private IntegracionBpmService bpmIntegracionService;
	
	@Autowired
	private EXTActuacionesAExplorarExpedienteDao extActuacionesAExplorarExpedienteDao;
	
	@Autowired
	private EXTActuacionesRealizadasExpedienteDao extActuacionesRealizadasExpedienteDao;
	
	@Autowired(required = false)
	private List<CumplimientoAcuerdoListener> listeners;
	

	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
	public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente) {

		Order order = new Order(OrderType.ASC, "id");
		return  genericDao.getListOrdered(EXTAcuerdo.class,order, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
	}

	@BusinessOperation(BO_PROPUESTA_ES_GESTOR_SUPERVISOR_ACTUAL)
	public Boolean usuarioLogadoEsGestorSupervisorActual(Long idExpediente) {
		Expediente expediente = expedienteDao.get(idExpediente);

		Long idPerfilGestorActual = expediente.getIdGestorActual();
		Long idPerfilSupervisorActual = expediente.getIdSupervisorActual();

		return usuarioLogadoTienePerfil(idPerfilGestorActual) || usuarioLogadoTienePerfil(idPerfilSupervisorActual);
	}

	@Transactional(readOnly = false)
	public void proponer(Long idPropuesta) {
		Acuerdo propuesta = acuerdoDao.get(idPropuesta);
		Expediente expediente = propuesta.getExpediente();

		if (expediente != null && expediente.getEstadoItinerario() != null) {

			Boolean esEstadoCompletarExp = DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoRevisarExp = DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoEnSancion = DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoDecisionComite = DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo());
			Boolean esEstadoSancionado = DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(expediente.getEstadoItinerario().getCodigo());

			if (esEstadoCompletarExp || esEstadoRevisarExp || esEstadoEnSancion) {
				cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
			} else if (esEstadoDecisionComite || esEstadoSancionado) {
				cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_ACEPTADO);
			}
		} else {
			throw new BusinessOperationException("PropuestaManager.proponer: No se ha encontrado expedientes asociados a esa propuesta/acuerdo");
		}
	}

	/**
	 * Cambia el estado de la prupuesta pasada por parametro
	 * @param propuesta
	 * @param nuevoCodigoEstado
	 */
	private void cambiarEstadoPropuesta(Acuerdo propuesta, String nuevoCodigoEstado) {
		DDEstadoAcuerdo nuevoEstado = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, nuevoCodigoEstado);
		if (nuevoEstado != null) {
			propuesta.setEstadoAcuerdo(nuevoEstado);

			if (DDEstadoAcuerdo.ACUERDO_PROPUESTO.equals(nuevoEstado.getCodigo())) {
				propuesta.setFechaPropuesta(new Date());
			} else if (DDEstadoAcuerdo.ACUERDO_RECHAZADO.equals(nuevoEstado.getCodigo())) {
				propuesta.setFechaEstado(new Date());
			} else if (DDEstadoAcuerdo.ACUERDO_CUMPLIDO.equals(nuevoEstado.getCodigo()) || DDEstadoAcuerdo.ACUERDO_INCUMPLIDO.equals(nuevoEstado.getCodigo())) {
				propuesta.setFechaResolucionPropuesta(new Date());
			} else if (DDEstadoAcuerdo.ACUERDO_FINALIZADO.equals(nuevoEstado.getCodigo())) {
				propuesta.setFechaCierre(new Date());
			}

			acuerdoDao.saveOrUpdate(propuesta);
		} else {
			throw new BusinessOperationException("PropuestaManager.cambiarEstadoPropuesta: No se encuentra el codigo del estado (DDEstadoAcuerdo)");
		}
	}

	/**
	 * comprueba si el usuario Logado dispone el perfil que se pase por parametro
	 * @param idPerfil
	 * @return
	 */
	private Boolean usuarioLogadoTienePerfil(Long idPerfil) {
		Usuario userlogged = usuarioManager.getUsuarioLogado();
		List<Perfil> perfiles = userlogged.getPerfiles();

		if (idPerfil == null) {
			return false;
		}

		for (Perfil perfil : perfiles) {
			if (idPerfil.equals(perfil.getId())) {
				return true;
			}
		}
		return false;
	}

	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_CONTRATOS_DEL_EXPEDIENTE)
	public List<Contrato> listadoContratosByExpedienteId(Long idExpediente) {
		
		List<ExpedienteContrato> listaContratosExpediente = genericDao.getList(ExpedienteContrato.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
		List<Contrato> contratos = new ArrayList<Contrato>();
		
		if (!Checks.esNulo(listaContratosExpediente) && listaContratosExpediente.size()>0) {
			for(ExpedienteContrato expCon : listaContratosExpediente){
				contratos.add(expCon.getContrato());	
			}
			
		}
		return contratos;
	}
	
	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_PROPUESTAS_REALIZADAS_BY_EXPEDIENTE_ID)
    public List<EXTActuacionesRealizadasExpediente> listadoPropuestasRealizadasByExpedienteId(Long id) {
        logger.debug("Obteniendo acuerdos del expediente" + id);
        Order order = new Order(OrderType.ASC, "id");
        return (List<EXTActuacionesRealizadasExpediente>) genericDao.getListOrdered(EXTActuacionesRealizadasExpediente.class, order, 
        		genericDao.createFilter(FilterType.EQUALS, "expediente.id", id));
    }
	
	@BusinessOperation(BO_PROPUESTA_GET_LISTADO_PROPUESTAS_EXPLORAR_BY_EXPEDIENTE_ID)
    public List<EXTActuacionesAExplorarExpediente> listadoActuacionesAExplorarExpediente(Long idExpediente) {
		Expediente expediente = proxyFactory.proxy(ExpedienteApi.class).getExpediente(idExpediente);
    	List<EXTActuacionesAExplorarExpediente> todasLasActuacionesAExplorar = new ArrayList<EXTActuacionesAExplorarExpediente>();
        // Obtengo la lista de las actuaciones marcadas
        List<EXTActuacionesAExplorarExpediente> actuacionesAExplorarMarcadasByExpediente = extActuacionesAExplorarExpedienteDao
                .getActuacionesAExplorarMarcadasByExpediente(idExpediente);
        // y de todos los tipos y subtipos aunque no hayan sido marcados, excepto los inactivos
        List<DDSubtipoSolucionAmistosaAcuerdo> subtiposActivosOMarcadosByExpediente = extActuacionesAExplorarExpedienteDao
                .getSubtiposActivosOMarcadosByExpediente(idExpediente);

        // y unificamos ambas listas en una

        todasLasActuacionesAExplorar.addAll(actuacionesAExplorarMarcadasByExpediente);

        boolean estaEnLista;
        for (DDSubtipoSolucionAmistosaAcuerdo subtipo : subtiposActivosOMarcadosByExpediente) {
            estaEnLista = false;
            for (EXTActuacionesAExplorarExpediente actuacion : actuacionesAExplorarMarcadasByExpediente) {
                if (actuacion.getDdSubtipoSolucionAmistosaAcuerdo().equals(subtipo)) {
                    estaEnLista = true;
                    break;
                }
            }
            if (!estaEnLista) {
            	EXTActuacionesAExplorarExpediente actuacionSinExplorar = new EXTActuacionesAExplorarExpediente();
                actuacionSinExplorar.setExpediente(expediente);
                actuacionSinExplorar.setDdSubtipoSolucionAmistosaAcuerdo(subtipo);
                actuacionSinExplorar.setDdValoracionActuacionAmistosa(null);
                actuacionSinExplorar.setObservaciones(null);
                actuacionSinExplorar.setId(null);
                todasLasActuacionesAExplorar.add(actuacionSinExplorar);
            }
        }

        // Ordena la lista por tipos
        Collections.sort(todasLasActuacionesAExplorar);

        return todasLasActuacionesAExplorar;
    }
	
	@Transactional
	@BusinessOperation(BO_PROPUESTA_SAVE_ACTUACION_REALIZADA_EXPEDIENTE)
    public void saveActuacionesRealizadasExpediente(DTOActuacionesRealizadasExpediente dto) {
    	EXTActuacionesRealizadasExpediente actRelExp;
    	if(dto.getActuaciones().getId() != null) {
    		actRelExp = extActuacionesRealizadasExpedienteDao.get(dto.getActuaciones().getId());
    	}else{
    		actRelExp = new EXTActuacionesRealizadasExpediente();
    		Expediente expediente = proxyFactory.proxy(ExpedienteApi.class).getExpediente(dto.getIdExpediente());
    		actRelExp.setExpediente(expediente);
    	}
    	actRelExp.setDdTipoActuacionAcuerdo(dto.getActuaciones().getDdTipoActuacionAcuerdo());
    	actRelExp.setDdResultadoAcuerdoActuacion(dto.getActuaciones().getDdResultadoAcuerdoActuacion());
    	actRelExp.setTipoAyudaActuacion(dto.getActuaciones().getTipoAyudaActuacion());
    	actRelExp.setFechaActuacion(dto.getActuaciones().getFechaActuacion());
    	actRelExp.setObservaciones(dto.getActuaciones().getObservaciones());
    	extActuacionesRealizadasExpedienteDao.save(actRelExp);
	}
    
    @BusinessOperation(BO_PROPUESTA_GET_ACTUACION_REALIZADAS_EXPEDIENTE)
    public EXTActuacionesRealizadasExpediente getActuacionRealizadasExpediente(Long idActuacion) {
        return extActuacionesRealizadasExpedienteDao.get(idActuacion);
    }
    
    @BusinessOperation(BO_PROPUESTA_GET_ACTUACION_EXPLORAR_EXPEDIENTE)
    public EXTActuacionesAExplorarExpediente getActuacionExplorarExpediente(Long idActuacion) {
        return extActuacionesAExplorarExpedienteDao.get(idActuacion);
    }
    
    @Override
    @Transactional
    @BusinessOperation(BO_PROPUESTA_SAVE_ACTUACION_EXPLORAR_EXPEDIENTE)
    public void saveActuacionesExplorarExpediente(DTOActuacionesExplorarExpediente dto) {
        EXTActuacionesAExplorarExpediente actuacion;
        if (dto.getIdActuacion() != null) {
            actuacion = extActuacionesAExplorarExpedienteDao.get(dto.getIdActuacion());
        } else {
            actuacion = new EXTActuacionesAExplorarExpediente();
            Expediente expediente = proxyFactory.proxy(ExpedienteApi.class).getExpediente(dto.getIdExpediente());
            actuacion.setExpediente(expediente);
        }
        DDSubtipoSolucionAmistosaAcuerdo subtipoSolucionAmistosa = (DDSubtipoSolucionAmistosaAcuerdo) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDSubtipoSolucionAmistosaAcuerdo.class, dto.getDdSubtipoSolucionAmistosaAcuerdo());
        actuacion.setDdSubtipoSolucionAmistosaAcuerdo(subtipoSolucionAmistosa);

        DDValoracionActuacionAmistosa valoracionActuacionAmistosa = (DDValoracionActuacionAmistosa) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDValoracionActuacionAmistosa.class, dto.getDdValoracionActuacionAmistosa());
        actuacion.setDdValoracionActuacionAmistosa(valoracionActuacionAmistosa);
        actuacion.setObservaciones(dto.getObservaciones());
        extActuacionesAExplorarExpedienteDao.save(actuacion);        
    }  

	@Transactional(readOnly = false)
	public void cancelar(Long idPropuesta) {
		Acuerdo propuesta = acuerdoDao.get(idPropuesta);
		cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_CANCELADO);
	}

	/**
	 * Pasa una propuesta a estado Finalizado.
	 * @param idPropuesta el id del acuerdo a finalizar
	 * @throws ParseException 
	 */
	@Transactional(readOnly = false)
	public void finalizar(Long idPropuesta, Date fechaPago, Boolean cumplido, String observaciones) {
		String codigoEstadoPropuesta = cumplido ? DDEstadoAcuerdo.ACUERDO_CUMPLIDO : DDEstadoAcuerdo.ACUERDO_INCUMPLIDO;
		DDEstadoAcuerdo estadoFinalizacion = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, codigoEstadoPropuesta);

		EXTAcuerdo propuesta = (EXTAcuerdo) acuerdoDao.get(idPropuesta);
		propuesta.setEstadoAcuerdo(estadoFinalizacion);
		propuesta.setFechaEstado(fechaPago);
		propuesta.setObservaciones(observaciones);
		acuerdoDao.save(propuesta);

		String descripcion = "La propuesta " + idPropuesta + " ha sido cambiada al estado " + estadoFinalizacion.getDescripcion();

		crearEventoPropuesta(propuesta.getExpediente().getId(), descripcion);
	}

	/**
	 * Crea una notificacion asociada al expediente y la revisa automaticamente para que no aparezca en las notificaciones del usuario.
	 * 
	 * @param idExpediente
	 * @param descripcion
	 * @param usuarioDestino
	 */
	private void crearEventoPropuesta(Long idExpediente, String descripcion) {
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();
		tareaDto.setIdEntidad(idExpediente);
		tareaDto.setDescripcion(descripcion);
		tareaDto.setSubtipoTarea(SubtipoTarea.CODIGO_EVENTO_PROPUESTA);
		tareaDto.setCodigoTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);

		try {
			Long idEvento = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(tareaDto);
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_FINALIZAR_NOTIF, idEvento);
		} catch (GenericRollbackException e) {
			logger.error(e);
			throw new BusinessOperationException("PropuestaManager.crearEvento: error al intentar crear el evento ");
		}
	}

	@Transactional(readOnly = false)
	public void rechazar(Long idPropuesta, String motivo, String observaciones) {
		
		EXTAcuerdo propuesta = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idPropuesta));
		DDMotivoRechazoAcuerdo motivoRechazoAcuerdo = genericDao.get(DDMotivoRechazoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(motivo)));
		propuesta.setMotivo(motivoRechazoAcuerdo.getDescripcion());
		if(observaciones != null && observaciones != ""){
			propuesta.setObservaciones(observaciones);	
		}
		
		acuerdoDao.save(propuesta);
		cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_RECHAZADO);
		DDEstadoAcuerdo estadoFinalizacion = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_RECHAZADO);
		String descripcion = "La propuesta " + idPropuesta + " ha sido cambiada al estado " + estadoFinalizacion.getDescripcion();
		
		crearEventoPropuesta(propuesta.getExpediente().getId(), descripcion);
		
	}

	@BusinessOperation(BO_PROPUESTA_GET_EXPEDIENTES)
	public List<Bien> getBienesDelExpedienteParaLaPropuesta(Long idExpediente, List<Long> contratosIncluidos) {
		
		Expediente expediente = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", idExpediente));
		List<Bien> bienes = new ArrayList<Bien>();
		
		if(!Checks.esNulo(expediente)){
			
			for(ExpedienteContrato expCont : expediente.getContratos()){
				if(contratosIncluidos.contains(expCont.getContrato().getId())){
					for(Bien bienCont : expCont.getContrato().getBienes()){
						if(!bienes.contains(bienCont)){
							bienes.add(bienCont);
						}
					}	
				}
			}
			
			for(ExpedientePersona expPer : expediente.getPersonas()){
				for(Bien bienPers : expPer.getPersona().getBienes()){
					if(!bienes.contains(bienPers)){
						bienes.add(bienPers);
					}
				}
			}
			
		}else{
			throw new BusinessOperationException("PropuestaManager.getBienesDelExpedienteParaLaPropuesta: No se encuentra el id de expediente "+idExpediente);	
		}
		
		return bienes;
		
	}
	
    /**
     * {@inheritDoc}
     */
	public Boolean estadoTodasPropuestas(List<EXTAcuerdo> propuestas, List<String> codigosEstadosValidos) {
		for (EXTAcuerdo propuesta : propuestas) {
			if (!codigosEstadosValidos.contains(propuesta.getEstadoAcuerdo().getCodigo())) {
				//Se ha encontrado una propuesta que no esta en ninguno de los estados validos
				return false;
			}
		}
		
		//Todas las propuestas estan en un estado valido
		return true;
	}
	
    /**
     * {@inheritDoc}
     */	
	public Boolean estadoAlgunaPropuesta(List<EXTAcuerdo> propuestas, List<String> codigosEstadosValidos) {
		for (EXTAcuerdo propuesta : propuestas) {
			if (codigosEstadosValidos.contains(propuesta.getEstadoAcuerdo().getCodigo())) {
				//Hemos encontrado una propuesta en uno de los estados validos
				return true;
			}
		}
		
		//No se ha encontrado ninguna propuesta en uno de los estados validos
		return false;
	}
	
	/**
	 * {@inheritDoc}
	 */
	public void cambiarEstadoPropuesta(EXTAcuerdo propuesta, String nuevoCodigoEstado, boolean generarEvento) {
		this.cambiarEstadoPropuesta(propuesta, nuevoCodigoEstado);
		
		if (generarEvento) {
			DDEstadoAcuerdo nuevoEstado = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, nuevoCodigoEstado);
			
			//String descripcion = "La propuesta " + propuesta.getId() + " ha sido cambiada al estado " + nuevoEstado.getDescripcion();
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String descripcion = ms.getMessage("propuesta.cambiarEstado.descripcionEvento", new Object[] { propuesta.getId(), nuevoEstado.getDescripcion() },
                    MessageUtils.DEFAULT_LOCALE);
			
			
			this.crearEventoPropuesta(propuesta.getExpediente().getId(), descripcion);
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void cerrarPropuesta(Long id) {
		EventFactory.onMethodStart(this.getClass());

		Acuerdo acuerdo = acuerdoDao.get(id);

		acuerdo.setFechaCierre(new Date());
		DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDEstadoAcuerdo.class,
						DDEstadoAcuerdo.ACUERDO_FINALIZADO);
		acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);

		acuerdoDao.saveOrUpdate(acuerdo);

		bpmIntegracionService.notificaCambioEstado(acuerdo);
		
		EventFactory.onMethodStop(this.getClass());
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public void registraCumplimientoPropuesta(CumplimientoAcuerdoDto dto) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(CumplimientoAcuerdoListener.ID_ACUERDO, dto.getId());
		map.put(CumplimientoAcuerdoListener.CLAVE_FINALIZADO, dto
				.getFinalizar());
		map.put(CumplimientoAcuerdoListener.CLAVE_CUMPLIDO, dto.getCumplido());
		map.put(CumplimientoAcuerdoListener.CLAVE_FECHA_CUMPLIMIENTO, dto
				.getFechaPago());
		map.put(CumplimientoAcuerdoListener.CLAVE_CANTIDAD_PAGADA, dto
				.getImportePagado());

		if (listeners != null) {
			for (CumplimientoAcuerdoListener l : listeners) {
				l.fireEvent(map);
			}
		}
	}
	
	@Override
	public List<EXTAcuerdo> listadoPropuestasDelExpediente(Long idExpediente, String estadoAcuerdo ) {

		Order order = new Order(OrderType.ASC, "id");
		Filter fExp = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		Filter fEstAcu = null;
		if(!Checks.esNulo(estadoAcuerdo)){
			fEstAcu = genericDao.createFilter(FilterType.EQUALS, "estadoAcuerdo.codigo", estadoAcuerdo);
		}
		return  genericDao.getListOrdered(EXTAcuerdo.class,order, fExp, fEstAcu);
	}

	@Override
	public List<Contrato> contratosIncluidosEnLosTerminosDeLaPropuesta(Long idPropuesta) {

		List<TerminoContrato> teaCnts = genericDao.getList(TerminoContrato.class,genericDao.createFilter(FilterType.EQUALS, "termino.acuerdo.id", idPropuesta), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		List<Contrato> contratos = new ArrayList<Contrato>();
		
		for(TerminoContrato teaCnt : teaCnts){
			if(!contratos.contains(teaCnt.getContrato())){
				contratos.add(teaCnt.getContrato());
			}
		}
		
		return contratos;
	}

	@Override
	public void asignaPropuestaAlAsunto(Long idPropuesta, Long idAsunto) {
		Asunto asunto = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));
		EXTAcuerdo propuesta = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idPropuesta));
		if(!Checks.esNulo(asunto) && !Checks.esNulo(propuesta)){
			propuesta.setAsunto(asunto);
			acuerdoDao.save(propuesta);
		}
	}
}
