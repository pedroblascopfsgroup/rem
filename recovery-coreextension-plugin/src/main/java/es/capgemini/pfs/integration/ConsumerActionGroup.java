package es.capgemini.pfs.integration;

import java.util.List;

import org.springframework.integration.core.Message;

public class ConsumerActionGroup<T> extends ConsumerAction<T> {

	private final List<ConsumerAction<T>> actionList;
	
	public ConsumerActionGroup(Rule<T> rule, List<ConsumerAction<T>> actionList) {
		super(rule);
		this.actionList = actionList;
	}
	
	public ConsumerActionGroup(List<Rule<T>> rules, List<ConsumerAction<T>> actionList) {
		super(rules);
		this.actionList = actionList;
	}
	
	@Override
	public void execute(Message<T> message) {
		if (!this.check(message)) {
			return;
		}
		for (ConsumerAction<T> action : actionList) {
			if (action.check(message)) {
				super.execute(message);
			}
		}
	}

	@Override
	protected void doAction(T message) {
		/* no tiene que hacer nada */
	}
	
}
