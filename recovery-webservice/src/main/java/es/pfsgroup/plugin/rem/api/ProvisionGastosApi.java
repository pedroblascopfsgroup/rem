package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;

public interface ProvisionGastosApi {
	
	

	/**
	 * Devuelve una página filtrada de provisiones
	 * @return DtoPage
	 */
    public DtoPage findAll(DtoProvisionGastosFilter dto);	
	

}
