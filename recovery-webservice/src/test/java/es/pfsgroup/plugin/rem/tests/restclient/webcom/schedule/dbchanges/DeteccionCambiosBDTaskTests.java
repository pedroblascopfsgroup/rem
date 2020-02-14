package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioEnEjecucion;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoPeticionTrabajo;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomStock;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomVentasYcomisiones;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosList;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.InfoTablasBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.VentasYComisionesConstantes;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common.utilities.CambioBDStub;

@RunWith(MockitoJUnitRunner.class)
public class DeteccionCambiosBDTaskTests {
	
	@Mock
	private ServletContext servletContext;
	
	@Mock
	private RestApi restApi;

	@Mock
	private ServiciosWebcomManager servicios;

	@Mock
	private CambiosBDDao detectorCambiosDao;
	
	@Mock
	private RegistroLlamadasManager registroLlamadas;
	
	@Mock
	private Properties appProperties;

	@InjectMocks
	private DetectorWebcomStock detectorCambiosStock;

	@InjectMocks
	private DetectorWebcomEstadoPeticionTrabajo deteccionCambiosTrabajo;

	@InjectMocks
	private DetectorWebcomVentasYcomisiones deteccionCambiosVentasYComisiones;

	@InjectMocks
	private DeteccionCambiosBDTask task;

	@Before
	public void setUp() {
		task.addRegistroCambiosBDHandler(deteccionCambiosTrabajo);
		task.addRegistroCambiosBDHandler(detectorCambiosStock);
		task.addRegistroCambiosBDHandler(deteccionCambiosVentasYComisiones);
	}

	@After
	public void tearDown() {
		Mockito.reset(servicios);
		Mockito.reset(detectorCambiosDao);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testDeteccionCambiosStock() throws ErrorServicioWebcom, ErrorServicioEnEjecucion {
			
		Map<String, Object> data1 = new HashMap<String, Object>();
		data1.put(ServicioStockConstantes.ID_ACTIVO_HAYA, "1");
		data1.put(ServicioStockConstantes.ES_NUEVO, true);
		data1.put(ServicioStockConstantes.COD_TIPO_VIA, "ABCDE");
		data1.put(ServicioStockConstantes.ACTUAL_IMPORTE_DESCUENTO_WEB, 1.2);
		Date fecha = new Date();
		data1.put(ServicioStockConstantes.DESDE_IMPORTE_DESCUENTO_WEB, fecha);

		//List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		Integer tamanyoBloque = Integer.valueOf(1000);
		CambiosList listPendientes = new CambiosList(tamanyoBloque);
		listPendientes.add(new CambioBDStub(data1));

		Map<String, Object> data2 = new HashMap<String, Object>();
		data2.put(ServicioStockConstantes.ID_ACTIVO_HAYA, "2");
		listPendientes.add(new CambioBDStub(data2));
		
		when(detectorCambiosDao.listCambios(eq(StockDto.class), any(InfoTablasBD.class), any(RestLlamada.class), any(CambiosList.class)))
				.thenReturn(listPendientes);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> stockArgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).webcomRestStock(stockArgumentCaptor.capture(), any(RestLlamada.class));

		List<StockDto> stockEnviado = stockArgumentCaptor.getValue();
		assertEquals("No se ha enviado la cantidad de elementos esparada", 2, stockEnviado.size());

		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(1),
				stockEnviado.get(0).getIdActivoHaya().getValue());
		assertEquals("El ES_NUEVO no tiene el valor esperado", Boolean.TRUE, stockEnviado.get(0).getEsNuevo().getValue());
		assertEquals("El COD_TIPO_VIA no tiene el valor esperado", "ABCDE",
				stockEnviado.get(0).getCodTipoVia().getValue());
		assertEquals("El ACTUAL_IMPORTE_DESCUENTO_WEB no tiene el valor esperado", new Double(1.2),
				stockEnviado.get(0).getActualImporteDescuentoWeb().getValue());
		assertEquals("El DESDE_IMPORTE_DESCUENTO_WEB no tiene el valor esperado", fecha,
				stockEnviado.get(0).getDesdeImporteDescuentoWeb().getValue());

		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(2),
				stockEnviado.get(1).getIdActivoHaya().getValue());
		
		verificaRegistroPeticionOK();

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testDeteccionCambioEstadoPeticionTrabajo() throws ErrorServicioWebcom, ErrorServicioEnEjecucion {

		Map<String, Object> data = new HashMap<String, Object>();
		data.put(EstadoTrabajoConstantes.ID_TRABAJO_REM, 1L);
		data.put(EstadoTrabajoConstantes.COD_ESTADO_TRABAJO, "Z");

		//List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		//cambiosBD.add(new CambioBDStub(data));
		Integer tamanyoBloque = Integer.valueOf(1000);
		CambiosList listPendientes = new CambiosList(tamanyoBloque);
		listPendientes.add(new CambioBDStub(data));
		when(detectorCambiosDao.listCambios(eq(EstadoTrabajoDto.class), any(InfoTablasBD.class),
				any(RestLlamada.class), any(CambiosList.class))).thenReturn(listPendientes);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> argumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).webcomRestEstadoPeticionTrabajo(argumentCaptor.capture(), any(RestLlamada.class));

		List<EstadoTrabajoDto> dtoList = argumentCaptor.getValue();
		assertFalse("La lista de cambios enviada al servicio no puede estar vacía", dtoList.isEmpty());
		assertEquals("El valor de ID_TRABAJO_REM no coincide", new Long(1L),
				dtoList.get(0).getIdTrabajoRem().getValue());
		assertEquals("El valor de COD_ESTADO_TRABAJO no coincide", "Z",
				dtoList.get(0).getCodEstadoTrabajo().getValue());
		
		verificaRegistroPeticionOK();
	}

	@Test
	public void testDeteccionDeCambios_ValoresNullados() throws ErrorServicioWebcom, ErrorServicioEnEjecucion {
		
		// Simularemos que el detector de cambios nos devuelve campos nullados
		// para distintos tipos de datos y nos aseguraremos que se ha seteado el
		// NullDataType adecuado.
		// Elegimos el SockDto porque tiene muchos campos y muy variados
		Map<String, Object> data = new HashMap<String, Object>();
		// StringDataType
		data.put(ServicioStockConstantes.COD_TIPO_VIA, null);
		// LongDataType
		data.put(ServicioStockConstantes.ID_ACTIVO_HAYA, null);
		// DateDataType
		data.put(ServicioStockConstantes.DESDE_IMPORTE_DESCUENTO_WEB, null);
		// FloatDataType
		data.put(ServicioStockConstantes.CONSTRUIDA_SUPERFICIE, null);
		// BooleanDataType
		data.put(ServicioStockConstantes.ASCENSOR, null);

		//List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		//cambiosBD.add(new CambioBDStub(data));
		Integer tamanyoBloque = Integer.valueOf(1000);
		CambiosList listPendientes = new CambiosList(tamanyoBloque);
		listPendientes.add(new CambioBDStub(data));
		when(detectorCambiosDao.listCambios(eq(StockDto.class), any(InfoTablasBD.class), any(RestLlamada.class), any(CambiosList.class)))
				.thenReturn(listPendientes);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> stockArgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).webcomRestStock(stockArgumentCaptor.capture(), any(RestLlamada.class));
		StockDto stock = (StockDto) stockArgumentCaptor.getValue().get(0);

		// NullStringDataType
		assertNull("El valor no es un NullDataType", (stock.getCodTipoVia().getValue()));
		// NullLongDataType
		assertNull("El valor no es un NullDataType", (stock.getIdActivoHaya().getValue()));
		// NullDateDataType
		assertNull("El valor no es un NullDataType", (stock.getDesdeImporteDescuentoWeb().getValue()));
		// NullFloatDataType
		assertNull("El valor no es un NullDataType", (stock.getConstruidaSuperficie().getValue()));
		// NullBooleanDataType
		assertNull("El valor no es un NullDataType", (stock.getAscensor().getValue()));

		// Finalmente comprobamos que los campos que no hayamos seteado
		// explícitamente permanecen a null. Elegimos uno no seteado al azar.
		assertNull("El campo debería ser null ya que no se ha Nulleado explicitamente", stock.getBanyos());
		
		verificaRegistroPeticionOK();
	}

	@Test
	public void testDeteccionDeCambios_mandarSiempreCamposObligatorios() throws ErrorServicioWebcom, ErrorServicioEnEjecucion {
		/*
		 * Cogemos por ejemplo el servicio de ventas y comisiones, para el cual
		 * hay varios datos oblitatorios.
		 * 
		 * En este caso el detector de cambios detecta que dichos campos
		 * obligatorios no han cambiado.
		 * 
		 * No obstante, a pesar de que continuan siendo iguales, deben mandarse
		 * igualmente al servicio, puesto que están marcados como obligatorios.
		 */

		Map<String, Object> data = new HashMap<String, Object>();
		// Sólo cambian las observaciones
		String newValue = "nuevas observaciones";
		data.put(VentasYComisionesConstantes.OBSERVACIONES, newValue);

		//List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		//CambioBDStub stub = new CambioBDStub(data);
		//cambiosBD.add(stub);
		Integer tamanyoBloque = Integer.valueOf(1000);
		CambiosList listPendientes = new CambiosList(tamanyoBloque);
		CambioBDStub stub = new CambioBDStub(data);
		listPendientes.add(stub);
		
		// El stub debe devolver el map de datos históricos"
		Map<String, Object> vh = new HashMap<String, Object>();
		vh.put(VentasYComisionesConstantes.ID_OFERTA_REM, 1L);
		vh.put(VentasYComisionesConstantes.ES_PRESCRIPCION, Boolean.TRUE);
		vh.put(VentasYComisionesConstantes.IMPORTE, 100.66);
		vh.put(VentasYComisionesConstantes.OBSERVACIONES, "observaciones antiguas");
		stub.setValoresHistoricos(vh);

		when(detectorCambiosDao.listCambios(eq(ComisionesDto.class), any(InfoTablasBD.class), any(RestLlamada.class), any(CambiosList.class)))
				.thenReturn(listPendientes);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> comisionesArtgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).webcomRestVentasYcomisiones(comisionesArtgumentCaptor.capture(), any(RestLlamada.class));
		ComisionesDto dto = (ComisionesDto) comisionesArtgumentCaptor.getValue().get(0);

		// Comprobamos algunos de los campos que son obligatorios en este DTO.
		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getIdOfertaRem());

		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getEsPrescripcion());

		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getImporte());

		// Comprobamos que el dato histórico está actualziado
		assertEquals("No se ha actualizado el dato histórico", newValue, dto.getObservaciones().getValue());
		
		verificaRegistroPeticionOK();

	}
	
	
	private RestLlamada compruebaSeGuardaRegistro() {
		
		//(RestLlamada llamada, @SuppressWarnings("rawtypes") DetectorCambiosBD handler,Integer contError)
			
		
		ArgumentCaptor<RestLlamada> llamadaCaptor = ArgumentCaptor.forClass(RestLlamada.class);
		ArgumentCaptor<DetectorCambiosBD> handler = ArgumentCaptor.forClass(DetectorCambiosBD.class);
		Integer contError = Integer.valueOf(0);
		 
		Mockito.verify(registroLlamadas).guardaRegistroLlamada(llamadaCaptor.capture(), handler.capture());

		RestLlamada registro = llamadaCaptor.getValue();
		return registro;
	}
	
	
	private void verificaRegistroPeticionOK() {
		RestLlamada registro = compruebaSeGuardaRegistro();
		assertNotNull("Se debería haber logueado el startTime", registro.getStartTime());
	}
	
	
	

}
