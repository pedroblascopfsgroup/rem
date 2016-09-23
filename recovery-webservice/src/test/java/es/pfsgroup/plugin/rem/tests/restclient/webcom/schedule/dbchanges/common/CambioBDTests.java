package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common;

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
		configCambios = new String[] { "campo1", "campo2" };
		datosHistoricos = new String[] { "valor viejo", "ABCDE" };
		datosActuales = new String[] { "nuevo valor", "ABCDE" };

		cambio = new CambioBD(configCambios);
	}

	@Test
	public void testGetCambios() {
		setUp();

		cambio.setDatosHistoricos(datosHistoricos);
		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();

		assertEquals("nuevo valor", cambios.get("campo1"));
		assertNull(cambios.get("campo2"));
	}

	@Test
	public void testDatosActualesContieneUnRegistroNuevo() {

		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();

		assertEquals("Deberían haberse actualizado 2 campos", 2, cambios.size());

	}

	@Test
	public void testDatosHistoricosContieneUnRegistroNuevo() {
		cambio.setDatosHistoricos(datosHistoricos);

		Map<String, Object> cambios = cambio.getCambios();

		assertEquals("No debería haber ningún cambio", 0, cambios.size());
	}

	@Test
	public void testDatosActualesCampoPasaANull() {
		cambio.setDatosHistoricos(datosHistoricos);
		datosActuales[0] = datosHistoricos[0];
		datosActuales[1] = null;
		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();
		assertEquals("Deberían haberse actualizado 1 campo", 1, cambios.size());
		assertTrue("El campo cambiado no es el correcto", cambios.containsKey(configCambios[1]));
		assertNull("El valor del campo debería ser null", cambios.get(configCambios[1]));

	}

	@Test
	public void testDatosHistoricosContieneUnDatoNull() {
		// hacemos que los datos actuales sean igual a los historicos y luego
		// seteamos a null uno de los campos de los historicos
		datosActuales[0] = datosHistoricos[0];
		datosActuales[1] = datosHistoricos[1];
		cambio.setDatosActuales(datosActuales);;
		datosHistoricos[0] = null;
		cambio.setDatosHistoricos(datosHistoricos);
		
		Map<String, Object> cambios = cambio.getCambios();
		assertEquals("Deberían haberse actualizado 1 campo", 1, cambios.size());
		assertEquals("El valor del campo actualizado no es el espeado", datosActuales[0], cambios.get(configCambios[0]));
		cambio.setDatosActuales(datosHistoricos);

	}

}
