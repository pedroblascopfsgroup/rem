package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import org.junit.Test;

import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class BorrarPerfilTest extends AbstractADMPerfilManagerTest {

	@Test
	public void testBorrarPerfil() {
		manager.borrarPerfil(1L);
		verify(perfilDao, times(1)).deleteById(1L);
	}

	@Test
	public void testIDNull_excepcion() {
		TestTemplate template = new NullArgumentsTest(manager, "borrarPerfil", Long.class);
		template.run();
	}
}
