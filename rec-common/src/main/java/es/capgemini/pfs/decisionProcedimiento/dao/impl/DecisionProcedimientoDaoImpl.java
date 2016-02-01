package es.capgemini.pfs.decisionProcedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.decisionProcedimiento.dao.DecisionProcedimientoDao;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;

/**
 * Creado el Mon Jan 12 15:48:55 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("DecisionProcedimientoDao")
public class DecisionProcedimientoDaoImpl extends AbstractEntityDao<DecisionProcedimiento, Long> implements DecisionProcedimientoDao {

	/**
	 * PONER JAVADOC FO.
	 * @param id id
	 * @return dp
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<DecisionProcedimiento> getByIdProcedimiento(Long id) {

		String sql = "from DecisionProcedimiento where procedimiento.id = ? and auditoria.borrado=false";
		return getHibernateTemplate().find(sql, id);
	}

}
