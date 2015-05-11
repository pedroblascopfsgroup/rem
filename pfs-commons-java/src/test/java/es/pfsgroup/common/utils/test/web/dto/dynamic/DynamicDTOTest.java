package es.pfsgroup.common.utils.test.web.dto.dynamic;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDTO;

public class DynamicDTOTest extends AbstractDynamicDTOTests {
	

	private static final String SOME_STRING = "My String";
	private static final Long SOME_LONG = 42L;
	private static final Double SOME_DOUBLE = 89.5;
	private static final String COMPLEX_TYPE_NAME = "A complex type name";
	private static final String COMPLEX_TYPE_VALUE = "The complex type value";
	private static final Object SOME_PRIMITIVE_INT = 76;
	private static final Object SOME_PRIMITIVE_BOOLEAN = true;

	@Test
	public void testDynamicDTOFromWebRequest() throws Exception {
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("string", SOME_STRING);
		parameters.put("long", SOME_LONG.toString());
		parameters.put("double", SOME_DOUBLE.toString());
		parameters.put("complexType.name", COMPLEX_TYPE_NAME);
		parameters.put("complexType.value", COMPLEX_TYPE_VALUE.toString());
		parameters.put("complexType.complexType.name", COMPLEX_TYPE_NAME.toString());
		parameters.put("complexType.complexType.value", COMPLEX_TYPE_VALUE);

		WebRequest request = createRequest(parameters);

		TestInfo dto = new DynamicDTO<TestInfo>(TestInfo.class)
				.create(request);

		assertEquals(SOME_STRING, dto.getString());
		assertEquals(SOME_LONG, dto.getLong());
		assertEquals(SOME_DOUBLE, dto.getDouble());
		assertEquals(COMPLEX_TYPE_NAME, dto.getComplexType().getName());
		assertEquals(COMPLEX_TYPE_VALUE, dto.getComplexType().getValue());
		assertEquals(COMPLEX_TYPE_NAME, dto.getComplexType().getComplexType()
				.getName());
		assertEquals(COMPLEX_TYPE_VALUE, dto.getComplexType().getComplexType()
				.getValue());

	}

	@Test
	public void testDynamicDtoPutValues() throws Exception {

		TestInfo dto = new DynamicDTO<TestInfo>(TestInfo.class)
				.put("string", SOME_STRING).put("complexType.complexType.name",COMPLEX_TYPE_NAME).create();

		assertEquals(SOME_STRING, dto.getString());
		assertNull(dto.getLong());
		assertNull(dto.getDouble());
		assertNull( dto.getComplexType().getName());
		assertNull(dto.getComplexType().getValue());
		assertEquals(COMPLEX_TYPE_NAME, dto.getComplexType().getComplexType()
				.getName());
		assertNull(dto.getComplexType().getComplexType()
				.getValue());
	}
	
	
	@Test
	public void testPrimitiveValues() throws Exception {
		TestInfo dto = new DynamicDTO<TestInfo>(TestInfo.class)
		.put("primitiveInt", SOME_PRIMITIVE_INT).put("primitiveBoolean",SOME_PRIMITIVE_BOOLEAN).create();
		
		assertEquals(SOME_PRIMITIVE_INT, dto.getPrimitiveInt());
		assertEquals(SOME_PRIMITIVE_BOOLEAN, dto.getPrimitiveBoolean());
		assertNull(dto.getString());
	}
	
	@Test
	public void testPrimitiveValuesAsStrings() throws Exception {
		TestInfo dto = new DynamicDTO<TestInfo>(TestInfo.class)
		.put("primitiveInt", "00" + SOME_PRIMITIVE_INT).put("primitiveBoolean",""+ SOME_PRIMITIVE_BOOLEAN).create();
		
		assertEquals(SOME_PRIMITIVE_INT, dto.getPrimitiveInt());
		assertEquals(SOME_PRIMITIVE_BOOLEAN, dto.getPrimitiveBoolean());
	}

}
