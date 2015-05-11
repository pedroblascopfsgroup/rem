package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.dao.impl.MSVDocumentoMasivoHibernateRawSQLDaoImpl;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Properties;

import org.hibernate.SQLQuery;
import org.hibernate.classic.Session;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.dao.impl.MSVDocumentoMasivoHibernateRawSQLDaoImpl;

/**
 * Clase genérica para probar la clase RawDao
 * @author bruno
 *
 */
public abstract class GenericRawDaoTests {

	private static final String MASTER_SCHEMA = "MASTER";
	@InjectMocks
	protected MSVDocumentoMasivoHibernateRawSQLDaoImpl rawDao;
	@Mock
	private SessionFactoryFacade mockSessionFactoryFacade;
	@Mock
	protected SQLQuery mockQuery;
	@Mock
	protected Session mockSession;
	@Mock
	private Properties mockAppProperties;

	@Before
	public void before() {
		when(mockSessionFactoryFacade.getSession(any(HibernateDaoSupport.class))).thenReturn(mockSession);
		when(mockSession.createSQLQuery(any(String.class))).thenReturn(mockQuery);
		when(mockAppProperties.getProperty("master.schema")).thenReturn(MASTER_SCHEMA);
	}

	@After
	public void after() {
		reset(mockSessionFactoryFacade);
		reset(mockSession);
		reset(mockQuery);
		reset(mockAppProperties);
	}

}
