package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

@RunWith(MockitoJUnitRunner.class)
public class MSVHojaExcelTest {

//	private static final String RUTA_PLANTILLA = "/home/pedro/DatosQuery.xls";
	private static final String RUTA_PLANTILLA_VACIA = "";
	private static final int NUM_FILAS=3001;
	
	private static final int NUM_COLUMNAS=15;
	private static final String CABECERA1="CABECERA1";
	private static final String CABECERA5="CABECERA5";
	private static final String CABECERA15="CABECERA15";
	
	private String ruta;
	private String ficheroSalida;
	
	@InjectMocks MSVHojaExcel excel;
	
	@Before
	public void before() {
		Properties p = new Properties();
		try {
			File f = new File("src/test/resources/test.properties");
			//System.out.println(f.getAbsolutePath());
			p.load(new FileReader(f));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		ruta=new File(".").getAbsolutePath() + p.getProperty("RUTA_EXCEL");		
		ficheroSalida = p.getProperty("FICHERO_SALIDA").toString();
		ficheroSalida = ficheroSalida.replaceFirst("-random-", String.valueOf(new Date().getTime()));
		excel = new MSVHojaExcel();
		excel.setRuta(ruta);
		
	}
	
	@After
	public void after() {
		File f = new File(ficheroSalida);
		f.delete();
	}
	
	@Test
	public void testRutaNumeroFilas() {
		
		assertEquals("Ruta incorrecta", ruta, excel.getRuta());
		
		try {
			assertTrue("Número de filas incorrecto", excel.getNumeroFilas()==NUM_FILAS);
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException: " + e.getMessage());
		}
		
	}
	
	@Test
	public void testGetCabeceras() {

		List<String> listaCabs = null;
		try {
			listaCabs = excel.getCabeceras();
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException: " + e.getMessage());
		}
		
		assertEquals("Error de validación de cabeceras 1", CABECERA1, listaCabs.get(0));
		assertEquals("Error de validación de cabeceras 5", CABECERA5, listaCabs.get(4));
		assertEquals("Error de validación de cabeceras 15", CABECERA15, listaCabs.get(14));
		
		assertEquals("Error de validación de num. cabeceras", NUM_COLUMNAS, listaCabs.size());
	}

	@Test
	public void testDameCelda() {
		
		String cA18="";
		String cF23="";
		String cB3001="";
		String cO2990="";
		
		try {
			cA18 = excel.dameCelda(18, 0);
			cF23 = excel.dameCelda(23, 5);
			cB3001 = excel.dameCelda(3000, 2);
			cO2990 = excel.dameCelda(2990, 14);
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException: " + e.getMessage());
		}

		assertEquals("Contenido celda A18", "ABC18", cA18);
		assertEquals("Contenido celda F23", "b", cF23);
		//assertEquals("Contenido celda C3001", "27 02 2021 12:00:00", cB3001);
		assertEquals("Contenido celda O2990", "2989", cO2990);
	
	}

	/** 
	 * Prueba de rendimiento de recorrido de una excel
	 * autor: pedro
	 */
	@Test
	public void testRecorridoCeldas() {

		BufferedWriter bw = null;
		
		long inicio = System.currentTimeMillis();
		String dummy="";
		try {
			bw = new BufferedWriter(new FileWriter(ficheroSalida));
		} catch (IOException e1) {
			System.out.println(e1.getMessage());
			fail("Error al abrir el fichero de salida " + ficheroSalida);
		}
		
		try {
			for (int i=0; i<excel.getNumeroFilas(); i++) {
				for (int j=0; j<excel.getCabeceras().size(); j++) {
					dummy = excel.dameCelda(i, j);
					bw.write(dummy + "\n");
				}
			}
			bw.flush();
			bw.close();
		} catch (IllegalArgumentException e) {
			fail("IllegalArgumentException: " + e.getMessage());
		} catch (IOException e) {
			fail("IOException: " + e.getMessage());
		}
		
		long miliSegundos = (System.currentTimeMillis() - inicio);
		String resultado="Tiempo transcurrido en recorrer una excel de 15 columnas y 3000 filas " +
				 miliSegundos + " milisegundos.";
		System.out.println(resultado);
		assertTrue(resultado, true);
		
	}

	@Test(expected=IllegalStateException.class)
	public void testRutaVacia() {
		
		excel.setRuta(RUTA_PLANTILLA_VACIA);
		try {
			excel.getNumeroFilas();
		}  catch (IOException e) {
			fail(e.getMessage());
		}
		
	}

	@Test(expected=IOException.class)
	public void testFicheroInexistente() throws IOException{
		
		excel.setRuta("fichero_inexistente.xls");
		try {
			excel.getNumeroFilas();
		} catch (IllegalArgumentException e) {
			fail(e.getMessage());
		} catch (IOException e) {
			throw e;
		}
		
	}

	@Test(expected=IllegalStateException.class)
	public void testFicheroCerrado() throws IOException{
		
		excel.cerrar();
		try {
			excel.getNumeroFilas();
		} catch (IllegalArgumentException e) {
			fail(e.getMessage());
		} catch (IOException e) {
			throw e;
		}
		
	}

	@Test(expected=ArrayIndexOutOfBoundsException.class)
	public void testCeldaFueraRango() throws IOException{
		
		try {
			excel.dameCelda(NUM_FILAS + 100, 0);
		} catch (IllegalArgumentException e) {
			fail(e.getMessage());
		} catch (IOException e) {
			fail(e.getMessage());
		}
		
	}

	@Test
	public void testCrearExcelErrores() {
		
		List<String> errores = new ArrayList<String>();
		for (int i=0; i<NUM_FILAS-1; i++) {
			errores.add("Error" + i);
		}
		String ficheroErrores="";
		try {
			ficheroErrores=excel.crearExcelErrores(errores);
		} catch (Exception e) {
			fail(e.getMessage());
		}
		
		String separador = System.getProperty("file.separator");
		String rutaFicheroErrores = new File(".").getAbsolutePath()+ separador + "utils" + separador + "testFiles" + separador + "ExcelPruebaErr.xls";
		
		assertEquals("Nombre de fichero esperado", ficheroErrores, rutaFicheroErrores);
		
		assertTrue("Existencia de fichero de errores: ", (new File(ficheroErrores)).exists());
		
	}

}
