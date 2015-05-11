package es.pfsgroup.common.utils.test.web.dto.dynamic;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.DictImpl;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.DictInfo;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.MainEntity;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.MainInfo;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.OtherImpl;
import es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample.OtherInfo;
import es.pfsgroup.common.utils.test.web.dto.dynamic.testdtos.MyDto;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;

public class DynamicDtoUtilsTest {

    protected static final String OTHER_DESCRIPCION = "Other descripcion";
    protected static final String NAME = "My name";
    protected static final String DICT_DESCRIPCION = "Dict description";
    protected static final Date DATE = new Date();

    @Test
    public void testFromMap1() throws Exception {
        final HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("name", NAME);
        params.put("date", DATE);
        params.put("dictionary.descripcion", DICT_DESCRIPCION);
        params.put("other.descripcion", OTHER_DESCRIPCION);

        final MainEntity entity = DynamicDtoUtils.create(MainEntity.class, params);
        assertMainEntity(entity);
    }

    @Test
    public void testFromMap2() throws Exception {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("string", "aoe");
        params.put("complexType.name", "nnn");

        TestInfo t = DynamicDtoUtils.create(TestInfo.class, params);
        assertEquals("aoe", t.getString());
        assertEquals("nnn", t.getComplexType().getName());
    }

    @Test
    public void testFromMap3() throws Exception {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("string", "aoe");
        TestInfo t = DynamicDtoUtils.create(TestInfo.class, params);
        assertEquals("aoe", t.getString());
        assertNull(t.getComplexType());
    }

    @Test
    public void testCreateFromObject() throws Exception {
        MainInfo mainInfo = createMainInfo();
        MainEntity entity = DynamicDtoUtils.create(MainEntity.class, mainInfo);

        // Assert values
        assertMainEntity(entity);
    }

    @Test
    public void estCreateDTOFromWebRequest() {

        final WebRequest myWebRequest = mock(WebRequest.class);

        Random random = new Random();

        String expectedString = RandomStringUtils.random(100);
        Long expectedLong = random.nextLong();
        Integer expectedInt = random.nextInt();
        Boolean expectedBoolean = random.nextBoolean();

        final HashMap<String, String[]> parametersMap = new HashMap<String, String[]>();
        // El value del map que devuelve el WebRequest Siempre es un array de Strings
        parametersMap.put("myString", new String[] {expectedString});
        parametersMap.put("myLong", new String[] {expectedLong.toString()});
        parametersMap.put("myInt", new String[] {expectedInt.toString()});
        
        parametersMap.put("myBoolean", new String[] {expectedBoolean.toString()});

        when(myWebRequest.getParameterMap()).thenReturn(parametersMap);

        MyDto result = DynamicDtoUtils.create(MyDto.class, myWebRequest);

        assertEquals(expectedString, result.getMyString());
        assertEquals(expectedLong, result.getMyLong());
        assertEquals(expectedInt, result.getMyInt());
        assertEquals(expectedBoolean, result.getMyBoolean());

    }

    private void assertMainEntity(MainEntity entity) {
        assertNull(entity.getId());
        assertEquals(NAME, entity.getName());
        assertEquals(DATE, entity.getDate());
        assertNotNull(entity.getDictionary());
        assertNotNull(entity.getOther());
        assertNull(entity.getDictionary().getCode());
        assertNull(entity.getOther().getId());
        assertEquals(OTHER_DESCRIPCION, entity.getOther().getDescripcion());
        assertEquals(DICT_DESCRIPCION, entity.getDictionary().getDescripcion());
    }

    private MainInfo createMainInfo() {
        return new MainInfo() {

            @Override
            public OtherInfo getOther() {
                return new OtherImpl(OTHER_DESCRIPCION);
            }

            @Override
            public String getName() {
                return NAME;
            }

            @Override
            public DictInfo getDictionary() {
                return new DictImpl(DICT_DESCRIPCION);
            }

            @Override
            public Date getDate() {
                return DATE;
            }
        };
    }

}
