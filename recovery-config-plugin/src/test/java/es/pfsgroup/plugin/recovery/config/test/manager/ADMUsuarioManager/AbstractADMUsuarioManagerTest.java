package es.pfsgroup.plugin.recovery.config.test.manager.ADMUsuarioManager;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMGestorDespachoDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMPerfilDao;
import es.pfsgroup.plugin.recovery.config.usuarios.ADMUsuarioManager;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMZonaUsuarioPerfilDao;
import es.pfsgroup.plugin.recovery.config.zonas.dao.ADMZonaDao;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractADMUsuarioManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Gestores-Despachos_default.xml";
	protected ADMUsuarioDao usuarioDao = null;
	protected ADMUsuarioManager admUsuarioManager = null;
	protected ADMGestorDespachoDao gestorDespachoDao = null;
	protected ADMDespachoExternoDao despachoExternoDao = null;
	protected ADMPerfilDao perfilDao = null;
	protected ADMZonaDao zonaDao = null;
	protected ADMZonaUsuarioPerfilDao zonaUsuarioPerfilDao = null;

	protected Executor executor;

	public AbstractADMUsuarioManagerTest() {
		super();
	}

	@Before
	public void setup() {
		this.usuarioDao = Mockito.mock(ADMUsuarioDao.class);
		this.gestorDespachoDao = Mockito.mock(ADMGestorDespachoDao.class);
		this.despachoExternoDao = Mockito.mock(ADMDespachoExternoDao.class);
		this.perfilDao = Mockito.mock(ADMPerfilDao.class);
		this.zonaDao = Mockito.mock(ADMZonaDao.class);
		this.zonaUsuarioPerfilDao = Mockito.mock(ADMZonaUsuarioPerfilDao.class);
		this.executor = mock(Executor.class);

		this.admUsuarioManager = new ADMUsuarioManager(usuarioDao,
				gestorDespachoDao, despachoExternoDao, perfilDao, zonaDao,
				zonaUsuarioPerfilDao, executor);
	}

	@After
	public void teardown() {
		this.admUsuarioManager = null;
		this.usuarioDao = null;
		this.despachoExternoDao = null;
		this.gestorDespachoDao = null;
		this.perfilDao = null;
		this.zonaDao = null;
		this.zonaUsuarioPerfilDao = null;
		this.executor = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit)
			throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}

	protected void obtenUsuarioLogadoDeExecutor(Entidad entidad)
			throws Exception {
		Usuario usuarioLogado = TestData.newTestObject(Usuario.class,
				new FieldCriteria("entidad", entidad), new FieldCriteria(
						"enabled", true));
		when(
				executor
						.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO))
				.thenReturn(usuarioLogado);
	}

	protected void buscarAsuntosDeExecutor(Long idUsuario, List<Asunto> expected)
			throws Exception {
		when(
				executor
						.execute(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UNA_PERSONA,idUsuario))
				.thenReturn(expected);
	}

	protected Entidad creaEntidadPruebas(Long idEntidad) throws Exception {
		Entidad entidad1 = TestData.newTestObject(Entidad.class,
				new FieldCriteria("id", idEntidad));
		return entidad1;
	}

	protected Usuario creaUsuarioPruebas(Long id, Entidad entidad)
			throws Exception {
		Usuario usuario = TestData.newTestObject(Usuario.class,
				new FieldCriteria("id", id), new FieldCriteria("entidad",
						entidad), new FieldCriteria("enabled", true));
		usuario.setZonaPerfil(new ArrayList<ZonaUsuarioPerfil>());
		usuario.getZonaPerfil().add(
				TestData.newTestObject(ZonaUsuarioPerfil.class,
						new FieldCriteria("usuario", usuario)));
		return usuario;
	}

}
