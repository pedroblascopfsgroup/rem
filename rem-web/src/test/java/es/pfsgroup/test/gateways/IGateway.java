package es.pfsgroup.test.gateways;

import java.util.HashMap;

import org.springframework.integration.annotation.Gateway;
import org.springframework.integration.annotation.Header;

import es.pfsgroup.recovery.integration.TypePayload;

public interface IGateway {

	@Gateway
	public void test(MensajeDto mensaje);
	@Gateway
	public void testString(String string
			, @Header(TypePayload.HEADER_MSG_TYPE) String tipo
    		, @Header(TypePayload.HEADER_MSG_ENTIDAD) String entidad
    		, @Header(TypePayload.HEADER_MSG_GROUP) String grupo);
	
	@Gateway
	public void testHashMap(HashMap<String, String> contenido);
}
