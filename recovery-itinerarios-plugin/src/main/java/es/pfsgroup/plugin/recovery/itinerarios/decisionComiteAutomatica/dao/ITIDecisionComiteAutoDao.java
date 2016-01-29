package es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dao;

import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.dao.AbstractDao;

public interface ITIDecisionComiteAutoDao extends AbstractDao<DecisionComiteAutomatico, Long> {

	public DecisionComiteAutomatico createNewDca(); 

}
