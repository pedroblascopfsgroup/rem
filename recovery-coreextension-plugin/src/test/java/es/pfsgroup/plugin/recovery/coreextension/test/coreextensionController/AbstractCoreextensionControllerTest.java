package es.pfsgroup.plugin.recovery.coreextension.test.coreextensionController;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.ui.ModelMap;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.coreextensionController;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.test.AbstractCoreextensionTests;

public abstract class AbstractCoreextensionControllerTest extends AbstractCoreextensionTests{
	
	@InjectMocks 
	coreextensionController coreextensionController;
	
	@Mock
    protected ApiProxyFactory mockProxyFactory;
	
	@Mock
	protected GenericABMDao mockGenericDao;
	
	protected ModelMap modelMap;
	
	@Mock coreextensionApi mockCoreextensionApi;

	@Before
    public void before() {
        random = new Random();
        modelMap = new ModelMap();
        when(mockProxyFactory.proxy(coreextensionApi.class)).thenReturn(mockCoreextensionApi);
        childBefore();
    }

    @After
    public void after() {
    	childAfter();
        random = null;
        modelMap = null;
        reset(mockProxyFactory);
        reset(mockGenericDao);
        reset(mockCoreextensionApi);
    }

}
