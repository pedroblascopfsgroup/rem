package es.pfsgroup.recovery.ext.impl.procedimiento;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

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
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;
import es.pfsgroup.recovery.integration.Guid;

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
	
}
