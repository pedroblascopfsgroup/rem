package es.pfsgroup.plugin.recovery.sidhiweb.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface SIDHIAccionJudicialApi {
	public static final String UPDATE_ACCIONES = "plugin.sidhiweb.updateAcciones";
	
	@BusinessOperationDefinition(UPDATE_ACCIONES)
	public void updateAcciones(String tipoJuicio, Long estadoProcesal, Long subestadoProcesal, String codigoInterfaz);
}
