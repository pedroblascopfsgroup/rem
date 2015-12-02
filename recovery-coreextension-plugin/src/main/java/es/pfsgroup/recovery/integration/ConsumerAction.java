package es.pfsgroup.recovery.integration;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;

public abstract class ConsumerAction<T> extends RuleMessageFilter<T> implements Action<T> {

	//private final static String DO_ACTION_METHOD = "doAction";
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private String description;

	public ConsumerAction(Rule<T> rule) {
		super(rule);
	}

	public ConsumerAction(List<Rule<T>> rules) {
		super(rules);
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}


	@Override
	public void execute(Message<T> message) {
		logger.debug(String.format("[INTEGRACION] Verificando ConsumerAction %s...", this.getClass().getName()));
		if (!this.check(message)) {
			return;
		}
		logger.debug(String.format("[INTEGRACION] Ejecutando ConsumerAction %s...", this.getClass().getName()));
		T payload = message.getPayload();
		doAction(payload);
		logger.info(String.format("[INTEGRACION] ConsumerAction %s ejecutado!", this.getClass().getName()));
	}

	protected abstract void doAction(T payload);

	/**
	 * Ejecuta la acción de este consumer manager.
	 * Busca un método llamado "doAction" en esta clase que cuadre con el payload<T> que se gestiona la clase..
	 * 
	 * @param payload
	 */
	/*
	private void invokeMethod(T payload) {
		try {
			Class<?>[] classes = {payload.getClass()};
			Method m = ClassUtils.getMethodIfAvailable(this.getClass(), DO_ACTION_METHOD, classes);
			if (m==null) {
				logger.warn(String.format("No se ha encontrado método 'doAction' en la clase %s para consumir el mensaje", payload.getClass().getName()));
				return;
			}
			m.invoke(payload);
		} catch (IllegalAccessException iae) {
			logger.error(iae);
		} catch (IllegalArgumentException iarge) {
			logger.error(iarge);
		} catch (InvocationTargetException ite) {
			logger.error(ite);
		} catch (Exception e) {
			logger.error(e);
		}
	}*/
	
}
