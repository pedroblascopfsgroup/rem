package es.pfsgroup.plugin.recovery.procuradores.procurador.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorProcedimientoDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;

@Repository("RelacionProcuradorProcedimientoDao")
public class RelacionProcuradorProcedimientoDaoImpl extends AbstractEntityDao<RelacionProcuradorProcedimiento, Long> implements RelacionProcuradorProcedimientoDao{

	@Override
	public List<RelacionProcuradorProcedimiento> getProcuradorProcedimiento(Long idProcedimiento){
		//Procedimiento
		
		HQLBuilder hb = new HQLBuilder(" from RelacionProcuradorProcedimiento rel ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rel.procedimiento.id", idProcedimiento, true);
		//HibernateQueryUtils.uniqueResult(this, hb);
		return HibernateQueryUtils.list(this, hb);
	}

	
}
