package es.pfsgroup.plugin.rem.proveedores.mediadores.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.DtoMediadorStats;
import es.pfsgroup.plugin.rem.model.VStatsCarteraMediadores;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresCarteraDao;

@Repository("MediadoresCarteraDao")
public class MediadoresCarteraDaoImpl extends AbstractEntityDao<VStatsCarteraMediadores, Long> implements MediadoresCarteraDao {
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Override
	public Page getStatsCarteraMediador(DtoMediadorStats dtoMediadorStats){
		HQLBuilder hb = new HQLBuilder(" FROM VStatsCarteraMediadores mev ");
		
		if(!Checks.esNulo(dtoMediadorStats.getId()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", dtoMediadorStats.getId());
		
		return HibernateQueryUtils.page(this, hb, dtoMediadorStats);
	}


}
