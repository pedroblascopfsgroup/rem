package es.pfsgroup.plugin.rem.test.model.gastoproveedoravisos;

import static org.junit.Assert.*;

import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import es.pfsgroup.plugin.rem.model.GastoProveedorAvisos;

public class CamposAlertaTest {
	
	private static final int TWO = 2;

	@Test
	public void sinAlertas ()  {
		GastoProveedorAvisos avisos = new GastoProveedorAvisos();
		
		avisos.setCorrespondeComprador(false);
		
		assertNull(avisos.camposAlerta());
	}
	
	@Test
	public void conAlertas () {
		GastoProveedorAvisos avisos = new GastoProveedorAvisos();
		
		avisos.setBajaProveedor(true);
		avisos.setFueraPerimetro(true);
		
		assertNotNull("No se han devuelto avisos", avisos.camposAlerta());
		
		List<String> campos = Arrays.asList(avisos.camposAlerta());
		assertEquals("Se esperaban 2 avisos", TWO, campos.size());
		
		assertTrue("No se ha encontrado el valor esperado", campos.contains("bajaProveedor"));
		assertTrue("No se ha encontrado el valor esperado", campos.contains("fueraPerimetro"));
	}

}
