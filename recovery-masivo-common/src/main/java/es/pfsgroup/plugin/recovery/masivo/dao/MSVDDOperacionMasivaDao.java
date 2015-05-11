package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

public interface MSVDDOperacionMasivaDao extends AbstractDao<MSVDDOperacionMasiva, Long> {
	
	List<MSVDDOperacionMasiva> dameListaOperacionesDeUsuario(Usuario usu);


}
