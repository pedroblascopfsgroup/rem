package es.pfsgroup.plugin.rem.proveedores.mediadores.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.VListMediadoresOfertas;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresOfertasDao;

@Repository("MediadoresOfertasDao")
public class MediadoresOfertasDaoImpl extends AbstractEntityDao<VListMediadoresOfertas, Long> implements MediadoresOfertasDao {
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public Page getListMediadorOfertas(DtoMediadorOferta dtoMediadorOferta) {
		HQLBuilder hb = new HQLBuilder(" FROM VListMediadoresOfertas mev ");
		
		if(!Checks.esNulo(dtoMediadorOferta.getId()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", dtoMediadorOferta.getId());
		
		return HibernateQueryUtils.page(this, hb, dtoMediadorOferta);
	}

}
