package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.anyLong;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.RegistroCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ServicioStockConstantes;

@RunWith(MockitoJUnitRunner.class)
public class DeteccionCambiosBDTests {
	
	@Mock
	private ServiciosWebcomManager servicios;
	
	@Mock
	private RegistroCambiosBD registroCambios;
	
	@InjectMocks
	private DeteccionCambiosBDTask task;
	
	@Test
	public void testDeteccionCambios(){
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
		
		when(registroCambios.listPendientes()).thenReturn(cambiosBD);
		
		task.detectaCambios();
		
		ArgumentCaptor<List> stockArgumentCaptor = ArgumentCaptor.forClass(List.class);
		verify(servicios).enviarStock(anyLong(),stockArgumentCaptor.capture());
		
		List<StockDto> stockEnviado = stockArgumentCaptor.getValue();
		assertEquals("No se ha enviado la cantidad de elementos esparada", 2, stockEnviado.size());
		
		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(1), stockEnviado.get(0).getIdActivoHaya().getValue());
		assertEquals("El NUEVO no tiene el valor esperado", Boolean.TRUE, stockEnviado.get(0).getNuevo().getValue());
		assertEquals("El COD_TIPO_VIA no tiene el valor esperado", "ABCDE", stockEnviado.get(0).getCodTipoVia().getValue());
		assertEquals("El ANTERIOR_IMPORTE no tiene el valor esperado", new Float(1.2), stockEnviado.get(0).getAnteriorImporte().getValue());
		assertEquals("El DESDE_IMPORTE no tiene el valor esperado", fecha, stockEnviado.get(0).getDesdeImporte().getValue());
		
		
		assertEquals("ID_ACTIVO HAYA tiene el valor esperado", new Long(2), stockEnviado.get(1).getIdActivoHaya().getValue());
		
	}


}
