package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao;

import java.util.Collection;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

public interface RecoveryAnotacionDaoApi extends AbstractDao {

    Collection<? extends Usuario> getGestores(String query);

}
