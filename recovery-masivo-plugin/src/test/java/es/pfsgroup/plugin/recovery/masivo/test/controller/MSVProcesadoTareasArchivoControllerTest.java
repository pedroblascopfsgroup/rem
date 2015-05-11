package es.pfsgroup.plugin.recovery.masivo.test.controller;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.ExcelManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVDiccionarioManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVProcesadoTareasArchivoController;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVPlantillaOperacion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;


/**
 * Tests unitarios de la clase MSVProcesadoTareasArchivoController
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVProcesadoTareasArchivoControllerTest  extends SampleBaseTestCase{
	
	private static final Long TIPO_OPERACION = 1L;
	
	//Definimos la clase sobre la que vamos a realizar los tests mediante la anotaci�n @InjectMocks
	@InjectMocks MSVProcesadoTareasArchivoController msvProcesadoTareasArchivoController;
	
	//Definimos los objetos Mock que vamos a utilizar.
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private ExcelManager mockExcelManager;
	@Mock private ExcelFileBean mockExcelFileBean;
	@Mock private MSVDiccionarioManager mockDiccionario;
	@Mock private MSVProcesoManager mockProcesoManager;
	@Mock MSVProcesoMasivo mockMSVProcesoMasivo;
	

    /**
     * Comprobamos que existe el m�todo abrirPantalla()
     */
    @Test    
    public void testAbrirPantalla(){
    	
    	ModelMap model = new ModelMap();
    	
    	List<MSVDDOperacionMasiva> listaTiposOperacion=new ArrayList<MSVDDOperacionMasiva>();
    	
    	//llamada al diccionario de tipos de operaci�n
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockDiccionario);
    	when(mockDiccionario.dameListaOperacionesDeUsuario()).thenReturn(listaTiposOperacion);
    	
    	//Llamada al listado de plantillas
    	List<MSVPlantillaOperacion> plantillas =new ArrayList<MSVPlantillaOperacion>();
    	when(mockDiccionario.dameListaPlantillasUsuario()).thenReturn(plantillas);
    	
    	String result = msvProcesadoTareasArchivoController.abrirPantalla(model);
    	
    	assertEquals(listaTiposOperacion, model.get("tiposOperacion"));
    	assertEquals(null, model.get("plantillas"));
    	assertEquals(result, MSVProcesadoTareasArchivoController.JSP_ABRIR_PANTALLA);
    	
    }
    

    
    /**
     * Utilizamos las clases Mock para simular la capa de negocio.
     * @throws Exception 
     */
    @Test 
    public void testDescargarFinal() throws Exception{
    	
    	ModelMap model = new ModelMap();
    	
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.generaExcelVaciaPorTipoOperacion(TIPO_OPERACION)).thenReturn(mockExcelFileBean);
    	
    	String result = msvProcesadoTareasArchivoController.descargarExcel(TIPO_OPERACION, model);
    	assertEquals(result, MSVProcesadoTareasArchivoController.JSP_DOWNLOAD_FILE);
    	
    }
    
    /**
     * Comprobamos que el ModelMap contiene el objeto FileItem
     * @throws Exception 
     */
    @Test
    public void testDescargarFinal2() throws Exception{
    	
    	ModelMap model = new ModelMap();
    	ExcelFileBean excelFileBean = new ExcelFileBean();
    	FileItem fileItem = new FileItem();
    	excelFileBean.setFileItem(fileItem);
    	
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.generaExcelVaciaPorTipoOperacion(TIPO_OPERACION)).thenReturn(excelFileBean);
    	
    	msvProcesadoTareasArchivoController.descargarExcel(TIPO_OPERACION, model);
    	assertEquals(model.get("fileItem") , fileItem);
    	
    }
    
    /**
     * Test que devuleve una excepci�n.
     * @throws Exception 
     */
	@Test//(expected = NullPointerException.class)    
    public void testDescargarFinal3() throws Exception{
    	
    	ModelMap model = new ModelMap();
    	ExcelFileBean excelFileBean = new ExcelFileBean();
    	FileItem fileItem = new FileItem();
    	excelFileBean.setFileItem(fileItem);
    	
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.generaExcelVaciaPorTipoOperacion(any(Long.class))).thenReturn(excelFileBean);
    	
    	msvProcesadoTareasArchivoController.descargarExcel(null, model);
    	assertEquals(model.get("fileItem") , fileItem);
    	
    }
	
    /**
     * Test del m�todo initProcess()
     * @throws Exception 
     */
	@Test
    public void testInitProcess() throws Exception{
    
    	  Long idTipoOperacion =  1l;
    	  Long idProceso = new Long(0);
    	  Long idEstadoProceso = new Long(0);
    	  String nombreFichero="";
          String descripcion = new String("Cargando");
    	  String codigoEstadoProceso = new String();
    	  
    	  ModelMap model= new ModelMap();
    	  MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
    	  
    	  dto.setIdTipoOperacion(idTipoOperacion);
    	  dto.setIdProceso(idProceso);
    	  dto.setIdEstadoProceso(idEstadoProceso);
    	  dto.setDescripcion(descripcion);
    	  dto.setCodigoEstadoProceso(codigoEstadoProceso);
    
    	  when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
    	  when(mockProcesoManager.iniciarProcesoMasivo(dto)).thenReturn(idProceso);
    	  
    	 /* comprobamos que  devuelve null*/
    	 String result = msvProcesadoTareasArchivoController.initProcess(idTipoOperacion,nombreFichero, model);
    	 
    	 assertEquals(result, MSVProcesadoTareasArchivoController.JSON_ID_PROCESO);
    	 assertEquals(model.get("idProceso") ,idProceso);
    	 assertEquals(model.get("idTipoOperacion") ,idTipoOperacion);
    	   	  
    }
    
    //import es.capgemini.devon.files.WebFileItem;

 
    /**
     * Test del m�todo descargarFicheroErrores
     * @throws Exception 
     */
    @Test
    public void testDescargaFicheroErrores() throws Exception {
    	
    	String resultado = new String();
    	ModelMap model = new ModelMap();
    	Long idFichero=1L;
    	FileItem item=new FileItem();
    	ExcelFileBean file=new ExcelFileBean();
    	file.setFileItem(item);
    	
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.descargarErrores(idFichero)).thenReturn(file);
    	
    	resultado = msvProcesadoTareasArchivoController.descargarFicheroErrores(idFichero, model);
    	
    	assertEquals(resultado, MSVProcesadoTareasArchivoController.JSP_DOWNLOAD_FILE);

    }
    
    /**
     * Comprobamos que se lanza la excepci�n IllegalArgumentException cuando
     * en el m�todo eliminarArhivo recibe como par�metro idProceso = null
     * @throws Exception 
     */
    @Test(expected=IllegalArgumentException.class)
    public void testEliminarArchivo() throws Exception {
    	
    	ModelMap model = new ModelMap();
    	
  	    msvProcesadoTareasArchivoController.eliminarArchivo(null, model);	
  	  
    }
    
    /**
     * Test del m�todo eliminarArchivo
     * comprobamos que introduciendo un idProceso que devuelve el JSON_GRID_ACTUALIZADO
     * @throws Exception 
     */
    @Test
    public void testEliminarArchivo2() throws Exception {
    	
    	Long idProceso = new Long(123);
    	ModelMap model = new ModelMap();
    	
 	    when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
  	    when(mockProcesoManager.eliminarProceso(idProceso)).thenReturn("ok");
  	    
  	  String resultado = msvProcesadoTareasArchivoController.eliminarArchivo(idProceso, model);	
  	  assertEquals(resultado, MSVProcesadoTareasArchivoController.JSON_GRID_ACTUALIZADO);
    	
    }
    
    /**
     * Test del m�todo mostrarProcesados. Comprobamos que  devuelve null
     * 
     * @throws Exception 
     */
    @Test(expected=IllegalArgumentException.class)
    public void testMostrarArchivosProcesados() throws Exception {
    	
    	String resultado = msvProcesadoTareasArchivoController.mostrarProcesos(null, null, null);	
        assertNull(resultado);
    }
    
    /**
     * Test del m�todo mostrarProcesados
     * 
     * @throws Exception 
     */
    @Test
    public void testMostrarArchivosProcesados2() throws Exception {
    	
    	ModelMap model = new ModelMap();
    	WebRequest wer = mock(WebRequest.class);
    	MSVDtoFiltroProcesos dto = new MSVDtoFiltroProcesos();   	
    	Page page = new Page() {
			
			@Override
			public int getTotalCount() {
				return 0;
			}
			
			@Override
			public List<?> getResults() {
				return null;
			}
		};
        when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
   	    
		when(mockProcesoManager.mostrarProcesosPaginated(dto)).thenReturn(page);

    	
		String resultado = msvProcesadoTareasArchivoController.mostrarProcesos(dto, model, wer);	
    	assertEquals(page, model.get("data"));
    	assertEquals(resultado, MSVProcesadoTareasArchivoController.JSON_DATOS_PROCESOS_PAGINATED);
    }
    	
    /**
     * Test del m�todo mostrarProcesos, centr�ndose en el filtrado.
     * 
     * @throws Exception 
     */
    @Test
    public void testMostrarProcesosCreaFiltros() throws Exception {
    	ModelMap model = new ModelMap();
    	WebRequest mockWebRequest = mock(WebRequest.class);
    	Map<String,String[]> enu = new HashMap<String, String[]>();
    	this.llenaMapa(enu);
    	MSVDtoFiltroProcesos dto = new MSVDtoFiltroProcesos();   	

    	ArgumentCaptor<MSVDtoFiltroProcesos> argument = ArgumentCaptor.forClass(MSVDtoFiltroProcesos.class);
    	
        when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
   	    when(mockProcesoManager.mostrarProcesosPaginated(argument.capture())).thenReturn(null);
   	    when(mockWebRequest.getParameterMap()).thenReturn(enu);
    	
		String resultado = msvProcesadoTareasArchivoController.mostrarProcesos(dto, model, mockWebRequest);
		
    	assertEquals(resultado, MSVProcesadoTareasArchivoController.JSON_DATOS_PROCESOS_PAGINATED);
    	assertEquals(argument.getValue().getFiltros().size(), 2);
    	assertEquals(argument.getValue().getFiltros().get(0).getValoresFiltrado().size(), 2);
    	assertEquals(argument.getValue().getFiltros().get(1).getValoresFiltrado().size(), 1);
    }
    
    private void llenaMapa(Map<String, String[]> enu) {
		enu.put("filter[0][field]", new String[]{RandomStringUtils.random(15)});
		enu.put("filter[0][data][type]", new String[]{RandomStringUtils.random(15)});
		enu.put("filter[0][data][comparison]", null);
		enu.put("filter[0][data][value]", new String[]{RandomStringUtils.random(15),RandomStringUtils.random(15)});
		
		enu.put("filter[1][field]", new String[]{RandomStringUtils.random(15)});
		enu.put("filter[1][data][type]", new String[]{RandomStringUtils.random(15)});
		enu.put("filter[1][data][comparison]", new String[]{RandomStringUtils.random(15)});
		enu.put("filter[1][data][value]", new String[]{RandomStringUtils.random(15)});
		
	}



	/**
     * Utilizamos las clases Mock para simular la capa de negocio.
     * @throws Exception 
     */
    @Test 
    public void testLiberarFichero() throws Exception{
    	
    	//Inicializaci�n.
    	ModelMap model = new ModelMap();
    	Long idProceso = 1L;
    	MSVProcesoMasivo msvProcesoMasivo = new MSVProcesoMasivo();
    	MSVDDEstadoProceso estadoProceso = new MSVDDEstadoProceso();
    	estadoProceso.setId(1L);
    	estadoProceso.setDescripcion("Estado Prueba");
    	estadoProceso.setCodigo(MSVDDEstadoProceso.CODIGO_VALIDADO);
    	
    	msvProcesoMasivo.setId(idProceso);
		msvProcesoMasivo.setEstadoProceso(estadoProceso);
    	
		//Comportamiento
    	when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
    	when(mockProcesoManager.liberarFichero(any(Long.class))).thenReturn(msvProcesoMasivo);
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.validarArchivo(idProceso)).thenReturn(true);
    	when(mockProcesoManager.modificarProcesoMasivo(any(MSVDtoAltaProceso.class))).thenReturn(msvProcesoMasivo);
    	
		String result = msvProcesadoTareasArchivoController.liberarFichero(idProceso, model);
		
		//Validaciones.
    	assertEquals(result, MSVProcesadoTareasArchivoController.JSON_CAMBIO_ESTADO);
    	
    	ArgumentCaptor<Long> argument = ArgumentCaptor.forClass(Long.class);
    	verify(mockProcesoManager).liberarFichero(argument.capture());
    	assertEquals(idProceso, argument.getValue());
    }
    
    @Test
    public void testValidarFichero() throws Exception{
    	ModelMap map=new ModelMap();
    	Long idProceso=1L;
    	MSVDtoAltaProceso dto=new MSVDtoAltaProceso();
    	MSVProcesoMasivo proceso=new MSVProcesoMasivo();
    	
    	when(mockProxyFactory.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
    	when(mockExcelManager.validarArchivo(idProceso)).thenReturn(true);
    	when(mockProxyFactory.proxy(MSVProcesoApi.class)).thenReturn(mockProcesoManager);
    	when(mockProcesoManager.modificarProcesoMasivo(dto)).thenReturn(proceso);
    	
    	String resultado=msvProcesadoTareasArchivoController.validarFichero(idProceso, map);
    	
    	assertNotNull(resultado, MSVProcesadoTareasArchivoController.JSON_CAMBIO_ESTADO);
    }
    

}
