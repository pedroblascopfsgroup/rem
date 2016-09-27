package es.pfsgroup.plugin.rem.tests.restclient.webcom;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyMap;
import static org.mockito.Matchers.anyString;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteStock;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RunWith(MockitoJUnitRunner.class)
public class ServiciosWebcomManagerTests extends ServiciosWebcomTestsBase {

	@Mock
	HttpClientFacade httpClient;

	@InjectMocks
	private ClienteEstadoTrabajo estadoTrabajoService;

	@InjectMocks
	private ClienteEstadoOferta estadoOfertaService;

	@InjectMocks
	private ClienteStock stockService;

	@Mock
	private RegistroLlamadasManager registroLlamadas;

	@InjectMocks
	private ServiciosWebcomManager manager;

	@Before
	public void setup() {
		initMocks(httpClient);
		manager.setWebServiceClients(estadoTrabajoService, estadoOfertaService, stockService);

	}

	@Test
	public void enviaActualizacionEstadoTrabajoTest() throws ErrorServicioWebcom {

		String method = "POST";
		String charset = "UTF-8";

		EstadoTrabajoDto dto = setupDto(new EstadoTrabajoDto());
		Long idRem = 1L;
		dto.setIdTrabajoRem(WebcomDataType.longDataType(idRem));
		Long idWebcom = 100L;
		dto.setIdTrabajoWebcom(WebcomDataType.longDataType(idWebcom));
		String codEstado = "ABC";
		dto.setCodEstadoTrabajo(WebcomDataType.stringDataType(codEstado));
		String motivoRechazo = "Mi Motivo";
		dto.setMotivoRechazo(WebcomDataType.stringDataType(motivoRechazo));

		manager.enviaActualizacionEstadoTrabajo(Arrays.asList(new EstadoTrabajoDto[] { dto }));

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.COD_ESTADO_TRABAJO, codEstado);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);

		
		verificaRegistroPeticionOK();
		
	}

	@Test
	public void enviaActualizacionEstadoOfertaTest() throws ErrorServicioWebcom {
		String method = "POST";
		String charset = "UTF-8";

		EstadoOfertaDto dto = setupDto(new EstadoOfertaDto());
		Long idRem = 1L;
		dto.setIdOfertaRem(LongDataType.longDataType(idRem));
		Long idWebcom = 2L;
		dto.setIdOfertaWebcom(LongDataType.longDataType(idWebcom));
		String codEstadoOferta = "ABC";
		dto.setCodEstadoOferta(StringDataType.stringDataType(codEstadoOferta));
		Long idActivoHaya = 4L;
		dto.setIdActivoHaya(LongDataType.longDataType(idActivoHaya));
		String codEstadoExpediente = "DEF";
		dto.setCodEstadoExpediente(StringDataType.stringDataType(codEstadoExpediente));
		Boolean vendido = Boolean.TRUE;
		dto.setVendido(BooleanDataType.booleanDataType(vendido));

		manager.enviaActualizacionEstadoOferta(Arrays.asList(new EstadoOfertaDto[] { dto }));

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_REM, idRem);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_ACTIVO_HAYA, idActivoHaya);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.COD_ESTADO_OFERTA, codEstadoOferta);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.COD_ESTADO_EXPEDIENTE, codEstadoExpediente);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.VENDIDO, vendido);

		
		verificaRegistroPeticionOK();
	}

	@Test
	public void enviarActualizacionStockTest() throws ErrorServicioWebcom {
		String method = "POST";
		String charset = "UTF-8";

		StockDto stock1 = setupDto(new StockDto());
		StockDto stock2 = setupDto(new StockDto());

		double actualImporte = 100.00;
		String codigoAgrupacionObraNueva = "ABCDE";

		stock1.setActualImporte(WebcomDataType.doubleDataType(actualImporte));
		// ¿El campo idEstado existirá o no?
		// stock1.setIdEstado(WebcomDataType.booleanDataType(true));
		stock2.setCodigoAgrupacionObraNueva(WebcomDataType.stringDataType(codigoAgrupacionObraNueva));

		// Seteamos un campo a Null explícitamente, para indicar un borrado
		stock2.setCodCee(WebcomDataType.nullStringDataType());

		List<StockDto> stock = new ArrayList<StockDto>();
		stock.add(stock1);
		stock.add(stock2);

		manager.enviarStock(stock);

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, ServicioStockConstantes.ACTUAL_IMPORTE, "100.00");
		// ¿El campo idEstado existirá o no?
		// assertDataEquals(requestData, 0, ServicioStockConstantes.ID_ESTADO,
		// Boolean.TRUE);
		assertDataEquals(requestData, 1, ServicioStockConstantes.CODIGO_AGRUPACION_OBRA_NUEVA,
				codigoAgrupacionObraNueva);

		// Comprobamos que los campos que ponemos explícitamente a Null
		// aparezcan como NULL en el JSON
		assertDataNull(requestData, 1, ServicioStockConstantes.COD_CEE);

		// Comprobamos que algunos de los campos no informados no estén en el
		// JSON
		assertDataIsMissing(requestData, 0, ServicioStockConstantes.ANTIGUEDAD);
		
		verificaRegistroPeticionOK();
	}

	@Test
	public void reintentosSiErrorHttpTest() {
		Mockito.reset(httpClient);
		HttpClientException exception = new HttpClientException("error!!", 404);
		try {
			Mockito.when(httpClient.processRequest(anyString(), anyString(), anyMap(), any(JSONObject.class), anyInt(),
					anyString())).thenThrow(exception);

			manager.enviaActualizacionEstadoTrabajo(createEstadoDtoList());
			fail("Debería haberse lanzado una excepción");
		} catch (Exception e) {
			assertTrue("La excepción no es la esperada", e instanceof ErrorServicioWebcom);
			assertTrue("El error debe ser reintentable", ((ErrorServicioWebcom) e).isReintentable());
		} finally {

			RestLlamada registro = compruebaSeGuardaRegistro();
			compruebaInfoBasicaRegistro(registro);

			assertTrue("El mensaje de error debe contener el error HTTP que se ha producido",
					registro.getErrorDesc().contains("404"));

			assertNull("La respuesta logada debería ser nula", registro.getResponse());
			
			assertNotNull("La excepción no se ha logado correctamente", registro.getException());
		}

	}


	@Test
	public void noReintentarSiErrorControladoWebcom() {
		ClienteEstadoTrabajo mockServicio = Mockito.spy(estadoTrabajoService);
		manager.setWebServiceClients(mockServicio, estadoOfertaService, stockService);

		ErrorServicioWebcom error = new ErrorServicioWebcom(ErrorServicioWebcom.MISSING_REQUIRED_FIELDS);

		try {
			Mockito.doThrow(error).when(mockServicio).enviaPeticion(Mockito.any(ParamsList.class),
					any(RestLlamada.class));
			manager.enviaActualizacionEstadoTrabajo(createEstadoDtoList());

			Mockito.verify(mockServicio).enviaPeticion(any(ParamsList.class), any(RestLlamada.class));
		} catch (Exception e) {
			assertTrue("La excepción no es la esperada", e instanceof ErrorServicioWebcom);
			assertFalse("El error no debe ser reintentable", ((ErrorServicioWebcom) e).isReintentable());
		} finally {
			compruebaSeGuardaRegistro();
			// El método que rellena el objeto RestLlamada está stubeado, por lo
			// tanto no podemos comprobar si la hemos rellenado bien aquí

		}

	}

	private <T extends WebcomRESTDto> T setupDto(T dto) {
		if (dto == null) {
			throw new IllegalArgumentException("'dto' no puede ser NULL. Debes pasarme una instancia.");
		}

		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(1234L));

		return dto;
	}

	private List<EstadoTrabajoDto> createEstadoDtoList() {
		EstadoTrabajoDto dto = new EstadoTrabajoDto();
		dto.setIdTrabajoRem(LongDataType.longDataType(1L));
		dto.setIdTrabajoWebcom(LongDataType.longDataType(1L));
		dto.setCodEstadoTrabajo(StringDataType.stringDataType("a"));

		return Arrays.asList(new EstadoTrabajoDto[] { setupDto(dto) });
	}
	
	private RestLlamada compruebaSeGuardaRegistro() {
		ArgumentCaptor<RestLlamada> llamadaCaptor = ArgumentCaptor.forClass(RestLlamada.class);
		Mockito.verify(registroLlamadas).guardaRegistroLlamada(llamadaCaptor.capture());

		RestLlamada registro = llamadaCaptor.getValue();
		return registro;
	}

	private void compruebaInfoBasicaRegistro(RestLlamada registro) {
		assertNotNull("Se debería haber registrado el endpoint al que nos conectamos", registro.getEndpoint());
		assertNotNull("Se debería haber registrado el ID de petición que mandamos", registro.getToken());
		assertNotNull("Se deberría haber registrado la IP desde la que invocamos", registro.getIp());
		assertNotNull("Se debería haber logado el método HTTP con el que invocamos la petición", registro.getMetodo());
		assertNotNull("Se debería haber logado la API KEY con la que generamos el signature", registro.getApiKey());
		assertNotNull("Se debería haber logado el signature generado", registro.getSignature());
		assertNotNull("Se debería haber logado la petición", registro.getRequest());
	}
	
	private void verificaRegistroPeticionOK() {
		RestLlamada registro = compruebaSeGuardaRegistro();
		compruebaInfoBasicaRegistro(registro);
		assertNull("No se debería loguear ningún código de error", registro.getErrorDesc());
		assertNotNull("Se debería haber logueado la respuesta a la llamada", registro.getResponse());
		assertNull("No se debería haber logado ninguna excepción", registro.getException());
	}

}
