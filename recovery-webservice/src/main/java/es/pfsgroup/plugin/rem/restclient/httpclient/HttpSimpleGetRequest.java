package es.pfsgroup.plugin.rem.restclient.httpclient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.httpclient.util.HttpURLConnection;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.databind.ObjectMapper;



public class HttpSimpleGetRequest {
	
	protected final Log logger = LogFactory.getLog(getClass());
	private static final int TIMEOUT = 60000;
	private URL url;
	private HttpURLConnection con;
	
	
	public HttpSimpleGetRequest(String url) {
		try {
			this.url = new URL(url);
		} catch (MalformedURLException e) {
			logger.error(e);
		}
	}
	
	public Object get() {
		Object response = null;
		try {
			this.con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-type", "application/json");
			con.setConnectTimeout(TIMEOUT);
			con.setReadTimeout(TIMEOUT);
			con.setInstanceFollowRedirects(false);
			int status = con.getResponseCode();
			BufferedReader reader = new BufferedReader(getReader(status));
			response = parsedResponse(status, reader);
			reader.close();
			con.disconnect();
			
			return response;
		} catch (IOException e) {
			this.con.disconnect();
			logger.error(e);
			
		}
		
		return response;
	}

	private Reader getReader(int status) throws IOException {
		Reader reader = null;
		if (status > 299) {
			reader = new InputStreamReader(con.getErrorStream());
		} else {
			reader = new InputStreamReader(con.getInputStream());
		}
		return reader;
	}

	private Object parsedResponse(int status, BufferedReader reader) throws IOException {
		String inputLine;
		StringBuilder content = new StringBuilder();
		while((inputLine = reader.readLine()) != null) {
			content.append(inputLine);
		}
		ObjectMapper mapper = new ObjectMapper();
		return mapper.writeValueAsString(content.toString());
	}

}
