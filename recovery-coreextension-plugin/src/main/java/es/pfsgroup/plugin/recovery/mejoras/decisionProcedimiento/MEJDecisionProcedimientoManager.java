package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.dao.ProcedimientoContratoExpedienteDao;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.decisionProcedimiento.dao.DecisionProcedimientoDao;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionParalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procedimientoDerivado.dao.ProcedimientoDerivadoDao;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoActuacionManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoReclamacionManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;


@Component
public class MEJDecisionProcedimientoManager extends
		BusinessOperationOverrider<DecisionProcedimientoApi> implements
		DecisionProcedimientoApi {

	public final static String FUNCION_FINALIZAR_ASUNTOS = "FINALIZAR-ASUNTO";
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private FuncionManager funcionManager;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
    
	@Resource
    private MessageService messageService;
	
	@Autowired
	private ProcedimientoContratoExpedienteDao procedimientoContratoExpedienteDao;
	
	@Autowired
    private DecisionProcedimientoDao decisionProcedimientoDao;
	
	@Autowired
	private CoreProjectContext coreProjectContext;
	
	@Autowired
	private IntegracionBpmService integracionBpmService;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
    
	@Autowired
	private TareaNotificacionManager tareaNotifManager;

	@Autowired
	private ProcedimientoManager prcManager;
	
	@Autowired
	private TipoProcedimientoManager tipoProcedimientoManager;
	
	@Autowired
	protected EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	ProcedimientoDerivadoDao procedimientoDerivadoDao; 

	@Autowired(required=false)
	@Qualifier(AccionTomaDecision.ACCION_TRAS_PARALIZAR)
	private List<AccionTomaDecision> accionesAdicionalesTrasParalizar;
	
	@Autowired(required=false)
	@Qualifier(AccionTomaDecision.ACCION_TRAS_FINALIZAR)
	private List<AccionTomaDecision> accionesAdicionalesTrasFinalizar;
    
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void rechazarPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
		try {
			DecisionProcedimiento dp = dtoDecisionProcedimiento.getDecisionProcedimiento();
			dtoDecisionProcedimiento.setDecisionProcedimiento(dp);
			 // Setear Decision como rechazada
	        DecisionProcedimiento decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();

	        // Si tiene una tarea asignada a la decisi�n la revivimos y le borramos
	        // la decisi�n asignada
	        TareaNotificacion tarea = decisionProcedimiento.getTareaAsociada();
	        if (tarea != null) {
	            tarea.getAuditoria().setBorrado(false);
	            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);

	            decisionProcedimiento.setTareaAsociada(null);
	        }

	        //Cancelamos todos los procedimientos de la decisi�n rechazada
	        for (ProcedimientoDerivado pd : decisionProcedimiento.getProcedimientosDerivados()) {
	            Procedimiento prc = genericDao.get(Procedimiento.class, genericDao
						.createFilter(FilterType.EQUALS, "id", pd.getProcedimiento().getId()));
	            
	            prc.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO)));

	            genericDao.save(Procedimiento.class, prc);
	        }

	        DDEstadoDecision estadoDecision = (DDEstadoDecision) diccionarioApi
	        		.dameValorDiccionarioByCod(DDEstadoDecision.class, DDEstadoDecision.ESTADO_RECHAZADO);
	        decisionProcedimiento.setEstadoDecision(estadoDecision);
	        // enviar notificacion
	        //decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
	        genericDao.save(DecisionProcedimiento.class, decisionProcedimiento);
	        notificarGestor(decisionProcedimiento, false);
	        
	        // borrar la tarea
	        finalizarTarea(decisionProcedimiento.getProcessBPM());
	        
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}

	}

	/**
	 * Actualiza una actuaci�n en una decisi�n/propuesta de continuidad de un
	 * procedimiento
	 * 
	 * @param id
	 *            id
	 * @param dto
	 *            Datos del procedimiento a actualizar.
	 */
	@BusinessOperation(BO_DEC_PCR_ACTUALIZAR_PROCEDIMIENTO)
	public void actualizarActuacion(Long id, MEJDtoProcedimientoDerivado dto) {
		Long idProcedimiento = dto.getId();
		Procedimiento procedimiento = getProcedimiento(id, idProcedimiento);
		procedimiento.setTipoActuacion(obtenerTipoActuacion(dto));
		procedimiento.setTipoProcedimiento(obtenerTipoProcedimiento(dto));
		procedimiento.setTipoReclamacion(obtenerTipoReclamacion(dto));
		procedimiento.setSaldoRecuperacion(dto.getSaldoRecuperacion());
		procedimiento
				.setPorcentajeRecuperacion(dto.getPorcentajeRecuperacion());
		procedimiento.setPlazoRecuperacion(dto.getPlazoRecuperacion());
		procedimiento.setPersonasAfectadas(obtenerPersonasAfectadas(dto
				.getPersonas()));

		executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO,
						procedimiento);
	}

	/**
	 * Elimina una actuacion de una propuesta/decisi�n de continuidad de
	 * procedimiento
	 * 
	 * @param id
	 *            Id propuesta/decision
	 * @param idProcedimiento
	 *            Id actuacion a eliminar
	 */
	@BusinessOperation(BO_DEC_PCR_ELIMINAR_PROCEDIMIENTO)
	@Transactional(readOnly = false)
	public void borrarActuacion(Long id, Long idProcedimiento) {
		Procedimiento procedimiento = getProcedimiento(id, idProcedimiento);
		List<ProcedimientoDerivado> derivados = getProcedimientosDerivados(id,
				idProcedimiento);
		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_DELETE,
				procedimiento);
		borraProcedimientosDerivados(derivados);
	}

	private void borraProcedimientosDerivados(
			List<ProcedimientoDerivado> derivados) {
		if (derivados != null) {
			for (ProcedimientoDerivado pd : derivados) {
				genericDao.deleteById(ProcedimientoDerivado.class, pd.getId());
			}
		}

	}

	private List<ProcedimientoDerivado> getProcedimientosDerivados(Long id,
			Long idProcedimiento) {
		if (id == null) {
			throw new IllegalArgumentException("El ID de la decisi�n es NULL");
		}
		if (idProcedimiento == null) {
			throw new IllegalArgumentException(
					"El ID del procedimiento es NULL");
		}
		Filter fdecision = genericDao.createFilter(FilterType.EQUALS,
				"decisionProcedimiento.id", id);
		Filter fprocedimiento = genericDao.createFilter(FilterType.EQUALS,
				"procedimiento.id", idProcedimiento);
		return genericDao.getList(ProcedimientoDerivado.class, fdecision,
				fprocedimiento);
	}

	private DDTipoReclamacion obtenerTipoReclamacion(
			MEJDtoProcedimientoDerivado dto) {
		return (DDTipoReclamacion) executor.execute(
				MEJTipoReclamacionManager.BO_TRE_MGR_GET_BY_CODIGO, dto
						.getTipoReclamacion());
	}

	private TipoProcedimiento obtenerTipoProcedimiento(
			MEJDtoProcedimientoDerivado dto) {
		return (TipoProcedimiento) executor.execute(
				MEJTipoProcedimientoManager.BO_TPO_MGR_GET_BY_CODIGO, dto
						.getTipoProcedimiento());
	}

	private DDTipoActuacion obtenerTipoActuacion(MEJDtoProcedimientoDerivado dto) {
		return (DDTipoActuacion) executor.execute(
				MEJTipoActuacionManager.BO_TAC_MGR_GET_BY_CODIGO, dto
						.getTipoActuacion());
	}

	private List<Persona> obtenerPersonasAfectadas(Long[] ids) {
		ArrayList<Persona> personas = new ArrayList<Persona>();

		for (Long id : ids) {
			Persona p = (Persona) executor.execute(
					PrimariaBusinessOperation.BO_PER_MGR_GET, id);
			personas.add(p);
		}

		return personas;
	}

	private Procedimiento getProcedimiento(Long id, Long idProcedimiento) {
		DecisionProcedimiento decision = (DecisionProcedimiento) executor
				.execute(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET, id);
		if (decision == null) {
			throw new BusinessOperationException("Propuesta no encontrada");
		}
		Procedimiento procedimiento = null;
		for (ProcedimientoDerivado pd : decision.getProcedimientosDerivados()) {
			if (pd.getProcedimiento().getId().equals(idProcedimiento)) {
				procedimiento = pd.getProcedimiento();
			}
		}
		if (procedimiento == null) {
			throw new BusinessOperationException("Actuaci�n incorrecta");
		}
		return procedimiento;
	}

	@Override
	public String managerName() {
		return "decisionProcedimientoManager";
	}

	@Override
	@BusinessOperation(MEJ_BO_DECISIONPROCEDIMIENTO_REANUDAR)
	@Transactional(readOnly = false)
	public void reanudarProcedimientoParalizado(Long id) {
		if (id != null) {
			Procedimiento proc = genericDao.get(Procedimiento.class, genericDao
					.createFilter(FilterType.EQUALS, "id", id));
			if (proc != null && (proc.getProcessBPM() != null)) {
				executor
						.execute(
								ComunBusinessOperation.BO_JBPM_MGR_ACTIVAR_PROCESOS_BPM,
								proc.getProcessBPM());
			}
		}

	}
	
	   /**
     * Crea un objeto ProcedimientoDerivado a partir del
     * DtoProcedimientoDerivado y crea el procedimiento Hijo, del procedimiento
     * asociado a la decision.
     *
     * @param dtoProc El DtoProcedimientoDerivado
     * @param decisionProcedimiento el objeto DecisionProcedimiento
     *
     * @return ProcedimientoDerivado
     */
    private ProcedimientoDerivado crearProcedimientoDerivado(DtoProcedimientoDerivado dtoProc, DecisionProcedimiento decisionProcedimiento) {
    	
    	MEJProcedimiento procHijo = null;
    	if(dtoProc.getProcedimientoHijo() != null) {
    		procHijo = (MEJProcedimiento) prcManager.getProcedimiento(dtoProc.getProcedimientoHijo());
    	}
        
        if(procHijo == null) {
        	procHijo = new MEJProcedimiento();
        
			Procedimiento procPadre = prcManager.getProcedimiento(dtoProc.getProcedimientoPadre());
			
			Filter filtroProcOr = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoOrigen", procPadre.getTipoProcedimiento().getCodigo());
			Filter filtroProcDest = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoDestino", dtoProc.getTipoProcedimiento());
			MEJConfiguracionDerivacionProcedimiento configuracion=genericDao.get(MEJConfiguracionDerivacionProcedimiento.class, filtroProcOr, filtroProcDest);
	
	        procHijo.setAuditoria(Auditoria.getNewInstance());
	        procHijo.setProcedimientoPadre(procPadre);
	        procHijo.setPlazoRecuperacion(dtoProc.getPlazoRecuperacion());
	        procHijo.setSaldoRecuperacion(dtoProc.getSaldoRecuperacion());
	        procHijo.setPorcentajeRecuperacion(dtoProc.getPorcentajeRecuperacion());
	 
	        if (Checks.esNulo(configuracion)){
	        	
		        procHijo.setJuzgado(procPadre.getJuzgado());
		        procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
		        procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
		        procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
		        procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
	        } else {
	        	if (configuracion.getJuzgado()){
	        		procHijo.setJuzgado(procPadre.getJuzgado());
	        	}
	        	if (configuracion.getCodigoProcedimientoEnJuzgado()){
	        		procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
	        	}
	        	if (configuracion.getObservacionesRecopilacion()){
	        		procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());
	        	}
	        	if (configuracion.getSaldoOriginalNoVencido()){
	        		procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
	        	} 
	        	if(configuracion.getSaldoOriginalVencido()){
	        		procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
	        	}
	        }
	        
	        procHijo.setAsunto(procPadre.getAsunto());
	        procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
	        procHijo.setDecidido(procPadre.getDecidido());
	        procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());
	        
	        
	        // seteo el procedimiento como 'derivado'
	        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) diccionarioApi
	        		.dameValorDiccionarioByCod(DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
	        procHijo.setEstadoProcedimiento(estadoProcedimiento);
	
	        DDTipoActuacion tipoActuacion = (DDTipoActuacion) diccionarioApi
	        		.dameValorDiccionarioByCod(DDTipoActuacion.class, dtoProc.getTipoActuacion());
	        procHijo.setTipoActuacion(tipoActuacion);
	
	        TipoProcedimiento tipoProcedimiento= genericDao.get(TipoProcedimiento.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo", dtoProc.getTipoProcedimiento()));
	        
	        procHijo.setTipoProcedimiento(tipoProcedimiento);
	
	        DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion) diccionarioApi
	        		.dameValorDiccionarioByCod(DDTipoReclamacion.class, dtoProc.getTipoReclamacion());
	        procHijo.setTipoReclamacion(tipoReclamacion);
	
	        // Agrego las personas al procedimiento
	        List<Persona> personas = new ArrayList<Persona>();
	        for (Long idPersona : dtoProc.getPersonas()) {
	            if (Checks.esNulo(idPersona) || idPersona == 0) {
	                continue;
	            }
	
	            personas.add(genericDao.get(Persona.class, genericDao
	    				.createFilter(FilterType.EQUALS, "id", idPersona)));
	        }
	        procHijo.setPersonasAfectadas(personas);
	        
	        if (!Checks.estaVacio(procPadre.getBienes())) {
	            // Agrego los bienes al procedimiento
	            List<ProcedimientoBien> procedimientosBien = new ArrayList<ProcedimientoBien>();
		        if ((tipoProcedimiento.getIsUnicoBien() && procPadre.getBienes().size()==1) ||
		        		(!tipoProcedimiento.getIsUnicoBien())) {
			        for (ProcedimientoBien procBien : procPadre.getBienes()) {
			        	
			        	ProcedimientoBien procBienCopiado = new ProcedimientoBien();
			        	procBienCopiado.setBien(procBien.getBien());
			        	procBienCopiado.setSolvenciaGarantia(procBien.getSolvenciaGarantia());
			        	procBienCopiado.setProcedimiento(procHijo);
			        	genericDao.save(ProcedimientoBien.class, procBienCopiado);
			        	procedimientosBien.add(procBienCopiado);
			        }
		        }
		        procHijo.setBienes(procedimientosBien);
	        }
	        executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procHijo);
        }
    
        ProcedimientoDerivado procedimientoDerivado = new ProcedimientoDerivado();
        procedimientoDerivado.setId(dtoProc.getId());
        procedimientoDerivado.setGuid(dtoProc.getGuid());
        procedimientoDerivado.setProcedimiento(procHijo);
        procedimientoDerivado.setDecisionProcedimiento(decisionProcedimiento);
        procedimientoDerivado.setAuditoria(Auditoria.getNewInstance());

        return procedimientoDerivado;
    }

    private void validacionesPreviasCrearDecision(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento, Procedimiento procedimiento) {

    	logger.info("Validación 1. Los procedimientos hijos son derivables...");
		if (dtoDecisionProcedimiento.getFinalizar()) {

			List<TipoProcedimiento> tiposProcedimientosHijos = new ArrayList<TipoProcedimiento>();
			DecisionProcedimiento decision = dtoDecisionProcedimiento.getDecisionProcedimiento(); 
			
			// Comprueba los de la decisión ya creada (en caso que la decisión estuviera creada)
			if (decision!=null && decision.getProcedimientosDerivados()!=null) {
				for (ProcedimientoDerivado prcDerivado : decision.getProcedimientosDerivados()) {
					tiposProcedimientosHijos.add(prcDerivado.getProcedimiento().getTipoProcedimiento());
				}
			}
			
			for (DtoProcedimientoDerivado procedimientoDerivado : dtoDecisionProcedimiento.getProcedimientosDerivados()) {
				String codTipoProcedimientoDerivado = procedimientoDerivado.getTipoProcedimiento();
				TipoProcedimiento tipoProcedimiento = tipoProcedimientoManager.getByCodigo(codTipoProcedimientoDerivado);
				tiposProcedimientosHijos.add(tipoProcedimiento);
			}
			
			
			// Comprueba
			for (TipoProcedimiento tipoProcedimiento : tiposProcedimientosHijos) {
				if (!tipoProcedimiento.getIsDerivable()) {
					throw new BusinessOperationException(
				 			"No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decisi&oacute;n o se finaliza origen.");
				}
			}
		}
		

		logger.info("Validación 2. El procedimiento orgien está activo...");
//		if (procedimiento.getEstadoProcedimiento() != null
//				&& (procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO) || 
//						procedimiento.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO))){ 
//				throw new UserException("El procedimiento de origen no está activo");
//			}
			
		logger.info("Validación 3 en Aceptación de Decisión...");
		Set<String> tomasDeDecision = coreProjectContext.getCategoriasSubTareas().get(CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION);
		List<TareaNotificacion> vTareas = tareaNotifManager.getListByProcedimientoSubtipo(procedimiento.getId(), tomasDeDecision);
        
		if (vTareas != null && vTareas.size() > 0) {
			Iterator<TareaNotificacion> it = vTareas.iterator();
			while (it.hasNext()) {
				TareaNotificacion tar = it.next();
				if(tar.getSubtipoTarea().getCodigoSubtarea().compareTo(SubtipoTarea.CODIGO_TOMA_DECISION_BPM) == 0 && dtoDecisionProcedimiento.getParalizar()){
				 	throw new BusinessOperationException(
				 			"No esta permitido crear una decisión de tipo paralización cuando hay una tarea de tipo (Toma de decisión de continuidad) pendiente de completar por el usuario.");
				 }
				if (it.hasNext()){
					throw new BusinessOperationException(
				 			"No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decisi&oacute;n o se finaliza origen.");
				}
			}
		}
    }
    
    /**
     * Crea o Actualiza un objeto DecisionProcedimiento en la BD.
     *
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @return DecisionProcedimiento
     * @throws Exception e
     */
    public DecisionProcedimiento createCabecera(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento, Procedimiento procedimiento) 
    		throws Exception {

        DecisionProcedimiento decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();
        if (dtoDecisionProcedimiento.getDecisionProcedimiento().getId() == null) {
			decisionProcedimiento = new DecisionProcedimiento();
			decisionProcedimiento.setProcedimiento(procedimiento);
			dtoDecisionProcedimiento.setDecisionProcedimiento(decisionProcedimiento);
			 
			decisionProcedimiento.setEntidad(dtoDecisionProcedimiento.getEntidad());
			decisionProcedimiento.setGuid(dtoDecisionProcedimiento.getGuid());
        }

    	validacionesPreviasCrearDecision(dtoDecisionProcedimiento, procedimiento);
    	logger.info("Validaciones OK!! Creando decisión en base de datos...");
        
        DDEstadoDecision estadoDecision = (DDEstadoDecision)diccionarioApi.dameValorDiccionarioByCod(DDEstadoDecision.class, dtoDecisionProcedimiento.getStrEstadoDecision());
        decisionProcedimiento.setEstadoDecision(estadoDecision);
        decisionProcedimiento.setFinalizada(false);
        decisionProcedimiento.setParalizada(false);

        decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
        
        return decisionProcedimiento;
    }
    
    
    /**
     * Crea o Actualiza un objeto DecisionProcedimiento en la BD.
     *
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @return DecisionProcedimiento
     * @throws Exception e
     */
    public void createOrUpdate(DecisionProcedimiento decisionProcedimiento, MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) 
    		throws Exception {

        DDCausaDecisionFinalizar causaDecisionFinalizar = (DDCausaDecisionFinalizar) diccionarioApi
        		.dameValorDiccionarioByCod(DDCausaDecisionFinalizar.class,dtoDecisionProcedimiento.getCausaDecisionFinalizar());
        decisionProcedimiento.setCausaDecisionFinalizar(causaDecisionFinalizar);
        DDCausaDecisionParalizar causaDecisionParalizar = (DDCausaDecisionParalizar) diccionarioApi
        		.dameValorDiccionarioByCod(DDCausaDecisionParalizar.class,dtoDecisionProcedimiento.getCausaDecisionParalizar());
        decisionProcedimiento.setCausaDecisionParalizar(causaDecisionParalizar);
        
        decisionProcedimiento.setFinalizada(dtoDecisionProcedimiento.getFinalizar());
        decisionProcedimiento.setParalizada(dtoDecisionProcedimiento.getParalizar());

        // DOV 20/12/2011 setear comentarios y fecha hasta
        // debido a que no se actualizaban dichos valores cuando el super acepta propuesta
        decisionProcedimiento.setComentarios(dtoDecisionProcedimiento.getComentarios());
        decisionProcedimiento.setFechaParalizacion(dtoDecisionProcedimiento.getFechaParalizacion());
        
        if (decisionProcedimiento.getProcedimientosDerivados() == null) {
            decisionProcedimiento.setProcedimientosDerivados(new ArrayList<ProcedimientoDerivado>());
        }

        for (DtoProcedimientoDerivado procDerivado : dtoDecisionProcedimiento.getProcedimientosDerivados()) {
            if (procDerivado.getProcedimientoPadre() == null) {
                continue;
            }
            
            ProcedimientoDerivado prc = decisionProcedimiento.getProcedimientoDerivadoById(procDerivado.getId());
            if (prc != null) {
            	procDerivado.setProcedimientoDerivado(prc);
                continue;
            }
            prc = crearProcedimientoDerivado(procDerivado, decisionProcedimiento);
            procDerivado.setProcedimientoDerivado(prc);
            decisionProcedimiento.getProcedimientosDerivados().add(prc);
        }

        decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
    }
    
    private void notificarGestor(DecisionProcedimiento dp, boolean aceptada) {
        // Crear una notificacion al gestor
        Long idEntidadInformacion = dp.getProcedimiento().getId();
        String codigoTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
        
        // l�gica para decidir si la notificacion se env�a al gestor CEX o JUD
        Boolean esSupervisorCEX = (Boolean) executor.execute(EXTProcedimientoApi.MEJ_BO_PRC_ES_SUPERVISOR_CEX ,
    			dp.getProcedimiento().getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        
        Boolean esSupervisor = (Boolean) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ES_SUPERVISOR,
    			dp.getProcedimiento().getAsunto().getId());
    	
        String codigoSubtipoTarea = null;
        //Vamos a entender que si es supervisor no puede ser supervisorCEX
    	if (esSupervisorCEX && !esSupervisor)
    		codigoSubtipoTarea = EXTSubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR_CONFECCION_EXPTE;
    	else
    		codigoSubtipoTarea = SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO;
    	
        String ok = "";
        Object[] param = new Object[] { dp.getProcedimiento().getNombreProcedimiento() };
        if (aceptada) {
            ok = messageService.getMessage("decisionProcedimiento.resultado.aceptado", param);
        } else {
            ok = messageService.getMessage("decisionProcedimiento.resultado.rechazado", param);
        }
        // String descripcion = "Se ha " + ok +
        // " la propuesta de decision del procedimiento  " +
        // dp.getProcedimiento().getNombreProcedimiento();
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea, ok);
        //tareaNotificacionManager.crearNotificacion(idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea, ok);
    }
    
    private void finalizarTarea(Long idBPM) {
        jbpmUtil.signalProcess(idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
    }

	//@BusinessOperation(overrides = ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void aceptarPropuesta(
			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
		
		logger.info("Control de usuario para aceptar decisión...");
		boolean esGestor = !proxyFactory.proxy(ProcedimientoApi.class)
				.esSupervisor(dtoDecisionProcedimiento.getIdProcedimiento());
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		boolean tieneFuncionFinalizar = funcionManager.tieneFuncion(usuario, FUNCION_FINALIZAR_ASUNTOS);
		if (esGestor && !tieneFuncionFinalizar) {
			if (dtoDecisionProcedimiento.getFinalizar()
					|| dtoDecisionProcedimiento.getParalizar()) {
				throw new BusinessOperationException(
						"Sólo el supervisor puede finalizar o paralizar el origen");
			}
		}
		
		ConfiguradorPropuesta configuradorPropuesta = new ConfiguradorPropuesta();
		Procedimiento p = prcManager.getProcedimiento(dtoDecisionProcedimiento.getIdProcedimiento());
		MEJProcedimiento procedimiento = MEJProcedimiento.instanceOf(p);
		//Comprobamos si pasa por un lado u otro, si el PrcRemoto, del procedimiento, es 1 se pondra el estado en conformacion
		if(!Checks.esNulo(procedimiento.getPrcRemoto()) && procedimiento.getPrcRemoto() == 1 && procedimiento.getGuid() != null) {
			configuradorPropuesta.setConfiguracion(ConfiguradorPropuesta.SOLO_ENVIAR);
			dtoDecisionProcedimiento.setStrEstadoDecision(DDEstadoDecision.ESTADO_EN_CONFORMACION);
		}
		
		this.aceptarPropuestaSinControl(dtoDecisionProcedimiento, configuradorPropuesta);
	}

	@Transactional(readOnly = false)
	public void aceptarPropuestaSinControl(
			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento, ConfiguradorPropuesta configuradorPropuesta) {
		
		logger.info("Aceptando decisión...");

		Procedimiento procedimiento = prcManager.getProcedimiento(dtoDecisionProcedimiento.getIdProcedimiento());
		DecisionProcedimiento decision = dtoDecisionProcedimiento.getDecisionProcedimiento();

		boolean estabaPropuesto = decision !=null 
				&& decision.getEstadoDecision() != null 
				&& decision.getEstadoDecision().getCodigo().equals(DDEstadoDecision.ESTADO_PROPUESTO);

		validacionesPreviasCrearDecision(dtoDecisionProcedimiento, procedimiento);
		
		logger.info("Validación 1 en Aceptación de Decisión (valida procedimientos derivados en propuestas que no hayan cambiado de estado) ...");
		if (decision.getProcedimientosDerivados()!=null) {
			for (ProcedimientoDerivado prd : decision.getProcedimientosDerivados()) {
				Procedimiento prc = prd.getProcedimiento();
				// Validar estado del procedimiento
				if (!prc.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO)) { 
					throw new UserException(String.format("El procedimiento %d no está en estado derivado, no se puede aceptar el procedimiento", prc.getId()));
				}
			}
		}
		
		try {
			if(configuradorPropuesta.isCrearCabecera()) {
				logger.info("Todo correcto! Crea la decisión ...");
				decision = createCabecera(dtoDecisionProcedimiento, procedimiento);
				if(configuradorPropuesta.isCrearOActualizar()) {
					createOrUpdate(decision, dtoDecisionProcedimiento);
				}
			}
		}
		catch(UserException userException){
			logger.error("Ups, Error al crear la decisión!!! Mensaje al usuario: ", userException);
			throw userException;
		} 
		catch(Exception exc){
			logger.error("Ups, Error al crear la decisión!!! Excepción general: ", exc);
			throw new BusinessOperationException(exc);
		}
		
		if(configuradorPropuesta.isRegistrarSaldos()) {
			logger.info("Todo correcto! Actualiza los procedimientos derivados con los valores del origen ...");
			for (ProcedimientoDerivado prd : decision.getProcedimientosDerivados()) {
				Procedimiento prc= prd.getProcedimiento();
					
				// Registrar los saldos vencido y no vencido originales del último
				// movimiento de los contratos
				Movimiento mv = null;
				BigDecimal saldoOriginalNoVencido = new BigDecimal(0);
				BigDecimal saldoOriginalVencido = new BigDecimal(0);
				for (ExpedienteContrato ec : prc.getExpedienteContratos()) {
					mv = ec.getContrato().getLastMovimiento();
					if (mv != null) {
						saldoOriginalNoVencido = saldoOriginalNoVencido.add(new BigDecimal(mv.getPosVivaNoVencida().floatValue()));
						saldoOriginalVencido = saldoOriginalVencido.add(new BigDecimal(mv.getPosVivaVencida().floatValue()));
					}
				}
				prc.setSaldoOriginalNoVencido(saldoOriginalNoVencido);
				prc.setSaldoOriginalVencido(saldoOriginalVencido);
			
				if(configuradorPropuesta.isLanzarBPMs()) {
					// Lanzar los JBPM para cada procedimiento
					String nombreJBPM = prc.getTipoProcedimiento().getXmlJbpm();
					Map<String, Object> param = new HashMap<String, Object>();
					param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, prc.getId());
					Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);
					//
					prc.setProcessBPM(idBPM);
				}
				
				genericDao.update(Procedimiento.class, prc);
			}
		}
	
		// Verificar si se da por finalizado el procedimiento origen
		if (configuradorPropuesta.isFinalizarProcedimiento() && decision.getCausaDecisionFinalizar() != null && decision.getFinalizada()) {
			logger.info("Finalizando origen ...");
			finalizarProcedimiento(procedimiento, decision);
	    }
			
		if (configuradorPropuesta.isParalizarProcedimiento() && decision.getCausaDecisionParalizar() != null  && decision.getParalizada()) {
			logger.info("Paralizando origen ...");
			
			if(configuradorPropuesta.isAplazarBPMs()) {
				Long idProcessBPM = procedimiento.getProcessBPM();
				jbpmUtil.aplazarProcesosBPM(idProcessBPM, decision.getFechaParalizacion());
			}
			
			paralizarProcedimiento(procedimiento, decision);
		}
		
		if(configuradorPropuesta.isAceptarDecision()) {
	
	        // Setear Decision como aceptada
			DDEstadoDecision estadoDecision = (DDEstadoDecision)diccionarioApi
	    			.dameValorDiccionarioByCod(DDEstadoDecision.class, DDEstadoDecision.ESTADO_ACEPTADO); 
			decision.setEstadoDecision(estadoDecision);
	        genericDao.update(DecisionProcedimiento.class, decision);
		}
		
		if(configuradorPropuesta.isFinalizarTareaAsociada()) {
	
	        // Si tiene una tarea asignada a la decisi�n la finalizamos
	        TareaNotificacion tarea = decision.getTareaAsociada();
	        if (tarea != null) {
	            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
	        }
		}
		
		if(configuradorPropuesta.isBorrarTareaAsociada()) {
	
			// borrar la tarea
			if (decision.getProcessBPM() != null) {
				finalizarTarea(decision.getProcessBPM());
			}
		}
	
		if(configuradorPropuesta.isFinalizarTareasTomaDecision()) {
			// Finaliza las tareas
			finalizaTareaTomaDecision(procedimiento);
		}
		
		if(configuradorPropuesta.isActualizarEstadoAsunto()) {
	
			//Actualizamos el estado del asunto
			actualizarEstadoAsunto(procedimiento);
		}
	
		if(configuradorPropuesta.isNotificarGestor()) {
			// Enviar al gestor una notificación con el resultado de aceptación. 
			// Se genera despu�s de finalizar todas las tareas del procedimiento porque sin� se finaliza yno se muestra en las notificaciones 
			if (estabaPropuesto) {
				notificarGestor(decision, true);
			}
		}
		
		if(configuradorPropuesta.isEnviarDatos()) {
        	integracionBpmService.enviarDatos(dtoDecisionProcedimiento);
        }
        
		logger.info("Finaliza aceptación de decisión!!!");
	}

	public void actualizarEstadoAsunto(Procedimiento procedimiento) {
		executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO, procedimiento.getAsunto().getId());
	}

	public void paralizarProcedimiento(Procedimiento procedimiento, DecisionProcedimiento dp) {
		// PARALIZADO: Paralizar* durante el periodo especificado en la
		// decisión el procedimiento origen.
		MEJProcedimiento mejProcedimiento = MEJProcedimiento.instanceOf(procedimiento); 
		mejProcedimiento.setEstaParalizado(true);
		mejProcedimiento.setFechaUltimaParalizacion(new Date());
		genericDao.save(MEJProcedimiento.class, mejProcedimiento);
		this.ejecutarAccionesAdicionales(dp, procedimiento, this.accionesAdicionalesTrasParalizar);
	}

	public void finalizarProcedimiento(Procedimiento procedimiento, DecisionProcedimiento dp) {
		try {
			DDEstadoProcedimiento estadoFin = (DDEstadoProcedimiento)diccionarioApi
					.dameValorDiccionarioByCod(DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO); 
	 		procedimiento.setEstadoProcedimiento(estadoFin);
			genericDao.save(Procedimiento.class, procedimiento);
			
			jbpmUtil.finalizarProcedimiento(procedimiento.getId());

			cancelarSubastaActiva(procedimiento);

			for (TareaNotificacion t : procedimiento.getTareas()){
				if (!t.getAuditoria().isBorrado()) {
					if(t.getTareaFinalizada() == null || (t.getTareaFinalizada()!=null && !t.getTareaFinalizada())){
						t.setTareaFinalizada(true);
						genericDao.update(TareaNotificacion.class, t);
					}
				}
			}
			
			this.ejecutarAccionesAdicionales(dp, procedimiento, this.accionesAdicionalesTrasFinalizar);

        } catch (Exception e) {
            logger.error(String.format("Error al finalizar el procedimiento %d", procedimiento.getId()), e);
        }		
	}

	@Transactional(readOnly = false)
	private void cancelarSubastaActiva(Procedimiento p) {
		Set<String> codigosSubasta = new HashSet<String>();
		codigosSubasta.add("P401");
		codigosSubasta.add("P409");
		codigosSubasta.add("H002");
		codigosSubasta.add("H003");
		codigosSubasta.add("H004");
		if(codigosSubasta.contains(p.getTipoProcedimiento().getCodigo())){
			Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(p.getId());
			if(!Checks.esNulo(sub)){
				sub.setEstadoSubasta(genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoSubasta.CAN)));
				genericDao.save(Subasta.class, sub);
				
				// Mensaje de integración para notificar fin de BPM.
				integracionBpmService.enviarDatos(sub);
			}
		}
	}

	public void finalizaTareaTomaDecision(Procedimiento prc) {
		Set<String> tomasDeDecision = coreProjectContext.getCategoriasSubTareas().get(CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION);

		List<TareaNotificacion> vTareas = tareaNotifManager.getListByProcedimientoSubtipo(prc.getId(), tomasDeDecision);

		if (!Checks.estaVacio(vTareas)) {
			for (TareaNotificacion tn : vTareas) {
				if (!tn.getAuditoria().isBorrado()) {
					tn.setTareaFinalizada(true);
					genericDao.update(TareaNotificacion.class, tn);
				}
			}
		}
	}
	
	private void notificarSupervisorConEspera(DecisionProcedimiento dp) {
        // Crear una notificaci�n al Supervisor
        // "Se ha realizado una propuesta de decision sobre el  procedimiento  "
        // + dp.getProcedimiento().getNombreProcedimiento();
        // crear tarea para el supervisor de judicial o CEX seg�n el usuario que haya propuesto la decisi�n
    	
    	Boolean esGestorCEX = (Boolean) executor.execute(EXTProcedimientoApi.MEJ_BO_PRC_ES_GESTOR_CEX ,
    			dp.getProcedimiento().getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
    	Long idJBPM;
    	if (esGestorCEX)
    		idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, dp.getProcedimiento().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, EXTSubtipoTarea.CODIGO_PROPUESTA_DECISION_SUPERVISOR_CONFECCION_EXPTE,
                PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO,true);
    	else 
    		idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, dp.getProcedimiento().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO,
                PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO,true);
    	
        dp.setProcessBPM(idJBPM);
        genericDao.update(DecisionProcedimiento.class, dp);
    }
    
	 /**
     * Para crear o actualizar una propuesta de decision desde un rol de gestor.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_DEC_PRC_MGR_CREAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
    public void crearPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {

        Procedimiento procedimiento = prcManager.getProcedimiento(dtoDecisionProcedimiento.getIdProcedimiento());
		
        // seteo en estado propuesto la decision
        DDEstadoDecision estadoDecision = (DDEstadoDecision) diccionarioApi
        		.dameValorDiccionarioByCod(DDEstadoDecision.class, DDEstadoDecision.ESTADO_PROPUESTO);

        dtoDecisionProcedimiento.getDecisionProcedimiento().setEstadoDecision(estadoDecision);

        DecisionProcedimiento decisionProcedimiento = null;
        try{
        	decisionProcedimiento = createCabecera(dtoDecisionProcedimiento, procedimiento);
        	createOrUpdate(decisionProcedimiento, dtoDecisionProcedimiento);

        }catch(Exception exc){
        	throw new BusinessOperationException(exc);
        }
        
        Boolean isDerivable = false;
		List<ProcedimientoDerivado> derivarA = decisionProcedimiento.getProcedimientosDerivados();
		if (derivarA != null && derivarA.size() > 0) {
			for (ProcedimientoDerivado derivacion : derivarA) {
				if (derivacion.getProcedimiento().getTipoProcedimiento().getIsDerivable()) {
					isDerivable = true;
				}
			}
		}
		else{
			isDerivable = true;
		}

		if (!isDerivable && dtoDecisionProcedimiento.getFinalizar()) {
			throw new BusinessOperationException("No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decision o se finaliza origen.");
		}

        // enviar mensaje al supervisor
        notificarSupervisorConEspera(decisionProcedimiento);

        //Comprobamos si existe alguna tarea de decisi�n para este procedimiento y se la asociamos a la decisi�n
		Set<String> tomasDeDecision = coreProjectContext.getCategoriasSubTareas().get(CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION);
		List<TareaNotificacion> vTareas = tareaNotifManager.getListByProcedimientoSubtipo(procedimiento.getId(), tomasDeDecision);

        //Si tiene alguna tarea, borramos la primera de ellas
        if (vTareas != null && vTareas.size() > 0) {
        	

            Iterator<TareaNotificacion> it = vTareas.iterator();
            boolean tareaEncontrada = false;

            //Recorremos las tareas decisi�n del procedimiento
            while (it.hasNext() && !tareaEncontrada) {
                TareaNotificacion tarea = it.next();
                
                if(tarea.getSubtipoTarea().getCodigoSubtarea().compareTo(SubtipoTarea.CODIGO_TOMA_DECISION_BPM) == 0 && dtoDecisionProcedimiento.getParalizar()){
                 	throw new BusinessOperationException(
                 			"No esta permitido crear una decisión de tipo paralización cuando hay una tarea de tipo (Toma de decisión de continuidad) pendiente de completar por el usuario.");
                 }
                
                if (it.hasNext() && !isDerivable ){
                	throw new BusinessOperationException(
                 			"No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decision o se finaliza origen.");
                }

                // Buscamos la primera tarea que no est� asignada ya a una
                // decisi�n y no est� borrada; para asignarla a la decisi�n
                // actual
                if (tarea.getDecisionAsociada() == null && !tarea.getAuditoria().isBorrado()) {

                    tarea.getAuditoria().setBorrado(true);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);

                    decisionProcedimiento.setTareaAsociada(tarea);
                    genericDao.update(DecisionProcedimiento.class, decisionProcedimiento);
                    tareaEncontrada = true;
                }
            }

        } 

    }

	/**
	 * Muestra las decisiones del procedimiento pero si la decisi�n es de paralizaci�n
	 * lo que hace es mostrarla en la finalizaci�n, as� mostramos los datos en una
	 * sola columna por pantalla
	 * 
	 * @param id
	 *            Id propuesta/decision
	 * @param idProcedimiento
	 *            Id actuacion a eliminar
	 */
	@BusinessOperation(MEJ_BO_DECISIONPROCEDIMIENTO_LISTA)
	public List<DecisionProcedimiento> getListDecisionProcedimientoSoloConDecisionFinal(Long id) {		
		
		List<DecisionProcedimiento> datosConsulta = null;
		try{			
			datosConsulta = decisionProcedimientoDao.getByIdProcedimiento(id); //genericDao.getList(DecisionProcedimiento.class);
			for (int i=0;i<datosConsulta.size();i++){
				//Hacemos que se muestre la decisi�n de paralizar en la decisi�n 
				//de finalizar para mostrar s�lo un campo por pantalla
				if ( datosConsulta.get(i).getCausaDecisionParalizar()!=null ){
					DDCausaDecisionFinalizar causaFinal = new DDCausaDecisionFinalizar();
										
					causaFinal.setAuditoria(datosConsulta.get(i).getCausaDecisionParalizar().getAuditoria());
					causaFinal.setCodigo(datosConsulta.get(i).getCausaDecisionParalizar().getCodigo());
					causaFinal.setDescripcion(datosConsulta.get(i).getCausaDecisionParalizar().getDescripcion());
					causaFinal.setDescripcionLarga(datosConsulta.get(i).getCausaDecisionParalizar().getDescripcionLarga());
					causaFinal.setId(datosConsulta.get(i).getCausaDecisionParalizar().getId());
					causaFinal.setVersion(datosConsulta.get(i).getCausaDecisionParalizar().getVersion());
					
					DecisionProcedimiento datoNuevo = datosConsulta.get(i);
					datoNuevo.setCausaDecisionFinalizar(causaFinal);
					datosConsulta.set(i, datoNuevo);
				}
			}
			
		}
		catch(Exception e){
			System.out.println("ERROR: "+e.getMessage());
		}
		return datosConsulta;
	}		
	
	public DecisionProcedimiento prepareGuid(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
		
		DecisionProcedimiento decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();
		if(decisionProcedimiento != null && decisionProcedimiento.getId() != null) {
		
			if ( Checks.esNulo(decisionProcedimiento.getGuid())) {
				
				String guid = Guid.getNewInstance().toString();
				while(getDecisionProcedimientoByGuid(guid) != null) {
					guid = Guid.getNewInstance().toString();
				}
				decisionProcedimiento.setGuid(guid);
				decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
				
				extProcedimientoManager.prepareGuid(decisionProcedimiento.getProcedimiento());
			}
			
			dtoDecisionProcedimiento.setGuid(decisionProcedimiento.getGuid());
			
			if (dtoDecisionProcedimiento.getProcedimientosDerivados() != null) {
				for (DtoProcedimientoDerivado dtoProcedimientoDerivado : dtoDecisionProcedimiento.getProcedimientosDerivados()) {
					prepareGuid(dtoProcedimientoDerivado);
				}
			}
		}
		
		return decisionProcedimiento;
	}

	private void prepareGuid(DtoProcedimientoDerivado dtoProcedimientoDerivado) {

		ProcedimientoDerivado procedimientoDerivado = dtoProcedimientoDerivado.getProcedimientoDerivado();
		if(procedimientoDerivado != null) {
			if (Checks.esNulo(procedimientoDerivado.getGuid())) {
				
				String guid = Guid.getNewInstance().toString();
				while(procedimientoDerivadoDao.getByGuid(guid) != null) {
					guid = Guid.getNewInstance().toString();
				}
				
				procedimientoDerivado.setGuid(guid);
				genericDao.save(ProcedimientoDerivado.class, procedimientoDerivado);
				
				extProcedimientoManager.prepareGuid(procedimientoDerivado.getProcedimiento());
				
				dtoProcedimientoDerivado.setGuid(procedimientoDerivado.getGuid());
			}
		}
	}
	
	private void ejecutarAccionesAdicionales(DecisionProcedimiento dp, Procedimiento prc, List<AccionTomaDecision> acciones) {
		if (acciones==null) {
			return;
		}
		for (AccionTomaDecision accion : acciones) {
			accion.ejecutar(dp, prc);
		}
	}
	
	public DecisionProcedimiento getDecisionProcedimientoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		DecisionProcedimiento decisionProcedimiento = genericDao.get(DecisionProcedimiento.class, filtro);
		return decisionProcedimiento;
	}	

}
