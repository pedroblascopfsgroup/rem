package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.ExcelManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.ExcelRepoManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVPlantillaOperacion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVAltaContratoExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVExcelValidatorAbstract;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVExcelValidatorFactoryImpl;

/**
 * Tests unitarios de la clase ExcelManager
 * 
 * @author manuel
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class ExcelManagerTest extends SampleBaseTestCase {


	
	public class ValidationExpedtedResult {

		private boolean erroresValidacion;
		private FileItem ficheroErores;
		private boolean ejecutadoCorrectamente;
		private Throwable excepcion;
		

		/**
		 * Se espera que haya petado la validaci�n
		 * 
		 * @param exception
		 *            Excepci�n que se lanza en el m�todo de validaci�n
		 */
		public ValidationExpedtedResult(Throwable excepcion) {
			this.setExcepcion(excepcion);
			this.ejecutadoCorrectamente = false;
		}

		/**
		 * Se espeara que la validaci�n se haya ejecutado correctamente
		 * 
		 * @param tieneErores
		 *            Indica si se han producido errores de validaci�n o no
		 * @param ficheroErrores
		 *            Fichero con los errores de validaci�n, en caso de haberse
		 *            producido
		 */
		public ValidationExpedtedResult(boolean tieneErrores, FileItem ficheroErrores) {
			this.erroresValidacion = tieneErrores;
			this.ejecutadoCorrectamente = true;
			this.ficheroErores = ficheroErrores;
		}

		public boolean tieneErroresValidacion() {
			return this.erroresValidacion;
		}

		public FileItem getFicheroErrores() {
			return this.ficheroErores;
		}

		public boolean ejecutadoCorrectamente() {
			return this.ejecutadoCorrectamente;
		}

		public Throwable getExcepcion() {
			return excepcion;
		}

		public void setExcepcion(Throwable excepcion) {
			this.excepcion = excepcion;
		}

	}

	private static final Long TIPO_PLANTILLA = 1L;

	// Definimos la clase sobre la que vamos a realizar los tests mediante la
	// anotaci�n @InjectMocks
	@InjectMocks
	ExcelManager excelManager;

	// Definimos los objetos Mock que vamos a utilizar.
	@Mock
	private ApiProxyFactory mockProxyFactory;
	@Mock
	private ExcelRepoManager mockExcelRepo;
	@Mock
	FileItem mockFileItem;
	@Mock
	MSVExcelValidatorFactoryImpl mockFactory;
	@Mock
	MSVExcelValidator mockExcelValidator;
	@Mock
	MSVFicheroDao mockFicheroDao;
	@Mock
	MSVProcesoDao mockProcesoDao;
	@Mock
	MSVDDOperacionMasivaDao mockOperacionMasivaDao;
	@Mock
	MSVProcesoManager mockProcesoManager;
	@Mock
	MSVAltaContratoExcelValidator mockAltaContratoValidator;
	@Mock
	MSVExcelValidatorAbstract mockExcelValidatorAbstract;
	@Mock 
	private GenericABMDao mockGenericDao;

	private String pathExcelACargar;
	
	private Random r = new Random();

	@After
	public void after() {
		reset(mockProxyFactory);
		reset(mockFileItem);
		reset(mockExcelValidator);
		reset(mockFicheroDao);
		reset(mockProcesoDao);
		reset(mockProcesoManager);
		reset(mockAltaContratoValidator);
		reset(mockExcelValidatorAbstract);
		reset(mockExcelRepo);
		reset(mockFactory);
	}

	@Before
	public void before() {
		when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
		when(mockFactory.getForTipoValidador(any(Long.class))).thenReturn(mockExcelValidator);
		Properties p = new Properties();
		try {
			String separador = System.getProperty("file.separator");
			File f = new File("src" + separador + "test" + separador + "resources" + separador + "test.properties");
			// System.out.println(f.getAbsolutePath());
			p.load(new FileReader(f));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// DIANA: funci�n que cambia las barras de la ruta por las barras del
		// sistema correspondiente
		String ruta_excel_modificada = MSVUtilTest.cambiarBarraSistema(p.getProperty("RUTA_EXCEL"));

		pathExcelACargar = new File(".").getAbsolutePath() + ruta_excel_modificada;
	}

	/**
	 * Comprobamos que existe el m�todo generaExcelVacia(tipoPlantilla)
	 * Comprobamos que devuelve un ExcelFileBean no nulo Comprobamos que incluye
	 * un FileItem
	 * 
	 * @throws FileNotFoundException
	 */
	@Test
	public void testDameExcelVacia() throws FileNotFoundException {

		when(mockProxyFactory.proxy(ExcelRepoApi.class)).thenReturn(mockExcelRepo);
		when(mockExcelRepo.dameExcel(any(Long.class))).thenReturn(mockFileItem);
		ExcelFileBean result = excelManager.generaExcelVacia(TIPO_PLANTILLA);

		verify(mockExcelRepo).dameExcel(TIPO_PLANTILLA);
		assertNotNull(result);
		assertEquals(result.getFileItem(), mockFileItem);

	}
	
	/**
	 * Comprobamos que devuelve error si no encuentra una plantilla.
	 * Comprobamos que devuelve un fichero si encuentra una plantilla.
	 * @throws FileNotFoundException
	 */
	@Test
	public void testDameExcelVaciaPorTipoOperacion() throws FileNotFoundException {

		Long tipoOperacion = r.nextLong();
		List<MSVPlantillaOperacion> lista = new ArrayList<MSVPlantillaOperacion>();
		MSVDDOperacionMasiva msvDDOperacionMasiva = new MSVDDOperacionMasiva();
		msvDDOperacionMasiva.setId(tipoOperacion);
		Filter mockFilter = mock(Filter.class);
		
		when(mockOperacionMasivaDao.get(any(Long.class))).thenReturn(msvDDOperacionMasiva);
		
		
		when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoOperacion", msvDDOperacionMasiva)).thenReturn(mockFilter);
		when(mockGenericDao.getList(MSVPlantillaOperacion.class, mockFilter)).thenReturn(lista);

		//Si no se encuentra la plantilla comprobamos que devuelve un error
		try{
			excelManager.generaExcelVaciaPorTipoOperacion(tipoOperacion);
			fail("Debe saltar una exceoci�n.");
		}
		catch (Exception e){
			verify(mockGenericDao).getList(MSVPlantillaOperacion.class, mockFilter);
			assertEquals(BusinessOperationException.class, e.getClass());
		}

		MSVPlantillaOperacion msvPlantillaOperacion = new MSVPlantillaOperacion();
		Long idTipoPlantilla = r.nextLong();
		msvPlantillaOperacion.setId(idTipoPlantilla);
		lista.add(msvPlantillaOperacion);
		
		when(mockProxyFactory.proxy(ExcelRepoApi.class)).thenReturn(mockExcelRepo);
		when(mockExcelRepo.dameExcel(idTipoPlantilla)).thenReturn(mockFileItem);
		
		ExcelFileBean excelFileBean = excelManager.generaExcelVaciaPorTipoOperacion(tipoOperacion);
		
		verify(mockExcelRepo, times(1)).dameExcel(idTipoPlantilla);
		assertNotNull(excelFileBean);
		assertEquals(excelFileBean.getFileItem(), mockFileItem);


	}	

	@Test
	public void testUploadFileConErroresValidacion() throws Exception {
		// Variables del proceso
		Long idProceso = r.nextLong();
		Long idTipoOperacion = r.nextLong();

		// Creamos los par�metros para el test
		ExcelFileBean file = createParameterExcelFileBean();
		MSVDtoFileItem dto = createParameterDtoFileItem(idProceso);

		// Progrmamos el comportamiento de los Mocks
		FileItem fileItemErrores = (FileItem) setComportamientoValidador(file, Boolean.TRUE);
		setComportamientoDaos(idProceso, idTipoOperacion);

		// Realizamos la llamada al Manager
		MSVDtoResultadoSubidaFicheroMasivo result = excelManager.uploadFile(file, dto);

		// Verificamos el resultado del test
		verificaResultadoTest(idProceso, file, new ValidationExpedtedResult(true, fileItemErrores), result, MSVDDEstadoProceso.CODIGO_ERROR);

	}

	/**
	 * Este test comprueba el funcionamiento cuando se produce alguna excepci�n
	 * en el validador. Si el validador peta por cualquier causa, el proceso
	 * debe marcarse como Err�neo
	 * 
	 * @throws Exception
	 */
	@Test(expected = RuntimeException.class)
	public void testUploadExcepcionesEnValidador() throws Exception {
		// Variables del proceso
		Long idProceso = r.nextLong();
		Long idTipoOperacion = r.nextLong();

		// Creamos los par�metros para el test
		ExcelFileBean file = createParameterExcelFileBean();
		MSVDtoFileItem dto = createParameterDtoFileItem(idProceso);

		// Programamos el comportamiento de los Mocks
		Throwable excepcion = (Throwable) setComportamientoValidador(file, new RuntimeException());
		setComportamientoDaos(idProceso, idTipoOperacion);

		// Realizamos la llamada al Manager
		MSVDtoResultadoSubidaFicheroMasivo result = excelManager.uploadFile(file, dto);

		// Verificamos el resultado del test
		verificaResultadoTest(idProceso, file, new ValidationExpedtedResult(excepcion), result, MSVDDEstadoProceso.CODIGO_ERROR);

	}

	@Test
	public void testUploadFileValidacionOK() throws Exception {
		// Variables del proceso
		Long idProceso = r.nextLong();
		Long idTipoOperacion = r.nextLong();

		// Creamos los par�metros para el test
		ExcelFileBean file = createParameterExcelFileBean();
		MSVDtoFileItem dto = createParameterDtoFileItem(idProceso);

		// Progrmamos el comportamiento de los Mocks
		this.setComportamientoValidador(file, Boolean.FALSE);
		this.setComportamientoDaos(idProceso, idTipoOperacion);

		// Realizamos la llamada al Manager
		MSVDtoResultadoSubidaFicheroMasivo result = excelManager.uploadFile(file, dto);

		// Verificamos el resultado del test
		verificaResultadoTest(idProceso, file, new ValidationExpedtedResult(false, null), result, MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);

	}

	@Test
	public void testDescargarErrores() throws Exception {
		Long idProceso = 1L;
		MSVDocumentoMasivo fichero = new MSVDocumentoMasivo();
		fichero.setErroresFichero(mockFileItem);

		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(fichero);
		ExcelFileBean file = excelManager.descargarErrores(1L);

		assertNotNull(file);
	}

	@Test(expected = BusinessOperationException.class)
	public void testDescargarErroresConExcepcion() throws Exception {
		Long idProceso = 1L;

		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(null);
		try {
			excelManager.descargarErrores(1L);
		} catch (Exception e) {
			throw e;
		}
	}

	@Test
	public void testValidarArchivo() {
		Long idProceso = 1L;
		Long idTipoOperacion = 1L;
		//MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
		MSVProcesoMasivo proceso = new MSVProcesoMasivo();
		MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
		proceso.setTipoOperacion(tipoOperacion);
		tipoOperacion.setId(1L);
		MSVDocumentoMasivo fichero = new MSVDocumentoMasivo();
		fichero.setContenidoFichero(mockFileItem);
		fichero.setDirectorio("C:/");
		fichero.setNombre("Nombre_fichero");

		MSVDtoValidacion dtoResultado = new MSVDtoValidacion();

		dtoResultado.setFicheroTieneErrores(false);

		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(fichero);
		when(mockFactory.getForTipoValidador(idTipoOperacion)).thenReturn(mockExcelValidator);
		when(mockExcelValidator.validarContenidoFichero(any(MSVExcelFileItemDto.class))).thenReturn(dtoResultado);

		when(mockProcesoDao.get(idProceso)).thenReturn(proceso);

		Boolean resultado = excelManager.validarArchivo(idProceso);

		ArgumentCaptor<MSVExcelFileItemDto> excelFileItemDtoCaptor = ArgumentCaptor.forClass(MSVExcelFileItemDto.class);
		verify(mockExcelValidator, times(1)).validarContenidoFichero(excelFileItemDtoCaptor.capture());

		// Bruno 21/2/2013 Comprobar que pasamos la ruta completa del fichro a
		// validar
		assertEquals("El path del fichero a validar no est� completa, falta el nombre del fichero", fichero.getDirectorio() + "/" + fichero.getNombre(), excelFileItemDtoCaptor.getValue().getRuta());

		assertTrue(resultado);
	}

	@Test
	public void testValidarArchivoConErrores() {
		Long idProceso = 1L;
		Long idTipoOperacion = 1L;
		//MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
		MSVProcesoMasivo proceso = new MSVProcesoMasivo();
		MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
		proceso.setTipoOperacion(tipoOperacion);
		tipoOperacion.setId(1L);
		MSVDocumentoMasivo fichero = new MSVDocumentoMasivo();
		fichero.setContenidoFichero(mockFileItem);
		fichero.setDirectorio("C:/");

		MSVDtoValidacion dtoResultado = new MSVDtoValidacion();

		dtoResultado.setFicheroTieneErrores(true);
		dtoResultado.setExcelErroresFormato(mockFileItem);

		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(fichero);
		when(mockFactory.getForTipoValidador(idTipoOperacion)).thenReturn(mockExcelValidator);
		when(mockExcelValidator.validarContenidoFichero(any(MSVExcelFileItemDto.class))).thenReturn(dtoResultado);

		when(mockProcesoDao.get(idProceso)).thenReturn(proceso);

		Boolean resultado = excelManager.validarArchivo(idProceso);

		assertFalse(resultado);
	}
	
	
	/**
	 * Tests del m�todo {@link ExcelManager#updateErrores(Long, FileItem)}
	 * @throws Exception
	 */
	@Test
	public void testupdateErrores() throws Exception{
		
		Long idProceso = r.nextLong();
		FileItem ficheroErrores = mock(FileItem.class);
		MSVDocumentoMasivo mockDocMasivo = mock(MSVDocumentoMasivo.class);
		
		when(mockFicheroDao.findByIdProceso(idProceso)).thenReturn(mockDocMasivo);
		
		excelManager.updateErrores(idProceso, ficheroErrores);
		
		verify(mockDocMasivo, times(1)).setErroresFichero(ficheroErrores);
		verify(mockFicheroDao, times(1)).saveOrUpdate(mockDocMasivo);
		
	}
	

	private String getDirectorioFicheor(File file) {
		String dir = file.getParent();
		if (Checks.esNulo(dir)) {
			return "./";
		} else {
			return dir;
		}
	}

	/**
	 * Crea el par�metro ExcelFileBean para los tests
	 * 
	 * @return
	 */
	private ExcelFileBean createParameterExcelFileBean() {
		FileItem item = new FileItem();
		File fileOriginal = new File(pathExcelACargar);
		item.setFile(fileOriginal);
		ExcelFileBean file = new ExcelFileBean();
		file.setFileItem(item);
		return file;
	}

	/**
	 * Crea el par�metro MSVDtoFileItem para los tests
	 * 
	 * @param idProceso
	 *            ID del proceso que vamos a simular
	 * @return
	 */
	private MSVDtoFileItem createParameterDtoFileItem(Long idProceso) {
		MSVDtoFileItem dto = new MSVDtoFileItem();
		dto.setIdProceso(idProceso);
		return dto;
	}

	/**
	 * Prorgrama los mocks mockProcesoDao y mockFicheroDao para que devuelvan
	 * los procesos y documentos masivos para los tests
	 * 
	 * @param idProceso
	 * @param tipoOperacion
	 */
	private void setComportamientoDaos(Long idProceso, Long idTipoOperacion) {
		// Creamos el objeto tipo de operaci�n
		MSVDDOperacionMasiva tipoOperacion = new MSVDDOperacionMasiva();
		tipoOperacion.setId(idTipoOperacion);
		// Creamos el objeto proceso masivo
		MSVProcesoMasivo proceso = new MSVProcesoMasivo();
		proceso.setTipoOperacion(tipoOperacion);
		// Programamos el mock
		when(mockProcesoDao.get(idProceso)).thenReturn(proceso);
		// Creamos el objeto documento masivo
		MSVDocumentoMasivo documento = new MSVDocumentoMasivo();
		documento.setProcesoMasivo(proceso);
		// Programamos el mock
		when(mockFicheroDao.crearNuevoDocumentoMasivo()).thenReturn(documento);
	}

	/**
	 * Programa el mock mockExcelValidator con el comportamiento que tienen que
	 * tener el validador para este test
	 * 
	 * @param excelFileBean
	 *            ExcelFileBean que se pasa como argumento al manager
	 * 
	 * @param validationResults
	 *            Resultado de la validaci�n, este objeto puede ser:
	 *            <ol>
	 *            <li>Un booleano: true indica que han habido errores de
	 *            validaci�n, false que no ha habido ning�n error</li>
	 *            <li>Una excepci�n, indica que el m�todo de validaci�n ha
	 *            fallado, lanzando la excepci�n que se indica aqu�.</li>
	 *            </ol>
	 * 
	 * @return En funci�n del resultado de la validaci�n devolver�
	 *         <ol>
	 *         <li>Si el m�todo de validaci�n peta, la excepci�n que se lanza</li>
	 *         <li>Si el m�todo de validaci�n se ejecuta correctamente, un
	 *         FileItem que, en el supuesto que hayan fallado las validaciones,
	 *         ser� el fichero con los errores</li>
	 *         </ol>
	 */
	private Object setComportamientoValidador(ExcelFileBean excelFileBean, Object validationResults) {
		// En funci�n del resultado de la validaci�n hacemos una cosa u otra
		if (validationResults instanceof Boolean) {
			// Devolveremos un DTO con el resultado de la validaci�n
			FileItem fileItemErrores = new FileItem();
			MSVDtoValidacion dtoValidacionFormato = new MSVDtoValidacion();
			dtoValidacionFormato.setFicheroTieneErrores((Boolean) validationResults);
			if ((Boolean) validationResults) {
				dtoValidacionFormato.setExcelErroresFormato(fileItemErrores);
			} else {
				dtoValidacionFormato.setExcelErroresFormato(excelFileBean.getFileItem());
			}
			when(mockExcelValidator.validarFormatoFichero(any(MSVExcelFileItemDto.class))).thenReturn(dtoValidacionFormato);
			return fileItemErrores;
		} else if (validationResults instanceof Throwable) {
			// Se lanza una excepci�n
			when(mockExcelValidator.validarFormatoFichero(any(MSVExcelFileItemDto.class))).thenThrow((Throwable) validationResults);
			return validationResults;
		} else {
			throw new IllegalArgumentException("validationResults tiene que ser un Boolean o una excepci�n (Throwable)");
		}

	}

	/**
	 * Valida que el manager ha hecho todo lo que se esperaba
	 * 
	 * @param idProceso
	 *            ID del proceso que se quer�a simular
	 * @param file
	 *            ExcelFileBean que se le pasa como par�metro al manager
	 * @param validationResult
	 *            Resultado que se espera de la validaci�n del fichero
	 * @param result
	 *            Resultado que devuelve el manager
	 * 
	 * @param estadoProceso
	 *            Estado que debe tener el proceso en este test
	 * @throws Exception
	 */
	private void verificaResultadoTest(Long idProceso, ExcelFileBean file, ValidationExpedtedResult validationResult, MSVDtoResultadoSubidaFicheroMasivo result, String estadoProceso) throws Exception {
		// Bruno 21/2/2013 Comprobamos que s�lo se verifica el fichero una vez
		verify(mockExcelValidator, times(1)).validarFormatoFichero(any(MSVExcelFileItemDto.class));

		// Bruno 21/2/2013: Comprobamos que se actualiza el proceso masivo
		ArgumentCaptor<MSVDtoAltaProceso> argModificarProceso = ArgumentCaptor.forClass(MSVDtoAltaProceso.class);
		verify(mockProcesoManager, times(1)).modificarProcesoMasivo(argModificarProceso.capture());

		// Bruno 21/2/2013: Comprobamos que se guarda el documento masivo
		ArgumentCaptor<MSVDocumentoMasivo> argSaveDocumento = ArgumentCaptor.forClass(MSVDocumentoMasivo.class);
		verify(mockFicheroDao, times(1)).save(argSaveDocumento.capture());

		assertNotNull(result);
		// Bruno 21/2/2013: Para acutalizar e proceso es necesario pasar el id
		// de
		// proceso
		assertEquals("No se ha pasado el idProceso al procesoManager", idProceso, argModificarProceso.getValue().getIdProceso());

		// Bruno 21/2/2013 Comprobamos que el estado del proceso sea el indicado
		assertEquals("El estado del proceso no es el correcto", estadoProceso, argModificarProceso.getValue().getCodigoEstadoProceso());

		// Bruno 21/02/2013: Comprobamos que siempre se le pasa el directorio
		// del documento masivo que guardamos
		assertEquals("No se ha seteado el directorio del documento masivo a guardar", getDirectorioFicheor(file.getFileItem().getFile()), argSaveDocumento.getValue().getDirectorio());

		if (validationResult.tieneErroresValidacion()) {
			// Bruno 21/2/2013: Comprobamos que se hayan guardado los errores de
			// validaci�n en el documento
			assertEquals("No se han guardado los errores de validaci�n", argSaveDocumento.getValue().getErroresFichero(), validationResult.getFicheroErrores());
		} else {
			assertEquals("No se ha guardado el documento original en el campo errores", argSaveDocumento.getValue().getErroresFichero(), file.getFileItem());
		}

		assertEquals("El fichero original no es el correcto", argSaveDocumento.getValue().getContenidoFichero().getFile().getPath(), pathExcelACargar);
	}
	
	


}
