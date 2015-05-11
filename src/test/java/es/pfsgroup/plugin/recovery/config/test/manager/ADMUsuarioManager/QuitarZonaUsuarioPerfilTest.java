package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.never;
import static org.junit.Assert.*;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class QuitarZonaUsuarioPerfilTest extends AbstractADMUsuarioManagerTest {

	@Test
	public void testEliminarZonPefUsu() throws Exception {
		Entidad entidad = creaEntidadPruebas(100L);
		obtenUsuarioLogadoDeExecutor(entidad);
		Usuario usuario = creaUsuarioPruebas(1L, entidad);
		ZonaUsuarioPerfil zpu = TestData.newTestObject(ZonaUsuarioPerfil.class,
				new FieldCriteria("id", 1L), new FieldCriteria("usuario",
						usuario));
		usuario.getZonaPerfil().add(zpu);

		Mockito.when(zonaUsuarioPerfilDao.get(1L)).thenReturn(zpu);

		admUsuarioManager.quitarZonaUsuarioPerfil(1L);

		Mockito.verify(zonaUsuarioPerfilDao).deleteById(1L);
	}

	@Test
	public void testEliminarZonPefUsu_NoPuedeQuedarZonificacionVacia_excepcion()
			throws Exception {
		Entidad entidad = creaEntidadPruebas(100L);
		obtenUsuarioLogadoDeExecutor(entidad);
		Usuario usuario = creaUsuarioPruebas(1L, entidad);
		ZonaUsuarioPerfil zpu = TestData.newTestObject(ZonaUsuarioPerfil.class,
				new FieldCriteria("id", 1L), new FieldCriteria("usuario",
						usuario));
		usuario.getZonaPerfil().clear();
		usuario.getZonaPerfil().add(zpu);

		Mockito.when(zonaUsuarioPerfilDao.get(1L)).thenReturn(zpu);
		try {
			admUsuarioManager.quitarZonaUsuarioPerfil(1L);
			fail("Deberia haberse lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}

		Mockito.verify(zonaUsuarioPerfilDao, never()).deleteById(1L);
	}

	@Test
	public void testEliminarZonPefUsu_OtraEntidad_excepcion() throws Exception {
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		Entidad entidadInvalida = creaEntidadPruebas(100L);
		Usuario usuario = creaUsuarioPruebas(1L, entidadInvalida);
		ZonaUsuarioPerfil zpu = TestData.newTestObject(ZonaUsuarioPerfil.class,
				new FieldCriteria("id", 1L), new FieldCriteria("usuario",
						usuario));

		Mockito.when(zonaUsuarioPerfilDao.get(1L)).thenReturn(zpu);
		try {
			admUsuarioManager.quitarZonaUsuarioPerfil(1L);
			Assert.fail("Se debería haber lanzado una excepción");
		} catch (BusinessOperationException e) {
		}

		Mockito.verify(zonaUsuarioPerfilDao, never()).deleteById(1L);
	}

	@Test
	public void testIdNullDevuelveExcepcion() throws Exception {
		try {
			admUsuarioManager.quitarZonaUsuarioPerfil(null);
			Assert.fail("Se debería haber lanzado una excepción");
		} catch (IllegalArgumentException e) {

		}

		Mockito.verify(zonaUsuarioPerfilDao, never()).deleteById(anyLong());
	}

	@Test
	public void testIdNoExisteDevuelveExcepcion() throws Exception {
		Mockito.when(zonaUsuarioPerfilDao.get(1L)).thenReturn(null);
		try {
			admUsuarioManager.quitarZonaUsuarioPerfil(10L);
			Assert.fail("Se debería haber lanzado una excepción");
		} catch (BusinessOperationException e) {

		}

		Mockito.verify(zonaUsuarioPerfilDao, never()).deleteById(anyLong());
	}

}
