package es.pfsgroup.plugin.rem.test.controller.activoControllerDispatcher;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import es.pfsgroup.plugin.rem.controller.ActivoControllerDispatcher;
import es.pfsgroup.plugin.rem.test.controller.activoControllerDispatcher.dto.ExampleDto;
import net.sf.json.JSONObject;

public class CreateFromJsonTests {
	
	private static final Integer ONE = 1;
	private static final Integer TWO = 2;
	private static final String ABCDE = "ABCDE";

	@Test
	public void createDtoFromJson (){
		JSONObject json = new JSONObject();
		json.put("string", ABCDE);
		json.put("date", "2017-12-31T00:00:00");
		json.put("integer", ONE);
		json.put("anotherInteger", TWO.toString());
		
		
		ExampleDto dto = ActivoControllerDispatcher.createFromJson(ExampleDto.class, json);
		assertEquals(ABCDE, dto.getString());
		assertEquals(ONE, dto.getInteger());
		assertEquals(TWO, dto.getAnotherInteger());
		assertNotNull("No se ha seteado la fecha", dto.getDate());
	}

}
