package es.pfsgroup.plugin.recovery.coreextension.test.dao.coreextensionManager;

import static org.mockito.Mockito.reset;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.dao.coreextensionManager;
import es.pfsgroup.plugin.recovery.coreextension.test.AbstractCoreextensionTests;

public abstract class AbstractCoreextensionManagerTest extends AbstractCoreextensionTests{
	
	@InjectMocks 
	coreextensionManager coreextensionManager;
	
	@Mock
    protected ApiProxyFactory mockProxyFactory;
	
	@Mock
	protected GenericABMDao mockGenericDao;
	
	@Before
    public void before() {
        random = new Random();

        childBefore();
    }

    @After
    public void after() {
    	childAfter();

    	random = null;
        reset(mockProxyFactory);
        reset(mockGenericDao);

    }

}
