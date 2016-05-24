package es.pfsgroup.plugin.recovery.config.test.manager.ADMPerfilManager;

import static org.mockito.Mockito.*;

import java.util.List;

import org.junit.After;
import org.junit.Before;

import es.capgemini.pfs.core.api.seguridadPw.PasswordApi;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.config.funciones.dao.ADMFuncionDao;
import es.pfsgroup.plugin.recovery.config.perfiles.ADMPerfilManager;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMFuncionPerfilDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMPerfilDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;
public abstract class AbstractADMPerfilManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Perfiles_default.xml";
	protected ADMPerfilManager manager = null;
	protected ADMFuncionDao funcionDao = null;
	protected ADMPerfilDao perfilDao = null;
	protected ADMFuncionPerfilDao funcionPerfilDao = null;
	protected ApiProxyFactory proxyFactory = null;
	protected PasswordApi mockPasswordApi = null;

	public AbstractADMPerfilManagerTest() {
		super();
	}

	@Before
	public void setup() {
		funcionDao = mock(ADMFuncionDao.class);
		perfilDao = mock(ADMPerfilDao.class);
		funcionPerfilDao = mock(ADMFuncionPerfilDao.class);
		proxyFactory = mock(ApiProxyFactory.class);
		mockPasswordApi = mock(PasswordApi.class);
		when(proxyFactory.proxy(PasswordApi.class)).thenReturn(mockPasswordApi);
		manager = new ADMPerfilManager(perfilDao,funcionDao, funcionPerfilDao, proxyFactory);
	}

	@After
	public void teardown() {
		manager = null;
		funcionDao = null;
		perfilDao = null;
		funcionPerfilDao = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}

}