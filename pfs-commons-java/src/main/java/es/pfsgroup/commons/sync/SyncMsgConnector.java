package es.pfsgroup.commons.sync;

import java.util.Date;

public class SyncMsgConnector {

	private String id;
	private String body;
	private ConnectorStatus sendStatus;
	private Date sendDate;
	private Date deliveryDate;

	public enum ConnectorStatus {
		PENDING,
		OK,
		KO
	}
	
	public SyncMsgConnector() {
		sendStatus = ConnectorStatus.PENDING;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBody() {
		return body;
	}
	public void setBody(String body) {
		this.body = body;
	}
	public Date getSendDate() {
		return sendDate;
	}
	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}
	public Date getDeliveryDate() {
		return deliveryDate;
	}
	public void setDeliveryDate(Date deliveryDate) {
		this.deliveryDate = deliveryDate;
	}

	public ConnectorStatus getSendStatus() {
		return sendStatus;
	}

	public void setSendStatus(ConnectorStatus sendStatus) {
		this.sendStatus = sendStatus;
	}
	
}
