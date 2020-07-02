package es.pfsgroup.plugin.rem.activo.admision.evolucion.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoActivoAdmisionEvolucion;

public interface ActivoAdmisionEvolucionApi {
	
	
	public List<DtoActivoAdmisionEvolucion> getListActivoAgendaEvolucion(Long id);

}
