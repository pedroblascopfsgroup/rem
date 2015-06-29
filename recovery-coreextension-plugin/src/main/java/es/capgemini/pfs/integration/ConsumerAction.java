package es.capgemini.pfs.integration;

import java.util.List;

import org.springframework.integration.core.Message;

public abstract class ConsumerAction<T> extends RuleMessageFilter<T> implements Action<T> {

	private String description;

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public ConsumerAction(Rule<T> rule) {
		super(rule);
	}

	public ConsumerAction(List<Rule<T>> rules) {
		super(rules);
	}

	@Override
	public void execute(Message<T> message) {
		if (!this.check(message)) {
			return;
		}
		T payload = message.getPayload();
		doAction(payload);
	}

	protected abstract void doAction(T message);

}
