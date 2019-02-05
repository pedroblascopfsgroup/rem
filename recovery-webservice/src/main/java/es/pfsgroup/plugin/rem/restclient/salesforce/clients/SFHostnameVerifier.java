package es.pfsgroup.plugin.rem.restclient.salesforce.clients;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

public class SFHostnameVerifier implements HostnameVerifier {

	@Override
	public boolean verify(String hostname, SSLSession session) {
		return true;
	}

}
