package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common;

import static org.junit.Assert.*;

import java.util.ArrayList;
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
		configCambios = new String[] { "campo1", "campo2", "campo3" };
		datosHistoricos = new String[] { "valor viejo", "ABCDE", null };
		datosActuales = new String[] { "nuevo valor", "ABCDE", null };

		cambio = new CambioBD(configCambios);
	}

	@Test
	public void testGetCambios() {
		setUp();

		cambio.setDatosHistoricos(datosHistoricos);
		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);

		assertEquals("nuevo valor", cambios.get(configCambios[0]));
		assertFalse(cambios.containsKey(configCambios[1]));
		assertFalse(cambios.containsKey(configCambios[2]));
		
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 3, valoresHistoricos.size());
	}

	@Test
	public void testDatosActualesContieneUnRegistroNuevo() {

		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);

		assertEquals("Deberían haberse actualizado 3 campos", 3, cambios.size());
		assertTrue("El map de valores históricos debería estar vacío", valoresHistoricos.isEmpty());

	}

	@Test
	public void testDatosHistoricosContieneUnRegistroNuevo() {
		cambio.setDatosHistoricos(datosHistoricos);

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);

		assertEquals("No debería haber ningún cambio", 0, cambios.size());
		
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 3, valoresHistoricos.size());
	}

	@Test
	public void testDatosActualesCampoPasaANull() {
		cambio.setDatosHistoricos(datosHistoricos);
		datosActuales[0] = datosHistoricos[0];
		datosActuales[1] = null;
		cambio.setDatosActuales(datosActuales);

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);
		
		assertEquals("Deberían haberse actualizado 1 campo", 1, cambios.size());
		assertTrue("El campo cambiado no es el correcto", cambios.containsKey(configCambios[1]));
		assertNull("El valor del campo debería ser null", cambios.get(configCambios[1]));
		
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 3, valoresHistoricos.size());

	}

	@Test
	public void testDatosHistoricosContieneUnDatoNull() {
		// hacemos que los datos actuales sean igual a los historicos y luego
		// seteamos a null uno de los campos de los historicos
		datosActuales[0] = datosHistoricos[0];
		datosActuales[1] = datosHistoricos[1];
		cambio.setDatosActuales(datosActuales);

		datosHistoricos[0] = null;
		cambio.setDatosHistoricos(datosHistoricos);

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);
		
		assertEquals("Deberían haberse actualizado 1 campo", 1, cambios.size());
		assertEquals("El valor del campo actualizado no es el esperado", datosActuales[0],
				cambios.get(configCambios[0]));
		cambio.setDatosActuales(datosHistoricos);
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 3, valoresHistoricos.size());

	}

	@Test
	public void testDevolverDatosHistoricos_noHayCambios() {
		// para que no e devuelvan cambios.
		cambio.setDatosActuales(datosHistoricos);
		cambio.setDatosHistoricos(datosHistoricos);
		Map<String, Object> valores = cambio.getValoresHistoricos(configCambios[1], configCambios[2]);
		
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 2, valores.size());

		assertEquals("No deberían haberse detectado cambios", 0, cambio.getCambios().size());

		assertFalse("El primer campo no debería haberse devuelto porque no es obligatorio",
				valores.containsKey(configCambios[0]));

		assertEquals("El valor del segundo campo no coincide", datosHistoricos[1], valores.get(configCambios[1]));

		assertTrue("Debería haberse devuelto el tercer campo por ser obligatorio",
				valores.containsKey(configCambios[2]));

		assertNull("El tercer campo debería ser null", valores.get(configCambios[2]));
	}

	@Test
	public void getCambios_clavePrimaria_noEnDto() {
		// Añadimos un campo nuevo, a ambos registros (actual e histórico) que
		// será la PK
		List<String> da = new ArrayList<String>();
		da.addAll(Arrays.asList(datosActuales));
		da.add("1");
		List<String> dh = new ArrayList<String>();
		dh.addAll(Arrays.asList(datosHistoricos));
		dh.add("1");

		cambio.setDatosActuales(da.toArray());
		cambio.setDatosHistoricos(dh.toArray());

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);

		assertEquals("El número de cambios esperado no coincide", 1, cambios.size());
		assertEquals("El map de valores históricos no tiene el número de elementos esperado", 3, valoresHistoricos.size());

	}

	@Test
	public void getCambios_clavePrimaria_noEnDto_y_registro_nuevo() {
		// Añadimos un campo nuevo en datos actuales que será la PK y dejamos
		// los datos históricos como un array de NULL
		List<String> da = new ArrayList<String>();
		da.addAll(Arrays.asList(datosActuales));
		da.add("1");

		cambio.setDatosActuales(da.toArray());

		Map<String, Object> cambios = cambio.getCambios();
		Map<String, Object> valoresHistoricos = cambio.getValoresHistoricos(configCambios);

		assertEquals("El número de cambios esperado no coincide", 3, cambios.size());
		assertTrue("El map de valores históricos debería estar vacío", valoresHistoricos.isEmpty());

	}

}
