package es.pfsgroup.plugin.recovery.config.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public interface ADMAsuntoDao extends AbstractDao<EXTAsunto, Long>{

	/**
	 * 
	 * @param idProcurador es un objeto de tabla usd_usuarios_despachos
	 * @return
	 */
	public List<EXTAsunto> getAsuntosProcurador(Long idProcurador);

	/**
	 * 
	 * @param idSupervisor es un objeto de tabla usd_usuarios_despachos
	 * @return
	 */
	public List<EXTAsunto> getAsuntosSupervisor(Long idSupervisor);

	/**
	 * 
	 * @param idGestor es un objeto de tabla usd_usuarios_despachos
	 * @return
	 */
	public List<EXTAsunto> getAsuntosGestor(Long idGestor);
	
	/**
	 * 
	 * @param idUsuario en un id de la tabla usu_usuarios
	 * @return
	 */
	public List<EXTAsunto> getAsuntosUsuario(Long idUsuario); 
	
	/**
	 * 
	 * @param idUsuario en un id de la tabla usu_usuarios
	 * @return
	 */
	public List<EXTAsunto> getAsuntosUsuarioProcurador (Long idUsuario); 
	
	/**
	 * 
	 * @param idUsuario
	 * @return
	 */
	public List<EXTAsunto> getAsuntosUsuarioSupervisor (Long idUsuario); 
	
	

}
