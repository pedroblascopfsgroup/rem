package es.pfsgroup.plugin.rem.rest.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.rest.dao.ActivosModificadosDao;
import es.pfsgroup.plugin.rem.rest.model.ActivosModificados;

@Repository("ActivosModificadosDaoImpl")
public class ActivosModificadosDaoImpl extends AbstractEntityDao<ActivosModificados, Long> implements ActivosModificadosDao{

	@Override
	public ActivosModificados getByActivo(Activo activo) {
		HQLBuilder hb = new HQLBuilder("from ActivosModificados");
		HQLBuilder.addFiltroIgualQue(hb, "activo", activo);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
