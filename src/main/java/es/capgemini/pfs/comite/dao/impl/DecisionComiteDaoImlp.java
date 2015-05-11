package es.capgemini.pfs.comite.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.dao.DecisionComiteDao;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Maneja las accesos a BBDD de las entidades DecisionComite.
 * @author aesteban
 *
 */
@Repository("DecisionComiteDao")
public class DecisionComiteDaoImlp extends AbstractEntityDao<DecisionComite, Long> implements DecisionComiteDao {

}
