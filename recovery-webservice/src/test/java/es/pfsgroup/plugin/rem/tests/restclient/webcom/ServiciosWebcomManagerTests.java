package es.pfsgroup.plugin.rem.tests.restclient.webcom;

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
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.web.servlet.ModelAndView;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.messagebroker.MessageBroker;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.controller.ResolucionComiteController;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
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
	private MessageBroker messageBroker;

	@InjectMocks
	private ServiciosWebcomManager manager;
	
	@InjectMocks
	private ResolucionComiteController resolucionComiteController;
	

	@Before
	public void setup() {
		initMocks(httpClient);
		manager.setWebServiceClients(estadoTrabajoService, estadoOfertaService, stockService);

	}

	@Test
	public void enviaActualizacionEstadoTrabajoTest() {

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

		manager.enviaActualizacionEstadoTrabajo(Arrays.asList(new EstadoTrabajoDto[]{dto}));

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.COD_ESTADO_TRABAJO, codEstado);
		assertDataEquals(requestData, 0, EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);

	}

	

	@Test
	public void enviaActualizacionEstadoOfertaTest() {
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

		manager.enviaActualizacionEstadoOferta(Arrays.asList(new EstadoOfertaDto[]{dto}));

		JSONArray requestData = genericValidation(httpClient, method, charset);

		assertDataBasicContent(requestData, 0);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_WEBCOM, idWebcom);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_OFERTA_REM, idRem);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.ID_ACTIVO_HAYA, idActivoHaya);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.COD_ESTADO_OFERTA, codEstadoOferta);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.COD_ESTADO_EXPEDIENTE, codEstadoExpediente);
		assertDataEquals(requestData, 0, EstadoOfertaConstantes.VENDIDO, vendido);

	}

	@Test
	public void enviarActualizacionStockTest() {
		String method = "POST";
		String charset = "UTF-8";

		StockDto stock1 = setupDto(new StockDto());
		StockDto stock2 = setupDto(new StockDto());

		double actualImporte = 100.00;
		String codigoAgrupacionObraNueva = "ABCDE";
		
		stock1.setActualImporte(WebcomDataType.doubleDataType(actualImporte));
		// ¿El campo idEstado existirá o no?
		//stock1.setIdEstado(WebcomDataType.booleanDataType(true));
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
		//assertDataEquals(requestData, 0, ServicioStockConstantes.ID_ESTADO, Boolean.TRUE);
		assertDataEquals(requestData, 1, ServicioStockConstantes.CODIGO_AGRUPACION_OBRA_NUEVA, codigoAgrupacionObraNueva);
		
		// Comprobamos que los campos que ponemos explícitamente a Null aparezcan como NULL en el JSON
		assertDataNull(requestData, 1, ServicioStockConstantes.COD_CEE);
		
		// Comprobamos que algunos de los campos no informados no estén en el JSON
		assertDataIsMissing(requestData, 0, ServicioStockConstantes.ANTIGUEDAD);
	}
	
	@Test
	public void reintentosSiErrorHttpTest(){
		Mockito.reset(httpClient);
		try {
			Mockito.when(httpClient.processRequest(anyString(), anyString(), anyMap(), any(JSONObject.class), anyInt(),
					anyString())).thenThrow(HttpClientException.class);
			
			manager.enviaActualizacionEstadoTrabajo(createEstadoDtoList());
			
			Mockito.verify(messageBroker).sendAsync(Mockito.any(Class.class), Mockito.any());;
		} catch (HttpClientException e) {
			
		}
	}

	
	@Test
	public void noReintentarSiErrorControladoWebcom(){
		ClienteEstadoTrabajo mockServicio =  Mockito.spy(estadoTrabajoService);
		manager.setWebServiceClients(mockServicio, estadoOfertaService, stockService);
		try {
			Mockito.doThrow(ErrorServicioWebcom.class).when(mockServicio).enviaPeticion(Mockito.any(ParamsList.class));
			manager.enviaActualizacionEstadoTrabajo(createEstadoDtoList());
			
			Mockito.verify(mockServicio).enviaPeticion(any(ParamsList.class));
			Mockito.verifyZeroInteractions(messageBroker);
			
			
		} catch (ErrorServicioWebcom e) {
		}
	}
	
	
	private <T extends WebcomRESTDto> T setupDto(T dto) {
		if (dto == null){
			throw new IllegalArgumentException("'dto' no puede ser NULL. Debes pasarme una instancia.");
		};
		
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(1234L));
		
		return dto;
	}
	
	private List<EstadoTrabajoDto> createEstadoDtoList() {
		EstadoTrabajoDto dto = new EstadoTrabajoDto();
		dto.setIdTrabajoRem(LongDataType.longDataType(1L));
		dto.setIdTrabajoWebcom(LongDataType.longDataType(1L));
		dto.setCodEstadoTrabajo(StringDataType.stringDataType("a"));
		
		return Arrays.asList(new EstadoTrabajoDto[]{setupDto(dto)});
	}


}
