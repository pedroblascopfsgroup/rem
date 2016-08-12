package es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.messagebroker.integrationtest.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.ResponseDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.common.AsyncCallMonitor;

@Service
public class WebServiceCallAndResponseHandler {

	private ResponseDto response;

	@Autowired
	private AsyncCallMonitor asyncMonitor;

	public ResponseDto getResponse() {
		return response;
	}

	public ResponseDto webServiceCallAndResponseRequest(RequestDto request) {
		// Esperamos 3 segundos y comprobamos si la llamada al message broker ha
		// finalizado
		try {
			Thread.sleep(1000);
			if (asyncMonitor.isMessageBrokerFinished()) {
				asyncMonitor.confirmAsyncCall();
			}
		} catch (InterruptedException e) {
		}

		ResponseDto response = new ResponseDto(request);
		return response;
	}

	public void webServiceCallAndResponseResponse(ResponseDto response) {
		synchronized (asyncMonitor) {
			this.response = response;
			asyncMonitor.notifyAll();
		}

	}
}
