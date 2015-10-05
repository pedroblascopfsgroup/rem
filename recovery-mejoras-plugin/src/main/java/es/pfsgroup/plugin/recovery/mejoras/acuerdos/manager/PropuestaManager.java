package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesAExplorarExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dao.EXTActuacionesRealizadasExpedienteDao;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.dto.DTOActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesAExplorarExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;
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
			Boolean esEstadoDecisionComite = DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo());

			if (esEstadoCompletarExp || esEstadoRevisarExp) {
				cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
			} else if (esEstadoDecisionComite) {
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
			
			if(DDEstadoAcuerdo.ACUERDO_PROPUESTO.equals(nuevoEstado.getCodigo())){
					propuesta.setFechaPropuesta(new Date());
				}else if(DDEstadoAcuerdo.ACUERDO_RECHAZADO.equals(nuevoEstado.getCodigo())){
						propuesta.setFechaEstado(new Date());
					}else if(DDEstadoAcuerdo.ACUERDO_CUMPLIDO.equals(nuevoEstado.getCodigo()) || DDEstadoAcuerdo.ACUERDO_INCUMPLIDO .equals(nuevoEstado.getCodigo())){
							propuesta.setFechaResolucionPropuesta(new Date());
						}else if(DDEstadoAcuerdo.ACUERDO_FINALIZADO .equals(nuevoEstado.getCodigo())){
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
	 * @param idAcuerdo el id del acuerdo a finalizar
	 * @throws ParseException 
	 */
	@Transactional(readOnly = false)
	public void finalizar(Long idAcuerdo, Date fechaPago, Boolean cumplido, String observaciones) {
		String codigoEstadoPropuesta = cumplido ? DDEstadoAcuerdo.ACUERDO_CUMPLIDO : DDEstadoAcuerdo.ACUERDO_INCUMPLIDO;
		DDEstadoAcuerdo estadoFinalizacion = (DDEstadoAcuerdo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAcuerdo.class, codigoEstadoPropuesta);

		EXTAcuerdo propuesta = (EXTAcuerdo) acuerdoDao.get(idAcuerdo);
		propuesta.setEstadoAcuerdo(estadoFinalizacion);
		propuesta.setFechaEstado(fechaPago);
		propuesta.setObservaciones(observaciones);
		acuerdoDao.save(propuesta);

		String descripcion = "La propuesta " + idAcuerdo + " ha sido cambiada al estado " + estadoFinalizacion.getDescripcion();

		crearEventoPropuesta(propuesta.getExpediente().getId(), descripcion, propuesta.getProponente().getId());
	}

	private void crearEventoPropuesta(Long idUnidadGestion, String descripcion, Long usuarioDestino) {
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();
		tareaDto.setIdEntidad(idUnidadGestion);
		tareaDto.setDescripcion(descripcion);
		tareaDto.setSubtipoTarea(SubtipoTarea.CODIGO_EVENTO_PROPUESTA);
		tareaDto.setCodigoTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);

		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(usuarioDestino);

		try {
			proxyFactory.proxy(EXTTareasApi.class).crearTareaNotificacionIndividualizada(tareaIndDto);
		} catch (EXTCrearTareaException e) {
			logger.error(e);
			throw new BusinessOperationException("PropuestaManager.crearEvento: error al intentar crear el evento ");
		}
	}

	@Transactional(readOnly = false)
	public void rechazar(Long idPropuesta, String motivo) {
		
		EXTAcuerdo propuesta = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idPropuesta));
		propuesta.setMotivo(motivo);
		acuerdoDao.save(propuesta);
		cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_RECHAZADO);
		
	}
}
