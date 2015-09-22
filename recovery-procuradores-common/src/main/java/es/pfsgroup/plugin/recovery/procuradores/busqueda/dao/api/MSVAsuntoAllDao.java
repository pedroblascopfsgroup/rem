package es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.api;

import java.util.Collection;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;

public interface MSVAsuntoAllDao extends AbstractDao<MSVAsuntoAll,Long> {

    Collection<? extends MSVAsuntoAll> getAsuntos(String query, Long idUsuarioLogado);

}
