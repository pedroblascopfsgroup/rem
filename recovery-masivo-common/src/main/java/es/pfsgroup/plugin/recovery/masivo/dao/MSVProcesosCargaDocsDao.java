package es.pfsgroup.plugin.recovery.masivo.dao;


import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesosCargaDocs;

public interface MSVProcesosCargaDocsDao extends AbstractDao<MSVProcesosCargaDocs, Long>{
	
	public boolean existeDocSinProcesar(String nombreDocumento);
	
	public MSVProcesosCargaDocs crearNuevoProceso();
	
	public MSVProcesosCargaDocs get(Long idProceso);
	
	public MSVProcesosCargaDocs mergeAndGet(Long idProceso);
	
	public void mergeAndUpdate(MSVProcesosCargaDocs proceso);
}
