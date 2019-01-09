package es.pfsgroup.plugin.rem.gencat;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.AbstractNotificatorService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;


@Service
public class NotificacionesGencatManager extends AbstractNotificatorService{
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	
	
	public void sendMailNotificacionSancionGencat(DtoGencatSave gencatDto, Activo activo) {
		logger.warn("ENTRO sendMailNotificacionSancionGencat ");
		String fechaSancion = gencatDto.getFechaSancion();
		String sancion = gencatDto.getSancion();
		String idActivo = Long.toString(gencatDto.getIdActivo());
		List<String> mailsCC = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		
		
		if(fechaSancion != null && sancion !=null) {
			ArrayList<String> para = new ArrayList<String>();
			Usuario gestorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			Usuario gestoriaFormalizacion  = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			if(!Checks.esNulo(gestorFormalizacion)) {
				
				para.add(gestorFormalizacion.getEmail());
			}
			if(!Checks.esNulo(gestoriaFormalizacion)) {
				
				para.add(gestoriaFormalizacion.getEmail());
			}
			if(sancion.equals("NO_EJERCE")) {
				sancion = "No ejerce";				
			}
			if(sancion.equals("EJERCE")) {
	            sancion = "Ejerce";				
			}
			   
			if(!para.isEmpty()) {
				
				String asunto = "Sanción GENCAT como " + sancion +" del activo " + idActivo;
				String cuerpo = 
						String.format("<p>GENCAT ha sancionado como %s la comunicacion del activo %s de su oferta aprobada. Un saludo</p>", sancion, idActivo);
				String cuerpoCorreo = this.generateCuerpoCorreoNotificacionAutomatica(cuerpo);
				
				genericAdapter.sendMail(para, mailsCC, asunto, cuerpoCorreo, adjuntos);
				
			}
			
			
		}
		
		
	}
	

}
