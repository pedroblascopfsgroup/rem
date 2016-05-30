package es.pfsgroup.plugin.recovery.procuradores.busqueda.dao.api;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.busqueda.model.MSVAsuntoAll;

public interface MSVAsuntoAllDao extends AbstractDao<MSVAsuntoAll,Long> {

    Collection<? extends MSVAsuntoAll> getAsuntos(String query, Long idUsuarioLogado);
    
    Collection<? extends MSVAsuntoAll> getAsuntosGrupoUsuarios(String query, List<Long> listaUsuarios);

}
