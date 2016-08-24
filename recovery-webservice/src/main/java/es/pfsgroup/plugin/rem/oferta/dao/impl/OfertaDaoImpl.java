package es.pfsgroup.plugin.rem.oferta.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao{

	@Override
	public Page getListTextosOfertaById(DtoTextosOferta dto, Long id) {
		
		HQLBuilder hb = new HQLBuilder(" from TextosOferta txo");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "txo.oferta.id", id);
		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
	
	
	
	
}
