package es.pfsgroup.plugin.rem.gasto.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;

@Repository("GastoDao")
public class GastoDaoImpl extends AbstractEntityDao<GastosProveedor, Long> implements GastoDao{
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {
		
		HQLBuilder hb = new HQLBuilder(" from VGastosProveedor vgasto");
		
	
		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		
		List<VGastosProveedor> ofertas = (List<VGastosProveedor>) pageVisitas.getResults();
		
		return new DtoPage(ofertas, pageVisitas.getTotalCount());
		
	}


	


}
