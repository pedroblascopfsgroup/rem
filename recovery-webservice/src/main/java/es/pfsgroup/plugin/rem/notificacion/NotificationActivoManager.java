package es.pfsgroup.plugin.rem.notificacion;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;

@Service
public class NotificationActivoManager extends AbstractNotificatorService {
		
	@Autowired
	private GenericAdapter genericAdapter;
	
	public void sendMailFasePublicacion(Activo activo, String asunto, String cuerpo,ArrayList<String> mailsPara,ArrayList<String> mailsCC) {
		if (!Checks.esNulo(activo)){

			List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();

			DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();

			dtoSendNotificator.setNumActivo(activo.getNumActivo());
			dtoSendNotificator.setDireccion(generateDireccion(activo));
			dtoSendNotificator.setTitulo(asunto);
	
			String cuerpoCorreo = generateCuerpo(dtoSendNotificator, cuerpo);
			
			genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);
				
		}
	}

}
