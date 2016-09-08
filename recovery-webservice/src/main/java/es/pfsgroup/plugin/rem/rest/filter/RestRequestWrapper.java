package es.pfsgroup.plugin.rem.rest.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import es.pfsgroup.commons.utils.Checks;

public class RestRequestWrapper extends HttpServletRequestWrapper {
	private final String body;
	private final ArrayList<Map<String, Object>> requestMapList = new ArrayList<Map<String, Object>>();
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
			//this.convertRequest2MapList();
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
	
	public ArrayList<Map<String, Object>> getRequestMapList() {
		return this.requestMapList;
	}
	
	public JSONObject getJsonObject() throws Exception {
		JSONObject json = null;
		
		try {
			
			json = JSONObject.fromObject(body);
			
			if(Checks.esNulo(json)){
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");	
				
			}else if(!json.containsKey("data") ){
				throw new Exception("No se han podido recuperar los datos de la petición. Falta campo data.");	
				
			}else if(!json.getJSONArray("data").isArray()){
				throw new Exception("No se han podido recuperar los datos de la petición. El campo data no es un array.");	
				
			}else {			
				logger.info("Petición correcta.");
			}
			
		}catch (Exception e) {
			throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");			
		}
		return json;
	}
	
	
	private void convertRequest2MapList() throws Exception {
		
		try {
			Map<String,Object> map = null;	
			if(!Checks.esNulo(this.body) && this.body.contains("data")){	
				String dataStr = StringUtils.substringBetween(this.body.trim(), "[", "]");
				if(!Checks.esNulo(dataStr)){				
					dataStr = dataStr.replace("\"", "");
					int init = dataStr.indexOf("{");
					int last = dataStr.lastIndexOf("}");
					dataStr = dataStr.substring(init + 1, last);		
					String[] elemStr = dataStr.split("\\},\\{"); 
					if(!Checks.esNulo(elemStr)){				
						for(String elem : elemStr){
							String[] attrStr = elem.split(","); 
							if(!Checks.esNulo(attrStr)){						
								map = new HashMap<String, Object>();
								for(String attr: attrStr){
									String[] keyVal = attr.split(":");
									map.put(keyVal[0].trim(), keyVal[1].trim()); 
									this.requestMapList.add(map);
								}
							}
						}	
					}
				}
			}
		}catch (Exception e) {
			throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");			
		}
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