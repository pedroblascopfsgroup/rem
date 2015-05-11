package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;

import java.io.File;
import java.io.FileReader;
import java.util.Properties;

import org.junit.Test;

/**
 * 
 * @author Diana
 * Clase generada para poner m�todos �tiles para todos los test
 */
public class MSVUtilTest {
	
	/**
	 * 
	 * @param ruta
	 * @return devuelve la ruta modificada con las barras de separaci�n correspondientes del sistema
	 */
	public static String cambiarBarraSistema(String ruta){
		
		String separador = System.getProperty("file.separator");
		String rutaFinal=ruta.replace("/", separador);
		return rutaFinal;
	}
	
	public static String getRutaFichero(String etiqueta) {
		
		Properties testProprerties = new Properties();
		try {
			File f = new File("src/test/resources/test.properties");
			// System.out.println(f.getAbsolutePath());
			testProprerties.load(new FileReader(f));
		} catch (Exception e) {
			throw new RuntimeException("No se han podido cargar las properties para el test: ", e);
		}

		String ruta = cambiarBarraSistema(new File(".").getAbsolutePath() + testProprerties.getProperty(etiqueta));
		return ruta;
		
	}

	
	@Test
	public void test() {
		assertTrue(true);
	}

}
