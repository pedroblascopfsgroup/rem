package es.capgemini.pfs.decisionProcedimiento.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.decisionProcedimiento.dao.DDCausaDecisionDao;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecision;

/**
 * Creado el Mon Jan 12 15:48:55 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("DDCausaDecisionDao")
public class DDCausaDecisionDaoImpl extends AbstractEntityDao<DDCausaDecision, Long> implements DDCausaDecisionDao {
}
