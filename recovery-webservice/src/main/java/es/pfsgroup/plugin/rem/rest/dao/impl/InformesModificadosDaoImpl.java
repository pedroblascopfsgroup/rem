package es.pfsgroup.plugin.rem.rest.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.rest.dao.InformesModificadosDao;
import es.pfsgroup.plugin.rem.rest.model.InformesModificados;

@Repository("InformesModificadosDaoImpl")
public class InformesModificadosDaoImpl extends AbstractEntityDao<InformesModificados, Long> implements InformesModificadosDao{

	@Override
	public InformesModificados getByInforme(ActivoInfoComercial informe) {
		HQLBuilder hb = new HQLBuilder("from InformesModificados");
		HQLBuilder.addFiltroIgualQue(hb, "informe", informe);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	
}
