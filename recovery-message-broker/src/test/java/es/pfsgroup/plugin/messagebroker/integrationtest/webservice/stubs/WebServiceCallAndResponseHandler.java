package es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs;

import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.ResponseDto;

@Service
public class WebServiceCallAndResponseHandler {

	private ResponseDto response;

	public ResponseDto getResponse() {
		return response;
	}


	public ResponseDto webServiceCallAndResponseRequest(RequestDto request){
		ResponseDto response = new ResponseDto(request);
		return response;
	}
	
	
	public void webServiceCallAndResponseResponse(ResponseDto response){
		this.response = response;
	}
}
