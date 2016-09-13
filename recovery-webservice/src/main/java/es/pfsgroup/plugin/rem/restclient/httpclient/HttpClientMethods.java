package es.pfsgroup.plugin.rem.restclient.httpclient;

import org.apache.commons.lang.StringUtils;

public class HttpClientMethods {
	
	public static final int GET = 1;
	public static final int POST = 2;
	public static final int UNKNOWN = -1;

	public static int valueOf(String methodString) {
		String upper = StringUtils.upperCase(methodString);
		if ("GET".equals(upper)){
			return GET;
		}else if ("POST".equals(upper)){
			return POST;
		}else{
			return UNKNOWN;
		}
	}

}
