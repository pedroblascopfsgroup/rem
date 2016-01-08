package es.capgemini.pfs.acuerdo;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.ActuacionesAExplorarAcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.ActuacionesRealizadasAcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesAExplorar;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.acuerdo.CumplimientoAcuerdoDto;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.registro.CumplimientoAcuerdoListener;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class EXTAcuerdoManager extends BusinessOperationOverrider<AcuerdoApi>
		implements AcuerdoApi {

	@Autowired
	private Executor executor;

	@Autowired
	private AcuerdoDao acuerdoDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private FuncionManager funcionManager;

	@Autowired(required = false)
	private List<CumplimientoAcuerdoListener> listeners;

	@Autowired
	private IntegracionBpmService bpmIntegracionService;
	
    @Autowired
    private ActuacionesRealizadasAcuerdoDao actuacionesRealizadasAcuerdoDao;

    @Autowired
    private ActuacionesAExplorarAcuerdoDao actuacionesAExplorarAcuerdoDao;
    
	@Override
	public String managerName() {
		return "acuerdoManager";
	}

	/**
	 * Guarda un acuerdo. Si es nuevo lo da de alta, si no lo modifica.
	 * 
	 * @param dto
	 *            el dto con los datos
	 * @return el id del acuerdo.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ACUERDO_MGR_GUARDAR_ACUERDO)
	@Transactional(readOnly = false)
	public Long guardarAcuerdo(DtoAcuerdo dto) {
		cleanDto(dto);

		Long resultado = parent().guardarAcuerdo(dto);

		return resultado;
	}

	

	@Override
	@BusinessOperation(BO_CORE_ACUERDO_CERRAR)
	@Transactional(readOnly = false)
	public void cerrarAcuerdo(Long id) {
		EventFactory.onMethodStart(this.getClass());

		Acuerdo acuerdo = acuerdoDao.get(id);

		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea
					.getSubtipoTarea().getCodigoSubtarea())) {
				Long idBPM = acuerdo.getIdJBPM();
				executor.execute(
						ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS,
						idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
			}
		}
		
		// Comprobar quien esta cerrando el acuerdo, supervisor o gestor, para crear la notificacion adecuada
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		
		if (!Checks.esNulo(acuerdo.getAsunto().getGestor()) && acuerdo.getAsunto().getGestor().getUsuario().getId().equals(usuarioLogado.getId())) {
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(),
				DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_GESTOR, null);
		} else {
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(),
					DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_SUPERVISOR, null);
		}

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
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ACUERDO_MGR_FINALIZAR_ACUERDO)
	@Transactional(readOnly = false)
	public void finalizarAcuerdo(Long idAcuerdo) {
		Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
	    if (acuerdo.getEstadoAcuerdo().getCodigo() == DDEstadoAcuerdo.ACUERDO_CANCELADO) { 
	    	throw new BusinessOperationException("acuerdos.cancelado"); 
	    }
	    DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	    DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);

	    acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
	    acuerdo.setFechaEstado(new Date());
	    acuerdoDao.save(acuerdo);
	    
	    bpmIntegracionService.notificaCambioEstado(acuerdo);
	    
	    //Cancelo las tareas del supervisor
	    cancelarTareasAcuerdoPropuesto(acuerdo);
	    cancelarTareasCerrarAcuerdo(acuerdo);
	    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
	         EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_SUPERVISOR, acuerdo.getObservaciones());

	}

	/**
	 * Pasa un acuerdo a estado Vigente.
	 * 
	 * @param idAcuerdo
	 *            el id del acuerdo a aceptar.
	 */
	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ACUERDO_MGR_ACEPTAR_ACUERDO)
	@Transactional(readOnly = false)
	public void aceptarAcuerdo(Long idAcuerdo) {
		EventFactory.onMethodStart(this.getClass());

		Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
		// NO PUEDE HABER OTROS ACUERDOS VIGENTES.
		if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(),
				idAcuerdo)) {
			throw new BusinessOperationException("acuerdos.hayOtrosVigentes");
		}
		DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_ACEPTADO);

		acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
		acuerdo.setFechaEstado(new Date());
		// Cancelo las tareas del supervisor
		cancelarTareasAcuerdoPropuesto(acuerdo);
		// Genero tareas al gestor para el cierre del acuerdo.
		String codigoPlazoTarea = buscaCodigoPorPeriodo(acuerdo
				.getPeriodicidadAcuerdo());
		
		//Si tiene el permiso CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA entonces NO DEBE generar la tarea
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		if (!funcionManager.tieneFuncion(usuarioLogado, "CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA")){
			Long idJBPM = (Long) executor.execute(
					ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM,
					acuerdo.getAsunto().getId(),
					DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
					SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, codigoPlazoTarea);
			acuerdo.setIdJBPM(idJBPM);
		}		
			
		acuerdoDao.save(acuerdo);

    	bpmIntegracionService.notificaCambioEstado(acuerdo);

		EventFactory.onMethodStop(this.getClass());
	}

	@Override
	@BusinessOperation(BO_CORE_CONTINUAR_ACUERDO)
	@Transactional(readOnly = false)
	public void continuarAcuerdo(Long id) {
		Acuerdo acuerdo = acuerdoDao.get(id);
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea
					.getSubtipoTarea().getCodigoSubtarea())) {

				String codigo = buscaCodigoPorPeriodo(acuerdo
						.getPeriodicidadAcuerdo());
				Filter filtroCodigo = genericDao.createFilter(
						FilterType.EQUALS, "codigo", codigo);
				PlazoTareasDefault plazoTarea = genericDao.get(
						PlazoTareasDefault.class, filtroCodigo);
				Long plazo = plazoTarea.getPlazo();
				Date fechaCalculada = new Date(System.currentTimeMillis()
						+ plazo);
				tarea.setFechaVenc(fechaCalculada);

				Long idBPM = acuerdo.getIdJBPM();

				executor.execute(
						ComunBusinessOperation.BO_JBPM_MGR_RECALCULAR_TIMER,
						idBPM, TareaBPMConstants.TIMER_TAREA_SOLICITADA,
						fechaCalculada);
			}
		}
	}

	@Override
	@BusinessOperation(BO_CORE_ACUERDO_GUARDAR_CUMPLIMIENTO)
	@Transactional(readOnly = false)
	public void registraCumplimientoAcuerdo(CumplimientoAcuerdoDto dto) {
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

	private String buscaCodigoPorPeriodo(
			DDPeriodicidadAcuerdo periodicidadAcuerdo) {
		String codigo = PlazoTareasDefault.CODIGO_CIERRE_ACUERDO;
		if(!Checks.esNulo(periodicidadAcuerdo)){
			String periodo = periodicidadAcuerdo.getCodigo();
			if (periodo.equals("01")) {
				codigo = CODIGO_CIERRE_ACUERDO_ANUAL;
			} else if (periodo.equals("02")) {
				codigo = CODIGO_CIERRE_ACUERDO_MENSUAL;
			} else if (periodo.equals("03")) {
				codigo = CODIGO_CIERRE_ACUERDO_SEMESTRAL;
			} else if (periodo.equals("04")) {
				codigo = CODIGO_CIERRE_ACUERDO_TRIMESTRAL;
			} else if (periodo.equals("05")) {
				codigo = CODIGO_CIERRE_ACUERDO_BIMESTRAL;
			} else if (periodo.equals("06")) {
				codigo = CODIGO_CIERRE_ACUERDO_SEMANAL;
			} else if (periodo.equals("07")) {
				codigo = CODIGO_CIERRE_ACUERDO_UNICO;
			}
		}

		return codigo;
	}

	private void cancelarTareasAcuerdoPropuesto(Acuerdo acuerdo) {
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_ACUERDO_PROPUESTO.equals(tarea
					.getSubtipoTarea().getCodigoSubtarea())) {
				Long idBPM = acuerdo.getIdJBPM();
				executor.execute(
						ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS,
						idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
			}
		}
	}

	private void cancelarTareasCerrarAcuerdo(Acuerdo acuerdo) {
		for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
			if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
				Long idBPM = acuerdo.getIdJBPM();
	             executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
	        }
	    }
	}
	
	@Override
	public Acuerdo getAcuerdoById(Long id) {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * Realiza una limpieza del DTO, poniendo nulls en sitios en d�nde hay una
	 * cadena vac�a y cosas de esas.
	 * 
	 * @param dto
	 */
	private void cleanDto(DtoAcuerdo dto) {
		if (Checks.esNulo(dto.getTipoPago())){
			dto.setTipoPago(null);
		}
		if (Checks.esNulo(dto.getImportePago())){
			dto.setImportePago(null);
		}
		if (Checks.esNulo(dto.getPeriodicidad())){
			dto.setPeriodicidad(null);
		}
		if (Checks.esNulo(dto.getPeriodo())){
			dto.setPeriodo(null);
		}

	}

    /**
     * Pasa un Acuerdo en estado En Conformaci�n a Propuesto.
     * @param idAcuerdo el id del acuerdo
     */
	@Override
    @BusinessOperation(overrides = ExternaBusinessOperation.BO_ACUERDO_MGR_PROPONER_ACUERDO)
    @Transactional(readOnly = false)
    public void proponerAcuerdo(Long idAcuerdo) {
    	parent().proponerAcuerdo(idAcuerdo);
        
    	// Genera un mensaje de propuesta de acuerdo
		Acuerdo acuerdo = (Acuerdo)executor.execute(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACUERDO_BY_ID, idAcuerdo);
    	bpmIntegracionService.notificaCambioEstado(acuerdo);
    }

    /**
     * Pasa un Acuerdo en estado En Conformaci�n a Propuesto.
     * @param idAcuerdo el id del acuerdo
     */
	@Override
    @BusinessOperation(overrides = ExternaBusinessOperation.BO_ACUERDO_MGR_CANCELAR_ACUERDO)
    @Transactional(readOnly = false)
    public void cancelarAcuerdo(Long idAcuerdo) {
    	parent().cancelarAcuerdo(idAcuerdo);
        
    	// Genera un mensaje de propuesta de acuerdo
		Acuerdo acuerdo = (Acuerdo)executor.execute(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACUERDO_BY_ID, idAcuerdo);
    	bpmIntegracionService.notificaCambioEstado(acuerdo);
    	
    }
	
	@Override
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_REALIZADAS_ACUERDO)
    @Transactional
    public void saveActuacionesRealizadasAcuerdo(DtoActuacionesRealizadasAcuerdo actuacionesRealizadasAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(actuacionesRealizadasAcuerdo.getIdAcuerdo());
        ActuacionesRealizadasAcuerdo actuaciones;
        if (actuacionesRealizadasAcuerdo.getActuaciones().getId() != null) {
            actuaciones = actuacionesRealizadasAcuerdoDao.get(actuacionesRealizadasAcuerdo.getActuaciones().getId());
        } else {
            actuaciones = new ActuacionesRealizadasAcuerdo();
            actuaciones.setAuditoria(Auditoria.getNewInstance());
        }
        actuaciones.setAcuerdo(acuerdo);
        actuaciones.setDdResultadoAcuerdoActuacion(actuacionesRealizadasAcuerdo.getActuaciones().getDdResultadoAcuerdoActuacion());
        actuaciones.setDdTipoActuacionAcuerdo(actuacionesRealizadasAcuerdo.getActuaciones().getDdTipoActuacionAcuerdo());
        actuaciones.setTipoAyudaActuacion(actuacionesRealizadasAcuerdo.getActuaciones().getTipoAyudaActuacion());
        actuaciones.setFechaActuacion(actuacionesRealizadasAcuerdo.getActuaciones().getFechaActuacion());
        actuaciones.setObservaciones(actuacionesRealizadasAcuerdo.getActuaciones().getObservaciones());
        actuacionesRealizadasAcuerdoDao.saveOrUpdate(actuaciones);
        
        bpmIntegracionService.enviarDatos(actuaciones);
    }

    /**
     * Guarda o actualiza la actuacion a explorar modificada o nueva.
     * @param dto DtoActuacionesAExplorar
     */
	@Override
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_A_EXPLORAR_ACUERDO)
    @Transactional(readOnly = false)
    public void saveActuacionAExplorarAcuerdo(DtoActuacionesAExplorar dto) {

        ActuacionesAExplorarAcuerdo actuacion;
        if (dto.getIdActuacion() != null) {
            actuacion = actuacionesAExplorarAcuerdoDao.get(dto.getIdActuacion());
        } else {
            actuacion = new ActuacionesAExplorarAcuerdo();
            actuacion.setGuid(dto.getGuid());
            actuacion.setAuditoria(Auditoria.getNewInstance());
            actuacion.setAcuerdo(acuerdoDao.get(dto.getIdAcuerdo()));
        }
        DDSubtipoSolucionAmistosaAcuerdo subtipoSolucionAmistosa = (DDSubtipoSolucionAmistosaAcuerdo) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDSubtipoSolucionAmistosaAcuerdo.class, dto.getDdSubtipoSolucionAmistosaAcuerdo());
        actuacion.setDdSubtipoSolucionAmistosaAcuerdo(subtipoSolucionAmistosa);

        DDValoracionActuacionAmistosa valoracionActuacionAmistosa = (DDValoracionActuacionAmistosa) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDValoracionActuacionAmistosa.class, dto.getDdValoracionActuacionAmistosa());
        actuacion.setDdValoracionActuacionAmistosa(valoracionActuacionAmistosa);
        actuacion.setObservaciones(dto.getObservaciones());
        actuacionesAExplorarAcuerdoDao.save(actuacion);
        
        bpmIntegracionService.enviarDatos(actuacion);
    }    
	
}
