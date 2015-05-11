package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.controller;

import org.junit.After;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentMatcher;

import static org.mockito.Mockito.*;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoController;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases.PeticionCambioMasivoGestoresTestCaseFactory;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases.PeticionCambioMasivoTestCase;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.testfwk.DInjector;


/**
 * Test sobre las peticiones de cambios masivos desde el Controller
 * @author bruno
 *
 */
public class PeticionCambioMasivoGestoresTest {

	private PeticionCambioMasivoGestoresTestCaseFactory testCaseFactory;
	
	private CambioMasivoGestoresAsuntoController controller;
	
	private CambioMasivoGestoresAsuntoApi manager;
	
	private UsuarioApi usuarioManager;
	
	private ApiProxyFactory proxyFactory;
	
	@Before
	public void setUp(){
		controller = new CambioMasivoGestoresAsuntoController();
		testCaseFactory = new PeticionCambioMasivoGestoresTestCaseFactory();
		proxyFactory = mockeaApiFactory();
		DInjector di = new DInjector(controller);
		di.inject("proxyFactory", proxyFactory);
	}
	
	

	@After
	public void tearDown(){
		controller = null;
		testCaseFactory = null;
		manager = null;
		usuarioManager = null;
		proxyFactory = null;
	}
	
	/**
	 * Prueba básica de anotar una petición de cambio
	 */
	@Test
	public void anotarCambiosPendientesDefaultTest(){
		
		final PeticionCambioMasivoTestCase testCase = testCaseFactory.peticionCambioMasivo(usuarioManager);
		WebRequest request = testCase.mockeaWebRequest();
		
		String jspName = controller.anotarCambiosPendientes(testCase.getWebDto(),request);
		verify(manager,times(1)).anotarCambiosPendientes(argThat(new ArgumentMatcher<PeticionCambioMasivoGestoresDto>() {

			@Override
			public boolean matches(Object argument) {
				return isTheSameDto(testCase, argument);
			}
		}));
		
		assertEquals(CambioMasivoGestoresAsuntoController.DEFAULT, jspName);
	}
	
	
	/**
	 * Devuelve un Mock para la factoría de proxies configurado para que devuelva las apis necesarias
	 * @return
	 */
	private ApiProxyFactory mockeaApiFactory() {
		proxyFactory = mock(ApiProxyFactory.class);
		manager = mock(CambioMasivoGestoresAsuntoApi.class);
		usuarioManager = mock(UsuarioApi.class);
		when(proxyFactory.proxy(CambioMasivoGestoresAsuntoApi.class)).thenReturn(manager);
		when(proxyFactory.proxy(UsuarioApi.class)).thenReturn(usuarioManager);
		return proxyFactory;
	}
	
	/**
	 * Comprueba que un objeto es igual a un DTO de petición
	 * 
	 * @param dto DTO a comparar
	 * @param o Objeto a comparar
	 * @return
	 */
	private boolean isTheSameDto(PeticionCambioMasivoTestCase testCase, Object o) {
		if (o == null) return false;
		
		if (o instanceof PeticionCambioMasivoGestoresDto){
			PeticionCambioMasivoGestoresDto dto = testCase.getWebDto();
			PeticionCambioMasivoGestoresDtoImpl o1 = (PeticionCambioMasivoGestoresDtoImpl) o;
			assertEquals(testCase.webRequest().getFechaFin(), o1.getFechaFin());
			assertEquals(testCase.webRequest().getFechaInicio(), o1.getFechaInicio());
			assertEquals(dto.getIdGestorOriginal(), o1.getIdGestorOriginal());
			assertEquals(dto.getIdNuevoGestor(),o1.getIdNuevoGestor());
			assertNotNull(o1.getSolicitante());
			assertEquals(testCase.getUsuarioLogado(),o1.getSolicitante().getId());
			assertEquals(dto.isReasignado(),o1.isReasignado());
			assertEquals(dto.getTipoGestor(),o1.getTipoGestor());
			return true;
		}else{
			return false;
		}
	}
}
