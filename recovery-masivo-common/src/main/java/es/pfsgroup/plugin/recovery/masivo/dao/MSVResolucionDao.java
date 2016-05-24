package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;

public interface MSVResolucionDao extends AbstractDao<MSVResolucion, Long>{
	
	public MSVResolucion crearNuevoProceso();
	
	public List<MSVResolucion> dameListaProcesos(String usernameo);

	public MSVResolucion mergeAndGet(Long idResolucion);

	public void mergeAndUpdate(MSVResolucion resolucion);

	public Page dameListaProcesos(MSVDtoFiltroProcesos dto);
	
	public List<MSVResolucion> dameResolucionByTarea(Long idTareaExterna);
	
	public MSVResolucion getResolucionByTareaNotificacion(Long idTareaNotificacion);
	
	public List<MSVResolucion> getResolucionesPendientesValidar(Long idTarea, List<String> tipoResolucionAccionBaned);

}
