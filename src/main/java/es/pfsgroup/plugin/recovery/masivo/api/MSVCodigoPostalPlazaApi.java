package es.pfsgroup.plugin.recovery.masivo.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.geninformes.factories.GENBusinessObjectApi;

public interface MSVCodigoPostalPlazaApi extends GENBusinessObjectApi{

	public static final String PLUGIN_MASIVO_OBTENER_PLAZA_DOMICILIO = "es.pfsgroup.recovery.masivo.api.MSVCodigoPostalPlazaApi.obtenerPlazaAPartirDeDomicilio";
	
	@BusinessOperationDefinition(PLUGIN_MASIVO_OBTENER_PLAZA_DOMICILIO)
	public String obtenerPlazaAPartirDeDomicilio(Long idAsunto);
	
	//int getPrioridad();

}
