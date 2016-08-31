package es.pfsgroup.plugin.rem.observacionesExpediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.ObservacionesExpedienteComercial;
import es.pfsgroup.plugin.rem.observacionesExpediente.dao.ObservacionExpedienteDao;

@Repository("ObservacionExpedienteDao")
public class ObservacionExpedienteDaoImpl extends AbstractEntityDao<ObservacionesExpedienteComercial, Long> implements ObservacionExpedienteDao {

	@Override
	public List<ObservacionesExpedienteComercial> getObservacionesByIdExpediente(Long idExpediente) {
		HQLBuilder hb = new HQLBuilder(" from ObservacionesExpedienteComercial obs");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "obs.expediente.id", idExpediente);
		
   		return HibernateQueryUtils.list(this, hb);
	}
}
