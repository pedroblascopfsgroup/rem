package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;

@Repository("ActivoPatrimonioDao")
public class ActivoPatrimonioDaoImpl extends AbstractEntityDao<ActivoPatrimonio, Long>  implements ActivoPatrimonioDao{

	@Override
	public ActivoPatrimonio getActivoPatrimonioByActivo(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(" from ActivoPatrimonio ap");
   	  	HQLBuilder.addFiltroLikeSiNotNull(hb, "ap.activo.id", idActivo, true);
   	  	hb.appendWhere("ap.auditoria.borrado is not null");

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
