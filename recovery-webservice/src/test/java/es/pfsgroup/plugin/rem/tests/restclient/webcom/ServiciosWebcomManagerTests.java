package es.pfsgroup.plugin.rem.tests.restclient.webcom;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteStock;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoOfertaConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;
import net.sf.json.JSONArray;

@RunWith(MockitoJUnitRunner.class)
public class ServiciosWebcomManagerTests extends ServiciosWebcomTestsBase {

	@Mock
	private ApiProxyFactory proxyFactory;

	@Mock
	HttpClientFacade httpClient;

	@InjectMocks
	private ClienteEstadoTrabajo estadoTrabajoService;

	@InjectMocks
	private ClienteEstadoOferta estadoOfertaService;
	
	@InjectMocks
	private ClienteStock stockService;

	@InjectMocks
	private ServiciosWebcomManager manager;

	@Before
	public void setup() {
		initMocks(proxyFactory, httpClient);
		manager.setWebServiceClients(estadoTrabajoService, estadoOfertaService, stockService);

	}

	@Test
	public void enviaActualizacionEstadoTrabajoTest() {

		String method = "POST";
		String charset = "UTF-8";

		Long idRem = 1L;
		Long idWebcom = 100L;
		String codEstado = "ABC";
		String motivoRechazo = "Mi Motivo";

		manager.enviaActualizacionEstadoTrabajo(idRem, idWebcom, codEstado, motivoRechazo);

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

		Long idRem = 1L;
		Long idWebcom = 2L;
		String codEstadoOferta = "ABC";
		Long idActivoHaya = 4L;
		String codEstadoExpediente = "DEF";
		Boolean vendido = Boolean.TRUE;

		manager.enviaActualizacionEstadoOferta(idRem, idWebcom, codEstadoOferta, idActivoHaya, codEstadoExpediente,
				vendido);

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

		StockDto stock1 = new StockDto();
		StockDto stock2 = new StockDto();

		float actualImporte = 100.00F;
		String codigoAgrupacionObraNueva = "ABCDE";

		stock1.setActualImporte(WebcomDataType.floatDataType(actualImporte));
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
		assertDataEquals(requestData, 0, ServicioStockConstantes.ACTUAL_IMPORTE, actualImporte);
		// ¿El campo idEstado existirá o no?
		//assertDataEquals(requestData, 0, ServicioStockConstantes.ID_ESTADO, Boolean.TRUE);
		assertDataEquals(requestData, 1, ServicioStockConstantes.CODIGO_AGRUPACION_OBRA_NUEVA, codigoAgrupacionObraNueva);
		
		// Comprobamos que los campos que ponemos explícitamente a Null aparezcan como NULL en el JSON
		assertDataNull(requestData, 1, ServicioStockConstantes.COD_CEE);
		
		// Comprobamos que algunos de los campos no informados no estén en el JSON
		assertDataIsMissing(requestData, 0, ServicioStockConstantes.ANTIGUEDAD);
	}

}
