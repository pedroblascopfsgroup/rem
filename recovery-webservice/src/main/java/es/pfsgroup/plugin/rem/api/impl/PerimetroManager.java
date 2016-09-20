package es.pfsgroup.plugin.rem.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.PerimetroApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;

@Service("perimetroManager")
public class PerimetroManager extends BusinessOperationOverrider<PerimetroApi> implements  PerimetroApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

		
	@Override
	public String managerName() {
		return "perimetroManager";
	}
	
	@Override
	public PerimetroActivo getPerimetroByIdActivo(Long idActivo) {
		
		Filter filtroPerimetro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, filtroPerimetro);
		
		return perimetroActivo;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean save(PerimetroActivo perimetroActivo) {

		if(!Checks.esNulo(perimetroActivo)){
			genericDao.save(PerimetroActivo.class, perimetroActivo);
			return true;
		} else {
			return false;
		}

	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean update(PerimetroActivo perimetroActivo) {

		if(!Checks.esNulo(perimetroActivo)){
			genericDao.update(PerimetroActivo.class, perimetroActivo);
			return true;
		} else {
			return false;
		}

	}

}
