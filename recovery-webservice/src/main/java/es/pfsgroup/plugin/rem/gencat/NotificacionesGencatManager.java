package es.pfsgroup.plugin.rem.gencat;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;


@Service
public class NotificacionesGencatManager extends AbstractNotificatorService{
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;
	
	public void sendMailNotificacionSancionGencat(DtoGencatSave gencatDto, Activo activo,DDSancionGencat sancion) {
		String fechaSancion = gencatDto.getFechaSancion();
		String sancionDto = gencatDto.getSancion();
		String numActivo = Long.toString(activo.getNumActivo());
		
		ArrayList<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		if(fechaSancion != null && sancionDto !=null) {
			
			usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION, mailsPara, mailsCC, false);
			usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION, mailsPara, mailsCC, false);
			usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, false);
			usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO, mailsPara, mailsCC, false);
			
			if(!mailsPara.isEmpty()) {
				if(mailsCC.isEmpty()){
					mailsCC.clear();
				}	
				String asunto = "Sanción GENCAT como " + sancion.getDescripcion() +" del activo " + numActivo;
				String cuerpo = 
						String.format("<p>GENCAT ha sancionado como %s la comunicación del activo %s de su oferta aprobada. Un saludo.</p>", sancion.getDescripcion(), numActivo);
				String cuerpoCorreo = this.generateCuerpoCorreoNotificacionAutomatica(cuerpo);
				
				genericAdapter.sendMail(mailsPara, mailsCC, asunto, cuerpoCorreo, adjuntos);
				
			}
			
		}
	
	}

}
