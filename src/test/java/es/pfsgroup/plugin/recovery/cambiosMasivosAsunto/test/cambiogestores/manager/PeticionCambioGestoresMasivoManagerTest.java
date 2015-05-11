package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.manager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.mockito.Mockito.*;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.CambioMasivoGestoresAsuntoApi;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.manager.CambioMasivoGestoresAsuntoManagerImpl;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases.PeticionCambioMasivoGestoresTestCaseFactory;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases.PeticionCambioMasivoTestCase;
import es.pfsgroup.testfwk.DInjector;

/**
 * Prueba la petición de cambio de gestor masiva en la parte del manager
 * 
 * @author bruno
 * 
 */
public class PeticionCambioGestoresMasivoManagerTest {

	private PeticionCambioMasivoGestoresTestCaseFactory testCaseFactory;

	private CambioMasivoGestoresAsuntoApi manager;

	private CambioMasivoGestoresAsuntoDao dao;

	@Before
	public void setUp() {
		testCaseFactory = new PeticionCambioMasivoGestoresTestCaseFactory();
		manager = new CambioMasivoGestoresAsuntoManagerImpl();
		dao = mock(CambioMasivoGestoresAsuntoDao.class);
		DInjector di = new DInjector(manager);
		di.inject("dao", dao);
	}

	@After
	public void tearDown() {
		testCaseFactory = null;
		manager = null;
		dao = null;
	}

	/**
	 * Prueba básica del cambio masivo de gestores
	 */
	@Test
	public void testCambioGestoresMasivoDefaultTest() {
		PeticionCambioMasivoTestCase testCase = testCaseFactory.peticionCambioMasivo(null);
		PeticionCambioMasivoGestoresDto dto = testCase.getManagerDto();

		manager.anotarCambiosPendientes(dto);

		verify(dao, times(1)).insertDirectoPeticiones(dto.getSolicitante(), dto.getTipoGestor(), dto.getIdGestorOriginal(), dto.getIdNuevoGestor(), dto.getFechaInicio(), dto.getFechaFin());
	}
}
