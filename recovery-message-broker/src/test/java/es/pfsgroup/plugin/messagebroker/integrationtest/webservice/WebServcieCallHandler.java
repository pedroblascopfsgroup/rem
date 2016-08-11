package es.pfsgroup.plugin.messagebroker.integrationtest.webservice;

import org.springframework.stereotype.Service;

@Service("webServiceCallHandler")
public class WebServcieCallHandler {

	private ResponseDto response;

	public ResponseDto getResponse() {
		return response;
	}


	public ResponseDto webServiceCallRequest(RequestDto request){
		ResponseDto response = new ResponseDto(request);
		return response;
	}
	
	
	public void webServiceCallResponse(ResponseDto response){
		this.response = response;
	}
}
