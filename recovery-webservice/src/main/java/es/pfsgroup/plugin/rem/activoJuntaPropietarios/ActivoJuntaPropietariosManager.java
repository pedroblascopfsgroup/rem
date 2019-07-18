package es.pfsgroup.plugin.rem.activoJuntaPropietarios;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.ActivoJuntaPropietariosDao;
import es.pfsgroup.plugin.rem.api.ActivoJuntaPropietariosApi;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;


@Service("activoJuntaPropietariosManager")
public class ActivoJuntaPropietariosManager implements ActivoJuntaPropietariosApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoJuntaPropietariosDao activoJuntaPropietariosDao;
	
	@Override
	public ActivoJuntaPropietarios findOne(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);		
		return genericDao.get(ActivoJuntaPropietarios.class, filtro );
	}

	@Override
	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios) {	
		return activoJuntaPropietariosDao.getListJuntas(dtoActivoJuntaPropietarios);
	}
	
}
