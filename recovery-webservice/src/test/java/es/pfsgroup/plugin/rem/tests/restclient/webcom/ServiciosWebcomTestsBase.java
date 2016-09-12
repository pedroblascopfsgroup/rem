package es.pfsgroup.plugin.rem.tests.restclient.webcom;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyMap;
import static org.mockito.Matchers.anyString;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.Map;

import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.recovery.api.UsuarioApi;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ServiciosWebcomTestsBase {
	
	public static final String USUARIO_REM = "TEST";
	

	public ServiciosWebcomTestsBase() {
		super();
	}

	protected void initMocks(ApiProxyFactory apiProxyMock, HttpClientFacade httpClientMock) {
		if (httpClientMock == null){
			throw new IllegalStateException("'httpClientMock' no puede ser NULL");
		}
		
		if (apiProxyMock != null) {
			UsuarioApi usuarioApi = mock(UsuarioApi.class);
			Usuario usuarioMock = mock(Usuario.class);
			when(apiProxyMock.proxy(UsuarioApi.class)).thenReturn(usuarioApi);
			when(usuarioApi.getUsuarioLogado()).thenReturn(usuarioMock);
			when(usuarioMock.getUsername()).thenReturn(USUARIO_REM);
		}
	
		try {
			when(httpClientMock.processRequest(anyString(), anyString(), anyMap(), any(JSONObject.class), anyInt(),
					anyString())).thenReturn(new JSONObject());
		} catch (HttpClientException e) {
		}
	}

	protected JSONArray genericValidation(HttpClientFacade httpClient, String method, String charset) {
		ArgumentCaptor<JSONObject> jsonArg = ArgumentCaptor.forClass(JSONObject.class);
		ArgumentCaptor<Map> headersArg = ArgumentCaptor.forClass(Map.class);
		try {
			Mockito.verify(httpClient).processRequest(anyString(), eq(method), headersArg.capture(), jsonArg.capture(),
					anyInt(), eq(charset));
		} catch (HttpClientException e) {
	
		}
	
		JSONArray requestData = validateRequestAndExtractData(headersArg, jsonArg);
		return requestData;
	}

	protected void assertDataContains(JSONArray requestData, int idx, String key) {
		assertTrue("data[i]." + key + " es requerido", requestData.getJSONObject(idx).containsKey(key));
	}

	protected void assertDataEquals(JSONArray requestData, int idx, String key, Object expected) {
		assertDataContains(requestData, idx, key);
		
		assertEquals("data[i]." + key + " no tiene el valor esperado", expected.toString(),
				requestData.getJSONObject(idx).get(key));
	}

	private JSONArray validateRequestAndExtractData(ArgumentCaptor<Map> headersArg, ArgumentCaptor<JSONObject> jsonArg) {
		Map headers = headersArg.getValue();
		assertNotNull("El header 'signatue' es requerido", headers.get("signature"));
		
		JSONObject request = jsonArg.getValue();
		assertTrue("'id' es requerido", request.containsKey("id"));
		assertNotNull("El 'id' de la petición no puede ser NULL", request.get("id"));
		
		JSONArray requestData = request.getJSONArray("data");
		assertNotNull("La petición debe contener el array 'data' ", requestData);
		return requestData;
	}

}