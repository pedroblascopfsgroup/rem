package es.pfsgroup.recovery.ext.api.multigestor.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

public interface EXTGrupoUsuariosDao extends AbstractDao<EXTGrupoUsuarios, Long>{

	List<Long> buscaGruposUsuario(Usuario usuario);
	List<Long> buscaGruposUsuarioById(Long usuId);
	
	/**
	 * Devuelve los Ids de los usuarios del grupo al que pertenece el usuario
	 * @param usuario
	 * @return
	 */
	List<Long> getIdsUsuariosGrupoUsuario(Usuario usuario);

}
