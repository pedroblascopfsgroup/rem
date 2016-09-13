package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.integrationtest.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.common.AsyncCallMonitor;

@Component
public class AnnotatedHandlerMock {

	private boolean executed = false;

	@Autowired
	private AsyncCallMonitor asyncCallMonitor;

	@AsyncRequestHandler
	public void execute(RequestDto request) {
		this.executed = true;
		synchronized (asyncCallMonitor) {
			if (asyncCallMonitor.isMessageBrokerFinished()) {
				asyncCallMonitor.confirmAsyncCall();
			}
			asyncCallMonitor.notifyAll();
		}

	}

	public boolean isExecuted() {
		return executed;
	}

	public void resetMock() {
		this.executed = false;
	}
}
