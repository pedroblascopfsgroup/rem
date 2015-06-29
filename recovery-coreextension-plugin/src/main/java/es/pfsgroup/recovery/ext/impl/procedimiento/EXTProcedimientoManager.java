package es.pfsgroup.recovery.ext.impl.procedimiento;

import java.util.HashSet;
import java.util.List;
import java.util.UUID;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;

@Component
public class EXTProcedimientoManager implements EXTProcedimientoApi {

	@Autowired
	private EXTProcedimientoDao extProcedimientoDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;


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

	public MEJProcedimiento getProcedimientoById(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		MEJProcedimiento mejProc = genericDao.get(MEJProcedimiento.class, filter);
		return mejProc;
	}
	
	public MEJProcedimiento prepareGuid(Procedimiento procedimiento) {
		MEJProcedimiento mejProc = getProcedimientoById(procedimiento.getId());
		if (Checks.esNulo(mejProc.getGuid())) {
			//logger.debug(String.format("[INTEGRACION] Asignando nuevo GUID para procedimiento %d", procedimiento.getId()));
			mejProc.setGuid(UUID.randomUUID().toString());
			extProcedimientoDao.saveOrUpdate(mejProc);
		}
		return mejProc;
	}
	
}
