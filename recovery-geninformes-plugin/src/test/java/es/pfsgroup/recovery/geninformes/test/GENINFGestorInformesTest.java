package es.pfsgroup.recovery.geninformes.test;

import static org.junit.Assert.assertTrue;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.recovery.geninformes.GENINFGestorInformes;

@RunWith(MockitoJUnitRunner.class)
public class GENINFGestorInformesTest {

	//private final static String RUTA_JASPER_PRUEBAS = "RUTA_JASPER_PRUEBAS";

	@InjectMocks
	GENINFGestorInformes gestorInformes;

	/**
	 * Probamos que falla si el nombre de la plantilla es vacío
	 */
	@Test(expected = IllegalStateException.class)
	public void testDameInformeNombrePlantillaVacio() {

		gestorInformes.dameInforme();
	}

	/**
	 * Probamos que falla si el nombre de la plantilla es vacío
	 */
	@Test(expected = IllegalStateException.class)
	public void testDameInformeNombrePlantillaInexistente() {

		gestorInformes.dameInforme("report2.jrxml",	new HashMap<String, Object>());
	}

	/**
	 * Probamos que genera un fichero pdf con el mismo nombre si todos los
	 * parámetros son correctos
	 */
	@Test
	public void testDameInformeCorrecto() {

		Map<String,Object> mapaValores = new HashMap<String,Object>();
		mapaValores.put("valor1", "valor correcto esperado");
		
		FileItem fi = gestorInformes.dameInforme("report1.jrxml", mapaValores);
		
		assertTrue("Nombre de fichero esperado incorrecto", fi.getFileName().contains("report1"));
		assertTrue("No existe el fichero que se esperaba", fi.getFile().exists());
		
	}

}
