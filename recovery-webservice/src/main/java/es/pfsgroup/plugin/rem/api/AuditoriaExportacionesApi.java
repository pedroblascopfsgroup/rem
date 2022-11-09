package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.DtoActivoGridFilter;

public interface AuditoriaExportacionesApi {

	boolean permiteBusqueda(DtoActivoGridFilter dto,Usuario user, String buscador) throws Exception;
	

}
