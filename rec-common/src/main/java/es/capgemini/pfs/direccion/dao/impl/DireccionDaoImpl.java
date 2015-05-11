package es.capgemini.pfs.direccion.dao.impl;

import java.math.BigDecimal;
import java.util.Collection;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.capgemini.pfs.direccion.dao.DireccionDao;
import es.capgemini.pfs.direccion.model.Direccion;

@Repository("DireccionDao")
public class DireccionDaoImpl extends AbstractEntityDao<Direccion, Long> implements DireccionDao {


	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonas(String query, Long idAsunto) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		if (Checks.esNulo(idAsunto)) {
			hql.append(" from Persona prcPer");
		} else {
			hql.append(" select distinct prcPer from Asunto asu join asu.procedimientos prc join prc.personasAfectadas prcPer ");
			andHql.append(" and asu.id = " + idAsunto + " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION);
		}
		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}

	public Long getLastId(String entity) {
		HQLBuilder b = new HQLBuilder("select max(id) from "+entity);		
		return (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

	public Long getNextIdDireccion() {
		String sql = "SELECT S_DIR_DIRECCIONES.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

	/**
	 * Crea un c�d de direcci�n a partir de una secuencia para las direcciones manuales
	 */
	public Long getNextCodDireccionManual() {
		String sql = "SELECT S_DIR_DIRECCIONES_COD_MANUAL.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
//	public int saveOrUpdatePersonaDireccion(Long idPersona, Long idDireccion, String usuario) {
//		String sqlInsert = "INSERT INTO DIR_PER (PER_ID, DIR_ID, USUARIOCREAR, FECHACREAR) VALUES ("
//				+ idPersona
//				+ ","
//				+ idDireccion
//				+ ",'"
//				+ usuario
//				+ "', SYSDATE)";
//		int resultado = getSession().createSQLQuery(sqlInsert).executeUpdate();
//		return resultado;
//	}

}
