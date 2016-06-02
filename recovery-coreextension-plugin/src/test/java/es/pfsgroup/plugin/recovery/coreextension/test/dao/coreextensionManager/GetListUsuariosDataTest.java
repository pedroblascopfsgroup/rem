package es.pfsgroup.plugin.recovery.coreextension.test.dao.coreextensionManager;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;

/**
 * Tests del método {@link es.pfsgroup.plugin.recovery.coreextension.dao.coreextensionManager#getListUsuariosData(long)}
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListUsuariosDataTest extends AbstractCoreextensionManagerTest {

	@Mock
	EXTGestoresDao mockGestoresDao;
	
	@Override
	public void childBefore() {

	}

	@Override
	public void childAfter() {
		
	}
	
	/**
	 * Test general.
	 */
	@Test
	public void testGetListTipoGestorAdicional(){

		List<Usuario> listado = new ArrayList<Usuario>();
		Long idTipoDespacho = RandomUtils.nextLong();
		
		when(mockGestoresDao.getGestoresByDespacho(idTipoDespacho)).thenReturn(listado);
		
		List<Usuario> result = coreextensionManager.getListUsuariosData(idTipoDespacho);
		
		assertNotNull(result);
		assertEquals(result, listado);
		
	}
	
	/**
	 * Test de ordenación.
	 */
	@Test
	public void testOrdenacion(){

		List<Usuario> listado = this.initListado();
		List<Usuario> listadoInicial = new ArrayList<Usuario>(listado);
		listadoInicial.addAll(listado);
		
		Long idTipoDespacho = RandomUtils.nextLong();
		
		when(mockGestoresDao.getGestoresByDespacho(eq(idTipoDespacho),any(Boolean.class))).thenReturn(listado);
		
		List<Usuario> result = coreextensionManager.getListUsuariosData(idTipoDespacho);
		
		assertNotNull(result);
		assertEquals(result.get(0), listadoInicial.get(2));
		assertEquals(result.get(1), listadoInicial.get(1));
		assertEquals(result.get(2), listadoInicial.get(0));
		
	}

	private List<Usuario> initListado() {
		List<Usuario> listado = new ArrayList<Usuario>();
		Usuario usuario1 = new Usuario();
		Usuario usuario2 = new Usuario();
		Usuario usuario3 = new Usuario();
		usuario1.setNombre("Juan");
		usuario1.setApellido1("Lopez");
		usuario2.setNombre("Luis");
		usuario2.setApellido1("López");
		usuario3.setNombre("Ana");
		usuario3.setApellido1("Sanz");

		listado.add(usuario3);
		listado.add(usuario2);
		listado.add(usuario1);
		return listado;
	}

}
