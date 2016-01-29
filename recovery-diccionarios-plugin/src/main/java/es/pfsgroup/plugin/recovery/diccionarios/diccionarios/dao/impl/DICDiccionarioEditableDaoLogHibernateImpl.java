package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableLogDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditableLog;


@Repository("DICDiccionarioEditableLogDao")
public class DICDiccionarioEditableDaoLogHibernateImpl extends AbstractEntityDao<DICDiccionarioEditableLog, Long> implements DICDiccionarioEditableLogDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<DICDiccionarioEditableLog> findByIdDiccionario(Long idDiccionarioEditable) {
		if (Checks.esNulo(idDiccionarioEditable)) throw new IllegalArgumentException("idDiccionarioEditable null");
		HQLBuilder hql = new HQLBuilder("from DICDiccionarioEditableLog");
		HQLBuilder.addFiltroIgualQue(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQue(hql, "diccionario.id", idDiccionarioEditable);
		hql.orderBy("fecha", HQLBuilder.ORDER_DESC);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		return query.list();
	}
}
