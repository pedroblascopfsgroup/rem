package es.pfsgroup.plugin.recovery.masivo.test.utils.impl;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.*;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.*;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.ValidationError;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVAltaContratoExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVExcelValidatorAbstract;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

@RunWith(MockitoJUnitRunner.class)
public class MSVAltaContratoExcelValidatorTest extends SampleBaseTestCase {

	@InjectMocks
	private MSVAltaContratoExcelValidator altaContratoExcelValidator;

	@Mock
	private MSVDDOperacionMasivaDao mockOperacionMasivaDao;

	@Mock
	private MSVExcelParser mockExcelParser;
	
	@Mock
	private Properties mockAppProperties;

	private Properties testProprerties;

	@Before
	public void before() {
		testProprerties = new Properties();
		try {
			File f = new File("src/test/resources/test.properties");
			// System.out.println(f.getAbsolutePath());
			testProprerties.load(new FileReader(f));
		} catch (Exception e) {
			throw new RuntimeException("No se han podido cargar las properties para el test: ", e);
		}
		
		when(mockAppProperties.getProperty(MSVExcelValidator.KEY_NUMERO_MAXIMO_FILAS)).thenReturn(new String("5000"));
	}
	
	@After
	public void after(){
		reset(mockExcelParser);
		reset(mockOperacionMasivaDao);
	}

	// @Mock
	// private MSVHojaExcel mockHojaExcel;
	// Incluimos comprobaci�n de que se invoca el constructor del ExcelParser
	// con file y no con ruta
	@Test
	@Ignore
	public void testValidarContenidoFichero() {
		try {
			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebas());
			dtoFile.setIdTipoOperacion(1L);

			//MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();

			//MSVHojaExcel msvHojaExcel = new MSVHojaExcel();
			File file = new File("rutaimaginaria");
			ExcelFileBean filebean = new ExcelFileBean();
			FileItem fileItem = new FileItem();
			fileItem.setFile(file);
			filebean.setFileItem(fileItem);

			dtoFile.setExcelFile(filebean);
			
			when(mockExcelParser.getExcel(any(File.class))).thenReturn(new MSVExcelParser().getExcel(file));
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel("rutaimaginaria"));
			
			ArgumentCaptor<File> argFichero = ArgumentCaptor.forClass(File.class);
			verify(mockExcelParser, times(1)).getExcel(argFichero.capture());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero ExcelPruebaErr.xls y
	 * comprobando que tiene un error de Excel por demasiadas filas
	 */
	public void testValidarFormatoFicheroIndicandoRutaFichero() {
		try {
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,i,s");
			Long idTipoOperacion = 1L;
			List<String> listaCabeceras = new ArrayList<String>();
			listaCabeceras.add("ID");
			listaCabeceras.add("IMPORTE");
			listaCabeceras.add("DESCRIPCION");

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebas());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebas()));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);

			verify(mockOperacionMasivaDao).get(idTipoOperacion);

			assertNotNull(resultado);

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	private String getRutaFicheroExcelPruebas() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL");
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero ExcelPruebaErr.xls y
	 * comprobando que tiene un error de Excel por demasiadas filas
	 */
	public void testValidarFormatoFicheroIndicandoExcelFileBean() {
		try {
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,i,s");
			Long idTipoOperacion = 1L;
			List<String> listaCabeceras = new ArrayList<String>();
			listaCabeceras.add("ID");
			listaCabeceras.add("IMPORTE");
			listaCabeceras.add("DESCRIPCION");

			ExcelFileBean excelFile = new ExcelFileBean();
			File file = new File(new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_INCORRECTA_TMP"));
			FileItem fileItem = new FileItem(file);
			excelFile.setFileItem(fileItem);

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setExcelFile(excelFile);
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(File.class))).thenReturn(new MSVExcelParser().getExcel(file));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);

			verify(mockOperacionMasivaDao).get(idTipoOperacion);

			assertNotNull(resultado);

			assertTrue("El validador deber�a haber dado errores", resultado.getFicheroTieneErrores());
			assertFalse("Se ha machacado el fichero original", file.getPath().equals(resultado.getExcelErroresFormato().getFile().getPath()));

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero ExcelPruebaVaciaErr.xls y
	 * comprobando que tiene un error de Excel vac�a
	 */
	public void testValidarFormatoFicheroSinFilas() {
		try {
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,i,s");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasSinFilas());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebasSinFilas()));
			
			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			assertTrue(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	private String getRutaFicheroExcelPruebasSinFilas() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_SINFILAS");
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero ExcelPruebaSinCabsErr.xls y
	 * comprobando que tiene un error de Excel sin cabeceras
	 */
	public void testValidarFormatoFicheroSinCabs() {
		try {
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,i,s");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasSinCabs());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebasSinCabs()));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			assertTrue(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	private String getRutaFicheroExcelPruebasSinCabs() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_SINCABS");
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero
	 * ExcelPruebaDifColumnasErr.xls y comprobando que tiene un error de Excel
	 * con diferente n�mero de cabeceras
	 */
	public void testValidarFormatoFicheroDifCabs() {
		try {
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,i,s");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasDifCabs());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebasDifCabs()));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			assertTrue(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	private String getRutaFicheroExcelPruebasDifCabs() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_DIFCABS");
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero ExcelPruebaDatosErr.xls y
	 * comprobando que tiene un error de Excel con errores de validaci�n en las
	 * columnas
	 */
	public void testValidarFormatoFicheroDatos() {
		try {
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,n*,i,f,s5,b");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasDatos());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebasDatos()));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			assertTrue(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	private String getRutaFicheroExcelPruebasDatos() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_DATOS");
	}

	@Ignore
	@Test
	/*
	 * Complementar esta prueba buscando el fichero
	 * ExcelPruebaDatosCorrectosErr.xls (si todo ha ido bien no debe existir)
	 */
	public void testValidarFormatoFicheroDatosOK() {
		try {
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,n*,i,f,s5,b");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasDatosOK());
			dtoFile.setIdTipoOperacion(idTipoOperacion);

			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroExcelPruebasDatosOK()));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			assertFalse(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	/**
	 * Comprobamos que se lance la excepci�n correcta cuando no se puede leer el n�mero de filas de la hoja excel
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	@Ignore
	@Test(expected = ValidationError.class)
	public void testErrorObtenerNumFilas() throws IllegalArgumentException, IOException {
			

			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setValidacionFormato("n,n*,i,f,s5,b");
			Long idTipoOperacion = 1L;

			MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
			dtoFile.setRuta(getRutaFicheroExcelPruebasDatosOK());
			dtoFile.setIdTipoOperacion(idTipoOperacion);
			
			MSVHojaExcel mockHojaExcel = mock(MSVHojaExcel.class);
			
			when(mockOperacionMasivaDao.get(idTipoOperacion)).thenReturn(tipoOperacion);
			when(mockExcelParser.getExcel(any(String.class))).thenReturn(mockHojaExcel);
			when(mockHojaExcel.getNumeroFilas()).thenThrow(new IOException());
			
			altaContratoExcelValidator.validarFormatoFichero(dtoFile);
			
	}

	private String getRutaFicheroExcelPruebasDatosOK() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_DATOS_OK");
	}

}
