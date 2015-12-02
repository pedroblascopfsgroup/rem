package es.pfsgroup.recovery.integration;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;

public class ActionDoNothing<T> implements Action<T> {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public boolean check(Message<T> message) {
		return false;
	}

	@Override
	public void execute(Message<T> message) {
		logger.debug(String.format("Pasa por aquí, no debería pasar porque siempre valida a falso", this.getClass()));
	}


}
