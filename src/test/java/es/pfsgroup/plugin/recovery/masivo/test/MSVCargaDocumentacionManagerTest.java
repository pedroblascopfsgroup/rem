package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Matchers.endsWith;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.atLeastOnce;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletContext;

import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;


//import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVCargaDocumentacionManager;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesosCargaDocsDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVAltaCargaDocDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCargaDocumentacionInitDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesosCargaDocs;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ContratoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.ext.api.contrato.EXTContratoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

/**
 * Prueba de la clase MSVCargaDocumentacionManager
 * @author carlos
 *
 */
@SuppressWarnings("deprecation")
@RunWith(MockitoJUnitRunner.class)
public class MSVCargaDocumentacionManagerTest extends SampleBaseTestCase {

	@InjectMocks MSVCargaDocumentacionManager manager;
	
	@Mock
	MSVCargaDocumentacionInitDto mockCargaDocuDTO;
	
	@Mock
	ServletContext mockServlet;
	
	private String rutaDirectorio = null;
	
	@Mock
	MSVProcesosCargaDocsDao mockProcesosDao;
	
	@Mock
	MSVProcesosCargaDocs mockProcesosCargaDocs;
	
	@Mock
	MSVDDEstadoProceso mockEstadoProceso;
	
	@Mock
	GenericABMDao mockGenericDao;
	
	@Mock
	MSVExcelParser mockExcelParser;
	
	@Mock
	MSVHojaExcel mockHojaExcel;
	
	@Mock
	ApiProxyFactory mockApiProxy;
	
	@Mock
	AsuntoApi mockAsuntoApi;
	
	@Mock
	EXTAsunto mockAsunto;
	
	@Mock
	ContratoApi mockContratoApi;
	
	@Mock
	EXTContrato mockContrato;
	 
	@Mock
	File mockFile;
	
	@Mock
	RecoveryBPMfwkBatchApi mockRecoveryBPMfwkBatchApi;
	
	@Mock
	EXTContratoApi mockEXTContratoApi;
	
	private File fileTest;
	@SuppressWarnings("unused")
	private File fileExcelTest;
	@SuppressWarnings("unused")
	private FileItem fileItemTest;
	
	@Before
	public void before() {
		this.rutaDirectorio = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION");
		// Limpiamos el directorio para preparar la ejecuci�n del test por si quedaba rastro de una ejecuci�n anterior
		limpiaDirectorio(null);
		
		copiaFicheros();
		
		when(mockCargaDocuDTO.getDirectorio()).thenReturn(rutaDirectorio);
		when(mockServlet.getRealPath(mockCargaDocuDTO.getDirectorio())).thenReturn(rutaDirectorio);
//		when(mockCargaDocuDTO.getMascara()).thenReturn("*.csv");
		when(mockCargaDocuDTO.getMascara()).thenReturn("*.xls");
		
		when(mockProcesosDao.existeDocSinProcesar(anyString())).thenReturn(false);
		when(mockProcesosDao.existeDocSinProcesar(endsWith("Err.xls"))).thenReturn(true);
		
		String rutaFileTest = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION")+"prueba.txt";
		fileTest = new File(rutaFileTest);
		fileItemTest = new FileItem(fileTest);		
		fileExcelTest = new File(rutaDirectorio+"relaciones.xls");
		
	}
	
	/**
	 * Se copian los ficheros necesarios para procesar los tests
	 */
	private void copiaFicheros() {
		String rutaDirectorio = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION");
		String rutaDirectorioBackup = rutaDirectorio+"backup";
		
		File directorioBackup = new File(rutaDirectorioBackup);
		File[] ficheros = directorioBackup.listFiles();
		for (int i=0;i<ficheros.length;i++) {
			if (!ficheros[i].getName().equals(".svn")) {
				FileCopy(ficheros[i], new File(rutaDirectorio+ficheros[i].getName()));
			}
		}
	}
	
	/**
	 * Se limpia todo rastro del test
	 */
	private void limpiaDirectorio(String strDirectorio) {
		if (Checks.esNulo(strDirectorio))
			strDirectorio = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION");
		
		File directorio = new File(strDirectorio);
		File[] ficheros = directorio.listFiles();
		for (int i=0;i<ficheros.length;i++) {			
			if ((!ficheros[i].getName().equals("backup")) && (!ficheros[i].getName().equals(".svn"))) {
				if (ficheros[i].isDirectory()) 
					limpiaDirectorio(ficheros[i].getAbsolutePath());
				ficheros[i].delete();
			}
		}
	}
	
	private void FileCopy(File sourceFile, File destinationFile) {

		try {
			
			FileInputStream in = new FileInputStream(sourceFile);
			FileOutputStream out = new FileOutputStream(destinationFile);

			int c;
			while( (c = in.read() ) != -1)
				out.write(c);

			in.close();
			out.close();
		} catch(IOException e) {
			System.err.println("Hubo un error de entrada/salida!!!");
		}
	}
	
  private void inicializaProcesaFicheroTestCasoGeneral() {
	@SuppressWarnings("unused")
	Filter mockFilter = mock(Filter.class);
	when(mockProcesosDao.crearNuevoProceso()).thenReturn(mockProcesosCargaDocs);
	//when(mockGenericDao.createFilter(any(FilterType.class), anyString(), anyString())).thenReturn(mockFilter);
	when(mockGenericDao.get(eq(MSVDDEstadoProceso.class), any(Filter.class))).thenReturn(mockEstadoProceso);

	
	when(mockExcelParser.getExcel(any(File.class))).thenReturn(mockHojaExcel);
	
		
	}
  
  


	private List<File> getListaFicheros(boolean todos) {
  		List<File> listaFichero = new ArrayList<File>();
		String rutaFileTest = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION");
		listaFichero.add(new File(rutaFileTest+"relaciones.xls"));
		listaFichero.add(new File(rutaFileTest+"relaciones2.xls"));
		if (todos) {
			listaFichero.add(new File(rutaFileTest+"prueba.txt"));
		}
		return listaFichero;		
	}
  
  
  	
  	
	@Test
	public void testGetFicheros() throws Exception {
		//List<File> listaFichero = manager.getFicheros(mockCargaDocuDTO);
		//assertEquals(2,listaFichero.size());
		
	}
	
	  /**
     * Comprobamos que el m�todo getFicheros devuelve BusinessException
     * cuando ruta no existe
	 * @throws Exception 
     */
	@Ignore
    @Test(expected=BusinessOperationException.class)
    public void testGetFichero_RutaNoExiste() throws Exception{
    	this.rutaDirectorio = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION")+"noExiste/";
		when(mockCargaDocuDTO.getDirectorio()).thenReturn(rutaDirectorio);
    	doThrow(BusinessOperationException.class).when(mockFile).exists();
    	//manager.getFicheros(mockCargaDocuDTO);
    }

	  /**
     * Comprobamos que el m�todo getFicheros devuelve BusinessException
     * cuando se le pasa directamente un fichero
	 * @throws Exception 
     */
	@Ignore
    @Test(expected=BusinessOperationException.class)
    public void testGetFichero_SinDirectorio() throws Exception{
    	this.rutaDirectorio = MSVUtilTest.getRutaFichero("RUTA_CARGA_DOCUMENTACION")+"relaciones.xls/";		
		when(mockCargaDocuDTO.getDirectorio()).thenReturn(rutaDirectorio);		
    	doThrow(BusinessOperationException.class).when(mockFile).exists();
    	//manager.getFicheros(mockCargaDocuDTO);
    	
    }


    @Test
    @Ignore
    public void testProcesaFichero_CasoGeneral() {
		@SuppressWarnings("unused")
		List<File> listaFichero = getListaFicheros(false);
		inicializaProcesaFicheroTestCasoGeneral();
		
		simulaFilasExcel();
		simulaGetAsunto();
		simulaGetContratosPorCasoNova();
		simulaGetContratos();
		simulaGetAsuntosActivos();
		simulaGetProcedimientos();	
		simulaAdjuntarDoc();
		
		MSVProcesosCargaDocs procesoCargaDocs =  simulaModificaProcesoCargaDocById();
		
		try {
			//manager.procesarFicheros(listaFichero, mockCargaDocuDTO);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
    	verify(mockAsuntoApi, atLeastOnce()).saveOrUpdateAsunto(mockAsunto);
    		
		verify(mockProcesosDao, atLeastOnce()).mergeAndUpdate(procesoCargaDocs);
    	
    }
    
    public void simulaAdjuntarDoc() {
    	
    	
    	Filter mockFilter = mock(Filter.class);
    	DDTipoFicheroAdjunto mockTipoFicheroAdj = mock(DDTipoFicheroAdjunto.class);
    	
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", "OT")).thenReturn(mockFilter);
    	when(mockGenericDao.get(DDTipoFicheroAdjunto.class, mockFilter)).thenReturn(mockTipoFicheroAdj);
    	
    	
    }

    @Test
    @Ignore
    public void testProcesaFichero_conErrores() {
		@SuppressWarnings("unused")
		List<File> listaFichero = getListaFicheros(false);
		inicializaProcesaFicheroTestCasoGeneral();
		
		simulaFilasExcel_error();
		simulaGetAsunto();
		simulaGetContratosPorCasoNova();
		simulaGetContratos();
		simulaGetAsuntosActivos();
		simulaGetProcedimientos();	
		simulaAdjuntarDoc();
		
		MSVProcesosCargaDocs procesoCargaDocs =  simulaModificaProcesoCargaDocById();
		
		try {
			//manager.procesarFicheros(listaFichero, mockCargaDocuDTO);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    		
		verify(mockAsuntoApi, atLeastOnce()).saveOrUpdateAsunto(mockAsunto);
		verify(mockProcesosDao, atLeastOnce()).mergeAndUpdate(procesoCargaDocs);
    	
    }
	    
    @Test
    @Ignore
    public void testProcesarFicheroAsunto() {
		@SuppressWarnings("unused")
    	List<File> listaFichero = getListaFicheros(false);
		inicializaProcesaFicheroTestCasoGeneral();
		
		simulaFilasExcel_sinAsunto();
		simulaGetAsunto();
		simulaGetContratosPorCasoNova();
		simulaGetContratos();
		simulaGetAsuntosActivos();
		simulaGetProcedimientos();	
		simulaAdjuntarDoc();
		
		MSVProcesosCargaDocs procesoCargaDocs =  simulaModificaProcesoCargaDocById();
		
		try {
			//manager.procesarFicheros(listaFichero, mockCargaDocuDTO);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    		
		verify(mockAsuntoApi, atLeastOnce()).saveOrUpdateAsunto(mockAsunto);
		verify(mockProcesosDao, atLeastOnce()).mergeAndUpdate(procesoCargaDocs);

    }

//    @Test
//    public void testZipAndMove() {
//    	try {
//			
//			Map<String, List<File>> mapFilesToZip = new HashMap<String, List<File>>();
//			
//			List<File> listaFichero = getListaFicheros(false);			
//			mapFilesToZip.put(getNow("relaciones.xls"), listaFichero);
//
////			List<File> listaFichero2 = getListaFicheros(true);
////			mapFilesToZip.put(getNow("relaciones2.xls"), listaFichero2);
////			
//			manager.zipAndMove(listaFichero, fileExcelTest, fileTest, mockCargaDocuDTO);
//			
//			
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//    	
//    }
    
//	private String getNow(String finalCad) {
//		Calendar currentDate = Calendar.getInstance(); //Get the current date
//		SimpleDateFormat formatter= new SimpleDateFormat("yyyyMMdd_HHmm");
//		String dateNow = formatter.format(currentDate.getTime());
//		
//		return dateNow+"_"+finalCad.substring(0, finalCad.lastIndexOf("."));
//	}
	
    public MSVProcesosCargaDocs simulaModificaProcesoCargaDocById() {
    	Long idProcess = 2L;
    	Long idEstado = 123L;
    	MSVProcesosCargaDocs procesoMasivo = new MSVProcesosCargaDocs();
    	
    	MSVAltaCargaDocDto dto = new MSVAltaCargaDocDto();
    	dto.setIdProceso(idProcess);
    	dto.setIdEstadoProceso(idEstado);
    	Filter mockFilter = mock(Filter.class);
    	when(mockProcesosDao.mergeAndGet(idProcess)).thenReturn(procesoMasivo);
    	//when(mockGenericDao.createFilter(any(FilterType.class), anyString(), anyString())).thenReturn(mockFilter);
    	
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEstadoProceso())).thenReturn(mockFilter);
    	
    	when(mockGenericDao.get(eq(MSVDDEstadoProceso.class), any(Filter.class))).thenReturn(mockEstadoProceso);
    	
    	MSVProcesosCargaDocs resultado = manager.modificaProcesoCargaDoc(dto);
    	assertEquals(resultado.getEstadoProceso(), procesoMasivo.getEstadoProceso());
    	return procesoMasivo;
    }
//
//    /**
//     * Verifica que ejecuta la llamada al inputBatch, pese a tener errores
//     * 
//     */    
//    @Test
//    public void testProcesaFichero_AsuntoError() {
//    	List<File> listaFichero = null;
//		try {
//			
//			listaFichero = manager.getFicheros(mockCargaDocuDTO);
//		
//			inicializaProcesaFicheroTestCasoGeneral();
//			when(mockHojaExcel.dameCelda(1, 0)).thenReturn("aaaaa");
//			
//			manager.procesarFicheros(listaFichero, mockCargaDocuDTO);
//		} catch (Exception e) {			
//			e.printStackTrace();
//		}
//    		
////		verify(mockRecoveryBPMfwkBatchApi, atLeastOnce()).programaProcesadoInput(anyLong(), any(RecoveryBPMfwkInputDto.class), any(RecoveryBPMfwkCallback.class));
//    	
//    }
//    
//
//    @Test
//    public void testProcesaFichero_SinProcedimientos() {
//    	List<File> listaFichero = null;
//		try {
//			listaFichero = manager.getFicheros(mockCargaDocuDTO);
//		
//			inicializaProcesaFicheroTestCasoGeneral();
//			when(mockAsunto.getProcedimientos()).thenReturn(new ArrayList<Procedimiento>());
//			
//			manager.procesarFicheros(listaFichero, mockCargaDocuDTO);
//		} catch (Exception e) {			
//			e.printStackTrace();
//		}
//    		
////		verify(mockRecoveryBPMfwkBatchApi, atLeastOnce()).programaProcesadoInput(anyLong(), any(RecoveryBPMfwkInputDto.class), any(RecoveryBPMfwkCallback.class));
//    	
//    }
//    
//    @Test
//    public void testAdjuntarDoc_sinAsunto() {
//    	
//    	//inicializaProcesaFicheroTestCasoGeneral();
//    	Map<String, Object> mapFila = getMapDatos("","2222");
//    	    	
//    	simulaBusquedaContratos();
//    	simulaGetAsunto();
//    	simulaGetContratos();
//    	simulaGetAsuntosActivos();
//    	
//    	String strErrores = manager.adjuntarDoc(mapFila, fileItemTest );
//    	
//    	verificarAdjuntarDoc_OK(strErrores);
//    }
//    
//    
//    private Map<String, Object> getMapDatos(String asunto, String contrato) {
//    	Map<String, Object> mapFila = new HashMap<String, Object>();
//    	mapFila.put(MSVCargaDocumentacionColumns.ASU_ID, asunto);
//    	mapFila.put(MSVCargaDocumentacionColumns.N_CASO_NOVA, contrato);
//		return mapFila;
//	}
//
//	@Test
//    public void testAdjuntarDoc_conAsuntoYContrato() {
//    	
//		Map<String, Object> mapFila = getMapDatos("11111", "22222");
//    	
//    	simulaBusquedaContratos();
//    	simulaGetAsunto();
//    	simulaGetContratos();
//    	simulaGetAsuntosActivos();
//    	
//    	String strErrores = manager.adjuntarDoc(mapFila, fileItemTest );
//    	
//    	verificarAdjuntarDoc_OK(strErrores);
//    	
//    }
//    
//    @Test
//    public void testAdjuntarDoc_sinContrato() {
//    	
//    	Map<String, Object> mapFila = getMapDatos("1111", "");
//    	
//    	simulaBusquedaContratos();
//    	simulaGetAsunto();
//    	simulaGetContratos();
//    	simulaGetAsuntosActivos();
//    	
//    	String strErrores = manager.adjuntarDoc(mapFila, fileItemTest );
//    	
//    	verificarAdjuntarDoc_OK(strErrores);
//    	
//    }
//    
//    public void verificarAdjuntarDoc_OK(String strErrores) {
//    	
//    	assertEquals("Ha habido un error no esperado", null, strErrores);
//    	verify(mockAsuntoApi,times(1)).saveOrUpdateAsunto(mockAsunto);
//    }
//    
//
//  
    public void simulaFilasExcel() {

    	@SuppressWarnings("unchecked")
		List<String> listaCabeceras = Arrays.asList(new String[]{"ASU_ID", "N_CASO_NOVA","NOMBRE_ADJUNTO", "TIPO_DOCUMENTO"});
    	try {
    		when(mockHojaExcel.getCabeceras()).thenReturn(listaCabeceras);
    		when(mockHojaExcel.getNumeroFilas()).thenReturn(2);
    		
    		when(mockHojaExcel.dameCelda(1, 0)).thenReturn("1111");
    		when(mockHojaExcel.dameCelda(1, 1)).thenReturn("222");
    		when(mockHojaExcel.dameCelda(1, 2)).thenReturn("prueba.txt");
    		when(mockHojaExcel.dameCelda(1, 3)).thenReturn("Esto es una prueba");
    		
    	} catch (IllegalArgumentException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	} catch (IOException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	}
    }
  
    public void simulaFilasExcel_error() {

    	@SuppressWarnings("unchecked")
		List<String> listaCabeceras = Arrays.asList(new String[]{"ASU_ID", "N_CASO_NOVA","NOMBRE_ADJUNTO", "TIPO_DOCUMENTO"});
    	try {
    		when(mockHojaExcel.getCabeceras()).thenReturn(listaCabeceras);
    		when(mockHojaExcel.getNumeroFilas()).thenReturn(3);
    		
    		when(mockHojaExcel.dameCelda(1, 0)).thenReturn("1111");
    		when(mockHojaExcel.dameCelda(1, 1)).thenReturn("222");
    		when(mockHojaExcel.dameCelda(1, 2)).thenReturn("prueba.txt");
    		when(mockHojaExcel.dameCelda(1, 3)).thenReturn("Esto es una prueba");
    		
    		when(mockHojaExcel.dameCelda(2, 0)).thenReturn("");
    		when(mockHojaExcel.dameCelda(2, 1)).thenReturn("3333");
    		when(mockHojaExcel.dameCelda(2, 2)).thenReturn("fichero2.doc");
    		when(mockHojaExcel.dameCelda(2, 3)).thenReturn("Esto es otra prueba");
    		
    		when(mockHojaExcel.dameCelda(3, 0)).thenReturn("22222");
    		when(mockHojaExcel.dameCelda(3, 1)).thenReturn("44444");
    		when(mockHojaExcel.dameCelda(3, 2)).thenReturn("prueba.txt");
    		when(mockHojaExcel.dameCelda(3, 3)).thenReturn("Otro tipo");
    		
    		when(mockHojaExcel.dameCelda(3, 0)).thenReturn("33333");
    		when(mockHojaExcel.dameCelda(3, 1)).thenReturn("55555");
    		when(mockHojaExcel.dameCelda(3, 2)).thenReturn("prueba2.txt");
    		when(mockHojaExcel.dameCelda(3, 3)).thenReturn("Otro tipo 2");
    		
    	} catch (IllegalArgumentException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	} catch (IOException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	}
    }
    
    public void simulaFilasExcel_sinAsunto() {

    	@SuppressWarnings("unchecked")
		List<String> listaCabeceras = Arrays.asList(new String[]{"ASU_ID", "N_CASO_NOVA","NOMBRE_ADJUNTO", "TIPO_DOCUMENTO"});
    	try {
    		when(mockHojaExcel.getCabeceras()).thenReturn(listaCabeceras);
    		when(mockHojaExcel.getNumeroFilas()).thenReturn(2);
    		
    		when(mockHojaExcel.dameCelda(1, 0)).thenReturn("");
    		when(mockHojaExcel.dameCelda(1, 1)).thenReturn("222");
    		when(mockHojaExcel.dameCelda(1, 2)).thenReturn("prueba.txt");
    		when(mockHojaExcel.dameCelda(1, 3)).thenReturn("Esto es una prueba");

    		
    	} catch (IllegalArgumentException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	} catch (IOException e1) {
    		// TODO Auto-generated catch block
    		e1.printStackTrace();
    	}
    }
    
    public void simulaGetAsunto() {
    	Long idAsunto = (long) 1111;
    	Filter filterOk = mock(Filter.class);
    	Filter filterKo = mock(Filter.class);
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idAsunto)).thenReturn(filterOk);    	
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "id", (long) 22222)).thenReturn(filterKo);
    	
    	when(mockGenericDao.get(EXTAsunto.class, filterOk)).thenReturn(mockAsunto);
    	when(mockGenericDao.get(EXTAsunto.class, filterKo)).thenReturn(null);
    	
    	
		when(mockApiProxy.proxy(AsuntoApi.class)).thenReturn(mockAsuntoApi);
		when(mockAsuntoApi.get((long) 1111)).thenReturn(mockAsunto);
		when(mockAsuntoApi.get((long) 22222)).thenReturn(null);
	}
    
    
    public void simulaGetContratosPorCasoNova() {
    	Long casoNova = (long) 222;
    	
    	Filter filterOk = mock(Filter.class);
    	Filter filterKo = mock(Filter.class);
    	
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "nroContrato",casoNova)).thenReturn(filterOk);
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "nroContrato",(long) 1234)).thenReturn(filterKo);

    	when(mockGenericDao.get(EXTContrato.class, filterOk)).thenReturn(mockContrato);
    	when(mockGenericDao.get(EXTContrato.class, filterKo)).thenReturn(null);
		
    }
    

    public void simulaGetContratos() {
    	final Contrato mockContrato1 = mock(Contrato.class);
    	final Contrato mockContrato2 = mock(Contrato.class);
    	final Contrato mockContrato3 = mock(Contrato.class);
    	
    	Set<Contrato> cnts = new HashSet<Contrato>();
    	cnts.add(mockContrato1);
    	cnts.add(mockContrato2);
    	cnts.add(mockContrato3);
    	when(mockAsunto.getContratos()).thenReturn(cnts);
    	
    	when(mockContrato.getId()).thenReturn((long) 22222);
    	when(mockContrato1.getId()).thenReturn((long) 1111);
    	when(mockContrato2.getId()).thenReturn((long) 22222);
    	when(mockContrato3.getId()).thenReturn((long) 33333);
    	
    	
    }

    public void simulaGetAsuntosActivos() {
    	Filter mockFilter = mock(Filter.class);
    	
    	List <Asunto> listaAsuntos = new ArrayList<Asunto>();
    	when(mockAsunto.getId()).thenReturn(100000L);
    	listaAsuntos.add(mockAsunto);    	
    	when(mockContrato.getAsuntosActivos()).thenReturn(listaAsuntos);
    	when(mockGenericDao.createFilter(FilterType.EQUALS, "id",100000L)).thenReturn(mockFilter);
    	when(mockGenericDao.get(EXTAsunto.class, mockFilter)).thenReturn(mockAsunto);
    }
    
	private void simulaGetProcedimientos() {
		Procedimiento mockProcedimiento1 = mock(Procedimiento.class);
		Procedimiento mockProcedimiento2 = mock(Procedimiento.class);
		
		List<Procedimiento> listaProcedimientos = new ArrayList<Procedimiento>();
		listaProcedimientos.add(mockProcedimiento1);
		listaProcedimientos.add(mockProcedimiento2);
		
		when(mockAsunto.getProcedimientos()).thenReturn(listaProcedimientos);
		when(mockProcedimiento1.getEstaAceptado()).thenReturn(false);
		when(mockProcedimiento2.getEstaAceptado()).thenReturn(true);

	}
    
	@After
    public void after() {
    	reset(mockCargaDocuDTO);
    	reset(mockServlet);
    	reset(mockProcesosDao);
    	reset(mockProcesosCargaDocs);
    	reset(mockEstadoProceso);
    	reset(mockGenericDao);
    	reset(mockExcelParser);
    	reset(mockHojaExcel);
    	reset(mockAsuntoApi);
    	reset(mockAsunto);
    	reset(mockContratoApi);
    	reset(mockContrato);	
    	reset(mockRecoveryBPMfwkBatchApi);    	
    	limpiaDirectorio(null);
    }

}
