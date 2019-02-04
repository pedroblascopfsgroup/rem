package es.pfsgroup.plugin.rem.rest.salesforce.api;

import java.io.IOException;

import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

public interface SalesforceApi {
	
	public void test2();
	
	public void test();
	
	public void test3() throws IOException, RestClientException, HttpClientException;
	
}
