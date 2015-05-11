package es.pfsgroup.commons.utils.test.web.dto.extensible.ExtensibleDto;

import static org.junit.Assert.*;

import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;
import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDtoBadFormatException;

public class GetParametersMapTest {

    private static final String PARAM_1_NAME = "myyParameter1";
    private static final String PARAM_2_NAME = "myyParameter2";
    private static final String PARAM_3_NAME = "myyParameter3";
    private static final String PARAM_4_NAME = "myyParameter4";

    private String param1value;
    private String param2value;
    private String param3value;
    private String param4value;

    private ExtensibleDto dto;

    @Before
    public void before() {
        dto = new ExtensibleDto() {
        };

        param1value = RandomStringUtils.randomAlphabetic(100);
        param2value = RandomStringUtils.randomAlphabetic(100);
        param3value = RandomStringUtils.randomAlphabetic(100);
        param4value = RandomStringUtils.randomAlphabetic(100);
    }

    @After
    public void after() {
        param4value = null;
        param3value = null;
        param2value = null;
        param1value = null;
        dto = null;
    }

    @Test
    public void testGetParametersMap() {
        final StringBuilder dynamicFiltersBuilder = new StringBuilder();
        dynamicFiltersBuilder.append(PARAM_1_NAME).append(":").append(param1value);
        dynamicFiltersBuilder.append(";").append(PARAM_2_NAME).append(":").append(param2value);
        dynamicFiltersBuilder.append(";").append(PARAM_3_NAME).append(":").append(param3value);
        dynamicFiltersBuilder.append(";").append(PARAM_4_NAME).append(":").append(param4value);

        dto.setDynamicParams(dynamicFiltersBuilder.toString());

        Map<String, String> params = dto.getParametersMap();

        assertEquals(param1value, params.get(PARAM_1_NAME));
        assertEquals(param2value, params.get(PARAM_2_NAME));
        assertEquals(param3value, params.get(PARAM_3_NAME));
        assertEquals(param4value, params.get(PARAM_4_NAME));

    }

    @Test
    public void testNoParams() {
        assertNull(dto.getParametersMap());
    }

    @Test
    public void testWrongFormat() {
        final String paramString = PARAM_1_NAME + "=" + param1value + ":" + param1value + ":" + param1value;
        try {
            dto.setDynamicParams(paramString);
            fail("Se debería haber lanzado una excepción");
        } catch (ExtensibleDtoBadFormatException e) {
            assertTrue(e.getMessage().contains(paramString));
        }
    }
}
