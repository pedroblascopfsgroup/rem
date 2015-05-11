package es.capgemini.pfs.core.api.plazoTareasDefault;

import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PlazoTareasDefaultApi {
	
	String BO_CORE_PLAZOS_BUSCAR_POR_NOMBRE = "core.plazoTareasDefault.buscaPlazoByDescripcion";

	@BusinessOperationDefinition(BO_CORE_PLAZOS_BUSCAR_POR_NOMBRE)
    public PlazoTareasDefault buscarPlazoPorDescripcion(String descripcion) ;

}
