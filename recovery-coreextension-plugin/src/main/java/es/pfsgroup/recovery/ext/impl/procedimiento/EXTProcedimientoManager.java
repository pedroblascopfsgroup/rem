package es.pfsgroup.recovery.ext.impl.procedimiento;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.AccionDesparalizarProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.MEJRecursoDao;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class EXTProcedimientoManager implements EXTProcedimientoApi {

	@Autowired
	private EXTProcedimientoDao extProcedimientoDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;

	@Autowired
	private EXTPersonaDao personaDao;
	
	@Autowired
	private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private DecisionProcedimientoManager decisionProcedimientoManager;
	
	@Autowired
	private MEJRecursoDao recursoDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private IntegracionBpmService integracionBPMService;
	
	@Autowired
	private CoreProjectContext coreProjectContext;
	
	@Autowired(required=false)
	private List<AccionDesparalizarProcedimiento> accionesAdicionalTrasDesparalizar;
		
	/**
	 * Busca procedimientos que contengan un determinado contrato
	 * 
	 * @param idContrato
	 *            ID del contrato buscado
	 * @param estados
	 *            Posibles estados de los Procedimientos a devolver. Si es NULL
	 *            se devolveran todos los procedimientos independientemente del
	 *            estado
	 * @return
	 */
	@BusinessOperation(BO_PRC_MGR_BUSCAR_PRC_CON_CONTRATO)
	@Override
	@Transactional
	public List<? extends Procedimiento> buscaProcedimientoConContrato(
			Long idContrato, String[] estados) {
		return extProcedimientoDao.buscaProcedimientoConContrato(idContrato,
				estados);
	}
	
	@SuppressWarnings("unchecked")
	public boolean tieneGestorYSupervisor(Long idProcedimiento){
		boolean resultado = false;
		boolean tieneSupervisor = false;
		boolean tieneGestor = false;
		
		Procedimiento pr = extProcedimientoDao.get(idProcedimiento);
		if(pr != null){
			HashSet<EXTUsuarioRelacionadoInfo> usuarios = (HashSet<EXTUsuarioRelacionadoInfo>)executor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS,pr.getAsunto().getId());
			
			for(EXTUsuarioRelacionadoInfo usuRel:usuarios){
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR.equalsIgnoreCase(usuRel.getTipoGestor().getCodigo())){
					tieneSupervisor = true;
				}
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.equalsIgnoreCase(usuRel.getTipoGestor().getCodigo())){
					tieneGestor = true;
				}
//				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR.equalsIgnoreCase(usuRel.getTipoGestor().getCodigo())){
//					tieneGestor = true;
//				}
			}
			
			if(tieneGestor && tieneSupervisor)
				resultado = true;
			
		}
		return resultado;
	}
	/**
	 * Este m�todo devuelve cual es el gestor de un procedimiento
	 * @param idProcedimiento Id del procedimiento del que queremos averiguar
	 * @return Devuelve un STring con el nombre y el apellido
	 */
	@SuppressWarnings("unchecked")
	public String getGestor(Long idProcedimiento){
		
		Procedimiento pr = extProcedimientoDao.get(idProcedimiento);
		if(pr != null){
			HashSet<EXTUsuarioRelacionadoInfo> usuarios = (HashSet<EXTUsuarioRelacionadoInfo>)executor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS,pr.getAsunto().getId());
			
			for(EXTUsuarioRelacionadoInfo usuRel:usuarios){
				
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.equalsIgnoreCase(usuRel.getTipoGestor().getCodigo())){
					return usuRel.getUsuario().getApellidoNombre();
				}
				
			}			
		}
		return "";
	}
	
	@SuppressWarnings("unchecked")
	public String getSupervisor(Long idProcedimiento){
		
		Procedimiento pr = extProcedimientoDao.get(idProcedimiento);
		if(pr != null){
			HashSet<EXTUsuarioRelacionadoInfo> usuarios = (HashSet<EXTUsuarioRelacionadoInfo>)executor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS,pr.getAsunto().getId());
			
			for(EXTUsuarioRelacionadoInfo usuRel:usuarios){
				
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR.equalsIgnoreCase(usuRel.getTipoGestor().getCodigo())){
					return usuRel.getUsuario().getApellidoNombre();
				}
				
			}			
		}
		return "";
	}

	public void setExecutor(Executor executor) {
		this.executor = executor;
	}

	public Executor getExecutor() {
		return executor;
	}

	@Override
	@BusinessOperation(BO_PRC_MGR_IS_PERSONA_EN_PROCEDIMIENTO)
	public Boolean isPersonaEnProcedimiento(Long idProcedimiento, Long idPersona) {
		return (Checks.esNulo(extProcedimientoDao.getPersonaProcedimiento(idProcedimiento, idPersona)) ? false : true);
	}
	
	
	@Override
	@BusinessOperation(BO_PRC_MGR_GET_INSTANCE_OF)
	public MEJProcedimiento getInstanceOf(Procedimiento procedimiento) {
		if (procedimiento instanceof MEJProcedimiento) {
			return (MEJProcedimiento) procedimiento;
		}
		if (Hibernate.getClass(procedimiento).equals(MEJProcedimiento.class)) {
			HibernateProxy proxy = (HibernateProxy) procedimiento;				
			return((MEJProcedimiento) proxy.writeReplace());
		}
		return null;
	}
    
	public MEJProcedimiento getProcedimientoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		MEJProcedimiento procedimiento = genericDao.get(MEJProcedimiento.class, filtro);
		return procedimiento;
	}

	public MEJProcedimiento prepareGuid(Procedimiento procedimiento) {
		MEJProcedimiento mejProc = MEJProcedimiento.instanceOf(procedimiento);
		boolean modificados = false;
		if (Checks.esNulo(mejProc.getGuid())) {
			//logger.debug(String.format("[INTEGRACION] Asignando nuevo GUID para procedimiento %d", procedimiento.getId()));
			mejProc.setGuid(Guid.getNewInstance().toString());
			modificados = true;
		}
		
		// Prepara la relación con los bienes.
		if (mejProc.getBienes()!=null) {
			for (ProcedimientoBien prcBien : mejProc.getBienes()) {
				if (!Checks.esNulo(prcBien.getGuid())) {
					continue;
				}
				prcBien.setGuid(Guid.getNewInstance().toString());
				modificados = true;
			}
		}

		// En caso de haber cambiado algo se guarda el estado
		if (modificados) {
			extProcedimientoDao.saveOrUpdate(mejProc);
		}
		return mejProc;
	}
	
	
	public Procedimiento guardaProcedimiento(EXTProcedimientoDto procDto) {
		MEJProcedimiento procedimiento =  null;

		MEJConfiguracionDerivacionProcedimiento configuracion  = null;
		if (procDto.getProcedimientoPadre()!=null) {
			Filter filtroProcOr = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoOrigen", procDto.getProcedimientoPadre().getTipoProcedimiento().getCodigo());
			Filter filtroProcDest = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimientoDestino", procDto.getTipoProcedimiento().getCodigo());
			configuracion = genericDao.get(MEJConfiguracionDerivacionProcedimiento.class, filtroProcOr, filtroProcDest);
		}
		
		if (procDto.getIdProcedimiento()==null) {
			procedimiento = new MEJProcedimiento();
			
			procedimiento.setAsunto(procDto.getAsunto());
			procedimiento.setProcedimientoPadre(procDto.getProcedimientoPadre());
			procedimiento.setTipoProcedimiento(procDto.getTipoProcedimiento());
			procedimiento.setDecidido(procDto.getDecidido());

			String guid = (!Checks.esNulo(procDto.getGuid())) ? procDto.getGuid() : Guid.getNewInstance().toString();
			procedimiento.setGuid(guid);
			
			if (Checks.esNulo(configuracion)){			
				procedimiento.setTipoActuacion(procDto.getTipoProcedimiento().getTipoActuacion());
			} else {
				if (configuracion.getTipoActuacion()){
					procedimiento.setTipoActuacion(procDto.getTipoProcedimiento().getTipoActuacion());
				}
			}

		} else {
			Procedimiento tmpProcedimiento = procedimientoDao.get(procDto.getIdProcedimiento());
			if (tmpProcedimiento==null) {
				throw new RuntimeException(String.format("Procedimiento no encontrado para actualizar: %d", procDto.getIdProcedimiento()));
			}
			procedimiento = MEJProcedimiento.instanceOf(tmpProcedimiento);
			
		}
		
		procedimiento.setExpedienteContratos(procDto.getExpedienteContratos());
		// procedimiento.setContrato(procPadre.getContrato());
		
		procedimiento.setFechaRecopilacion(procDto.getFechaRecopilacion());
		List<Persona> personas = new ArrayList<Persona>();
		for (Persona per : procDto.getPersonas()) {
			Persona p = personaDao.get(per.getId());
			personas.add(p);
		}
		procedimiento.setPersonasAfectadas(personas);
		procedimiento.setEstadoProcedimiento(procDto.getEstadoProcedimiento());
		
		if (Checks.esNulo(configuracion)){
			procedimiento.setJuzgado(procDto.getJuzgado());
			procedimiento.setCodigoProcedimientoEnJuzgado(procDto.getCodigoProcedimientoEnJuzgado());
			procedimiento.setObservacionesRecopilacion(procDto.getObservacionesRecopilacion());
			procedimiento.setPlazoRecuperacion(procDto.getPlazoRecuperacion());
			procedimiento.setPorcentajeRecuperacion(procDto.getPorcentajeRecuperacion());
			procedimiento.setSaldoOriginalNoVencido(procDto.getSaldoOriginalNoVencido());
			procedimiento.setSaldoOriginalVencido(procDto.getSaldoOriginalVencido());
			procedimiento.setSaldoRecuperacion(procDto.getSaldoRecuperacion());
			procedimiento.setTipoReclamacion(procDto.getTipoReclamacion());
		} else {
			
			if (configuracion.getJuzgado()){
				procedimiento.setJuzgado(procDto.getJuzgado());
			}
			if (configuracion.getCodigoProcedimientoEnJuzgado()){
				procedimiento.setCodigoProcedimientoEnJuzgado(procDto.getCodigoProcedimientoEnJuzgado());
			}
			if (configuracion.getObservacionesRecopilacion()){
				procedimiento.setObservacionesRecopilacion(procDto.getObservacionesRecopilacion());
			}
			if (configuracion.getPlazoRecuperacion()){
				procedimiento.setPlazoRecuperacion(procDto.getPlazoRecuperacion());
			} 
			if (configuracion.getPorcentajeRecuperacion() ){
				procedimiento.setPorcentajeRecuperacion(procDto.getPorcentajeRecuperacion());
			}
			if (configuracion.getSaldoOriginalNoVencido()){
				procedimiento.setSaldoOriginalNoVencido(procDto.getSaldoOriginalNoVencido());
			}
			if (configuracion.getSaldoOriginalVencido()){
				procedimiento.setSaldoOriginalVencido(procDto.getSaldoOriginalVencido());
			}
			if (configuracion.getSaldoRecuperacion() ){
				procedimiento.setSaldoRecuperacion(procDto.getSaldoRecuperacion());
			}
			if (configuracion.getTipoReclamacion()){
				procedimiento.setTipoReclamacion(procDto.getTipoReclamacion());
			}
		}
		
		if (!Checks.estaVacio(procDto.getBienes())) {
            // Agrego los bienes al procedimiento
            List<ProcedimientoBien> procedimientosBien = new ArrayList<ProcedimientoBien>();
            
            // Si es automático no se comprueba el flag unicoBien, se copian todos.
//	        if ((tipoProcedimiento.getIsUnicoBien() && procPadre.getBienes().size()==1) ||
//	        		(!tipoProcedimiento.getIsUnicoBien())) {
		        for (ProcedimientoBien procBien : procDto.getBienes()) {
		        	
		        	ProcedimientoBien procBienCopiado = new ProcedimientoBien();
		        	procBienCopiado.setBien(procBien.getBien());
		        	procBienCopiado.setSolvenciaGarantia(procBien.getSolvenciaGarantia());
		        	procBienCopiado.setProcedimiento(procedimiento);
		        	genericDao.save(ProcedimientoBien.class, procBienCopiado);
		        	procedimientosBien.add(procBienCopiado);
		        }
//	        }
	        procedimiento.setBienes(procedimientosBien);
        }
		
		executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO, procedimiento);
		return procedimiento;// procedimientoManager.getProcedimiento(idProcedimiento);
	}

	@Override
	@BusinessOperation(MEJ_BO_PRC_ES_GESTOR_CEX)
	public Boolean esGestorCEX(Long idProcedimiento, String codUg) {
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equalsIgnoreCase(codUg)) {
			Long idAsunto = procedimientoDao.get(idProcedimiento).getAsunto().getId();
			EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));

			Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			if (asunto.getGestorCEXP() != null && asunto.getGestorCEXP().getUsuario() != null)
				return asunto.getGestorCEXP().getUsuario().getId().equals(usuario.getId());
			else
				return false;

		} else
			return false;

	}

	@Override
	@BusinessOperation(MEJ_BO_PRC_ES_SUPERVISOR_CEX)
	public Boolean esSupervisorCEX(Long idProcedimiento, String codUg) {
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equalsIgnoreCase(codUg)) {
			Long idAsunto = procedimientoDao.get(idProcedimiento).getAsunto().getId();
			EXTAsunto asunto = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto));

			Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			if (asunto.getSupervisorCEXP() != null && asunto.getSupervisorCEXP().getUsuario() != null)
				return asunto.getSupervisorCEXP().getUsuario().getId().equals(usuario.getId());
			else
				return false;

		} else
			return false;

	}

	@Override
	@Transactional(readOnly = false)
	public void desparalizarProcedimiento(Long idProcedimiento) {
		this.desparalizarProcedimiento(idProcedimiento, true);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void desparalizarProcedimiento(Long idProcedimiento, boolean envioMsg) {
		
		MEJProcedimiento prc = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		if (prc == null || !prc.isEstaParalizado()) {
			return;
		} 
			
		// Integración para enviar la acción de activación 
		if (prc.getProcessBPM()==null && envioMsg) {
			integracionBPMService.activarBPM(prc);
			return;
		}
		
		// Antes de desparalizar las tareas hay que comprobar que no haya recursos pendientes
		boolean recSinFinalizar = false;
		List<Recurso> listRecProc = recursoDao.getRecursosPorProcedimiento(idProcedimiento);
		
		if (listRecProc != null){
			for (Recurso rec : listRecProc) {
				if(Checks.esNulo(rec.getResultadoResolucion())){
					recSinFinalizar = true;
				}
			}
		}
		
		if (!recSinFinalizar && prc.getProcessBPM()!=null){
			Map<String, Object> variables = new HashMap<String, Object>();
			if (!Checks.esNulo(prc.getPlazoParalizacion())) {
				// FIXME Poner la constante PLAZO_TAREAS_DEFAULT en alg�n sitio
				variables.put("PLAZO_TAREA_DEFAULT", prc.getPlazoParalizacion());
			}
			
			jbpmUtil.addVariablesToProcess(prc.getProcessBPM(), variables);
			jbpmUtil.activarProcesosBPM(prc.getProcessBPM());
		}

		prc.setEstaParalizado(false);
		prc.setFechaUltimaParalizacion(null);
		prc.setPlazoParalizacion(null);

		genericDao.save(MEJProcedimiento.class, prc);
		
		if (this.accionesAdicionalTrasDesparalizar!=null) {
			for (AccionDesparalizarProcedimiento accion : this.accionesAdicionalTrasDesparalizar) {
				accion.ejecutar(prc);
			}
		}
		
		// Integración para enviar el procedimiento, sólo para los originales 
		if (envioMsg) {
			integracionBPMService.activarBPM(prc);
		}
		
	}
	
	@Override
	public MEJProcedimiento get(Long idProcedimiento) {
		MEJProcedimiento prc = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		return prc;
	}
	
	@Override
	public boolean isDespararizable(Long idProcedimiento) {
		MEJProcedimiento prc = this.get(idProcedimiento);
		return (prc != null && prc.isEstaParalizado());
	}
	
	@Override
	public boolean isDespararizablePorEntidad(Long idProcedimiento) {
		if (!isDespararizable(idProcedimiento)) {
			return false;
		}

		// Comprueba que ha sido generado por la misma entidad
		MEJProcedimiento prc = this.get(idProcedimiento);
		// Se recupera la decisión de paralización para comprobar si se ha tomado desde la misma entidad en que estamos actualmente o en una de las
		// que se permite la desparalización
		DecisionProcedimiento decisionParalizacion = null;
		for(DecisionProcedimiento decisionProcedimiento : decisionProcedimientoManager.getList(idProcedimiento)) {
			if(decisionProcedimiento.getParalizada()) {
				if(decisionParalizacion != null) {
					if(decisionProcedimiento.getAuditoria().getFechaCrear().after(decisionParalizacion.getAuditoria().getFechaCrear())) {
						decisionParalizacion = decisionProcedimiento;
					}
				}
				else {
					decisionParalizacion = decisionProcedimiento;
				}
			}
		}
		
		if(decisionParalizacion != null && !Checks.esNulo(decisionParalizacion.getEntidad())) {
			Set<String> entidadesDesparalizables = coreProjectContext.getEntidadesDesparalizacion();
			return entidadesDesparalizables.contains(decisionParalizacion.getEntidad());
		}
		
		return true;
	}
	
}
