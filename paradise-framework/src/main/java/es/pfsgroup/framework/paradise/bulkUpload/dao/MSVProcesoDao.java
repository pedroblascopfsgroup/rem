package es.pfsgroup.framework.paradise.bulkUpload.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;


public interface MSVProcesoDao extends AbstractDao<MSVProcesoMasivo, Long>{
	
	public MSVProcesoMasivo crearNuevoProceso();
	
	public List<MSVProcesoMasivo> dameListaProcesos(String usernameo);

	public MSVProcesoMasivo mergeAndGet(Long idProceso);

	public void mergeAndUpdate(MSVProcesoMasivo proceso);

	public MSVProcesoMasivo getByToken(Long tokenProceso);

	public Page dameListaProcesos(MSVDtoFiltroProcesos dto);

}
