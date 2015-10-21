package es.pfsgroup.recovery.integration;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;

public class RuleMessageFilter<T> implements Rule<T> {

    private final Log logger = LogFactory.getLog(getClass());
	
	private final List<Rule<T>> rules;

	public RuleMessageFilter(Rule<T> rule) {
		this.rules = new ArrayList<Rule<T>>();
		this.rules.add(rule);
	}
	
	public RuleMessageFilter(List<Rule<T>> rules) {
		this.rules = rules;
	}

	public List<Rule<T>> getRules() {
		return rules;
	}

	public boolean check(Message<T> message) {
		boolean found = false;
		for (Rule<T> rule : this.getRules()) {
			if (rule.check(message)) {
				logger.debug(String.format("[INTEGRACION] Regla encontrada! ", rule.getClass().getName()));
				found = true;
				break;
			}
		}
		if (!found) {
			logger.debug("[INTEGRACION] Mensaje descartado!");
		}
		return found;
	}

}
