package es.pfsgroup.plugin.messagebroker.integrationtest.webservice.stubs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.messagebroker.integrationtest.webservice.RequestDto;

@Service
public class WebServiceOnlyCallHandler {

	private RequestDto request;

	@Autowired
	private AsyncCallMonitor asyncMonitor;

	public void webServiceOnlyCallRequest(RequestDto request) {
		synchronized (asyncMonitor) {
			this.request = request;
			asyncMonitor.notifyAll();
		}
	}

	public RequestDto getRequest() {
		return request;
	}

}
