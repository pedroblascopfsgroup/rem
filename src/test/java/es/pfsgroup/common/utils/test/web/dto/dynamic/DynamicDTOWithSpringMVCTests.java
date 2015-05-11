//package es.pfsgroup.common.utils.test.web.dto.dynamic;
//
//import static org.junit.Assert.*;
//
//import java.util.HashMap;
//import java.util.Map;
//
//import org.junit.Test;
//import org.springframework.web.context.request.WebRequest;
//
//import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDTO;
//
//public class DynamicDTOWithSpringMVCTests extends AbstractDynamicDTOTests{
//
//	
//	@Test
//	public void testWithSpringMVCWebRequest() throws Exception {
//		
//		Map<String, Object> parameters = new HashMap<String, Object>();
//		
//		parameters.put("long", new String[]{"1"});
//		
//		WebRequest request = createRequest(parameters);
//		
//		TestInfo dto = new DynamicDTO<TestInfo>(TestInfo.class).create(request);
//		
//		
//		assertEquals((Long) 1L, dto.getLong());
//	}
//}
