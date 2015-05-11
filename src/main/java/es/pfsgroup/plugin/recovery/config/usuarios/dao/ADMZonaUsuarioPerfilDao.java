package es.pfsgroup.plugin.recovery.config.usuarios.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

public interface ADMZonaUsuarioPerfilDao extends AbstractDao<ZonaUsuarioPerfil, Long>{

	//TODO Eliminar este metodo.
	public void borrar(Long zonid, Long pefid, Long usuid);

	public ZonaUsuarioPerfil buscaZonPefUsu(Long z, Long idUsuario,
			Long idPerfil);

}
