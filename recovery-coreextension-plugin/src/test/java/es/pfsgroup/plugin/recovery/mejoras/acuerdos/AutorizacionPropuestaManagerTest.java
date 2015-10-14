package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager.PropuestaManager;

@RunWith(MockitoJUnitRunner.class)
public class AutorizacionPropuestaManagerTest {

	@Mock
	private UtilDiccionarioApi mockUtilDiccionarioApi;

	@Mock
	private AcuerdoDao acuerdoDao;

	@Mock
	private ExpedienteDao expedienteDao;

	@Mock
	private UsuarioManager usuarioManager;

	@InjectMocks
	private PropuestaManager propuestaManager;

	/**
	 * Generic Id used to test
	 */
	private static final Long ID_EXPEDIENTE = RandomUtils.nextLong();
	private static final Long ID_USUARIO = RandomUtils.nextLong();

	/**
	 * El usuario logado tiene el mismo perfil que el gestor actual del estado del itinerario
	 */
	@Test
	public void testElUsuarioLogadoEsGestorActual() {
		// Mock methods
		Perfil perfil = new Perfil();
		perfil.setId(RandomUtils.nextLong());

		DDEstadoItinerario estadoItinerario = new DDEstadoItinerario();
		estadoItinerario.setCodigo("CODIGO_ESTADO");

		Estado estado = new Estado();
		// se setea solo el perfil para gestor
		estado.setGestorPerfil(perfil);
		estado.setEstadoItinerario(estadoItinerario);

		List<Estado> estados = new ArrayList<Estado>();
		estados.add(estado);

		Itinerario itinerario = new Itinerario();
		itinerario.setEstados(estados);

		Arquetipo arquetipo = new Arquetipo();
		arquetipo.setItinerario(itinerario);

		Expediente expediente = new Expediente();
		expediente.setArquetipo(arquetipo);
		expediente.setEstadoItinerario(estadoItinerario);

		when(expedienteDao.get(ID_EXPEDIENTE)).thenReturn(expediente);

		// Mock usuario logado
		mockUsuarioLogadoWithPerfil(perfil);

		// Method to test
		Boolean esGestor = propuestaManager.usuarioLogadoEsGestorSupervisorActual(ID_EXPEDIENTE);

		assertEquals(true, esGestor);		
	}

	/**
	 * El usuario logado tiene el mismo perfil que el supervisor actual del estado del itinerario
	 */
	@Test
	public void testElUsuarioLogadoEsSupervisorActual() {
		// Mock methods
		DDEstadoItinerario estadoItinerario = new DDEstadoItinerario();
		estadoItinerario.setCodigo("CODIGO_ESTADO");

		Perfil perfil = new Perfil();
		perfil.setId(RandomUtils.nextLong());

		Estado estado = new Estado();
		// se setea solo el perfil para supervisor
		estado.setSupervisor(perfil);
		estado.setEstadoItinerario(estadoItinerario);

		List<Estado> estados = new ArrayList<Estado>();
		estados.add(estado);

		Itinerario itinerario = new Itinerario();
		itinerario.setEstados(estados);

		Arquetipo arquetipo = new Arquetipo();
		arquetipo.setItinerario(itinerario);

		Expediente expediente = new Expediente();
		expediente.setArquetipo(arquetipo);
		expediente.setEstadoItinerario(estadoItinerario);

		when(expedienteDao.get(ID_EXPEDIENTE)).thenReturn(expediente);

		// Mock usuario logado
		mockUsuarioLogadoWithPerfil(perfil);

		// Method to test
		Boolean esSupervisor = propuestaManager.usuarioLogadoEsGestorSupervisorActual(ID_EXPEDIENTE);

		assertEquals(true, esSupervisor);		
	}

	/**
	 * El usuario logado NO tiene el mismo perfil que el supervisor actual del estado del itinerario
	 */
	@Test
	public void testElUsuarioLogadoNoEsSupervisorActual() {
		// Mock methods
		DDEstadoItinerario estadoItinerario = new DDEstadoItinerario();
		estadoItinerario.setCodigo("CODIGO_ESTADO");

		Perfil perfil = new Perfil();
		perfil.setId(RandomUtils.nextLong());

		Estado estado = new Estado();
		// se setea solo el perfil para supervisor
		estado.setSupervisor(perfil);
		estado.setEstadoItinerario(estadoItinerario);

		List<Estado> estados = new ArrayList<Estado>();
		estados.add(estado);

		Itinerario itinerario = new Itinerario();
		itinerario.setEstados(estados);

		Arquetipo arquetipo = new Arquetipo();
		arquetipo.setItinerario(itinerario);

		Expediente expediente = new Expediente();
		expediente.setArquetipo(arquetipo);
		expediente.setEstadoItinerario(estadoItinerario);

		when(expedienteDao.get(ID_EXPEDIENTE)).thenReturn(expediente);

		// Mock usuario logado - un perfil diferente al que se encuentra en el estado del itinerario
		Perfil perfil2 = new Perfil();
		perfil2.setId(RandomUtils.nextLong());
		mockUsuarioLogadoWithPerfil(perfil2);

		// Method to test
		Boolean esSupervisor = propuestaManager.usuarioLogadoEsGestorSupervisorActual(ID_EXPEDIENTE);

		assertEquals(false, esSupervisor);		
	}

	/**
	 * Helper method mock userlogado with perfil
	 * @param perfil
	 */
	private void mockUsuarioLogadoWithPerfil(Perfil perfil) {
		ZonaUsuarioPerfil zonaUsuarioPerfil = new ZonaUsuarioPerfil();
		zonaUsuarioPerfil.setPerfil(perfil);

		List<ZonaUsuarioPerfil> zonaUsuarioPerfiles = new ArrayList<ZonaUsuarioPerfil>();
		zonaUsuarioPerfiles.add(zonaUsuarioPerfil);

		Usuario usuarioLogado = new Usuario();
		usuarioLogado.setId(ID_USUARIO);
		usuarioLogado.setZonaPerfil(zonaUsuarioPerfiles);
		when(usuarioManager.getUsuarioLogado()).thenReturn(usuarioLogado);
	}
}
