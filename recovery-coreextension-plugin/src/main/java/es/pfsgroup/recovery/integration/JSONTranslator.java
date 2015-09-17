package es.pfsgroup.recovery.integration;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JSONTranslator implements Translator {
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public String serialize(Object content) {
		ObjectMapper mapper = new ObjectMapper();
		String jsonValue = null;
		try {
			jsonValue = mapper.writeValueAsString(content);
		} catch (JsonGenerationException e) {
			logger.error("[INTEGRACION] Error serializando payload.", e);
		} catch (JsonMappingException e) {
			logger.error("[INTEGRACION] Error serializando payload.", e);
		} catch (IOException e) {
			logger.error("[INTEGRACION] Error serializando payload.", e);
		}
		return jsonValue;
	}

	@Override
	public Object deserialize(String json, Class<?> type) {
		ObjectMapper mapper = new ObjectMapper();
		Object object = null;
		try {
			final JsonNode jsonNode = mapper.readTree(json);
			final String className = jsonNode.get("@class").asText();
			final Class<?> cls = Class.forName(className);
			object = mapper.convertValue(jsonNode, cls);
		} catch (ClassNotFoundException e) {
			logger.error("[INTEGRACION] Clase la clase indicada en el mensaje no existe", e);
		} catch (JsonParseException e) {
			logger.error("[INTEGRACION] Error de-serializando payload.", e);
		} catch (JsonMappingException e) {
			logger.error("[INTEGRACION] Error de-serializando payload.", e);
		} catch (IOException e) {
			logger.error("[INTEGRACION] Error de-serializando payload.", e);
		}
		return object;
	}

}
