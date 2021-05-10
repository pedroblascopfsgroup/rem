package es.pfsgroup.framework.paradise.http.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;

import net.sf.json.JSONObject;



public class HttpSimplePostRequest {
	
	protected final Log logger = LogFactory.getLog(getClass());
	private static final int TIMEOUT = 60000;
	private URL url;
	private Map<String, Object> params;
	private HttpURLConnection con;
	private int status = -1;
	private boolean debug = true; //propiedad para imprimir los datos 
	
	public HttpSimplePostRequest(String url, Map<String, Object> params) {
		try {
			this.url = new URL(url);
			this.params = params;
		} catch (MalformedURLException e) {
			logger.error(e);
		}
	}
	
	public JSONObject post() {
		JSONObject response = null;
		try {
			
			this.con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/json; utf-8");
			this.buildParams();
			con.setConnectTimeout(TIMEOUT); 
			con.setReadTimeout(TIMEOUT);
			this.status = con.getResponseCode();
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
	
	public <T extends Serializable> T post(Class<T> clazzDto) {
		try {
			
			this.con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/json; utf-8");
			this.buildParams();
			con.setConnectTimeout(TIMEOUT);
			con.setReadTimeout(TIMEOUT);
			this.status = con.getResponseCode();
			BufferedReader reader = new BufferedReader(getReader(status));
			String response = getBodyResponse(reader);
			reader.close();
			con.disconnect();
			
			return parsedResponse( response , clazzDto);
			
		} catch (IOException e) {
			this.con.disconnect();
			logger.error(e);
			
		}
		
		return null;
	}

	private void buildParams() {
		this.con.setDoOutput(true);
		String jsonInputString = getParamsAsInputString();
		if (jsonInputString.length() > 2) {
			try {
				OutputStream os = con.getOutputStream();
				byte[] input = jsonInputString.getBytes("utf-8");
				os.write(input, 0, input.length);
			} catch (IOException e) {
				logger.error("[ERROR] No se ha podido generar el body de la petición" + HttpSimplePostRequest.class.getName());
			}
			
		}
	
	}

	private String getParamsAsInputString() {
		String jsonInputString = "";
		for (Entry<String, Object> param : this.params.entrySet()) {
			
			if (param.getValue() instanceof String) {
				jsonInputString = String.format("%s \"%s\": \"%s\",", jsonInputString, param.getKey(), param.getValue());	
			} else {
				jsonInputString = String.format("%s \"%s\": %s,", jsonInputString, param.getKey(), param.getValue());
			}
			
		}
		
		return "{" + jsonInputString.trim().substring(0, jsonInputString.length()-2) +"}";
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
	
	private String getBodyResponse(BufferedReader reader) throws IOException {
		String inputLine;
		StringBuilder content = new StringBuilder();
		while((inputLine = reader.readLine()) != null) {
			content.append(inputLine.trim());
		}
		return content.toString();
		
	}
	
	private JSONObject parsedResponse(int status, BufferedReader reader) throws IOException {

		JSONObject jsonObject = JSONObject.fromObject(getBodyResponse(reader));
		jsonObject.accumulate("status", this.status); 
		
		if (debug) {
			showInfo(jsonObject);
		}
		return jsonObject; 
	}
	
	private <T extends Serializable> T parsedResponse(String response, Class<T> clazz) {
	     ObjectMapper mapper = new ObjectMapper();
	     mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

	     ObjectReader reader = mapper.reader(clazz);
	     try {
			MappingIterator<T> elements = reader.readValues(response);
			return elements.next();
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	     
		return null;
	}
	
	@SuppressWarnings("unchecked")
	private void showInfo(JSONObject jsonObject) {
		if (jsonObject == null) {
			logger.error("[ERROR] No se ha recibido datos de la peticion POST " + HttpSimplePostRequest.class.getName());
		}
		
		Iterator<String> keys = jsonObject.keys(); 
		while(keys.hasNext()) { 
			String key = keys.next(); 
			logger.error("[INFO] Propiedad:" +key+ " \n Value " + jsonObject.getString(key));
		}		
	}

	public int getStatus() { return this.status; };

}
