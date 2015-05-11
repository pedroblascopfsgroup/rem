package es.pfsgroup.recovery.geninformes.api;

import es.pfsgroup.recovery.geninformes.factories.GENBusinessObjectApi;

public interface GENINFInformeEntidadGenerator extends GENBusinessObjectApi{

	GENINFInformeEntidad getInformeEntidad(String tipoEntidad);

}
