package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import java.util.ArrayList;
import java.util.List;

import junit.framework.Assert;

import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;

public class QuitarGestorDespachoTest extends AbstractADMUsuarioManagerTest {

	@Test
	public void testQuitarGestorDespacho() throws Exception {
		Entidad entidad = creaEntidadPruebas(1L);
		obtenUsuarioLogadoDeExecutor(entidad);
		List<GestorDespacho> listGestDesp = new ArrayList<GestorDespacho>();
		GestorDespacho mockGestor = Mockito.mock(GestorDespacho.class);
		listGestDesp.add(mockGestor);
		Usuario mockusu = Mockito.mock(Usuario.class);
		DespachoExterno mockDespacho = Mockito.mock(DespachoExterno.class);

		Mockito.when(gestorDespachoDao.getList()).thenReturn(listGestDesp);
		for (GestorDespacho gd : listGestDesp) {
			Mockito.when(gd.getUsuario()).thenReturn(mockusu);
			Mockito.when(mockusu.getId()).thenReturn(1L);
			Mockito.when(mockusu.getEntidad()).thenReturn(entidad);
			Mockito.when(gd.getDespachoExterno()).thenReturn(mockDespacho);
			Mockito.when(mockDespacho.getId()).thenReturn(1L);
			Mockito.when(gd.getId()).thenReturn(1L);
		}
		admUsuarioManager.quitarGestorDespacho(1L, 1L);

		Mockito.verify(gestorDespachoDao, Mockito.times(1)).deleteById(1L);
	}

	@Test
	public void testSiIdUsuarioNulo() throws Exception {
		Entidad entidad = creaEntidadPruebas(1L);
		obtenUsuarioLogadoDeExecutor(entidad);
		List<GestorDespacho> listGestDesp = new ArrayList<GestorDespacho>();
		GestorDespacho mockGestor = Mockito.mock(GestorDespacho.class);
		listGestDesp.add(mockGestor);
		Usuario mockusu = Mockito.mock(Usuario.class);
		DespachoExterno mockDespacho = Mockito.mock(DespachoExterno.class);

		Mockito.when(gestorDespachoDao.getList()).thenReturn(listGestDesp);
		for (GestorDespacho gd : listGestDesp) {
			Mockito.when(gd.getUsuario()).thenReturn(mockusu);
			Mockito.when(mockusu.getId()).thenReturn(1L);
			Mockito.when(mockusu.getEntidad()).thenReturn(entidad);
			Mockito.when(gd.getDespachoExterno()).thenReturn(mockDespacho);
			Mockito.when(mockDespacho.getId()).thenReturn(1L);
			Mockito.when(gd.getId()).thenReturn(1L);
		}
		admUsuarioManager.quitarGestorDespacho(null, 1L);

		Mockito.verify(gestorDespachoDao, Mockito.never()).deleteById(1L);

	}

	@Test
	public void testSiIdDespachoNulo() throws Exception {
		Entidad entidad = creaEntidadPruebas(1L);
		obtenUsuarioLogadoDeExecutor(entidad);
		List<GestorDespacho> listGestDesp = new ArrayList<GestorDespacho>();
		GestorDespacho mockGestor = Mockito.mock(GestorDespacho.class);
		listGestDesp.add(mockGestor);
		Usuario mockusu = Mockito.mock(Usuario.class);
		DespachoExterno mockDespacho = Mockito.mock(DespachoExterno.class);

		Mockito.when(gestorDespachoDao.getList()).thenReturn(listGestDesp);
		for (GestorDespacho gd : listGestDesp) {
			Mockito.when(gd.getUsuario()).thenReturn(mockusu);
			Mockito.when(mockusu.getId()).thenReturn(1L);
			Mockito.when(mockusu.getEntidad()).thenReturn(entidad);
			Mockito.when(gd.getDespachoExterno()).thenReturn(mockDespacho);
			Mockito.when(mockDespacho.getId()).thenReturn(1L);
			Mockito.when(gd.getId()).thenReturn(1L);
		}
		admUsuarioManager.quitarGestorDespacho(1L, null);

		Mockito.verify(gestorDespachoDao, Mockito.never()).deleteById(1L);

	}

	@Test
	public void testSiNoLoEncuentra() throws Exception {
		Entidad entidad = creaEntidadPruebas(1L);
		obtenUsuarioLogadoDeExecutor(entidad);
		List<GestorDespacho> listGestDesp = new ArrayList<GestorDespacho>();
		GestorDespacho mockGestor = Mockito.mock(GestorDespacho.class);
		listGestDesp.add(mockGestor);
		Usuario mockusu = Mockito.mock(Usuario.class);
		DespachoExterno mockDespacho = Mockito.mock(DespachoExterno.class);

		Mockito.when(gestorDespachoDao.getList()).thenReturn(listGestDesp);
		for (GestorDespacho gd : listGestDesp) {
			Mockito.when(gd.getUsuario()).thenReturn(mockusu);
			Mockito.when(mockusu.getId()).thenReturn(1L);
			Mockito.when(mockusu.getEntidad()).thenReturn(entidad);
			Mockito.when(gd.getDespachoExterno()).thenReturn(mockDespacho);
			Mockito.when(mockDespacho.getId()).thenReturn(1L);
			Mockito.when(gd.getId()).thenReturn(1L);
		}
		admUsuarioManager.quitarGestorDespacho(1L, 5L);

		Mockito.verify(gestorDespachoDao, Mockito.never()).deleteById(1L);
	}

	@Test
	public void testOtraEntidad() throws Exception {
		Entidad entidadInvalida = creaEntidadPruebas(100L);
		obtenUsuarioLogadoDeExecutor(creaEntidadPruebas(1L));
		List<GestorDespacho> listGestDesp = new ArrayList<GestorDespacho>();
		GestorDespacho mockGestor = Mockito.mock(GestorDespacho.class);
		listGestDesp.add(mockGestor);
		Usuario mockusu = Mockito.mock(Usuario.class);
		DespachoExterno mockDespacho = Mockito.mock(DespachoExterno.class);

		Mockito.when(gestorDespachoDao.getList()).thenReturn(listGestDesp);
		for (GestorDespacho gd : listGestDesp) {
			Mockito.when(gd.getUsuario()).thenReturn(mockusu);
			Mockito.when(mockusu.getId()).thenReturn(1L);
			Mockito.when(mockusu.getEntidad()).thenReturn(entidadInvalida);
			Mockito.when(gd.getDespachoExterno()).thenReturn(mockDespacho);
			Mockito.when(mockDespacho.getId()).thenReturn(1L);
			Mockito.when(gd.getId()).thenReturn(1L);
		}
		try {
			admUsuarioManager.quitarGestorDespacho(1L, 1L);
			Assert.fail("Se debería haber lanzado una excepción");
		} catch (BusinessOperationException e) {
		}

		Mockito.verify(gestorDespachoDao, Mockito.never()).deleteById(1L);
	}

}
