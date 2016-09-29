package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.NullDataType;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorCambiosEstadoPeticionTrabajo;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorCambiosStockActivos;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorCambiosVentasYComisiones;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.InfoTablasBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.VentasYComisionesConstantes;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common.utilities.CambioBDStub;

@RunWith(MockitoJUnitRunner.class)
public class DeteccionCambiosBDTaskTests {

	@Mock
	private ServiciosWebcomManager servicios;

	@Mock
	private CambiosBDDao detectorCambiosDao;

	@InjectMocks
	private DetectorCambiosStockActivos detectorCambiosStock;

	@InjectMocks
	private DetectorCambiosEstadoPeticionTrabajo deteccionCambiosTrabajo;

	@InjectMocks
	private DetectorCambiosVentasYComisiones deteccionCambiosVentasYComisiones;

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
	public void testDeteccionCambiosStock() throws ErrorServicioWebcom {

		Map<String, Object> data1 = new HashMap<String, Object>();
		data1.put(ServicioStockConstantes.ID_ACTIVO_HAYA, "1");
		data1.put(ServicioStockConstantes.NUEVO, true);
		data1.put(ServicioStockConstantes.COD_TIPO_VIA, "ABCDE");
		data1.put(ServicioStockConstantes.ANTERIOR_IMPORTE, 1.2);

		Date fecha = new Date();
		data1.put(ServicioStockConstantes.DESDE_IMPORTE, fecha);

		List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		cambiosBD.add(new CambioBDStub(data1));

		Map<String, Object> data2 = new HashMap<String, Object>();
		data2.put(ServicioStockConstantes.ID_ACTIVO_HAYA, "2");
		cambiosBD.add(new CambioBDStub(data2));

		when(detectorCambiosDao.listCambios(eq(StockDto.class), any(InfoTablasBD.class))).thenReturn(cambiosBD);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> stockArgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).enviarStock(stockArgumentCaptor.capture());

		List<StockDto> stockEnviado = stockArgumentCaptor.getValue();
		assertEquals("No se ha enviado la cantidad de elementos esparada", 2, stockEnviado.size());

		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(1),
				stockEnviado.get(0).getIdActivoHaya().getValue());
		assertEquals("El NUEVO no tiene el valor esperado", Boolean.TRUE, stockEnviado.get(0).getNuevo().getValue());
		assertEquals("El COD_TIPO_VIA no tiene el valor esperado", "ABCDE",
				stockEnviado.get(0).getCodTipoVia().getValue());
		assertEquals("El ANTERIOR_IMPORTE no tiene el valor esperado", new Double(1.2),
				stockEnviado.get(0).getAnteriorImporte().getValue());
		assertEquals("El DESDE_IMPORTE no tiene el valor esperado", fecha,
				stockEnviado.get(0).getDesdeImporte().getValue());

		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(2),
				stockEnviado.get(1).getIdActivoHaya().getValue());

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testDeteccionCambioEstadoPeticionTrabajo() throws ErrorServicioWebcom {

		Map<String, Object> data = new HashMap<String, Object>();
		data.put(EstadoTrabajoConstantes.ID_TRABAJO_REM, 1L);
		data.put(EstadoTrabajoConstantes.COD_ESTADO_TRABAJO, "Z");

		List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		cambiosBD.add(new CambioBDStub(data));
		when(detectorCambiosDao.listCambios(eq(EstadoTrabajoDto.class), any(InfoTablasBD.class))).thenReturn(cambiosBD);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> argumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).enviaActualizacionEstadoTrabajo(argumentCaptor.capture());

		List<EstadoTrabajoDto> dtoList = argumentCaptor.getValue();
		assertFalse("La lista de cambios enviada al servicio no puede estar vacía", dtoList.isEmpty());
		assertEquals("El valor de ID_TRABAJO_REM no coincide", new Long(1L),
				dtoList.get(0).getIdTrabajoRem().getValue());
		assertEquals("El valor de COD_ESTADO_TRABAJO no coincide", "Z",
				dtoList.get(0).getCodEstadoTrabajo().getValue());
	}

	@Test
	public void testDeteccionDeCambios_ValoresNullados() throws ErrorServicioWebcom {
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
		data.put(ServicioStockConstantes.DESDE_IMPORTE, null);
		// FloatDataType
		data.put(ServicioStockConstantes.SUPERFICIE, null);
		// BooleanDataType
		data.put(ServicioStockConstantes.ASCENSOR, null);

		List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		cambiosBD.add(new CambioBDStub(data));
		when(detectorCambiosDao.listCambios(eq(StockDto.class), any(InfoTablasBD.class))).thenReturn(cambiosBD);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> stockArgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).enviarStock(stockArgumentCaptor.capture());
		StockDto stock = (StockDto) stockArgumentCaptor.getValue().get(0);

		// NullStringDataType
		assertTrue("El valor no es un NullDataType", (stock.getCodTipoVia() instanceof NullDataType));
		// NullLongDataType
		assertTrue("El valor no es un NullDataType", (stock.getIdActivoHaya() instanceof NullDataType));
		// NullDateDataType
		assertTrue("El valor no es un NullDataType", (stock.getDesdeImporte() instanceof NullDataType));
		// NullFloatDataType
		assertTrue("El valor no es un NullDataType", (stock.getSuperficie() instanceof NullDataType));
		// NullBooleanDataType
		assertTrue("El valor no es un NullDataType", (stock.getAscensor() instanceof NullDataType));

		// Finalmente comprobamos que los campos que no hayamos seteado
		// explícitamente permanecen a null. Elegimos uno no seteado al azar.
		assertNull("El campo debería ser null ya que no se ha Nulleado explicitamente", stock.getBanyos());
	}

	@Test
	public void testDeteccionDeCambios_mandarSiempreCamposObligatorios() throws ErrorServicioWebcom {
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

		List<CambioBD> cambiosBD = new ArrayList<CambioBD>();
		CambioBDStub stub = new CambioBDStub(data);
		cambiosBD.add(stub);
		// El stub debe devolver el map de datos históricos"
		Map<String, Object> vh = new HashMap<String, Object>();
		vh.put(VentasYComisionesConstantes.ID_OFERTA_REM, 1L);
		vh.put(VentasYComisionesConstantes.ES_PRESCRIPCION, Boolean.TRUE);
		vh.put(VentasYComisionesConstantes.IMPORTE, 100.66);
		vh.put(VentasYComisionesConstantes.OBSERVACIONES, "observaciones antiguas");
		stub.setValoresHistoricos(vh);
		
		when(detectorCambiosDao.listCambios(eq(ComisionesDto.class), any(InfoTablasBD.class))).thenReturn(cambiosBD);

		//////////////////////////
		task.detectaCambios();
		//////////////////////////

		ArgumentCaptor<List> comisionesArtgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).ventasYcomisiones(comisionesArtgumentCaptor.capture());
		ComisionesDto dto = (ComisionesDto) comisionesArtgumentCaptor.getValue().get(0);

		// Comprobamos algunos de los campos que son obligatorios en este DTO.
		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getIdOfertaRem());

		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getEsPrescripcion());

		assertNotNull("Este campo debería venir informado por ser obligatorio", dto.getImporte());
		
		// Comprobamos que el dato histórico está actualziado
		assertEquals("No se ha actualizado el dato histórico", newValue, dto.getObservaciones().getValue());

	}

}
