package es.pfsgroup.plugin.messagebroker.integrationtest.common;

import org.springframework.stereotype.Component;

@Component
public class AsyncCallMonitor {
	
	private boolean messageBrokerFinished = false;
	private boolean asyncCallConfirmed;

	public boolean isMessageBrokerFinished() {
		return messageBrokerFinished;
	}

	public void setMessageBrokerFinished(boolean messageBrokerFinished) {
		this.messageBrokerFinished = messageBrokerFinished;
	}

	public void confirmAsyncCall() {
		this.asyncCallConfirmed = true;
		
	}

	public boolean isAsyncCallConfirmed() {
		return asyncCallConfirmed;
	}

}
