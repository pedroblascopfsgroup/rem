package es.capgemini.pfs.test.tareaNotificacion.EXTTareaNotificacionManager;

import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Properties;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.context.ApplicationContext;


import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;

public abstract class AbstractExtTareaNotificacionManagerTests {

	@InjectMocks
	protected EXTTareaNotificacionManager realManager;
	
	protected EXTTareaNotificacionManager manager;
	@Mock
	private ApplicationContext mockApplicationContext;
	@Mock
	protected TareaNotificacionApi mockParentManager;
	@Mock
	private Executor mockExecutor;
	@Mock
	private VencimientoUtils mockVencimientoUtils;
	@Mock
	private GenericABMDao mockGenericDao;
	@Mock
	private Usuario mockUsuarioLogado;
	@Mock
	private VTARBusquedaOptimizadaTareasDao mockBusquedaTareasDao;
	@Mock
	private Properties appProperties;
	@Mock
	private EXTModelClassFactory modelClassFactory;
	
	private VerificacionInteraccionesEXTTNM verificador;
	private SimulacionInteraccionesEXTTNM simulador;
	
	
	

	public AbstractExtTareaNotificacionManagerTests() {
		super();
	}

	@Before
	public void before() {
		MockitoAnnotations.initMocks(this);
		manager = spy(realManager);
		when(mockApplicationContext.getBean(manager.managerName())).thenReturn(mockParentManager);
		when(mockApplicationContext.getBean("vencimientoUtils")).thenReturn(mockVencimientoUtils);
		when(mockExecutor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).thenReturn(mockUsuarioLogado);
		when(appProperties.getProperty(EXTTareaNotificacionManager.EXPORTAR_ASUNTOS_LIMITE_SIMULTANEO)).thenReturn("1");
		new VencimientoUtils().setApplicationContext(mockApplicationContext);
		verificador = new VerificacionInteraccionesEXTTNM(mockExecutor, mockGenericDao);
		simulador = new SimulacionInteraccionesEXTTNM(manager,mockExecutor, mockBusquedaTareasDao, mockGenericDao);
		setUpChildTest();
	}

	@After
	public void after() {
		tearDownChildTest();
		reset(mockApplicationContext);
		reset(mockParentManager);
		reset(mockExecutor);
		reset(mockVencimientoUtils);
		reset(mockGenericDao);
		reset(mockUsuarioLogado);
		reset(mockBusquedaTareasDao);
		verificador = null;
		simulador = null;
		new VencimientoUtils().setApplicationContext(null);
	}
	
	/**
	 * Código de inicialización pre-test de cada hijo
	 */
	public abstract void setUpChildTest();
	
	/**
	 * Código de limpieza post-tet de cada hijo
	 */
	public abstract void tearDownChildTest();

	
	
	/**
	 * Utilidad para la verificación de colaboradores
	 * @return
	 */
	protected VerificacionInteraccionesEXTTNM verificarInteracciones(){
		return this.verificador;
	}
	
	/**
	 * Utilidad para simular interacciones con los colaboradores
	 * @return
	 */
	protected SimulacionInteraccionesEXTTNM simularInteracciones(){
		return this.simulador;
	}
	
}