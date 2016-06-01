package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVAsunto;

public interface MSVAsuntoDao extends AbstractDao<MSVAsunto,Long> {

    Collection<? extends MSVAsunto> getAsuntos(String query,Long idUsuarioLogado);
    
    Collection<? extends MSVAsunto> getAsuntosGrupoUsuarios(String query, List<Long> listaUsuarios);

}
