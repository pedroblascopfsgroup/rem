package es.pfsgroup.plugin.rem.rest.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class RestRequestWrapper extends HttpServletRequestWrapper {
	private final String body;
	protected static final Log logger = LogFactory.getLog(RestRequestWrapper.class);
	
	public RestRequestWrapper(HttpServletRequest request) throws IOException, Exception {
		super(request);
		StringBuilder stringBuilder = new StringBuilder();
		BufferedReader bufferedReader = null;
		try {
			InputStream inputStream = request.getInputStream();
			if (inputStream != null) {
				bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
				char[] charBuffer = new char[128];
				int bytesRead = -1;
				while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
					stringBuilder.append(charBuffer, 0, bytesRead);
				}
			} else {
				stringBuilder.append("");
			}
		} catch (IOException ex) {
			throw ex;
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (IOException ex) {
					throw ex;
				}
			}
		}
		
		if (stringBuilder.toString() != null && !stringBuilder.toString().isEmpty()) {
			body = stringBuilder.toString();
		}else{
			body = request.getParameter("data");
		}
	}

	@Override
	public ServletInputStream getInputStream() throws IOException {
		final ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(body.getBytes());
		ServletInputStream servletInputStream = new ServletInputStream() {
			public int read() throws IOException {
				return byteArrayInputStream.read();
			}
		};
		return servletInputStream;
	}

	@Override
	public BufferedReader getReader() throws IOException {
		return new BufferedReader(new InputStreamReader(this.getInputStream()));
	}

	public String getBody() {
		return this.body;
	}
	
	
	public JSONObject getJsonObject() throws Exception {
		JSONObject json = null;
		
		try {
			
			json = JSONObject.fromObject(body);
			
			if(Checks.esNulo(json)){
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);	
				
			}else if(!json.containsKey("data") ){
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);	
				
			}
			
		}catch (Exception e) {
			throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);			
		}
		return json;
	}
	

	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Object getRequestData(Class clase) throws JsonParseException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		mapper.generateJsonSchema(clase); 
		Object dataJson = mapper.readValue(this.body, clase);
		return dataJson;
	}
	

	
}