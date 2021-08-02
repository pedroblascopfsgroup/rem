package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

public interface RecalculoVisibilidadComercialApi {
	
	public Map<Long, List<String>> recalcularVisibilidadComercial(Activo[] activos, DDEstadosExpedienteComercial nuevoEstadoExpediente);

	public Map<Long, List<String>> recalcularVisibilidadComercial(Oferta oferta, DDEstadosExpedienteComercial nuevoEstadoExpediente);
	
	public Map<Long, List<String>> recalcularVisibilidadComercial(List<Long> listaIdActivos);
	
	public void lanzarPrimerErrorSiTiene(Map<Long, List<String>> mapaErrores);

	Map<Long, List<String>> recalcularVisibilidadComercial(Activo activo, Boolean dtoCheckGestorComercial,Boolean dtoExcluirValidaciones, boolean fichaActivo);

	
}