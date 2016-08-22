package es.pfsgroup.framework.paradise.bulkUpload.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

public interface MSVDDOperacionMasivaDao extends AbstractDao<MSVDDOperacionMasiva, Long> {
	
	List<MSVDDOperacionMasiva> dameListaOperacionesDeUsuario(Usuario usu);


}
