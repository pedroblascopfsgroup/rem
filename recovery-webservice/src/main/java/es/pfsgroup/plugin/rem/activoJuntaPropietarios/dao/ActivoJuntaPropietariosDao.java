package es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;

public interface ActivoJuntaPropietariosDao extends AbstractDao<ActivoJuntaPropietarios, Long>{

	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios); 
	
}
