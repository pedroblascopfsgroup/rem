package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;

@Repository("ActivoPatrimonioDao")
public class ActivoPatrimonioDaoImpl extends AbstractEntityDao<ActivoHistoricoPatrimonio, Long> implements ActivoPatrimonioDao{

	@Override
	public List<ActivoHistoricoPatrimonio> getHistoricoAdecuacionesAlquilerByActivo(long idActivo) {
		
		HQLBuilder hb = new HQLBuilder(" from ActivoHistoricoPatrimonio ahp");
		
   	  	HQLBuilder.addFiltroLikeSiNotNull(hb, "ahp.activo.id", idActivo, true);
   	  	hb.appendWhere("ahp.auditoria.borrado is not null");

		return HibernateQueryUtils.list(this, hb);
	}

}
