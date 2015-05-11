package es.capgemini.pfs.decisionProcedimiento.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;

/**
 * PONER JAVADOC FO.
 *
 * @author: Lisandro Medrano
 */
public interface DecisionProcedimientoDao extends AbstractDao<DecisionProcedimiento, Long> {
	/**
	 * PONER JAVADOC FO.
	 * @param id id
	 * @return dp
	 */
	List<DecisionProcedimiento> getByIdProcedimiento(Long id);
}
