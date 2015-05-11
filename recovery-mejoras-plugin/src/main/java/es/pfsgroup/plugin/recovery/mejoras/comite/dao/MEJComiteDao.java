package es.pfsgroup.plugin.recovery.mejoras.comite.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.comite.dto.MEJDtoBusquedaPreAsuntosComite;
import es.pfsgroup.plugin.recovery.mejoras.comite.model.MEJComite;

public interface MEJComiteDao extends AbstractDao<MEJComite, Long> {
	public List<MEJComite> findComitesValidosCurrentUser(Usuario usuario);
	public Page getPreAsuntosComite(MEJDtoBusquedaPreAsuntosComite dto);
	public void flush();
	public void clear();
}
