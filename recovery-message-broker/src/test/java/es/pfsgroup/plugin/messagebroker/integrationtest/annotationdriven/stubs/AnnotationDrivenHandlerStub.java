package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.annotations.AsyncResponseHandler;

public class AnnotationDrivenHandlerStub {

	@AsyncRequestHandler(typeOfMessage = "annotationTest")
	public String request(String request) {
		System.out.println("REQUEST [" + request + "]");
		
		return "Respuesta de la " + request;
	}

	@AsyncResponseHandler(typeOfMessage = "annotationTest")
	public void response(String response) {
		System.out.println("RESPONSE: " + response);
	}
}
