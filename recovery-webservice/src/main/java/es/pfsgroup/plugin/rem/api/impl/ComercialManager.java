package es.pfsgroup.plugin.rem.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ComercialApi;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("comercialManager")
public class ComercialManager extends BusinessOperationOverrider<ComercialApi> implements  ComercialApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private VisitaDao visitaDao;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

		
	@Override
	public String managerName() {
		return "comercialManager";
	}
	
	
	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getListVisitas(dtoVisitasFilter);
	}
	
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {

		return ofertaDao.getListOfertas(dtoOfertasFilter);
	}

	

}
