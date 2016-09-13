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
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import net.sf.json.JSONArray;

@RunWith(MockitoJUnitRunner.class)
public class ServiciosWebcomManagerTests extends ServiciosWebcomTestsBase {


	@Mock
	private ApiProxyFactory proxyFactory;

	@Mock HttpClientFacade httpClient;
	
	@InjectMocks
	private ClienteEstadoTrabajo estadoTrabajoService;
	
	@InjectMocks
	private ClienteEstadoOferta estadoOfertaService;

	@InjectMocks
	private ServiciosWebcomManager manager;
	

	@Before
	public void setup() {
		initMocks(proxyFactory, httpClient);
		manager.setWebServiceClients(estadoTrabajoService, estadoOfertaService);
		
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

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_ESTADO_TRABAJO, idEstado);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);

	}
	
	@Test
	public void enviaActualizacionEstadoOfertaTest(){
		String method = "POST";
		String charset = "UTF-8";
		
		Long idRem = 1L;
		Long idWebcom = 2L;
		Long idEstadoOferta = 2L;
		Long idActivoHaya = 4L;
		Long idEstadoExpediente = 5L;
		Boolean vendido = Boolean.TRUE;
		
		manager.enviaActualizacionEstadoOferta(idRem, idWebcom, idEstadoOferta, idActivoHaya, idEstadoExpediente, vendido);
		
		JSONArray requestData = genericValidation(httpClient, method, charset);
		
		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_WEBCOM , idWebcom);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_REM , idRem);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_ACTIVO_HAYA , idActivoHaya);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_ESTADO_OFERTA , idEstadoOferta);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_ESTADO_EXPEDIENTE , idEstadoExpediente);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.VENDIDO , vendido);
		
	}

}
