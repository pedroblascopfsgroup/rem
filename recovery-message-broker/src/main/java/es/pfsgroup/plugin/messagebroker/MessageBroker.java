package es.pfsgroup.plugin.messagebroker;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.messagebroker.exceptions.InvalidHandler;
import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerGateway;
import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerHandlerRegistry;

/**
 * Permite enviar objetos como mensajes. Deben existir manejadores (handler) que
 * sepan qué hacer con el objeto para procesarlo. Existen dos opciones para
 * crear manejadores
 * 
 * <dl>
 * <dt>Por convención</dt>
 * <dd>El handler debe seguir unas reglas de construcción y nomenclatura:
 * <ol>
 * <li>El beanName del handler debe terminar con el sufjio 'Handler' el resto
 * del nombre del bean deberá coincidir con el 'typeOfMessage' especificado en
 * el momento de mandar el mejsaje</li>
 * <li>Si el mensaje se va a procesar de forma asíncrona, el handler debe tener
 * dos métodos: request y resposne. El método response nos lo podemos ahorrar si
 * el método request no devuelve ningún resultado.</li>
 * <li>El método 'request' debe llamarse <code>typeOfMessageRequest</code> (debe
 * contener el sufijo Request) y debe aceptar un único parámetro.</li>
 * <li>El método 'response' debe llamarse <code>typeOfMessageResponse</code>
 * (debe contener el sufijo Response) y debe aceptar un único parámetro.</li>
 * </ol>
 * </dd>
 * 
 * 
 * <dt>Mediante anotaciones</dt>
 * <dd>Simplemente deben etiquetarse los métodos 'request' y 'response' mediante
 * las anotaciones {@link AsyncRequestHandler} y {@link AsyncResponseHandler}
 * respectivaemte. Ambos métodos deben aceptar un sólo parámetro. Si el método
 * 'request' no devuelve ningún valor o será necesario definir un método
 * 'response'.</dd>
 * 
 * </dl>
 * 
 * @author bruno
 *
 */
public class MessageBroker {

	private static final String HANDLER_SUFFIX = "Handler";
	private MessageBrokerGateway messageBrokerGateway;

	/**
	 * Envía datos de forma asíncrona.
	 * 
	 * @param typeOfMessage
	 *            Identificador usado para determinar el handler que va a
	 *            recibir el objeto enviado. Ver la documentación de
	 *            {@link MessageBroker} para conocer más sobre las opciones para
	 *            definir handlers.
	 * @param data
	 *            Objeto que encapsula la información que queremos enviar.
	 */
	public void sendAsync(String typeOfMessage, Object data) {
		messageBrokerGateway.sendAsyncMessage(typeOfMessage, data);

	}

	/**
	 * Envía datos de foram asíncrona
	 * 
	 * @param clazz
	 *            Clase que va a recibir y procesar el objeto que enviamos. Esta
	 *            clase debe ser un handler que siga las convenciones de nombres
	 *            que se explican en la documentación de {@link MessageBroker}
	 * @param data
	 *            Objeto que encapsula la información que queremos enviar.
	 */
	public void sendAsync(Class clazz, Object data) {
		String simpleName = MessageBrokerUtils.lowercaseFirstChar(clazz.getSimpleName());
		String typeOfMessage = null;
		if (simpleName.endsWith(HANDLER_SUFFIX)) {
			typeOfMessage = simpleName.substring(0, simpleName.length() - HANDLER_SUFFIX.length());

		} else {
			typeOfMessage = simpleName;
		}

		this.sendAsync(typeOfMessage, data);

	}


	public void setMessageBrokerGateway(MessageBrokerGateway messageBrokerGateway) {
		this.messageBrokerGateway = messageBrokerGateway;
	}
}
