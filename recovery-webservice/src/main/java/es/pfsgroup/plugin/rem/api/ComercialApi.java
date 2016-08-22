package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;

public interface ComercialApi {
	
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter);

}
