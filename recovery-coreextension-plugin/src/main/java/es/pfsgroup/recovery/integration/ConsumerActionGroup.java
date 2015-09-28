package es.pfsgroup.recovery.integration;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;

public class ConsumerActionGroup<T> extends ConsumerAction<T> {

	private final Log logger = LogFactory.getLog(getClass());
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
		logger.debug(String.format("[INTEGRACION] Verificando grupo de ConsumerAction %s...", this.getClass().getName()));
		if (!this.check(message)) {
			return;
		}
		logger.debug(String.format("[INTEGRACION] Ejecutando grupo de ConsumerAction %s...", this.getClass().getName()));
		for (ConsumerAction<T> action : actionList) {
			if (action.check(message)) {
				super.execute(message);
			}
		}
		logger.info(String.format("[INTEGRACION] Grupo de ConsumerAction %s finalizado!", this.getClass().getName()));
	}

	@Override
	protected void doAction(T message) {
		/* no tiene que hacer nada */
	}
	
}
