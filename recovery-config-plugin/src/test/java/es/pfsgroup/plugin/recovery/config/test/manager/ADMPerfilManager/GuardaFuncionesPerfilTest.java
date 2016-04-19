package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoMoreInteractions;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class GuardaFuncionesPerfilTest extends AbstractADMPerfilManagerTest {

	@Test
	public void testGuardaFunciones() throws Exception {
		final Long ID_PERFIL = 3L;
		final Collection<Long> FUNCIONES = Arrays.asList(1L, 3L, 5L, 99L);
		String PasswordTest="PASSWORD_TEST";

		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				ID_PERFIL));
		Collection<Funcion> fs = TestData.newTestCollectionByFieldCriteria(
				Funcion.class, "id", FUNCIONES);
		FuncionPerfil mockFuncionPerfil = mock(FuncionPerfil.class);

		when(funcionPerfilDao.createNewObject()).thenReturn(mockFuncionPerfil);
		for (Funcion f : fs) {
			when(funcionDao.get(f.getId())).thenReturn(f);
		}
		when(perfilDao.get(ID_PERFIL)).thenReturn(p);

		Usuario usuario = getUsuario(PasswordTest);
		
		when(mockPasswordApi.isPwCorrect(usuario, PasswordTest)).thenReturn(Boolean.TRUE);
		
		manager.guardaFuncionesPerfil(ID_PERFIL, FUNCIONES, PasswordTest);

		verify(mockFuncionPerfil,times(fs.size())).setPerfil(p);
		for (Funcion f : fs) {
			verify(mockFuncionPerfil).setFuncion(f);
		}
		verify(funcionPerfilDao,times(fs.size())).save(mockFuncionPerfil);
		verify(funcionPerfilDao,times(fs.size())).createNewObject();
	}

	private Usuario getUsuario(String pass) {
		UsuarioApi usuarioApi = mock(UsuarioApi.class);
		when(proxyFactory.proxy(UsuarioApi.class)).thenReturn(usuarioApi);
		
		Usuario usuario = mock(Usuario.class);
		when(usuarioApi.getUsuarioLogado()).thenReturn(usuario);
		
		when(usuario.getPassword()).thenReturn(pass);
		return usuario;
	}

	@Test
	public void testGuardaFunciones_funcionNoExiste_Excepcion() throws Exception {
		final Long ID_PERFIL = 3L;
		final List<Long> FUNCIONES = Arrays.asList(1L);
		String PasswordTest="PASSWORD_TEST";

		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				ID_PERFIL));
		FuncionPerfil mockFuncionPerfil = mock(FuncionPerfil.class);

		when(funcionPerfilDao.createNewObject()).thenReturn(mockFuncionPerfil);
		when(funcionDao.get(FUNCIONES.get(0))).thenReturn(null);

		when(perfilDao.get(ID_PERFIL)).thenReturn(p);

		try {
			Usuario usuario = getUsuario(PasswordTest);
			when(mockPasswordApi.isPwCorrect(usuario, PasswordTest)).thenReturn(Boolean.TRUE);
			manager.guardaFuncionesPerfil(ID_PERFIL, FUNCIONES, PasswordTest);
			fail("Se deberia haber lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}
		verify(perfilDao).get(ID_PERFIL);
		verify(funcionDao).get(FUNCIONES.get(0));
		verify(funcionPerfilDao).createNewObject();
		verifyZeroInteractions(perfilDao);
		verifyZeroInteractions(funcionDao);
		verifyZeroInteractions(funcionPerfilDao);

	}

	@Test
	public void testGuardar_FuncionesVaciasONull_noHacerNada() {
		final Collection<Long> FUNCIONES = new ArrayList<Long>();
		String PasswordTest="PASSWORD_TEST";
		
		Usuario usuario = getUsuario(PasswordTest);
		when(mockPasswordApi.isPwCorrect(usuario, PasswordTest)).thenReturn(Boolean.TRUE);
		manager.guardaFuncionesPerfil(1L, FUNCIONES, PasswordTest);
		manager.guardaFuncionesPerfil(1L, null, PasswordTest);

		verifyZeroInteractions(perfilDao);
		verifyZeroInteractions(funcionDao);
		verifyZeroInteractions(funcionPerfilDao);
	}

	@Test
	public void testPerfilNoExiste_lanzaExcepcion() {
		when(perfilDao.get(1L)).thenReturn(null);
		String PasswordTest="PASSWORD_TEST";
		try {
			Usuario usuario = getUsuario(PasswordTest);
			when(mockPasswordApi.isPwCorrect(usuario, PasswordTest)).thenReturn(Boolean.TRUE);
			manager.guardaFuncionesPerfil(1L, Arrays.asList(1l, 2L, 3L), PasswordTest);
			fail("Se deberia haber lanzado una excepci�n");
		} catch (BusinessOperationException e) {
		}
		verify(perfilDao).get(1L);
		verifyNoMoreInteractions(perfilDao);
		verifyZeroInteractions(funcionDao);
		verifyZeroInteractions(funcionPerfilDao);

	}

	@Test
	public void testIdPerfilNull_lanzaExcepcion() {
		when(perfilDao.get(1L)).thenReturn(null);
		String PasswordTest="PASSWORD_TEST";
		try {
			getUsuario(PasswordTest);
			manager.guardaFuncionesPerfil(null, Arrays.asList(1l, 2L, 3L), "");
			fail("Se deberia haber lanzado una excepci�n");
		} catch (IllegalArgumentException e) {
		}

		verifyZeroInteractions(perfilDao);
		verifyZeroInteractions(funcionDao);
		verifyZeroInteractions(funcionPerfilDao);

	}
}
