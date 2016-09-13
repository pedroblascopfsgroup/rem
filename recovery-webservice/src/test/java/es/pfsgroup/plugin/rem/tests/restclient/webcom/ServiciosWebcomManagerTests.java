package es.pfsgroup.plugin.rem.tests.restclient.webcom;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import net.sf.json.JSONArray;

@RunWith(MockitoJUnitRunner.class)
public class ServiciosWebcomManagerTests extends ServiciosWebcomTestsBase {


	@Mock
	private ApiProxyFactory proxyFactory;

	@Mock HttpClientFacade httpClient;

	@InjectMocks
	private ServiciosWebcomManager manager;

	@Before
	public void setup() {
		initMocks(proxyFactory, httpClient);
	}

	@Test
	public void enviaActualizacionEstadoTrabajoTest() {

		String method = "POST";
		String charset = "UTF-8";
		
		Long idRem = 1L;
		Long idWebcom = 100L;
		Long idEstado = 50L;
		String motivoRechazo = "Mi Motivo";
		
		manager.enviaActualizacionEstadoTrabajo(idRem, idWebcom, idEstado, motivoRechazo);

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataContains(requestData, 0, EstadoTrabajoConstantes.FECHA_ACCION);
		assertDataContains(requestData, 0, EstadoTrabajoConstantes.ID_USUARIO_REM_ACCION);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_ESTADO_TRABAJO, idEstado);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);

	}

}
