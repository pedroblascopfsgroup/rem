package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;
import es.pfsgroup.plugin.messagebroker.integrationtest.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.ResponseDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.common.AsyncCallMonitor;

@Component
public class AnnotationDrivenStub {

	private ResponseDto response;
	private RequestDto request;

	@Autowired
	private AsyncCallMonitor asyncMonitor;

	@AsyncRequestHandler(typeOfMessage = "annotationTest")
	public ResponseDto request(RequestDto request) {
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

	@AsyncResponseHandler(typeOfMessage = "annotationTest")
	public void response(ResponseDto response) {
		synchronized (asyncMonitor) {
			this.response = response;
			asyncMonitor.notifyAll();
		}
	}
	
	@AsyncRequestHandler(typeOfMessage = "annotationTestOnlyRequest")
	public void requestOnly(RequestDto request) {
		this.request(request);
		this.request = request;
		
	}

	public RequestDto getRequest() {
		return request;
	}

	public ResponseDto getResponse() {
		return response;
	}

	public void cleanStub() {
		request = null;
		response = null;
	}

}
