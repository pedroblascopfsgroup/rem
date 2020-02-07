package es.pfsgroup.plugin.rem.activoproveedor.dao.impl;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activoproveedor.dao.ActivoProveedorDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;

@Repository("ActivoProveedorDao")
public class ActivoProveedorDaoImpl extends AbstractEntityDao<ActivoProveedor, Long> implements ActivoProveedorDao {

	@Override
	public ActivoProveedor getProveedorByCodigoRem(Long codigo) {
		ActivoProveedor resultado = null;
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			Criteria criteria = session.createCriteria(ActivoProveedor.class);
			criteria.add(Restrictions.eq("codigoProveedorRem", codigo));
			resultado = (ActivoProveedor) criteria.uniqueResult();
		} catch (Exception e) {
			logger.error("error al persistir la oferta", e);
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}

		return resultado;
	}

}
