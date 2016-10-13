package es.pfsgroup.plugin.rem.notificacion;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;
import es.pfsgroup.plugin.rem.notificacion.api.RegistroApi;

/**
 * Manager de la entidad Registro.
 * @author adevicente
 *
 */
@Service("Registro")
@Transactional(readOnly = false)
public class RegistroManager implements RegistroApi {
	


	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	
	

	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_CREA_INFO_TAREA)
	public Map<String, Object> createInfoEventoTarea(Long idTarea,
			Long emisor, Date fecha_creacion, Date fecha_vencimiento,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion, List<String> mailPara, List<String> mailCc,
			String idAdjuntoCrear, String idAdjuntoResp, Long idTareaAppExterna) {
		
		HashMap<String, Object> info = new HashMap<String, Object>();
	
		if(!Checks.esNulo(idTarea)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA,idTarea);
		}
		if(!Checks.esNulo(emisor)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA,emisor);
		}
		if(!Checks.esNulo(fecha_creacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_CREACION_TAREA,fecha_creacion);
		}
		if(!Checks.esNulo(fecha_vencimiento)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_VENCIMIENTO_TAREA,fecha_vencimiento);
		}
		if(!Checks.esNulo(destinatario)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA,destinatario);
		}
		if(!Checks.esNulo(asunto)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ASUNTO_TAREA,asunto);
		}
		if(!Checks.esNulo(descripcion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA,descripcion);
		}
		if(!Checks.esNulo(mail) && mail){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL,1);
		}
		if(!Checks.esNulo(tipoAnotacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION,tipoAnotacion);
		}
		if(!Checks.esNulo(mailPara) && mailPara.size()>0){
			String listamails = "";
			for(int i= 0; i< mailPara.size(); i++){
				if(i==mailPara.size()-1){
					listamails+= mailPara.get(i);
				}else{
					listamails+= mailPara.get(i).concat(";");
				}
			}
			if(!listamails.equalsIgnoreCase("")){
				info.put(RegistroApi.EventoTarea.LISTA_MAIL_PARA_TAREA,listamails);
			}
		}
		if(!Checks.esNulo(mailCc) && mailCc.size()>0){
			String listamails = "";
			for(int i= 0; i< mailCc.size(); i++){
				if(i==mailCc.size()-1){
					listamails+= mailCc.get(i);
				}else{
					listamails+= mailCc.get(i).concat(";");
				}
			}
			if(!listamails.equalsIgnoreCase("")){
				info.put(RegistroApi.EventoTarea.LISTA_MAIL_CC_TAREA,listamails);
			}
		}
		if(!Checks.esNulo(idAdjuntoCrear)){
			info.put(RegistroApi.EventoTarea.ID_ADJUNTO_CREAR_TAREA,idAdjuntoCrear);
		}		
		if(!Checks.esNulo(idAdjuntoResp)){
			info.put(RegistroApi.EventoTarea.ID_ADJUNTO_RESP_TAREA,idAdjuntoResp);
		}
		if(!Checks.esNulo(idTareaAppExterna)){
			info.put(RegistroApi.EventoTarea.ID_TAREA_APP_EXTERNA,idTareaAppExterna);
		}
		return info;
	}
	
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_CREA_INFO_NOTIFICACION)
	public Map<String, Object> createInfoEventoNotificacion(
			Long idnotificacion, Long emisor, Date fecha_creacion,
			Long destinatario, String asunto, String descripcion, boolean mail,
			String tipoAnotacion, List<String> mailPara, List<String> mailCc,
			String idAdjuntoCrear, String idAdjuntoResp, Long idTareaAppExterna) {
		
		HashMap<String, Object> info = new HashMap<String, Object>();
		
		if(!Checks.esNulo(idnotificacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ID_NOTIFICACION,idnotificacion);
		}
		if(!Checks.esNulo(emisor)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.EMISOR_NOTIFICACION,emisor);
		}
		if(!Checks.esNulo(fecha_creacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FECHA_CREACION_NOTIFICACION,fecha_creacion);
		}
		if(!Checks.esNulo(destinatario)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESTINATARIO_NOTIFICACION,destinatario);
		}
		if(!Checks.esNulo(asunto)){		
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ASUNTO_NOTIFICACION,asunto);
		}
		if(!Checks.esNulo(descripcion)){		
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION,descripcion);
		}
		if(!Checks.esNulo(mail) && mail){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FLAG_MAIL,1);
		}
		if(!Checks.esNulo(tipoAnotacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION,tipoAnotacion);
		}		
		if(!Checks.esNulo(mailPara) && mailPara.size()>0){
			String listamails = "";
			for(int i= 0; i< mailPara.size(); i++){
				if(i==mailPara.size()-1){
					listamails+= mailPara.get(i);
				}else{
					listamails+= mailPara.get(i).concat(";");
				}
			}
			if(!listamails.equalsIgnoreCase("")){
				info.put(RegistroApi.EventoNotificacion.LISTA_MAIL_PARA_NOTIF,listamails);
			}
		}
		if(!Checks.esNulo(mailCc) && mailCc.size()>0){
			String listamails = "";
			for(int i= 0; i< mailCc.size(); i++){
				if(i==mailCc.size()-1){
					listamails+= mailCc.get(i);
				}else{
					listamails+= mailCc.get(i).concat(";");
				}
			}
			if(!listamails.equalsIgnoreCase("")){
				info.put(RegistroApi.EventoNotificacion.LISTA_MAIL_CC_NOTIF,listamails);
			}
		}
		if(!Checks.esNulo(idAdjuntoCrear)){
			info.put(RegistroApi.EventoNotificacion.ID_ADJUNTO_CREAR_NOTIF,idAdjuntoCrear);
		}		
		if(!Checks.esNulo(idAdjuntoResp)){
			info.put(RegistroApi.EventoNotificacion.ID_ADJUNTO_RESP_NOTIF,idAdjuntoResp);
		}
		if(!Checks.esNulo(idTareaAppExterna)){
			info.put(RegistroApi.EventoNotificacion.ID_TAREA_APP_EXTERNA,idTareaAppExterna);
		}
		return info;
	}
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_CREA_INFO_COMENTARIO)
	public Map<String, Object> createInfoEventoComentario(Long emisor,
			Date fecha_creacion, String asunto, String descripcion,
			String tipoAnotacion, Long idTareaAppExterna) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		
		if(!Checks.esNulo(emisor)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoComentario.EMISOR_COMENTARIO,emisor);
		}
		if(!Checks.esNulo(fecha_creacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoComentario.FECHA_CREACION_COMENTARIO,fecha_creacion);
		}
		if(!Checks.esNulo(asunto)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoComentario.ASUNTO_COMENTARIO,asunto);
		}
		if(!Checks.esNulo(descripcion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO,descripcion);
		}
		if(!Checks.esNulo(tipoAnotacion)){
			info.put(AgendaMultifuncionTipoEventoRegistro.EventoComentario.TIPO_ANOTACION,tipoAnotacion);
		}
		return info;
	}
	

	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_CREA_INFO_MAIL)
	public Map<String, Object> createInfoEventoMail(String asunto,
			String from, String destino, String cc, String cuerpo) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		if(!Checks.esNulo(from)){
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_ORIGEN, from);
		}
		if(!Checks.esNulo(asunto)){
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ASUNTO, asunto);
		}
		if(!Checks.esNulo(destino)){
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO, destino);
		}
		if(!Checks.esNulo(cc)){
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_CC, cc);
		}
		if(!Checks.esNulo(cuerpo)){
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_CUERPO, cuerpo);
		}
		return info;
	}
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_CREA_INFO_MAIL_CON_ADJUNTO)
	public Map<String, Object> createInfoEventoMailConAdjunto(
			String asunto, String from,
			String destino,
			String cc, String cuerpo,
			List<DtoAdjuntoMail> adjuntosList) {
		HashMap<String, Object> info = new HashMap<String, Object>();

		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_ORIGEN, from);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ASUNTO, asunto);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO, destino);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_CC, cc);
		info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_CUERPO, cuerpo);
		if(!Checks.esNulo(adjuntosList) && !Checks.estaVacio(adjuntosList)){
			String adjuntos="";
			for (DtoAdjuntoMail adjunto : adjuntosList){
				if ("".equals(adjuntos)){ adjuntos = adjuntos + adjunto.getAdjunto().getId();}
				else { adjuntos=adjuntos+","+adjunto.getAdjunto().getId();}
			}
			info.put(MEJDDTipoRegistro.RegistroEmail.CLAVE_ADJUNTOS,adjuntos );
		}

		return info;
	}

	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_DEJAR_TRAZA)
	public void dejarTraza(final long idUsuario, final String tipoEvento,
			final long idUg, final String codUg, final Map<String, Object> infoEvento, 
			final MEJRegistro registro) {
		
		MEJTrazaDto dtoTraza = new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return idUsuario;
			}
			
			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}

			@Override
			public long getIdUnidadGestion() {
				return idUg;
			}
			
			@Override
			public String getTipoUnidadGestion() {
				return codUg;
			}			

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return infoEvento;
			}

			
		};
		if(Checks.esNulo(registro)){
			//Creamos un nuevo registro
			proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(dtoTraza);
		}else{
			//Añadimos info adicional a un registro
			saveInformacionAdicional(dtoTraza, registro);
		}
	}
	
	
	
	

	
	
	/**
	 * Genera la información adicional a un registro. 
	 * @param dto 
	 * @param registro 
	 * @return 
	 */
	private void saveInformacionAdicional(MEJTrazaDto dto, MEJRegistro registro) {
		if (dto.getInformacionAdicional() != null) {
			Iterator<Entry<String, Object>> it = dto.getInformacionAdicional()
					.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, Object> e = it.next();
				MEJInfoRegistro info = new MEJInfoRegistro();
				info.setRegistro(registro);
				info.setClave(e.getKey());
				if (e.getValue() != null) {
					if (e.getValue() instanceof Date) {
						info.setValor("" + ((Date) e.getValue()).getTime());
					} else {
						info.setValor(e.getValue().toString());
					}
				} else {
					info.setValor("null");
				}
				genericDao.save(MEJInfoRegistro.class, info);
				registro.addInfo(info);
			}
		}
	}
	
	
	@Override
	@BusinessOperation(PLUGIN_REM_REGISTRO_DELETE_ATTRIBUTE_INFO_REGISTRO)
	public Boolean deleteAttributeInfoRegistro(String Atribute, Long idTraza) {
		
		if(Checks.esNulo(idTraza)){
			throw new BusinessOperationException("No se ha pasado el id del registro.");
		
		}else{
			MEJRegistro registro = (MEJRegistro) proxyFactory.proxy(MEJRegistroApi.class).get(idTraza);
			if(Checks.esNulo(registro)){
				throw new BusinessOperationException("No se han podido recuperar los datos del registro.");
			
			}else{
				for (ClaveValor cv : registro.getInfoRegistro()){
					if (cv.getClave().equals(Atribute)) {
						MEJInfoRegistro cvInfo = (MEJInfoRegistro)cv;
						if(!Checks.esNulo(cvInfo)){
							Filter filtroIdRegistro=genericDao.createFilter(FilterType.EQUALS, "id", cvInfo.getId());
							MEJInfoRegistro registroInfo = genericDao.get(MEJInfoRegistro.class, filtroIdRegistro);
							if(!Checks.esNulo(registroInfo)){
								genericDao.deleteById(MEJInfoRegistro.class, registroInfo.getId());
							}
						}
					}
				}
				return true;
			}
		}
	}
	
	
}



	
