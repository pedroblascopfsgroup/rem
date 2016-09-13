package es.pfsgroup.plugin.messagebroker.integrationtest.annotationdriven.stubs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.messagebroker.annotations.AsyncRequestHandler;
import es.pfsgroup.plugin.messagebroker.exceptions.RetriesRequiredException;
import es.pfsgroup.plugin.messagebroker.integrationtest.RequestDto;
import es.pfsgroup.plugin.messagebroker.integrationtest.common.AsyncCallMonitor;

@Component("testErrorStub")
public class TestErrorsStub {
	
	int numRetries = 0;


	@AsyncRequestHandler
	public void execute(RequestDto request) {
		this.numRetries ++;
		throw new RetriesRequiredException(new RuntimeException("Error simulado"),5);
	}


	public int getNumRetries() {
		return numRetries;
	}


	public void setNumRetries(int numRetries) {
		this.numRetries = numRetries;
	}
}
