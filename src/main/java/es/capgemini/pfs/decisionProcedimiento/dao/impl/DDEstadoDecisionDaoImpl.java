package es.capgemini.pfs.decisionProcedimiento.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.decisionProcedimiento.dao.DDEstadoDecisionDao;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;

/**
 * Creado el Mon Jan 12 15:48:55 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("DDEstadoDecisionDao")
public class DDEstadoDecisionDaoImpl extends AbstractEntityDao<DDEstadoDecision, Long> implements DDEstadoDecisionDao {
}
