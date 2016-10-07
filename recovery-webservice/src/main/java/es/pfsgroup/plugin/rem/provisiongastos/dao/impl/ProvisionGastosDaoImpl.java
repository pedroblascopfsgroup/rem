package es.pfsgroup.plugin.rem.provisiongastos.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;

@Repository("ProvisionGastosDao")
public class ProvisionGastosDaoImpl extends AbstractEntityDao<ProvisionGastos, Long> implements ProvisionGastosDao{

	@Override
	public Page findAll(DtoProvisionGastosFilter dto) {
		
		HQLBuilder hb = new HQLBuilder(" from ProvisionGastos prg");

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prg.numProvision", dto.getNumProvision());
		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
	
    
}
