package es.pfsgroup.framework.paradise.bulkUpload.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;

public interface MSVFicheroDao extends AbstractDao<MSVDocumentoMasivo, Long>{
	
	MSVDocumentoMasivo crearNuevoDocumentoMasivo();
	
	String obtenerErrores(Long idFichero);

	MSVProcesoMasivo  alta();
	
	MSVProcesoMasivo update(String idProceso, String nuevoEstado);

	String eliminarArchivo(Long idProceso,MSVDocumentoMasivo documentoMasivo);

	MSVDocumentoMasivo findByIdProceso(long idProceso);



}
