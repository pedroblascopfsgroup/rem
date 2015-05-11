package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dao.AASAnalisisAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.model.AASAnalisisAsunto;


@Repository
public class AASAnalisisAsuntoDaoImpl extends AbstractEntityDao<AASAnalisisAsunto, Long> implements AASAnalisisAsuntoDao{

	@Override
	public AASAnalisisAsunto createNewObject() {
		return new AASAnalisisAsunto();
	}

	@Override
	public AASAnalisisAsunto findByAsunto(Long id) {
		HQLBuilder b = new HQLBuilder("from AASAnalisisAsunto aas");
		b.appendWhere("aas.auditoria.borrado = false");
		HQLBuilder.addFiltroIgualQue(b, "aas.asunto.id", id);
		
		return HibernateQueryUtils.uniqueResult(this, b);
	}

}