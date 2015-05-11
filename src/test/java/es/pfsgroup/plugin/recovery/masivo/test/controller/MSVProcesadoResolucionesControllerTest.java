package es.pfsgroup.plugin.recovery.masivo.test.controller;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVAsuntoManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVDiccionarioManager;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVResolucionManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVAsuntoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVProcesadoResolucionesController;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDMotivoInadmision;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDRequerimientoPrevio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto.MSVTipoResolucionDto;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;


/**
 * Tests unitarios de la clase MSVProcesadoResolucionesController
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVProcesadoResolucionesControllerTest  extends SampleBaseTestCase{
	
	//Definimos la clase sobre la que vamos a realizar los tests mediante la anotaci�n @InjectMocks
	@InjectMocks MSVProcesadoResolucionesController msvProcesadoResolucionesController;
	
	//Definimos los objetos Mock que vamos a utilizar.
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private MSVDiccionarioManager mockDiccionario;
	@Mock private MSVResolucionManager mockMSVResolucionManager;
	@Mock private WebRequest mockRequest;
	@Mock private MSVAsuntoManager mockMSVAsuntoManager;
	@Mock private PlazaJuzgadoApi mockPlazaJuzgadoApi;
	@Mock private AsuntoApi mockAsuntoApi;
	@Mock private PersonaApi mockPersonaApi;
	
	Random r = new Random();
	

    /**
     * Comprobamos que existe el m�todo abrirPantalla()
     */
    @Test    
    public void testAbrirPantalla(){
    	
    	ModelMap model = new ModelMap();
    	
    	List<MSVDDTipoJuicio> tiposJuicio = new ArrayList<MSVDDTipoJuicio>();
    	List<MSVDDTipoResolucion> tiposResolucion = new ArrayList<MSVDDTipoResolucion>();
    	
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockDiccionario);
    	when(mockDiccionario.dameValoresDiccionario(MSVDDTipoJuicio.class)).thenReturn(tiposJuicio);
    	when(mockDiccionario.dameValoresDiccionario(MSVDDTipoResolucion.class)).thenReturn(tiposResolucion);
    	
    	String result = msvProcesadoResolucionesController.abrirPantalla(model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSP_ABRIR_PANTALLA);
//    	assertNotNull(model.get("tiposJuicio"));
//    	assertNotNull(model.get("tiposResolucion"));
    	
    }
    
    /**
     * Comprobamos que existe el m�todo comprobarAsunto(model)
     */
    @Test
	public void testComprobarAsunto(){
		
    	ModelMap model = new ModelMap();
    	
    	String result = msvProcesadoResolucionesController.comprobarAsunto(model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_COMPROBAR_ASUNTO);
	}
	

	/**
     * Comprobamos que existe el m�todo mostarProcesos(model)
     */
    @Test
	public void testMostarProcesos(){
		
    	ModelMap model = new ModelMap();
    	
    	when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockMSVResolucionManager);
    	
    	String result = msvProcesadoResolucionesController.mostarProcesos(null,  model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_MOSTRAR_PROCESOS_RESOLUCION_PAGINATED);
	}
	

	/**
     * Comprobamos que existe el m�todo dibujarDatosDinamicos(model)
     */
    @Test
	public void testDibujarDatosDinamicos(){
		
    	ModelMap model = new ModelMap();
    	
    	String result = msvProcesadoResolucionesController.dibujarDatosDinamicos(model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_DIBUJRA_DATOS_DINAMICOS);
	}
	

	/**
     * Comprobamos el m�todo dameAyuda(Long idTipoResolucion, ModelMap model)
     */
    @Test
	public void testDameAyuda(){
		
    	ModelMap model = new ModelMap();
    	Long idTipoResolucion = r.nextLong();
    	String ayuda = String.valueOf(r.nextLong());

    	when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockMSVResolucionManager);
    	when(mockMSVResolucionManager.dameAyuda(idTipoResolucion)).thenReturn(ayuda);
    	
		String result = msvProcesadoResolucionesController.dameAyuda(idTipoResolucion, model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_AYUDA);
    	assertEquals(ayuda, model.get("html"));
	}
	
	/**
     * Comprobamos que existe el m�todo adjuntarFichero(model)
     */
    @Test
	public void testAdjuntarFichero(){
		
    	ModelMap model = new ModelMap();
    	
    	String result = msvProcesadoResolucionesController.adjuntarFichero(model);
    	
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_ADJUNTAR_FICHERO);
	}
	
	/**
     * Comprobamos que existe el m�todo grabarYProcesar(model)
     */
    @Test
	public void testGrabarYProcesar(){
		
    	ModelMap model = new ModelMap();
    	Map<String,String[]> mapa = new HashMap<String, String[]>();
    	mapa.put("asunto", new String[]{"Asunto 1"});
    	mapa.put("d_fecha", new String[]{"22/12/2012"});
    	MSVResolucionesDto dtoResolucion = new MSVResolucionesDto();
    	MSVResolucion msvResolucion = new MSVResolucion();
    	
    	when(mockRequest.getParameterMap()).thenReturn(mapa);
    	when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockMSVResolucionManager);
    	when(mockMSVResolucionManager.guardarDatos(any(MSVResolucionesDto.class))).thenReturn(msvResolucion);
    	
    	String result = msvProcesadoResolucionesController.grabarYProcesar(dtoResolucion, model, mockRequest);

    	ArgumentCaptor<MSVResolucionesDto> msvResolucionesDtoCaptor = ArgumentCaptor.forClass(MSVResolucionesDto.class);
    	verify(mockMSVResolucionManager, times(1)).guardarDatos(msvResolucionesDtoCaptor.capture());
    	
    	//Comprobamos que se devuelve el string a la p�gina correcta.
    	assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_GRABAR_PROCESAR);
    	
    	//comprobamos que se devuelve la resoluci�n correcta.
    	assertSame(msvResolucion,model.get("resolucion"));
    	
    	//Comprobamos que recuperamos los valores din�micos correctamente.
    	assertEquals(mapa.get("d_fecha")[0], msvResolucionesDtoCaptor.getValue().getCamposDinamicos().get("d_fecha"));
    	assertNull(msvResolucionesDtoCaptor.getValue().getCamposDinamicos().get("asunto"));
	}
    
	/**
     * Comprobamos el m�todo cargaResolucion(Long idResolucion, ModelMap model)
     */
    @Test
	public void testCargaResolucion(){
    	
    	ModelMap model = new ModelMap();
    	Long idResolucion = r.nextLong();
    	MSVResolucion msvResolucion = new MSVResolucion();
    	try {   	
	    	when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockMSVResolucionManager);
			when(mockMSVResolucionManager.getResolucion(any(Long.class))).thenReturn(msvResolucion);
	    	
	    	String result = msvProcesadoResolucionesController.cargaResolucion(idResolucion, model);
	    	
	    	//Comprobamos que se devuelve el string a la p�gina correcta.    	
	    	assertNotNull(result);
	    	assertEquals(result, MSVProcesadoResolucionesController.JSON_GRABAR_PROCESAR);
	    	
	    	//comprobamos que se devuelve la resoluci�n correcta.
	    	assertSame(msvResolucion,model.get("resolucion"));  
		} catch (Exception e) {
			fail("Error en el m�todo testCargaResolucion.");
		}
    	
    }
    
	/**
     * Test del m�todo String procesarResolucion(Long idResolucion, ModelMap model) throws Exception
     */
    @Test
	public void testProcesarResolucion(){
    	
    	ModelMap model = new ModelMap();
    	Long idResolucion = r.nextLong();
    	MSVResolucion msvResolucion = new MSVResolucion();
    	try {   	
	    	when(mockProxyFactory.proxy(MSVResolucionApi.class)).thenReturn(mockMSVResolucionManager);
			when(mockMSVResolucionManager.procesaResolucion(any(Long.class))).thenReturn(msvResolucion);
	    	
	    	String result = msvProcesadoResolucionesController.procesarResolucion(idResolucion, model);
	    	
	    	//Comprobamos que se devuelve el string a la p�gina correcta.    	
	    	assertNotNull(result);
	    	assertEquals(result, MSVProcesadoResolucionesController.JSON_GRABAR_PROCESAR);
	    	
	    	//comprobamos que se devuelve la resoluci�n correcta.
	    	assertEquals(MSVResolucion.class ,model.get("resolucion").getClass());  
		} catch (Exception e) {
			fail("Error en el m�todo testProcesarResolucion.");
		}
    	
    }
    
    /**
     * Comprobamos el m�todo getAsuntosInstant(String query, ModelMap model)
     */
    @Test 
    public void testGetAsuntosInstant(){
    	
    	ModelMap model = new ModelMap();
    	String query = new String();
    	Collection listaAsuntos = new ArrayList();
    	
    	when(mockProxyFactory.proxy(MSVAsuntoApi.class)).thenReturn(mockMSVAsuntoManager);
		when(mockMSVAsuntoManager.getAsuntos(any(String.class))).thenReturn(listaAsuntos);
		
    	String result = msvProcesadoResolucionesController.getAsuntosInstant(query, model);
    	
		assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_LISTA_ASUNTOS);
    	
    	assertSame(listaAsuntos,model.get("data"));  
    	
    }
    
    @Ignore
    @Test
    public void testGetTiposDeResolucion() {
    	ModelMap model = new ModelMap();
    	Long idTarea = 1L;
    	Long idProcedimiento = 2L;
    	
    	MSVResolucionInputApi mockResolucionInputApi = mock(MSVResolucionInputApi.class);
    	
    	Set<MSVTipoResolucionDto> tiposResolucion = new HashSet<MSVTipoResolucionDto>();
    	List<MSVTipoResolucionDto> listaTiposResolucion = new ArrayList<MSVTipoResolucionDto>();
    	
		when(mockProxyFactory.proxy(MSVResolucionInputApi.class)).thenReturn(mockResolucionInputApi);
		when(mockResolucionInputApi.obtenerTiposResolucionesTareas(idTarea)).thenReturn(tiposResolucion);
		
    	String result = msvProcesadoResolucionesController.getTiposDeResolucion(idTarea, idProcedimiento, model);
    	
		assertNotNull(result);
    	assertEquals(result, MSVProcesadoResolucionesController.JSON_LISTA_TIPOS_RESOLUCION);
    	
    	assertEquals(listaTiposResolucion, (List<MSVTipoResolucionDto>)model.get("data"));
    }
    
    
    @Test
    public void testGetTiposRequerimiento(){
    	ModelMap model = new ModelMap();
    	List<MSVDDRequerimientoPrevio> lista=new ArrayList<MSVDDRequerimientoPrevio>();
    	
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockDiccionario);
    	when(mockDiccionario.dameValoresDiccionario(MSVDDRequerimientoPrevio.class)).thenReturn(lista);
    	
    	String result = msvProcesadoResolucionesController.getTiposRequerimiento(model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_LISTA_TIPOS_REQUERIMIENTO, result);
    
    	assertSame(lista, model.get("tiposRequerimiento"));
    }
    
    @Test
    public void testGetMotivosInadmision(){
    	ModelMap model = new ModelMap();
    	
    	List<MSVDDMotivoInadmision> lista=new ArrayList<MSVDDMotivoInadmision>();
    	
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockDiccionario);
    	when(mockDiccionario.dameValoresDiccionario(MSVDDMotivoInadmision.class)).thenReturn(lista);
    	
    	
    	String result = msvProcesadoResolucionesController.getMotivosInadmision(model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_LISTA_MOTIVOS_INADMISION, result);
    
    	assertSame(lista, model.get("motivosInadmision"));
    }
    
    @Test
    public void testGetPlazas(){
    	ModelMap model = new ModelMap();
    	List<TipoPlaza> lista=new ArrayList<TipoPlaza>();
    	
    	when(mockProxyFactory.proxy(MSVDiccionarioApi.class)).thenReturn(mockDiccionario);
    	when(mockDiccionario.dameValoresDiccionario(TipoPlaza.class)).thenReturn(lista);
    	
    	
    	String result = msvProcesadoResolucionesController.getPlazas(model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_LISTA_PLAZAS, result);
    
    	assertSame(lista, model.get("plazas"));
    	
    }
    
    @Test
    public void testGetJuzgadosByPlaza(){
    	ModelMap model = new ModelMap();
    	List<TipoJuzgado> lista=new ArrayList<TipoJuzgado>();
    	String codigoPlaza="AA";
    	
    	when(mockProxyFactory.proxy(PlazaJuzgadoApi.class)).thenReturn(mockPlazaJuzgadoApi);
    	when(mockPlazaJuzgadoApi.buscaJuzgadosPorPlaza(codigoPlaza)).thenReturn(lista);
    	
    	
    	String result = msvProcesadoResolucionesController.getJuzgadosByPlaza(codigoPlaza, model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_LISTA_JUZGADOSPLAZA, result);
    
    	assertSame(lista, model.get("juzgados"));
    }
    
    @Test
    public void testGetDemandadosAsunto(){
    	ModelMap model = new ModelMap();
    	Long idAsunto = 1L;
    	List<Persona> listaPersonas= new ArrayList<Persona>();
    	List<Procedimiento> listaProcedimientos = new ArrayList<Procedimiento>();
    	Procedimiento p=new Procedimiento();
    	Asunto asunto=new Asunto();
    	
    	p.setPersonasAfectadas(listaPersonas);
    	listaProcedimientos.add(p);
    	asunto.setId(idAsunto);
    	asunto.setProcedimientos(listaProcedimientos);
    	
    	when(mockProxyFactory.proxy(AsuntoApi.class)).thenReturn(mockAsuntoApi);
    	when(mockAsuntoApi.get(idAsunto)).thenReturn(asunto);
    	
    	String result=msvProcesadoResolucionesController.getDemandadosAsunto(idAsunto, model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_DEMANDADOSASUNTO, result);
    	
    	assertSame(listaPersonas, model.get("demandados"));
    	
    }
    
    @Test
    public void testGetDomiciliosDemandados(){
    	ModelMap model = new ModelMap();
    	
    	List<Direccion> listaDirecciones=new ArrayList<Direccion>();
    	Long idDemandado=1L;
    	
    	Persona p = new Persona();
    	p.setId(idDemandado);
    	p.setDirecciones(listaDirecciones);
    	
    	when(mockProxyFactory.proxy(PersonaApi.class)).thenReturn(mockPersonaApi);
    	when(mockPersonaApi.get(idDemandado)).thenReturn(p);
    	
    	String result=msvProcesadoResolucionesController.getDomiciliosDemandados(idDemandado, model);
    	
    	assertNotNull(result);
    	assertEquals(MSVProcesadoResolucionesController.JSON_DOMICILIOS_DEMANDADO, result);
    	
    	assertSame(listaDirecciones, model.get("domicilios"));
    }
}
