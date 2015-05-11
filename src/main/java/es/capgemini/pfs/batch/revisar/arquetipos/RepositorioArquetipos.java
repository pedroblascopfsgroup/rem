package es.capgemini.pfs.batch.revisar.arquetipos;

import java.util.List;

import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Representa un repositorio de arquetipos.
 * 
 * Permite obtener arquetipos dondequiera que estén persisitidos.
 * 
 * @author bruno
 *
 */
public interface RepositorioArquetipos {

	/**
	 * Devuelve una lista de Arquetipos.
	 * @return
	 */
	List<RuleEndState> getList();

}
