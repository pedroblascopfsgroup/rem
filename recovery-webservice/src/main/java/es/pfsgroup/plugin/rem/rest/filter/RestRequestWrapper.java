package es.pfsgroup.plugin.rem.rest.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import net.sf.json.JSONObject;

public class RestRequestWrapper extends HttpServletRequestWrapper {
	private final String body;
	protected static final Log logger = LogFactory.getLog(RestRequestWrapper.class);
	private PeticionRest peticionRest = null;

	private long tiempoInicio;
	private long tiempoFin;
	private boolean trace = true;

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
			logger.error(ex.getMessage(),ex);
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (IOException ex) {
					logger.error(ex.getMessage(),ex);
				}
			}
		}

		if (stringBuilder.toString() != null && !stringBuilder.toString().isEmpty()) {
			body = stringBuilder.toString();
		} else if (request.getParameter("data") != null && !request.getParameter("data").isEmpty()){
			body = request.getParameter("data");
		}else{
			body = request.getQueryString();			
		}
	}

	@Override
	public ServletInputStream getInputStream() throws IOException {
		final ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(body.getBytes());
		return new ServletInputStream() {
			public int read() throws IOException {
				return byteArrayInputStream.read();
			}
		};
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


		} catch (Exception e) {
			json = null;
		}
		return json;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Object getRequestData(Class clase) throws JsonParseException, JsonMappingException, IOException,
			InstantiationException, IllegalAccessException {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		mapper.generateJsonSchema(clase);
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		mapper.setDateFormat(df);
		
		Object dataJson = null;
		try {
			dataJson = mapper.readValue(this.body, clase);
		}catch(Exception e) {
			logger.error("error parseando el JSON", e);
			dataJson = null;
		}
		return dataJson;
	}

	public PeticionRest getPeticionRest() {
		return peticionRest;
	}

	public void setPeticionRest(PeticionRest peticionRest) {
		this.peticionRest = peticionRest;
	}

	public long getTiempoInicio() {
		return tiempoInicio;
	}

	public void setTiempoInicio(long tiempoInicio) {
		this.tiempoInicio = tiempoInicio;
	}

	public long getTiempoFin() {
		return tiempoFin;
	}

	public void setTiempoFin(long tiempoFin) {
		this.tiempoFin = tiempoFin;
	}

	public boolean isTrace() {
		return trace;
	}

	public void setTrace(boolean trace) {
		this.trace = trace;
	}

}