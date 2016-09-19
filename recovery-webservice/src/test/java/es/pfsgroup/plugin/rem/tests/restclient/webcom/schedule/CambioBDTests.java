package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;

public class CambioBDTests {

	private String[] configCambios;
	private String[] datosHistoricos;
	private String[] datosActuales;
	private CambioBD cambio;
	
	@Before
	public void setUp() {
		configCambios = new String[] {"campo1", "campo2"};
		datosHistoricos = new String[]{"valor viejo", "ABCDE"};
		datosActuales = new String[]{"nuevo valor", "ABCDE"};
		
		cambio = new CambioBD(configCambios);
	}


	@Test
	public void testGetCambios(){
		setUp();
		
		cambio.setDatosHistoricos(datosHistoricos);
		cambio.setDatosActuales(datosActuales);
		
		Map<String, Object> cambios = cambio.getCambios();
		
		assertEquals("nuevo valor", cambios.get("campo1"));
		assertNull(cambios.get("campo2"));
	}


	
	@Test
	public void testDatosActualesContieneUnRegistroNuevo(){
	
		cambio.setDatosActuales(datosActuales);
		
		Map<String, Object> cambios = cambio.getCambios();
		
		assertEquals("Deberían haberse actualizado 2 campos", 2, cambios.size());
		
	}
	
	@Test
	public void testDatosHistoricosContieneUnRegistroNuevo(){
		cambio.setDatosHistoricos(datosHistoricos);
		
		Map<String, Object> cambios = cambio.getCambios();
		
		assertEquals("No debería haber ningún cambio", 0, cambios.size());
	}

}
