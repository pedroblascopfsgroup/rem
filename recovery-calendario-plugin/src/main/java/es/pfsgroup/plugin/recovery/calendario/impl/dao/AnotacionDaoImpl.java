package es.pfsgroup.plugin.recovery.calendario.impl.dao;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.calendario.api.CalendarioTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.calendario.impl.dto.DtoRespuestaBusquedaTareasImpl;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

/**
 * Implementación para la persistencia de las tareas del calendario
 * @author Guillem
 *
 */ 
@Component
public class AnotacionDaoImpl extends AbstractEntityDao<EXTTareaNotificacion, Long>{

	private static final String BO_USUARIO_MGR_GET_USUARIO_LOGADO = "usuarioManager.getUsuarioLogado";
	private static final String MEJ_BO_GETMAPA_REGISTRO = "plugin.mejoras.registro.getMapa";
	private static final String BO_TAREA_MGR_GET = "tareaNotificacionManager.get";
	
    @Autowired
    private Executor executor;
    
	@Autowired
	GenericABMDao genericDao;
    
	/**
	 * {@inheritDoc}
	 */
    @SuppressWarnings("rawtypes")
	@Transactional
	public List obtenerAnotaciones(DtoTareas dto) {
		try{			
	        String hql = "from EXTTareaNotificacion tar where tar.destinatarioTarea = ? and tar.tipoDestinatario = 'U'";
			return getHibernateTemplate().find(hql, (Usuario) executor.execute(BO_USUARIO_MGR_GET_USUARIO_LOGADO));
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}
	
	/**
	 * {@inheritDoc}
	 */
    @Transactional
	public Object obtenerAnotacion(DtoTareas dto) {
		try{			
			Long idTarea = dto.getId();
			DtoRespuestaBusquedaTareasImpl result = null;
			if (!Checks.esNulo(idTarea)) {
				SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
				result = new DtoRespuestaBusquedaTareasImpl();
				MEJInfoRegistro infoRegistro = getTrazaParaLaTarea(idTarea);
				Map<String, String> info = getInfoAdicionalTraza(infoRegistro);
				TareaNotificacion tarea = (TareaNotificacion) executor.execute(BO_TAREA_MGR_GET, idTarea);
				result.setFechaInicioDesde(format.format(tarea.getFechaInicio())); // Fecha
				result.setFechaVencimientoDesde(format.format(tarea.getFechaVenc())); // FechaVencimiento
				result.setTipoAnotacion(getTipoAnotacion(info)); // TipoAnotacion
				result.setFlagEnvioCorreo("1".equals(getInfoValue(info, CalendarioTipoEventoRegistro.EventoTarea.FLAG_MAIL, "0"))); // FlagEmail
				result.setUsuarioDestinoTarea(getInfoValue(info, CalendarioTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA, null)); // Destinatario
				result.setUsuarioOrigenTarea(getInfoValue(info, CalendarioTipoEventoRegistro.EventoTarea.EMISOR_TAREA, null)); // Emisor
				result.setSituacion("Asunto"); // Situacion
				result.setId(idTarea); // IdTarea
				result.setDescripcion(getInfoValue(info, CalendarioTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA, null)); // Descripcion
				result.setIdAsunto(!Checks.esNulo(tarea.getAsunto()) ? tarea.getAsunto().getId() : 0);	// IdAsunto			
				result.setTieneResponder(false); // TieneResponder
				Usuario usuLogado =  (Usuario) executor.execute(BO_USUARIO_MGR_GET_USUARIO_LOGADO);
				Long idUsuarioDestino = null;
				if(tarea instanceof EXTTareaNotificacion)
					idUsuarioDestino = ((EXTTareaNotificacion)tarea).getDestinatarioTarea().getId();					
				if(idUsuarioDestino != null)
					if(idUsuarioDestino.equals(usuLogado.getId())) result.setTieneResponder(true);
				MEJInfoRegistro infoRegistroRespuesta = getTrazaRespuestaTarea(idTarea);
				Map<String, String> infoRespuesta = getInfoAdicionalTraza(infoRegistroRespuesta);
				result.setRespuesta(getInfoValue(infoRespuesta, CalendarioTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA, null)); // Respuesta
			}
			return result;
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}	
	
	private Map<String, String> getInfoAdicionalTraza(
			MEJInfoRegistro infoRegistro) {
		if (infoRegistro == null) return null;		
		@SuppressWarnings("unchecked")
		Map<String, String> info = (Map<String, String>) executor.execute(MEJ_BO_GETMAPA_REGISTRO, infoRegistro.getRegistro().getId());
		return info;
	}

	private MEJInfoRegistro getTrazaParaLaTarea(Long idTarea) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", CalendarioTipoEventoRegistro.EventoTarea.ID_TAREA);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
		MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2);
		return infoRegistro;
	}
	
	private String getTipoAnotacion(Map<String, String> info) {
		if (!Checks.esNulo(info)) {
			String tipoAnotacion = info.get(CalendarioTipoEventoRegistro.EventoTarea.TIPO_ANOTACION);
			 DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, 
		        		genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
		        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));		       
		        if(tipoAnotacionDD !=null)
		        	return tipoAnotacionDD.getDescripcion();
		}
		return "Desconocido";
	}	
	
	private MEJInfoRegistro getTrazaRespuestaTarea(Long idTarea) {
		Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave", CalendarioTipoEventoRegistro.EventoRespuesta.ID_TAREA);
		Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
		MEJInfoRegistro infoRegistroRespuesta = genericDao.get(MEJInfoRegistro.class, fr1, fr2);
		return infoRegistroRespuesta;
	}

	private String getInfoValue(Map<String, String> info, String infoKey, String defaultValue) {
		if (Checks.estaVacio(info)) {
			return defaultValue;
		} else {
			String v = info.get(infoKey);
			return Checks.esNulo(v) ? defaultValue : v;
		}
	}
	
	//TODO: prueba de task scanner para hudson
	
}
