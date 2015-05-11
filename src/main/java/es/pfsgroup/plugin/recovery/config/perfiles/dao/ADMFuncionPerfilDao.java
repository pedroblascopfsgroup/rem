package es.pfsgroup.plugin.recovery.config.perfiles.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.FuncionPerfil;

public interface ADMFuncionPerfilDao extends AbstractDao<FuncionPerfil, Long>{

	/**
	 * Crea un objeto nuevo, vacío y fuera de persistencia.
	 * @return
	 */
	public FuncionPerfil createNewObject();

	/**
	 * Busca las relaciones entre un perfil y una función
	 * @param idFuncion ID de la función
	 * @param idPerfil ID del perfil-
	 * @return Devuelve una lista de resultados. Devuelve una lista vacía si no hay relaciones.
	 */
	public List<FuncionPerfil> find(Long idFuncion, Long idPerfil);

}
