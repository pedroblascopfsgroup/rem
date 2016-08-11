package es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs;

import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.RequestDto;

@Service
public class WebServiceOnlyCallHandler {
	
	private RequestDto request;

	public void webServiceOnlyCallRequest(RequestDto request){
		this.request =request;
	}

	public RequestDto getRequest() {
		return request;
	}

}
