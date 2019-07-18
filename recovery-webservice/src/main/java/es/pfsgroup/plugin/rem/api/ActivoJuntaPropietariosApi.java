package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;

public interface ActivoJuntaPropietariosApi {

	public ActivoJuntaPropietarios findOne(Long id);
	
	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios);

}
