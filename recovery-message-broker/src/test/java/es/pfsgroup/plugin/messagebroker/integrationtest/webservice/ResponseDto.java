package es.pfsgroup.plugin.messagebroker.integrationtest.webservice;

public class ResponseDto {

	private RequestDto request;

	public ResponseDto(RequestDto request) {
		this.request = request;
	}

	public RequestDto getRequest() {
		return request;
	}

}
