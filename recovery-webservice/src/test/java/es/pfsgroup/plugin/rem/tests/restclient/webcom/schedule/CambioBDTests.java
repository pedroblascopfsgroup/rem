package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule;

import static org.junit.Assert.*;

import java.util.Map;

import org.junit.Test;

import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.CambioBD;

public class CambioBDTests {

	@Test
	public void testGetCambios(){
		String[] configCambios = new String[] {"campo1", "campo2"};
		String[] datosHistoricos = new String[]{"valor viejo", "ABCDE"};
		String[] datosActuales = new String[]{"nuevo valor", "ABCDE"};
		
		
		CambioBD cambio = new CambioBD(configCambios);
		
		cambio.setDatosHistoricos(datosHistoricos);
		cambio.setDatosActuales(datosActuales);
		
		Map<String, Object> cambios = cambio.getCambios();
		
		assertEquals("nuevo valor", cambios.get("campo1"));
		assertNull(cambios.get("campo2"));
	}

}
