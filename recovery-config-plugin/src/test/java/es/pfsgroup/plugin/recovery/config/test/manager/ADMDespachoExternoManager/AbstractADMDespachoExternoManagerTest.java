package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import static org.mockito.Mockito.*;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMGestorDespachoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;
import es.pfsgroup.recovery.ext.api.multigestor.EXTDDTipoGestorApi;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public abstract class AbstractADMDespachoExternoManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Gestores-Despachos_default.xml";
	protected ADMDespachoExternoManager admDespachoExternoManager = null;
	protected ADMDespachoExternoDao despachoExternoDao = null;
	protected ADMGestorDespachoDao gestorDespachoDao = null;
	protected ADMTipoDespachoExternoDao tipoDespachoDao = null;
	protected EXTTipoGestorPropiedadDao tipoGestorDao = null;
	protected ApiProxyFactory proxyMock = null;
	protected Executor executor;

	public AbstractADMDespachoExternoManagerTest() {
		super();
	}

	@Before
	public void setup() {
		this.despachoExternoDao = mock(ADMDespachoExternoDao.class);
		this.gestorDespachoDao = mock(ADMGestorDespachoDao.class);
		this.tipoDespachoDao = mock(ADMTipoDespachoExternoDao.class);
		this.tipoGestorDao = mock(EXTTipoGestorPropiedadDao.class);
		this.proxyMock = mock(ApiProxyFactory.class);
		this.executor = mock(Executor.class);
		
		this.admDespachoExternoManager = new ADMDespachoExternoManager(
		despachoExternoDao, gestorDespachoDao, tipoDespachoDao, tipoGestorDao, proxyMock, executor);
	}

	@After
	public void teardown() {
		this.admDespachoExternoManager = null;
		this.despachoExternoDao = null;
		this.gestorDespachoDao = null;
		this.tipoDespachoDao = null;
		this.tipoGestorDao = null;
		this.proxyMock = null;
		this.executor = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
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