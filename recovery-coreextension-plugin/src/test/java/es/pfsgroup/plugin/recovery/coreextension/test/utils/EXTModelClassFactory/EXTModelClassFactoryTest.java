package es.pfsgroup.plugin.recovery.coreextension.test.utils.EXTModelClassFactory;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Properties;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;

@RunWith(MockitoJUnitRunner.class)
public class EXTModelClassFactoryTest {

    @InjectMocks
    private EXTModelClassFactory factory;
    
    @Mock
    private Properties appProperties;
    
    private String boName;
    
    private Class defaultClass;
    
    @Before
    public void before(){
        defaultClass = FakeClassForTests.class;
        boName = RandomStringUtils.randomAlphabetic(100);
    }
    
    @After
    public void after(){
        defaultClass = null;
        boName = null;
        reset(appProperties);
    }
    
    @Test
    public void testReturnDefaultClass(){
        Class returned = factory.getModelFor(boName, defaultClass);
        assertEquals(defaultClass, returned);
    }
    
    @Test
    public void testReturnCustomizedModel(){
        class NewModel extends FakeClassForTests{};
        when(appProperties.getProperty(boName + ".model")).thenReturn(NewModel.class.getName());
        Class returned = factory.getModelFor(boName, defaultClass);
        assertEquals(NewModel.class, returned);
    }
    
    
    @Test(expected = BusinessOperationException.class)
    public void testReturnCustomizedModel_wrongClass(){
        class NewModelNotChildFromDefault{};
        when(appProperties.getProperty(boName + ".model")).thenReturn(NewModelNotChildFromDefault.class.getName());
        Class returned = factory.getModelFor(boName, defaultClass);
        fail();
    }
    
    @Test(expected = BusinessOperationException.class)
    public void testReturnCustomizedModel_classNotFound(){
        when(appProperties.getProperty(boName + ".model")).thenReturn(RandomStringUtils.randomAlphanumeric(250));
        Class returned = factory.getModelFor(boName, defaultClass);
        fail();
    }
}
