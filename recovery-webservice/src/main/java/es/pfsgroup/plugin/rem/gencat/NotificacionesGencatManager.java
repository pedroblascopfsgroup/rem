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
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;


@Service
public class NotificacionesGencatManager extends AbstractNotificatorService{
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;
	
	public void sendMailNotificacionSancionGencat(DtoGencatSave gencatDto, Activo activo,DDSancionGencat sancion) {
		String fechaSancion = gencatDto.getFechaSancion();
		String sancionDto = gencatDto.getSancion();
		String numActivo = Long.toString(activo.getNumActivo());
		
		ArrayList<String> mailsPara = new ArrayList<String>();
		List<String> mailsCC = new ArrayList<String>();
		List<String> mailsSustituto = new ArrayList<String>();
		List<DtoAdjuntoMail> adjuntos = new ArrayList<DtoAdjuntoMail>();
		
		if(fechaSancion != null && sancionDto !=null) {
			
			Usuario gestorFormalizacion = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
			Usuario gestoriaFormalizacion  = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
			Usuario gestorComercial  = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
			Usuario gestorComBackInm  = gestorActivoManager.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO);
			
			
			if(!Checks.esNulo(gestorFormalizacion)){
				mailsSustituto.clear();
				mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(gestorFormalizacion);
				if (!Checks.estaVacio(mailsSustituto)){
					mailsPara.addAll(mailsSustituto);
					mailsCC.add(gestorFormalizacion.getEmail());
				}else{
					mailsPara.add(gestorFormalizacion.getEmail());
				}
			}
			
			if(!Checks.esNulo(gestoriaFormalizacion)){
				mailsSustituto.clear();
				mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(gestoriaFormalizacion);
				if (!Checks.estaVacio(mailsSustituto)){
					mailsPara.addAll(mailsSustituto);
					mailsCC.add(gestoriaFormalizacion.getEmail());
				}else{
					mailsPara.add(gestoriaFormalizacion.getEmail());
				}
			}
			
			if(!Checks.esNulo(gestorComercial)){
				mailsSustituto.clear();
				mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(gestorComercial);
				if (!Checks.estaVacio(mailsSustituto)){
					mailsPara.addAll(mailsSustituto);
					mailsCC.add(gestorComercial.getEmail());
				}else{
					mailsPara.add(gestorComercial.getEmail());
				}
			}
			
			if(!Checks.esNulo(gestorComBackInm)){
				mailsSustituto.clear();
				mailsSustituto = usuarioRemApiImpl.getGestorSustitutoUsuario(gestorComBackInm);
				if (!Checks.estaVacio(mailsSustituto)){
					mailsPara.addAll(mailsSustituto);
					mailsCC.add(gestorComBackInm.getEmail());
				}else{
					mailsPara.add(gestorComBackInm.getEmail());
				}
			}
			
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
