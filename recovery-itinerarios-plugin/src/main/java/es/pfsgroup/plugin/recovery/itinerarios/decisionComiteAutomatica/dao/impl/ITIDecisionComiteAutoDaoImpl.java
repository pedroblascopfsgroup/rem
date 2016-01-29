package es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dao.ITIDecisionComiteAutoDao;

@Repository("ITIDecisionComiteAutoDao")
public class ITIDecisionComiteAutoDaoImpl extends AbstractEntityDao<DecisionComiteAutomatico, Long>
	implements ITIDecisionComiteAutoDao{

	@Override
	public DecisionComiteAutomatico createNewDca() {
		return new DecisionComiteAutomatico();
	}

}
