package es.pfsgroup.plugin.recovery.coreextension.test.utils.EXTHQLFieldsSelector;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.coreextension.utils.EXTHQLFieldsSelector;

@RunWith(MockitoJUnitRunner.class)
public class EXTHQLFieldsSelectorTest {

    
    private static class SampleClassForTest{
        // Don't add, static
        public static String STATIC_FIELD;
        
        // Add
        private String myString;
        
        // Don't add, transient
        private transient String myTransientString;
        
        // Add
        protected Long myLong;
        
        // Don't add, invalid type
        public SampleClassForTest sameObject;
     
    }
    
    private static final String CLASS_ALIAS = "myClass";
    
    private static final String FIELDS_COMMA_SEPARATED = "myClass.myString as myString, myClass.myLong as myLong";
    
    private static final List VALID_TYPES = Arrays.asList(String.class, Long.class);
    
    @InjectMocks
    private EXTHQLFieldsSelector selector;
    
    @Test
    public void testSelectFields(){
        String select = selector.selectAllFields(SampleClassForTest.class,CLASS_ALIAS, VALID_TYPES).toString();
        assertEquals("select distinct " + FIELDS_COMMA_SEPARATED, select.trim());
    }
    
    @Test
    public void testSelectFields_childClass(){
        class FirstChildClass extends SampleClassForTest{};
        class SecondChildClass extends FirstChildClass{Long anotherLong;};
        
        @SuppressWarnings("unchecked")
        String select = selector.selectAllFields(SecondChildClass.class, CLASS_ALIAS, VALID_TYPES).toString();
        assertEquals("select distinct " + FIELDS_COMMA_SEPARATED + ", " + CLASS_ALIAS + ".anotherLong as anotherLong", select.trim());
    }
}
