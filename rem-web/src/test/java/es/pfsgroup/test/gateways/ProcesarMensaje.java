package es.pfsgroup.test.gateways;

import org.springframework.integration.core.Message;
import org.springframework.integration.message.ErrorMessage;
import org.springframework.integration.message.MessageHandlingException;

public class ProcesarMensaje {
	
	public Message<String> procesar(Message<String> msg){
		System.out.println("Procesando : " + msg.getPayload());
		return msg;
	}
	
	public void showError(ErrorMessage mensaje){
		MessageHandlingException mensajeError = (MessageHandlingException) mensaje.getPayload();
		System.err.println("Error: " + mensajeError.getMessage());
	}

}
