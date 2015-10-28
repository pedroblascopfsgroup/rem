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
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.BPMContants;
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
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
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
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
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
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoProcedimientoDerivado;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoActuacionManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.MEJTipoReclamacionManager;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
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
    
    
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void rechazarPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
		try {
			DecisionProcedimiento dp = dtoDecisionProcedimiento.getDecisionProcedimiento();
			DecisionProcedimiento dp2 = HibernateUtils.merge(dp);
			dtoDecisionProcedimiento.setDecisionProcedimiento(dp2);
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

	        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
	                DDEstadoDecision.class, DDEstadoDecision.ESTADO_RECHAZADO);
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
        MEJProcedimiento procHijo = new MEJProcedimiento();

		Procedimiento procPadre= genericDao.get(Procedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "id", dtoProc.getProcedimientoPadre()));
		
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
        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
        procHijo.setEstadoProcedimiento(estadoProcedimiento);

        DDTipoActuacion tipoActuacion = (DDTipoActuacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoActuacion.class,
                dtoProc.getTipoActuacion());
        procHijo.setTipoActuacion(tipoActuacion);

        TipoProcedimiento tipoProcedimiento= genericDao.get(TipoProcedimiento.class, genericDao
				.createFilter(FilterType.EQUALS, "codigo", dtoProc.getTipoProcedimiento()));
        
        procHijo.setTipoProcedimiento(tipoProcedimiento);

        DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDTipoReclamacion.class, dtoProc.getTipoReclamacion());
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
    
        ProcedimientoDerivado procedimientoDerivado = new ProcedimientoDerivado();
        procedimientoDerivado.setId(dtoProc.getId());
        procedimientoDerivado.setProcedimiento(procHijo);
        procedimientoDerivado.setDecisionProcedimiento(decisionProcedimiento);
        procedimientoDerivado.setAuditoria(Auditoria.getNewInstance());

        return procedimientoDerivado;
    }


    /**
     * Crea o Actualiza un objeto DecisionProcedimiento en la BD.
     *
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @return DecisionProcedimiento
     * @throws Exception e
     */
    public DecisionProcedimiento createOrUpdate(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception {

        DecisionProcedimiento decisionProcedimiento = null;
        if (dtoDecisionProcedimiento.getDecisionProcedimiento().getId() != null) {
             decisionProcedimiento = genericDao.get(DecisionProcedimiento.class, genericDao
    				.createFilter(FilterType.EQUALS, "id", dtoDecisionProcedimiento.getDecisionProcedimiento().getId()));
        } else {
            decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();
        }
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, dtoDecisionProcedimiento.getStrEstadoDecision());

        decisionProcedimiento.setEstadoDecision(estadoDecision);
        
        DDCausaDecisionFinalizar causaDecisionFinalizar = (DDCausaDecisionFinalizar) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecisionFinalizar.class,dtoDecisionProcedimiento.getCausaDecisionFinalizar());        
        decisionProcedimiento.setCausaDecisionFinalizar(causaDecisionFinalizar);
        DDCausaDecisionParalizar causaDecisionParalizar = (DDCausaDecisionParalizar) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecisionParalizar.class,dtoDecisionProcedimiento.getCausaDecisionParalizar());        
        decisionProcedimiento.setCausaDecisionParalizar(causaDecisionParalizar);
        /*
        DDCausaDecision causaDecision = (DDCausaDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecision.class,
                dtoDecisionProcedimiento.getCausaDecision());
        decisionProcedimiento.setCausaDecision(causaDecision);
        */
        
        decisionProcedimiento.setFinalizada(dtoDecisionProcedimiento.getFinalizar());
        decisionProcedimiento.setParalizada(dtoDecisionProcedimiento.getParalizar());
        // DOV 20/12/2011 setear comentarios y fecha hasta
        // debido a que no se actualizaban dichos valores cuando el super acepta propuesta
        decisionProcedimiento.setComentarios(dtoDecisionProcedimiento.getComentarios());
        decisionProcedimiento.setFechaParalizacion(dtoDecisionProcedimiento.getFechaParalizacion());
        
        if (decisionProcedimiento.getProcedimientosDerivados() == null) {
            decisionProcedimiento.setProcedimientosDerivados(new ArrayList<ProcedimientoDerivado>());
        }
        int counter = 0;
        for (DtoProcedimientoDerivado procDerivado : dtoDecisionProcedimiento.getProcedimientosDerivados()) {
            if (procDerivado.getProcedimientoPadre() == null) {
                continue;
            }

            ProcedimientoDerivado prc = null;
            if (procDerivado.getId() != null) {

                prc = genericDao.get(ProcedimientoDerivado.class, genericDao.createFilter(FilterType.EQUALS, "id", procDerivado.getId()));

            }
            if (prc != null) {
                counter++;
                continue;
            }

            prc = crearProcedimientoDerivado(procDerivado, decisionProcedimiento);
            counter++;
            // Busco si el objeto existe en la lista de procedmientos derivados
            if (prc.getId() != null) {
                for (int i = 0; i < decisionProcedimiento.getProcedimientosDerivados().size(); i++) {
                    ProcedimientoDerivado prd = decisionProcedimiento.getProcedimientosDerivados().get(i);
                    if (prc.getId().equals(prd.getId())) {
                        decisionProcedimiento.getProcedimientosDerivados().set(i, prc);
                    }
                }
            } else {
                decisionProcedimiento.getProcedimientosDerivados().add(prc);
            }

        }

        genericDao.save(DecisionProcedimiento.class, decisionProcedimiento);
        return decisionProcedimiento;
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

	@BusinessOperation(overrides = ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void aceptarPropuesta(
			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
		boolean esGestor = !proxyFactory.proxy(ProcedimientoApi.class)
				.esSupervisor(dtoDecisionProcedimiento.getIdProcedimiento());
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		boolean tieneFuncionFinalizar = funcionManager.tieneFuncion(usuario, FUNCION_FINALIZAR_ASUNTOS);
		if (esGestor && !tieneFuncionFinalizar) {
			if (dtoDecisionProcedimiento.getFinalizar()
					|| dtoDecisionProcedimiento.getParalizar()) {
				throw new BusinessOperationException(
						"S�lo el supervisor puede finalizar o paralizar el origen");
			}
		}
		this.aceptarPropuestaSinControl(dtoDecisionProcedimiento);
	}

	@Transactional(readOnly = false)
	public void aceptarPropuestaSinControl(
			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
	    //TODO Simplificar este m�todo, demasiado complejo

		DecisionProcedimiento decisionPropuesta = null;
        if (dtoDecisionProcedimiento.getDecisionProcedimiento().getId() != null) {
        	decisionPropuesta = genericDao.get(DecisionProcedimiento.class, genericDao
    				.createFilter(FilterType.EQUALS, "id", dtoDecisionProcedimiento.getDecisionProcedimiento().getId()));
        } 
        boolean estabaPropuesto = decisionPropuesta!=null && decisionPropuesta.getEstadoDecision() != null && decisionPropuesta.getEstadoDecision().getCodigo().equals(DDEstadoDecision.ESTADO_PROPUESTO);
		DecisionProcedimiento decision = null;
			try{
	    decision = createOrUpdate(dtoDecisionProcedimiento);
	    
		}catch(Exception exc){
			throw new BusinessOperationException(exc);
		}
			
		//JZ
		Boolean isDerivable = false;
        List<ProcedimientoDerivado> derivarA = decision.getProcedimientosDerivados();
		if (derivarA != null && derivarA.size() > 0) {
			for (ProcedimientoDerivado derivacion : derivarA) {
				if (derivacion.getProcedimiento().getTipoProcedimiento().getIsDerivable()) {
					isDerivable = true;
				}
			}
		} else {
			isDerivable = true;
		}        
        
        if (!isDerivable && dtoDecisionProcedimiento.getFinalizar()){
        	throw new BusinessOperationException(
         			"No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decision o se finaliza origen.");
        }
        		
        DecisionProcedimiento dp = decision;
        TareaNotificacion tarea = dp.getTareaAsociada();
        
        List<TareaNotificacion> vTareas = (List<TareaNotificacion>) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO,
                dp.getProcedimiento().getId(), SubtipoTarea.CODIGO_TOMA_DECISION_BPM);


        if (vTareas != null && vTareas.size() > 0) {
            Iterator<TareaNotificacion> it = vTareas.iterator();
            while (it.hasNext()) {
                TareaNotificacion tar = it.next();
                
                if(tar.getSubtipoTarea().getCodigoSubtarea().compareTo(SubtipoTarea.CODIGO_TOMA_DECISION_BPM) == 0 && dtoDecisionProcedimiento.getParalizar()){
                 	throw new BusinessOperationException(
                 			"No esta permitido crear una decisión de tipo paralización cuando hay una tarea de tipo (Toma de decisión de continuidad) pendiente de completar por el usuario.");
                 }
                
                if (it.hasNext() && !isDerivable ){
                	throw new BusinessOperationException(
                 			"No es posible derivar a un Tramite de notificación o verbal desde monitorio, si se viene de una tarea de toma de decision o se finaliza origen.");
                }
            }
        }

        // Flag para saber si el estado estaba propuesto, y enviar una
        // notificacion al gestor con el resultado
        
        
        MEJProcedimiento p = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", dp.getProcedimiento().getId()));
        
        // VALIDACIONES
        // No existen los procedimientos con los c�digos pasados como
        // par�metros.
        // El procedimiento origen no est� activo.
        if (p.getEstadoProcedimiento() != null
                && (p.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO || p.getEstadoProcedimiento()
                        .getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)) { throw new UserException(
                "El procedimiento de origen no est� activo"); }

        for (ProcedimientoDerivado prd : dp.getProcedimientosDerivados()) {
    		Procedimiento prc= genericDao.get(Procedimiento.class, genericDao
    				.createFilter(FilterType.EQUALS, "id", prd.getProcedimiento().getId()));
        	
            // Validar estado del procedimiento
            if (!prc.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO)) { throw new UserException(
                    "El procedimiento " + prc.getId() + " no est� en estado derivado"); }

            // Registrar los saldos vencido y no vencido originales del �ltimo
            // movimiento de los contratos
            Movimiento mv = null;
            BigDecimal saldoOriginalNoVencido = new BigDecimal("0.0");
            BigDecimal saldoOriginalVencido = new BigDecimal("0.0");
            for (ExpedienteContrato ec : prc.getExpedienteContratos()) {
                mv = ec.getContrato().getLastMovimiento();
                if (mv != null) {
                    saldoOriginalNoVencido = saldoOriginalNoVencido.add(new BigDecimal(mv.getPosVivaNoVencida().floatValue()));
                    saldoOriginalVencido = saldoOriginalVencido.add(new BigDecimal(mv.getPosVivaVencida().floatValue()));
                }
            }
            prc.setSaldoOriginalNoVencido(saldoOriginalNoVencido);
            prc.setSaldoOriginalVencido(saldoOriginalVencido);

            // Lanzar los JBPM para cada procedimiento
            String nombreJBPM = prc.getTipoProcedimiento().getXmlJbpm();
            Map<String, Object> param = new HashMap<String, Object>();
            param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, prc.getId());
            Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);
            //
            prc.setProcessBPM(idBPM);
            genericDao.update(Procedimiento.class, prc);
        }

        // Lanzar el/los proceso/s correspondiente/s (incluidos en la
        // derivaci�n)

        // Verificar si se da por finalizado el procedimiento origen
        //if (dp.getCausaDecision() != null) {
        if (dp.getCausaDecisionFinalizar() != null) {
            if (dp.getFinalizada()) {
                // FINALIZADO:Parar definitivamente el procedimiento origen
                try {
                	
                    jbpmUtil.finalizarProcedimiento(p.getId());
                    //p.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao
            				//.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)));

                	// Integración con mensajería
                    integracionBpmService.finalizarBPM(p);

                    cancelarSubastaActiva(p);

                } catch (Exception e) {
                    logger.error("Error al finalizar el procedimiento " + p.getId(), e);
                }
            }
        }
		if (dp.getCausaDecisionParalizar() != null) {
			Long idProcessBPM = p.getProcessBPM();
			if (dp.getParalizada()) {
				// PARALIZADO: Paralizar* durante el periodo especificado en la
				// decisi�n el procedimiento origen.
				jbpmUtil.aplazarProcesosBPM(idProcessBPM, dp.getFechaParalizacion());

				p.setEstaParalizado(true);
				p.setFechaUltimaParalizacion(new Date());
				genericDao.save(MEJProcedimiento.class, p);

				// Paralizamos el BPM
				integracionBpmService.paralizarBPM(p, dp.getFechaParalizacion());
			}
		}
		
        // Setear Decision como aceptada
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, DDEstadoDecision.ESTADO_ACEPTADO);

        dp.setEstadoDecision(estadoDecision);

        genericDao.update(DecisionProcedimiento.class, dp);

        // Si tiene una tarea asignada a la decisi�n la finalizamos
        if (tarea != null) {
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
        }

        // borrar la tarea
        if (dp.getProcessBPM() != null) {
            finalizarTarea(dp.getProcessBPM());
        }

        //Actualizamos el estado del asunto
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO, p.getAsunto().getId());
		
		finalizaTareaTomaDecision(dtoDecisionProcedimiento.getIdProcedimiento());
		
		
		//FINALIZAMOS TODAS LAS TAREAS DEL PROCEDIMIENTO
		if(dp.getFinalizada()){
			for(TareaNotificacion t:p.getTareas()){
				if (!t.getAuditoria().isBorrado()) {
					if(t.getTareaFinalizada() == null || (t.getTareaFinalizada()!=null && !t.getTareaFinalizada())){
						t.setTareaFinalizada(true);
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}
		}

	    // Enviar al gestor una notificación con el resultado de aceptación. 
		// Se genera despu�s de finalizar todas las tareas del procedimiento porque sin� se finaliza yno se muestra en las notificaciones 
		if (estabaPropuesto) {
	         notificarGestor(dp, true);
	    }
		
		//Se comenta la notificaci�n al propio supervisor de la aceptaci�n de la propuesta ya que �l mismo la ha aceptado y es redundante
		//Object[] param = new Object[] { getNombreProcedimiento(dtoDecisionProcedimiento.getIdProcedimiento()) };
		//generaNotificacion(dtoDecisionProcedimiento.getIdProcedimiento(), messageService.getMessage("decisionProcedimiento.resultado.aceptado", param));
	}

	@Transactional(readOnly = false)
	private void cancelarSubastaActiva(MEJProcedimiento p) {
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


	private void generaNotificacion(Long idProcedimiento, String string) {
		
		
		// l�gica para decidir si la notificacion se env�a al gestor CEX o JUD
        Boolean esSupervisorCEX = (Boolean) executor.execute(EXTProcedimientoApi.MEJ_BO_PRC_ES_SUPERVISOR_CEX ,
        		idProcedimiento, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
    	
        String subtipoTarea = "9999999999";
    	if (esSupervisorCEX)
    		subtipoTarea = EXTSubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR_2_CONFECCION_EXPTE;
		
		SubtipoTarea st = genericDao.get(SubtipoTarea.class, genericDao
				.createFilter(FilterType.EQUALS, "codigoSubtarea", subtipoTarea));
		
		if (st == null) {
			logger.warn("No se ha configurado el Subtipo Tarea Base "
					+ subtipoTarea
					+ ", no se va a mandar la segunda notificaci�n");
		} else {
			proxyFactory.proxy(TareaNotificacionApi.class).crearNotificacion(
					idProcedimiento,
					DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, subtipoTarea,
					string);
		}
	}

	private void finalizaTareaTomaDecision(Long prcId) {
		Set<String> tomasDeDecision = coreProjectContext.getCategoriasSubTareas().get(CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION);
		
		List<TareaNotificacion> vTareas = proxyFactory.proxy(
				TareaNotificacionApi.class).getListByProcedimientoSubtipo(
				prcId, tomasDeDecision);

		if (!Checks.estaVacio(vTareas)) {
			for (TareaNotificacion tn : vTareas) {
				if (!tn.getAuditoria().isBorrado()) {
					tn.setTareaFinalizada(true);
					genericDao.update(TareaNotificacion.class, tn);
					HibernateUtils.merge(tn);
				}
			}
		}
	}
	
	private String getNombreProcedimiento(Long idProcedimiento) {
		Procedimiento p = proxyFactory.proxy(es.pfsgroup.recovery.api.ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		if (p == null){
			return "";
		}else{
			return p.getAsunto().getNombre() + "-" + p.getTipoProcedimiento().getDescripcion();
		}
	}
	
    private void notificarSupervisor(DecisionProcedimiento dp) {
        // Crear una notificaci�n al Supervisor
        // String descripcion =
        // "Se ha realizado una propuesta de decision sobre el  procedimiento  "
        // + dp.getProcedimiento().getNombreProcedimiento();
        // crear tareas para el supervisor
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, dp.getProcedimiento().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO,
                PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO);
        dp.setProcessBPM(idJBPM);
        genericDao.update(DecisionProcedimiento.class, dp);
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

        // seteo en estado propuesto la decision
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, DDEstadoDecision.ESTADO_PROPUESTO);

        dtoDecisionProcedimiento.getDecisionProcedimiento().setEstadoDecision(estadoDecision);

        DecisionProcedimiento decisionProcedimiento;
        try{
        	decisionProcedimiento = createOrUpdate(dtoDecisionProcedimiento);

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
        notificarSupervisorConEspera(dtoDecisionProcedimiento.getDecisionProcedimiento());

        //Comprobamos si existe alguna tarea de decisi�n para este procedimiento y se la asociamos a la decisi�n
        List<TareaNotificacion> vTareas = (List<TareaNotificacion>) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO,
                dtoDecisionProcedimiento.getDecisionProcedimiento().getProcedimiento().getId(), SubtipoTarea.CODIGO_TOMA_DECISION_BPM);

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
	
	
}
