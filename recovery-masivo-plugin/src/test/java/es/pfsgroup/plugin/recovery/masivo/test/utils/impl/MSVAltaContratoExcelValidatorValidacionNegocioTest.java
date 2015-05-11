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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Random;

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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.ValidationError;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidators;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVValidationResult;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaContratosColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVAltaContratoExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

@RunWith(MockitoJUnitRunner.class)
public class MSVAltaContratoExcelValidatorValidacionNegocioTest extends SampleBaseTestCase {

	private static final String[] columnasFicheroAltaCartera = { MSVAltaContratosColumns.N_CASO, MSVAltaContratosColumns.N_REFERENCIA, MSVAltaContratosColumns.REF_CEDENTE,
			MSVAltaContratosColumns.LETRADO, MSVAltaContratosColumns.GRUPO_DE_GESTORES, MSVAltaContratosColumns.GRUPO_DE_BACK_OFFICE, MSVAltaContratosColumns.TIPO_DE_PROCEDIMIENTO };

	@InjectMocks
	private MSVAltaContratoExcelValidator altaContratoExcelValidator;

	@Mock
	private MSVDDOperacionMasivaDao mockOperacionMasivaDao;

	@Mock
	private MSVExcelParser mockExcelParser;

	@Mock
	private MSVBusinessValidationFactory mockValidationFactory;

	@Mock
	private MSVBusinessValidators mockValidadoresNegocio;

	@Mock
	private MSVBusinessValidationRunner mockValidationRunner;

	@Mock
	private Properties mockAppProperties;
	
	private Properties testProprerties;
	
	private Random r = new Random();

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
	public void after() {
		reset(mockExcelParser);
		reset(mockOperacionMasivaDao);
	}

	/**
	 * Comprueba el caso en el que la validaci�n de negocio es OK si no hay
	 * validadores definidos
	 */
	@Ignore
	@Test
	public void testValidarNegocioOK_sinValidadoresDefinidos() {
		try {
			Long idTipoOperacion = r.nextLong();
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setId(idTipoOperacion);

			MSVExcelFileItemDto dtoFile = creaParametroExcelFileItemDto(tipoOperacion);

			programaComportamientoMocksBasicos(tipoOperacion);

			configuraValidadores(tipoOperacion, null);

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarContenidoFichero(dtoFile);
			assertFalse(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	/**
	 * Comprueba el caso en el que la validaci�n de negocio es OK habiendo
	 * validadores.
	 */
	@Ignore
	@Test
	public void testValidarNegocioOK_conValidadores() {
		try {
			Long idTipoOperacion = r.nextLong();
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setId(idTipoOperacion);

			MSVExcelFileItemDto dtoFile = creaParametroExcelFileItemDto(tipoOperacion);

			programaComportamientoMocksBasicos(tipoOperacion);

			configuraValidadores(tipoOperacion, creaMapaValidadores(true, null));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarContenidoFichero(dtoFile);
			assertFalse(resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	/**
	 * Comprueba el caso en el que todas las validaciones de negocio van mal
	 * validadores.
	 */
	@Ignore
	@Test
	public void testValidarNegocioERROR() {
		try {
			Long idTipoOperacion = r.nextLong();
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setId(idTipoOperacion);

			MSVExcelFileItemDto dtoFile = creaParametroExcelFileItemDto(tipoOperacion);

			programaComportamientoMocksBasicos(tipoOperacion);

			configuraValidadores(tipoOperacion, creaMapaValidadores(false, null));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarContenidoFichero(dtoFile);
			assertTrue("Las validaciones de negocio deber�an haber fallado.", resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	/**
	 * Comprueba el caso en el que todas las validaciones de negocio van mal
	 * validadores.
	 */
	@Ignore
	@Test
	public void testValidarNegocioERROR_parcial() {
		try {
			Long idTipoOperacion = r.nextLong();
			MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
			tipoOperacion.setId(idTipoOperacion);

			MSVExcelFileItemDto dtoFile = creaParametroExcelFileItemDto(tipoOperacion);

			programaComportamientoMocksBasicos(tipoOperacion);

			HashMap<String, Boolean> excepciones = new HashMap<String, Boolean>();
			excepciones.put(MSVAltaContratosColumns.TIPO_DE_PROCEDIMIENTO, Boolean.FALSE);
			configuraValidadores(tipoOperacion, creaMapaValidadores(true, excepciones));

			MSVDtoValidacion resultado = altaContratoExcelValidator.validarContenidoFichero(dtoFile);
			assertTrue("Las validaciones de negocio deber�an haber fallado.", resultado.getFicheroTieneErrores());

		} catch (Exception e) {
			fail("Se ha producido una excepci�n inesperada: " + e.getMessage());
		}

	}

	/**
	 * Configura los validadores de negocio para el caso de pruebas
	 * 
	 * @param tipoOperacion
	 *            Tipo de operaci�n que queremos validar
	 * @param mapaValidadores
	 *            Lista de validadores para el caso de preubas
	 */
	private void configuraValidadores(MSVDDOperacionMasiva tipoOperacion, Map<String, MSVColumnValidator> mapaValidadores) {

		when(mockValidationFactory.getValidators(tipoOperacion)).thenReturn(mockValidadoresNegocio);
		if (Checks.estaVacio(mapaValidadores)) {
			when(mockValidadoresNegocio.getValidatorForColumn(any(String.class))).thenReturn(null);
		} else {
			for (Entry<String, MSVColumnValidator> e : mapaValidadores.entrySet()) {
				when(mockValidadoresNegocio.getValidatorForColumn(e.getKey())).thenReturn(e.getValue());
				boolean valid = debeValidar(e.getValue());
				when(mockValidationRunner.runValidation(eq(e.getValue()),any(String.class))).thenReturn(new MSVValidationResult(valid, null));
			}
		}
	}

	/**
	 * Nos dice si un determinado validador debe dar la columna como v�lida o
	 * no.
	 * 
	 * @param value
	 * @return
	 */
	private boolean debeValidar(MSVColumnValidator value) {
		if (value instanceof DummyColumnValidator) {
			return ((DummyColumnValidator) value).isValid();
		} else {
			throw new IllegalArgumentException("El validador debe ser un DummyColumnValidator");
		}
	}

	/**
	 * Crea una lista de validadores para el caso de pruebas
	 * 
	 * @param porDefecto
	 *            Resultado de la validaci�n por defecto
	 * 
	 * @param excepciones
	 *            Mapa con las columnas para las que la validaci�n debe ser
	 *            distinta a la de por, defecto
	 * 
	 * @return
	 */
	private Map<String, MSVColumnValidator> creaMapaValidadores(boolean porDefecto, Map<String, Boolean> excepciones) {
		HashMap<String, MSVColumnValidator> validadores = new HashMap<String, MSVColumnValidator>();
		for (String column : columnasFicheroAltaCartera) {
			if (!Checks.estaVacio(excepciones)) {
				Boolean valid = excepciones.get(column);
				validadores.put(column, new DummyColumnValidator(valid != null ? valid.booleanValue() : porDefecto));
			} else {
				validadores.put(column, new DummyColumnValidator(porDefecto));
			}
		}
		return validadores;
	}

	/**
	 * Programa el comportamiento de los mocks: mockOperacionMasivaDao,
	 * mockExcelParser
	 * 
	 * @param tipoOperacion
	 */
	private void programaComportamientoMocksBasicos(MSVDDOperacionMasiva tipoOperacion) {
		when(mockOperacionMasivaDao.get(tipoOperacion.getId())).thenReturn(tipoOperacion);
		when(mockExcelParser.getExcel(any(String.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroEjemploAltaCartera()));
		when(mockExcelParser.getExcel(any(File.class))).thenReturn(new MSVExcelParser().getExcel(getRutaFicheroEjemploAltaCartera()));
	}

	/**
	 * Crea el objeto que se le pasar� como par�metro al validador
	 * 
	 * @param tipoOperacion
	 *            Tipo de operaci�n que se va a solicitar
	 * @return
	 */
	private MSVExcelFileItemDto creaParametroExcelFileItemDto(MSVDDOperacionMasiva tipoOperacion) {
		MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
		ExcelFileBean excelFile = new ExcelFileBean();
		FileItem fileItem = new FileItem();
		fileItem.setFile(new File(getRutaFicheroEjemploAltaCartera()));
		excelFile.setFileItem(fileItem);
		dtoFile.setExcelFile(excelFile);
		dtoFile.setIdTipoOperacion(tipoOperacion.getId());
		return dtoFile;
	}

	private String getRutaFicheroEjemploAltaCartera() {
		return new File(".").getAbsolutePath() + testProprerties.getProperty("RUTA_EXCEL_EJEMPLO_ALTA_CARTERA");
	}

}
