package es.pfsgroup.plugin.precontencioso.burofax.dao.impl;

import java.math.BigDecimal;
import java.util.Collection;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.burofax.dao.BurofaxDao;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;

@Repository
public class BurofaxDaoImpl extends AbstractEntityDao<BurofaxPCO, Long> implements BurofaxDao {
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonasConDireccion(String query) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from Persona prcPer");
		andHql.append(" and prcPer.direcciones IS NOT EMPTY");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonasConContrato(String query) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from Persona prcPer");
		andHql.append(" and prcPer.contratosPersona IS NOT EMPTY");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonas(String query) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from Persona prcPer");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	public Long obtenerSecuenciaFicheroDocBurofax() {
		String sql = "SELECT S_BUR_FICHERO_DOC.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
	
}
