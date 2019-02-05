package es.pfsgroup.plugin.rem.rest.salesforce.api.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenRequest;
import es.pfsgroup.plugin.rem.rest.dto.AuthtokenResponse;
import es.pfsgroup.plugin.rem.rest.dto.ResponseGestorDocumentalFotos;

/*import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.util.EntityUtils;
import org.apache.http.client.ClientProtocolException;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.json.JSONException;*/

import es.pfsgroup.plugin.rem.rest.salesforce.api.SalesforceApi;
import es.pfsgroup.plugin.rem.restclient.exception.AccesDeniedException;
import es.pfsgroup.plugin.rem.restclient.exception.FileErrorException;
import es.pfsgroup.plugin.rem.restclient.exception.InvalidJsonException;
import es.pfsgroup.plugin.rem.restclient.exception.MissingRequiredFieldsException;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.exception.UnknownIdException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacadeInternalError;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.salesforce.clients.ClienteSalesforceGenerico;
import es.pfsgroup.plugin.rem.restclient.salesforce.clients.SalesforceEndpoint;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.WebcomEndpoint;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

// INICIO IMPORTS HTTPCLIENT
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.PostMethod;
// FIN IMPORTS HTTPCLIENT


import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.ServletContext;

import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;



import org.apache.commons.lang.StringEscapeUtils;


/**
 * Este cliente de Saleforce sirve para invocar a todos los endpoints. El endpoint
 * al que queremos invocar se pasa como parámetro al método de invocación.
 * 
 * @author Isidro Sotoca
 *
 */
@Component
public class SalesforceManager implements SalesforceApi {
	
	
	//TODO: Meter esto en un devon
	private static final String USERNAME = "admin@haya.es.dev";
	private static final String PASSWORD = "empaua_2016";
	private static final String LOGIN_URL = "https://test.salesforce.com";
	private static final String GRANT_SERVICE = "/services/oauth2/token?grant_type=authorization_code";
	//private static final String GRANT_TYPE = "authorization_code";
	private static final String CLIENT_ID = 
    		"3MVG9w8uXui2aB_pR8OlLmNTWNoIy9xDh.q6oZo2O8nuJv_sV200sZZE.LJzA.qpfMr7xwk.eEYVAgT.x0vQx";
	private static final String CLIENT_SECRET = "8669100424893793616";
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private ClienteSalesforceGenerico cliente;
	
	private static String ID_AUTH_TOKEN = "idAuthToken";
	private static String GET_AUTHTOKEN_ENDPOINT = "getAuthtoken/";
	private static String UPLOAD_ENDPOINT = "upload/";
	private static String DELETE_ENDPOINT = "delete/";
	private static String FILE_SEARCH_ENDPOINT = "get/";
	
	ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public void test2() {
		
		
		
		// Create a trust manager that does not validate certificate chains
	    TrustManager[] trustAllCerts = new TrustManager[] {new X509TrustManager() {
	            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
	                return null;
	            }
	            public void checkClientTrusted(X509Certificate[] certs, String authType) {
	            }
	            public void checkServerTrusted(X509Certificate[] certs, String authType) {
	            }
	        }
	    };

	    // Install the all-trusting trust manager
	    SSLContext sc;
		try {
			sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
		    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

		    // Create all-trusting host name verifier
		    HostnameVerifier allHostsValid = new HostnameVerifier() {
		        public boolean verify(String hostname, SSLSession session) {
		            return true;
		        }
		    };

		    // Install the all-trusting host verifier
		    HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (KeyManagementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpClient httpclient = new HttpClient();

        // Assemble the login request URL
        String loginURL = 	LOGIN_URL +
        					GRANT_SERVICE +
							"&client_id=" + CLIENT_ID +
							"&client_secret=" + CLIENT_SECRET +
							"&username=" + USERNAME +
							"&password=" + PASSWORD;

        // Login requests must be POSTs
        PostMethod httpPost = new PostMethod();
        httpPost.setPath(loginURL);
        Integer statusCode = null;

        try {
            // Execute the login POST request
        	statusCode = httpclient.executeMethod(httpPost);
        }  
        catch (IOException ioException) {
            ioException.printStackTrace();
        }

        // verify response is HTTP OK
        if (statusCode != 200) {
            System.out.println("Error authenticating to Force.com: "+statusCode);
            // Error is in EntityUtils.toString(response.getEntity())
            return;
        }

        String getResult = null;
        try {
            getResult = getResponseBody(httpPost);
            JSONObject jsonObject = null;
            String loginAccessToken = null;
            String loginInstanceUrl = null;
            try {
            	jsonObject = JSONObject.fromObject(getResult);
            	loginAccessToken = jsonObject.getString("access_token");
            	loginInstanceUrl = jsonObject.getString("instance_url");
            } 
            catch (JSONException jsonException) {
            	jsonException.printStackTrace();
            }
            
            //System.out.println(response.getStatusLine());
            System.out.println("Successful login");
            System.out.println("  instance URL: "+loginInstanceUrl);
            System.out.println("  access token/session ID: "+loginAccessToken);
        } catch (Exception ioException) {
            ioException.printStackTrace();
        }

        // release connection
        httpPost.releaseConnection();
		
	}
	
	
	private String getResponseBody(HttpMethod method) {
		// Ensure we have read entire response body by reading from buffered
		// stream
		if (method != null && method.hasBeenUsed()) {
			BufferedReader in = null;
			StringWriter stringOut = new StringWriter();
			BufferedWriter dumpOut = new BufferedWriter(stringOut, 8192);
			try {
				in = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream()));
				String line = "";
				while ((line = in.readLine()) != null) {
					dumpOut.write(line);
					dumpOut.newLine();
				}
			} catch (IOException e) {
				throw new HttpClientFacadeInternalError("Error Reading Response Stream", e);
			} finally {
				try {
					dumpOut.flush();
					dumpOut.close();
					if (in != null)
						in.close();
				} catch (IOException e) {
					logger.warn("Error Closing Response Stream", e);
				}
			}
			return StringEscapeUtils.unescapeHtml(stringOut.toString());
		}
		return null;
	}
	
	
	
	public void test() {
		
		/*String params = "{"
				+ "grant_type: 'password', "
				+ "client_id: '3MVG9w8uXui2aB_pR8OlLmNTWNoIy9xDh.q6oZo2O8nuJv_sV200sZZE.LJzA.qpfMr7xwk.eEYVAgT.x0vQx', "
				+ "client_secret: '8669100424893793616', "
				+ "username: 'admin@haya.es.dev', "
				+ "password: 'empaua_2016' "
		+ "}";
		
		httpClient.processRequest(LOGIN_URL + GRANT_SERVICE, "POST", "application/x-www-form-urlencoded", params, 5,
			"");*/
		
		/*HttpClient httpclient = HttpClientBuilder.create().build();

        // Assemble the login request URL
        String loginURL = 	LOGIN_URL +
        					GRANT_SERVICE +
							"&client_id=" + CLIENT_ID +
							"&client_secret=" + CLIENT_SECRET +
							"&username=" + USERNAME +
							"&password=" + PASSWORD;

        // Login requests must be POSTs
        HttpPost httpPost = new HttpPost(loginURL);
        HttpResponse response = null;

        try {
            // Execute the login POST request
            response = httpclient.execute(httpPost);
        } 
        catch (ClientProtocolException cpException) {
            cpException.printStackTrace();
        } 
        catch (IOException ioException) {
            ioException.printStackTrace();
        }

        // verify response is HTTP OK
        final int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode != HttpStatus.SC_OK) {
            System.out.println("Error authenticating to Force.com: "+statusCode);
            // Error is in EntityUtils.toString(response.getEntity())
            return;
        }

        String getResult = null;
        try {
            getResult = EntityUtils.toString(response.getEntity());
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
        JSONObject jsonObject = null;
        String loginAccessToken = null;
        String loginInstanceUrl = null;
        try {
            jsonObject = (JSONObject) new JSONTokener(getResult).nextValue();
            loginAccessToken = jsonObject.getString("access_token");
            loginInstanceUrl = jsonObject.getString("instance_url");
        } 
        catch (JSONException jsonException) {
            jsonException.printStackTrace();
        }
        
        //System.out.println(response.getStatusLine());
        System.out.println("Successful login");
        System.out.println("  instance URL: "+loginInstanceUrl);
        System.out.println("  access token/session ID: "+loginAccessToken);

        // release connection
        httpPost.releaseConnection();*/
		
	}
	
	//Llamadas utilizando la misma forma que GD Fotos
	@Override
	public void test3() throws IOException, RestClientException, HttpClientException {
		try {
			//trustEveryone();
		}
		catch (Exception e) {
			throw new IOException(e.getMessage());
		}
		getAuthtoken();
	}
	
	private AuthtokenResponse getAuthtoken() throws IOException, RestClientException, HttpClientException {
		
		AuthtokenRequest request = new AuthtokenRequest();
		
		SalesforceEndpoint salesforceEndpoint = SalesforceEndpoint.getTokenEndPoint(appProperties);
		salesforceEndpoint.validateCallTokenEndpoint();
		
		request.setApp_id(salesforceEndpoint.getClientId());
		request.setApp_secret(salesforceEndpoint.getClientSecret());
		
		String jsonResponse = null;
		AuthtokenResponse response = null;
		if (servletContext.getAttribute(ID_AUTH_TOKEN) != null) {
			
			response = (AuthtokenResponse) servletContext.getAttribute(ID_AUTH_TOKEN);
			if (response.getData().getExpires().compareTo(new Date()) < 0) {
				
				jsonResponse = cliente.send(null, salesforceEndpoint, "").toString();
				response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
				if (response.getError() != null && !response.getError().isEmpty()) {
					servletContext.setAttribute(ID_AUTH_TOKEN, null);
					throwException(response.getError());
				}

			}
		} 
		else {
			
			jsonResponse = cliente.send(null, salesforceEndpoint, "").toString();
			response = mapper.readValue(jsonResponse, AuthtokenResponse.class);
			if (response.getError() != null && !response.getError().isEmpty()) {
				servletContext.setAttribute(ID_AUTH_TOKEN, null);
				throwException(response.getError());
			}
			servletContext.setAttribute(ID_AUTH_TOKEN, response);

		}
		return response;
		
	}
	
	private void throwException(String error) throws RestClientException {
		
		if (error.equals(ResponseGestorDocumentalFotos.ACCESS_DENIED)) {
			throw new AccesDeniedException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.FILE_ERROR)) {
			throw new FileErrorException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.INVALID_JSON)) {
			throw new InvalidJsonException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.MISSING_REQUIRED_FIELDS)) {
			throw new MissingRequiredFieldsException();
		} 
		else if (error.equals(ResponseGestorDocumentalFotos.UNKNOWN_ID)) {
			throw new UnknownIdException();
		}
		
	}
	
	
	private void ignorarSSLHandshakeException() throws Exception {
		
		try {
	        TrustManager[] trustAllCerts = new TrustManager[] { 
	            new X509TrustManager() {
	                public X509Certificate[] getAcceptedIssuers() {
	                    X509Certificate[] myTrustedAnchors = new X509Certificate[0];  
	                    return myTrustedAnchors;
	                }

	                @Override
	                public void checkClientTrusted(X509Certificate[] certs, String authType) {}

	                @Override
	                public void checkServerTrusted(X509Certificate[] certs, String authType) {}
	            }
	        };

	        SSLContext sc = SSLContext.getInstance("SSL");
	        sc.init(null, trustAllCerts, new SecureRandom());
	        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
	        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
	            @Override
	            public boolean verify(String arg0, SSLSession arg1) {
	                return true;
	            }
	        });
	    } catch (Exception e) {
	    	throw e;
	    }
        
	}
	
	private void trustEveryone() { 
	    try { 
	            HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier(){ 
	                    public boolean verify(String hostname, SSLSession session) { 
	                            return true; 
	                    }}); 
	            SSLContext context = SSLContext.getInstance("TLS"); 
	            context.init(null, new X509TrustManager[]{new CustomInsecureX509TrustManager()
	            		}, new SecureRandom()); 
	            HttpsURLConnection.setDefaultSSLSocketFactory( 
	                            context.getSocketFactory()); 
	    } catch (Exception e) { // should never happen 
	    	System.out.println("Error en trustEveryone");
	            e.printStackTrace(); 
	    } 
	} 
	
	/**
	 * Método genérico para enviar una petición REST a Saleforce.
	 * 
	 * @param endpoint
	 *            Endpoint al que nos vamos a conectar.
	 * @param paramsList
	 *            Colección de Map de parámetros (campos) a enviar en la
	 *            petición.
	 * 
	 * @param registroLlamada
	 *            Objeto en el que se irán registrando los detalles sobre la
	 *            invocación al servicio.
	 * 
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> send(WebcomEndpoint endpoint, ParamsList paramsList, RestLlamada registroLlamada)
			throws ErrorServicioWebcom {
		
		HttpClient httpClient = new HttpClient();
		
		if (httpClient == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el httpClient.");
		}

		if (endpoint == null) {
			throw new IllegalArgumentException("El método no se ha invocado correctamente. Falta el endpoint.");
		}

		if (paramsList == null) {
			throw new IllegalArgumentException("'paramsList' no puede ser NULL");
		}

		if (registroLlamada == null) {
			throw new IllegalArgumentException("'registroLlamada' no puede ser NULL");
		}

		logger.trace("Llamada a servicio " + endpoint.toString() + " con parámetros " + paramsList);
		JSONObject response = null;
		JSONObject requestBody = null;
		try {
			// Llamada al servicio
			requestBody = WebcomRequestUtils.createRequestJson(paramsList);
			String jsonString = requestBody.toString();
			logger.debug("[DETECCIÓN CAMBIOS] Request:");
			logger.debug(jsonString);
			registroLlamada.logTiempPrepararJson();
			registroLlamada.setToken(requestBody.getString(WebcomRequestUtils.JSON_PROPERTY_ID));
			registroLlamada.setRequest(jsonString);

			String apiKey = endpoint.getApiKey();
			String publicAddress = getPublicAddress();
			registroLlamada.setApiKey(apiKey);
			registroLlamada.setIp(publicAddress);

			String signature = WebcomSignatureUtils.computeSignatue(apiKey, publicAddress, jsonString);
			registroLlamada.setSignature(signature);
			logger.trace("Cálculo del signature [apiKey=" + apiKey + ", ip=" + publicAddress + "] => " + signature);

			Map<String, String> headers = new HashMap<String, String>();
			headers.put("signature", signature);
			String httpMethod = endpoint.getHttpMethod();
			registroLlamada.setMetodo(httpMethod);
			String endpointUrl = endpoint.getEndpointUrl();
			registroLlamada.setEndpoint(endpointUrl);

			debugJsonFile(jsonString);

//			response = httpClient.processRequest(endpointUrl, httpMethod, headers, jsonString, endpoint.getTimeout(),
//					endpoint.getCharset());
			registroLlamada.setResponse(response.toString());

			logger.debug("[DETECCIÓN CAMBIOS] Response:");
			if (response != null && !response.isEmpty()) {
				logger.debug(response.toString());
			}

			// Gestión de errores si respuesta OK
			if (response.containsKey("error")) {
				String error = response.getString("error");
				registroLlamada.setErrorDesc(error);
				if ((error != null) && (!"".equals(error)) && (!"null".equals(error))) {
					logger.error("Webcom ha respondido con un código de error: " + error);
					throw new ErrorServicioWebcom(error);
				}
			}
			return response;
//		} catch (HttpClientException e) {
//			logger.fatal("No se ha podido establecer la conexión por un error en Http Client", e);
//			registroLlamada.setErrorDesc("HTTP:" + e.getResponseCode());
//			throw new ErrorServicioWebcom(e);
		} catch (UnsupportedEncodingException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} catch (NoSuchAlgorithmException e) {
			throw new HttpClientFacadeInternalError("No se ha podido calcular el signature", e);
		} finally {
			try {
				JSONArray data = obtenerDataResponse(response);
				if (data != null) {
					trazarObjetosRechazados(registroLlamada, data, false);
				} else {
					data = obtenerDataResponse(requestBody);
					if (data != null) {
						trazarObjetosRechazados(registroLlamada, data, true);
					}
				}
			} catch (Exception e) {
				logger.error("Error trazando datos rechazados", e);
			}
			registroLlamada.logTiempoPeticionRest();

		}
		
	}
	
	/**
	 * Método tentativo para obtener la data de la petición o la respuest
	 * @param object
	 * @return
	 */
	private JSONArray obtenerDataResponse(JSONObject object) {
		JSONArray data = null;
		try {
			data = object.getJSONArray("data");
		} catch (Exception e) {
			//no cambiar esto a error, es un metodo tentativo
			logger.info("Error al obtener la respuesta, usamos la peticion");
		}
		return data;

	}

	private void trazarObjetosRechazados(RestLlamada registroLlamada, JSONArray data, boolean trazandoRequest) {
		ArrayList<JSONObject> datosErroneos = new ArrayList<JSONObject>();
		for (int i = 0; i < data.size(); i++) {
			JSONObject jsonObject = data.getJSONObject(i);
			if (trazandoRequest || (jsonObject.containsKey("success") && !jsonObject.getBoolean("success"))) {
				datosErroneos.add(jsonObject);
			}

		}
		registroLlamada.setDatosErroneos(datosErroneos);
	}

	private void debugJsonFile(String jsonString) {
		String DEBUG_FILE = !Checks.esNulo(appProperties.getProperty("rest.client.json.debug.file"))
				? appProperties.getProperty("rest.client.json.debug.file") : "true";

		if (DEBUG_FILE.equals("true")) {
			FileWriter fileW = null;

			try {
				fileW = new FileWriter(System.getProperty("user.dir").concat(System.getProperty("file.separator"))
						.concat("call.json"));
				fileW.write(jsonString);
			} catch (Exception e) {
				logger.error("error al guardar el fichero JSON");
			} finally {
				try {
					if (fileW != null) {
						fileW.close();
					}
				} catch (IOException e) {
					logger.error("error al cerrar el fichero");
				}
			}
		}
	}
	
	private String getPublicAddress() {
		return WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.SERVER_PUBLIC_ADDRESS, "UNKNOWN_ADDRESS");
	}
	
}
