package es.pfsgroup.recovery.integration;

import java.util.List;

import org.springframework.integration.core.Message;
import org.springframework.integration.selector.MessageSelector;

public class RuleMessageSelector<T> extends RuleMessageFilter<T> implements MessageSelector {

	public RuleMessageSelector(Rule<T> rule) {
		super(rule);
	}
	
	public RuleMessageSelector(List<Rule<T>> rules) {
		super(rules);
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean accept(Message<?> message) {
		return check((Message<T>) message);
	}


}
