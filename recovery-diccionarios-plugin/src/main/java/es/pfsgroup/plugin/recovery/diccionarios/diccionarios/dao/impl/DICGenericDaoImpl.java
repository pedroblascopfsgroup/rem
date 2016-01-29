package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICGenericDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;

@Repository
public class DICGenericDaoImpl extends AbstractEntityDao<DICDiccionarioEditable, Long> implements DICGenericDao{

	@Override
	public Long getLastId(Class entityClass) {
		String hql = "select max(id) from ".concat(entityClass.getCanonicalName());
		return (Long) getSession().createQuery(hql).uniqueResult();
	}

}