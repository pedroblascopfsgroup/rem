package es.pfsgroup.framework.paradise.bulkUpload.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVPlantillaOperacion;


public interface MSVPlantillaOperacionDao extends AbstractDao<MSVPlantillaOperacion, Long> {
	
	List<MSVPlantillaOperacion> dameListaPlantillasUsuario(Usuario usu);
	
	MSVPlantillaOperacion obtenerRutaExcel(Long id);

	MSVPlantillaOperacion obtenerRutaExcelByTipoOperacion(Long idTipoOperacion);

}
