package es.pfsgroup.commons.utils.test.web.dto.factory.DTOFactory;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.web.dto.factory.DTOFactory;

/**
 * Test de integración del método creaYRellenaDTO de {@link DTOFactory}
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class CreaYRellenaDtoIntegrationTest {

    private static final String PARAM1_KEY = "dynamicParameter1";
    private static final String PARAM2_KEY = "dynamicParameter2";
    private static final String PARAM3_KEY = "dynamicParameter3";
    private static final String PARAM4_KEY = "dynamicParameter4";
    private static final String PARAM5_KEY = "dynamicParameter5";

    @InjectMocks
    private DTOFactory dtoFactory;

    @Mock
    private Properties appProperties;

    private WebRequest requestObject;

    private String nombreRequestMapping;

    private String expectedString;

    private Long expectedLong;

    private Integer expectedInteger;

    private String expectedSublcassValue;
    
    private String param1Value;
    private String param2Value;
    private String param3Value;
    private String param4Value;
    private String param5Value;

    @Before
    public void before() {
        Random random = new Random();

        expectedString = RandomStringUtils.randomAlphabetic(23);
        expectedLong = random.nextLong();
        expectedInteger = random.nextInt();
        expectedSublcassValue = RandomStringUtils.randomAlphabetic(100);

        requestObject = mock(WebRequest.class);
        
        param1Value = RandomStringUtils.randomAlphabetic(10);
        param2Value = RandomStringUtils.randomAlphabetic(10);
        param3Value = RandomStringUtils.randomAlphabetic(10);
        param4Value = RandomStringUtils.randomAlphabetic(10);
        param5Value = RandomStringUtils.randomAlphabetic(10);

        // Creamos mapa con los parámetros que vendrán en el request
        Map parameters = new HashMap<Object, Object>();
        // El value del map que devuelve el WebRequest Siempre es un array de
        // Strings
        parameters.put("stringProperty", new String[] { expectedString });
        parameters.put("longProperty", new String[] { expectedLong.toString() });
        parameters.put("integerProperty", new String[] { expectedInteger.toString() });
        parameters.put("subclassProperty", new String[] { expectedSublcassValue });
        
        StringBuilder dynamicParametersBuilder = new StringBuilder();
        dynamicParametersBuilder.append(PARAM1_KEY).append(":").append(param1Value);
        dynamicParametersBuilder.append(";").append(PARAM2_KEY).append(":").append(param2Value);
        dynamicParametersBuilder.append(";").append(PARAM3_KEY).append(":").append(param3Value);
        dynamicParametersBuilder.append(";").append(PARAM4_KEY).append(":").append(param4Value);
        dynamicParametersBuilder.append(";").append(PARAM5_KEY).append(":").append(param5Value);
        
        parameters.put("params", new String[] {dynamicParametersBuilder.toString()});

        when(requestObject.getParameterMap()).thenReturn(parameters);
    }

    @After
    public void after() {
        requestObject = null;
        expectedInteger = null;
        expectedLong = null;
        expectedString = null;
        expectedSublcassValue = null;
        
        param1Value = null;
        param2Value = null;
        param3Value = null;
        param4Value = null;
        param5Value = null;
    }

    @Test
    public void testCreaYRellena_defaultDTO_withDynamicParameters() {

        DTOEjemplo dto;
        try {
            dto = dtoFactory.creaYRellenaDTO(nombreRequestMapping, requestObject, DTOEjemplo.class);

            doBasicAssertions(dto);
        } catch (ClassNotFoundException e) {
            // Esto no va a ocurrir
            fail("No debería haber ocurrido esto.");
        }

    }

    @Test
    public void testCreaYRellena_withSubclass_withDynamicParameters() {

        when(appProperties.getProperty(nombreRequestMapping + ".dto")).thenReturn(DTOSubclass.class.getName());

        DTOEjemplo dto;
        try {
            dto = dtoFactory.creaYRellenaDTO(nombreRequestMapping, requestObject, DTOEjemplo.class);
            doBasicAssertions(dto);

            assertTrue(dto instanceof DTOSubclass);

            DTOSubclass dto2 = (DTOSubclass) dto;

            assertEquals(expectedSublcassValue, dto2.getSubclassProperty());
        } catch (ClassNotFoundException e) {
            // Esto no va a ocurrir
            fail("No debería haber ocurrido esto.");
        }

    }

    @Test(expected = IllegalArgumentException.class)
    public void testCreaYRellena_classIsNotSubclass() {
        class NotASubclass {
        }
        ;
        when(appProperties.getProperty(nombreRequestMapping + ".dto")).thenReturn(NotASubclass.class.getName());

        try {
            dtoFactory.creaYRellenaDTO(nombreRequestMapping, requestObject, DTOEjemplo.class);
        } catch (ClassNotFoundException e) {
            // Esto no va a ocurrir
            fail("No debería haber ocurrido esto.");
        }
    }

    @Test
    public void testCreaYRellena_classNotFound() {
        when(appProperties.getProperty(nombreRequestMapping + ".dto")).thenReturn(RandomStringUtils.randomAlphabetic(666));
        try {
            dtoFactory.creaYRellenaDTO(nombreRequestMapping, requestObject, DTOEjemplo.class);
            fail("Debería haberse lanzado una excepción");
        } catch (ClassNotFoundException e) {
            assertTrue(true);
        }
    }

    private void doBasicAssertions(final DTOEjemplo dto) {
        assertEquals(expectedString, dto.getStringProperty());
        assertEquals(expectedLong, dto.getLongProperty());
        assertEquals(expectedInteger, dto.getIntegerProperty());
       
        assertNull(dto.getNullString());
        
        assertNotNull(dto.getParametersMap());
        
        assertEquals(param1Value, dto.getParametersMap().get(PARAM1_KEY));
        assertEquals(param2Value, dto.getParametersMap().get(PARAM2_KEY));
        assertEquals(param3Value, dto.getParametersMap().get(PARAM3_KEY));
        assertEquals(param4Value, dto.getParametersMap().get(PARAM4_KEY));
        assertEquals(param5Value, dto.getParametersMap().get(PARAM5_KEY));
    }

}
