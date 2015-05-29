package es.pfsgroup.commons.sync;

import java.util.Date;
import java.util.List;

public abstract class SyncMsgFactoryBase<T> implements SyncMsgFactory<T> {

	private final List<SyncConnector> connectorList;
	private final SyncTranslator translator;

	public SyncMsgFactoryBase(List<SyncConnector> connectorList, SyncTranslator translator) {
		this.connectorList = connectorList;
		this.translator = translator;
	}
	
	public abstract T createMessage();
	
	public abstract String getID();
	
	public abstract Class<T> getGenericType();
	
	/**
	 * Envia un mensaje a través de los conectores.
	 * 
	 * @param message
	 */
	public final SyncMsgConnector send(T message) {
		String body = translator.serialize(message);
		SyncMsgConnector msgConnector = new SyncMsgConnector();
		msgConnector.setId(this.getID());
		msgConnector.setBody(body);
		msgConnector.setSendDate(new Date());
		doBeforeSend(msgConnector);
		for (SyncConnector connector : connectorList) {
			connector.send(msgConnector);
		}
		doAfterSend(msgConnector);
		return msgConnector;
	}
	
	/**
	 * Realiza la acción antes de enviar un mensaje.
	 * @param message
	 */
	protected void doBeforeSend(SyncMsgConnector message) {
		/* no-action */
	}

	/**
	 * Realiza la acción antes de enviar un mensaje.
	 * @param message
	 */
	protected void doAfterSend(SyncMsgConnector message) {
		/* no-action */
	}

	/**
	 * Procesa un mensaje
	 * 
	 * @param message
	 */
	public final void processMessage(SyncMsgConnector message) {
		String body = message.getBody();
		T simpleMessage = (T)translator.deserialize(body, getGenericType());
		doProcessMessage(simpleMessage);
	}
	
	/**
	 * Realiza la acción con un mensaje específico.
	 * @param message
	 */
	protected void doProcessMessage(T message) {
		/* no-action */
	}
	
}

