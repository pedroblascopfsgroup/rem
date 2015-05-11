package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;

public interface MSVProcesoDao extends AbstractDao<MSVProcesoMasivo, Long>{
	
	public MSVProcesoMasivo crearNuevoProceso();
	
	@Deprecated
	public String eliminarProceso(long idProceso, MSVProcesoMasivo procesoMasivo);
	
	public List<MSVProcesoMasivo> dameListaProcesos(String usernameo);

	public MSVProcesoMasivo mergeAndGet(Long idProceso);

	public void mergeAndUpdate(MSVProcesoMasivo proceso);

	public MSVProcesoMasivo getByToken(Long tokenProceso);

	public Page dameListaProcesos(MSVDtoFiltroProcesos dto);

}
