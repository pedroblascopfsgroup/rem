package es.pfsgroup.plugin.rem.gastosExpediente.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.gastosExpediente.dao.GastosExpedienteDao;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;

@Repository("GastosExpedienteDao")
public class GastosExpedienteDaoImpl extends AbstractEntityDao<GastosExpediente, Long> implements GastosExpedienteDao{
	
	
	
	@Override
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto comisionDto) {
		
		HQLBuilder hql = new HQLBuilder("from GastosExpediente");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "id", comisionDto.getIdHonorarioRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idGastoWebcom", comisionDto.getIdHonorarioWebcom());

		return HibernateQueryUtils.list(this, hql);
	}
	
	


}
