package es.capgemini.pfs.integration;

import java.io.IOException;

import org.junit.Test;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonTest {

	@Test
	public void testJsonPojo() {
		PojoStr pojoStr = new PojoStr("valor introducido");
		String t = serialize(pojoStr);
		pojoStr = (PojoStr)deserialize(t);
	}
	
	public String serialize(Object message) {
		ObjectMapper mapper = new ObjectMapper();
		String jsonValue = null;
		try {
			jsonValue = mapper.writeValueAsString(message);
			Pojo p = new Pojo(message.getClass().getName(), jsonValue);
			jsonValue = mapper.writeValueAsString(p);
		} catch (JsonGenerationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jsonValue;
	}

	public Object deserialize(String formattedMsg) {
		ObjectMapper mapper = new ObjectMapper();
		Object object = null;
		try {
			Pojo cls = mapper.readValue(formattedMsg, Pojo.class);
			Class c = Class.forName(cls.getClase());
			object = mapper.readValue(cls.getDatos(), c);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
		} catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch blockFile(
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return object;
	}	
}
