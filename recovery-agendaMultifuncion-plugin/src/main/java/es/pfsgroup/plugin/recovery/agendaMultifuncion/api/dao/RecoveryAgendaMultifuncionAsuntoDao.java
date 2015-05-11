package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.RecoveryAgendaMultifuncionDtoBusquedaAsunto;

public interface RecoveryAgendaMultifuncionAsuntoDao {

    public abstract Page buscarAsuntosPaginated(Usuario usuarioLogado, RecoveryAgendaMultifuncionDtoBusquedaAsunto dto);

}
