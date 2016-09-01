package es.pfsgroup.plugin.rem.expedienteComercial.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Repository("ExpedienteComercialDao")
public class ExpedienteComercialDaoImpl extends AbstractEntityDao<ExpedienteComercial, Long> implements ExpedienteComercialDao {

	@Override
	public Page getCompradoresByExpediente(Long idExpediente, WebDto webDto) {

		HQLBuilder hql = new HQLBuilder("from VBusquedaCompradoresExpediente");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idExpediente", idExpediente.toString());
		
		return HibernateQueryUtils.page(this, hql, webDto);
	}
}
