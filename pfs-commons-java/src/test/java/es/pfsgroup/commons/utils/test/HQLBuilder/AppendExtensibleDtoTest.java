package es.pfsgroup.commons.utils.test.HQLBuilder;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;

@RunWith(MockitoJUnitRunner.class)
public class AppendExtensibleDtoTest {

    private static final String PARAM1_KEY = "param1";

    private static final String PARAM2_KEY = "param2";

    private HQLBuilder builderSpy;

    private ExtensibleDto dto;

    private Map<String, String> dynamicParameters;

    private String param1Value;

    private String param2Value;

    @Before
    public void before() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException {
        dto = mock(ExtensibleDto.class);

        param1Value = RandomStringUtils.random(100);
        param2Value = RandomStringUtils.random(100);

        dynamicParameters = new HashMap<String, String>();
        dynamicParameters.put(PARAM1_KEY, param1Value);
        dynamicParameters.put(PARAM2_KEY, param2Value);

        // when(dto.getParametersMap()).thenReturn(dynamicParameters);
        // Como getParametersMap es final inyectaremos los parámetros a saco
        inyecta(dto, dynamicParameters);

        builderSpy = spy(new HQLBuilder(""));
        doNothing().when(builderSpy).appendWhere(any(String.class));
    }


    @After
    public void after() {
        dto = null;
        dynamicParameters = null;
        param1Value = null;
        param2Value = null;
        builderSpy = null;
    }

    @Test
    public void testAppendExtensibleDto() {
        builderSpy.appendExtensibleDto(dto);

        verify(builderSpy).appendWhere(PARAM1_KEY + " = '" + param1Value + "'");
        verify(builderSpy).appendWhere(PARAM2_KEY + " = '" + param2Value + "'");
    }
    
    private void inyecta(final ExtensibleDto object, final Map<String, String> parameters) throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException {
        final Field f = ExtensibleDto.class.getDeclaredField("pmap");
        f.setAccessible(true);
        f.set(object, parameters);
    }
}
