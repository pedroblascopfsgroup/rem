package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;

@Repository("ActivoHistoricoPatrimonioDao")
public class ActivoHistoricoPatrimonioDaoImpl extends AbstractEntityDao<ActivoHistoricoPatrimonio, Long>  implements ActivoHistoricoPatrimonioDao{

	@Override
	public List<ActivoHistoricoPatrimonio> getHistoricoAdecuacionesAlquilerByActivo(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(" from ActivoHistoricoPatrimonio ahp");
		
   	  	HQLBuilder.addFiltroLikeSiNotNull(hb, "ahp.activo.id", idActivo, true);
   	  	hb.orderBy("id", "desc");
		return HibernateQueryUtils.list(this, hb);

	}

	

}
