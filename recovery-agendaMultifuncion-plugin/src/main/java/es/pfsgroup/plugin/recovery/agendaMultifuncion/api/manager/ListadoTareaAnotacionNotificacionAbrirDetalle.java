package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoMostrarAnotacion;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class ListadoTareaAnotacionNotificacionAbrirDetalle implements BuzonTareasViewHandler {

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public String getJspName() {
		return "plugin/agendaMultifuncion/asunto/detalleAnotacion";
	}

	@Override
	public Object getModel(Long idTarea) {
		DtoMostrarAnotacion result = null;
		if (!Checks.esNulo(idTarea)) {
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			EXTTareaNotificacion tarea = (EXTTareaNotificacion) proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);

			result = new DtoMostrarAnotacion();
			if (tarea.getAsunto() != null) {
				result.setSituacion("Asunto");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
			}
			if (tarea.getExpediente() != null) {
				result.setSituacion("Expediente");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
			}
			if (tarea.getCliente() != null) {
				result.setSituacion("Cliente");
				result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
			}
			if (tarea.getPersona() != null) { // PERSONA QUE NO ES CLIENTE
				result.setSituacion("Persona");
				result.setCodUg("9");
			}

			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ID_NOTIFICACION);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
			MEJInfoRegistro infoRegistro = getInfoRegistro(f1, f2);

			if (infoRegistro != null) {// SI ES NULL, SE TRATA DE UNA
										// NOTIFICACI�N GENERADA AL CREAR LA
										// RESPUETA
				Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(infoRegistro.getRegistro().getId());
				// TareaNotificacion tarea =
				// proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);

				String fechaCreacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FECHA_CREACION_NOTIFICACION);
				if (StringUtils.hasText(fechaCreacion)) {
					Long fechaLong = Long.parseLong(fechaCreacion);
					result.setFecha(format.format(new Date(fechaLong)));
				}

				String tipoAnotacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION);
				if (StringUtils.hasText(tipoAnotacion)) {
					DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
							genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

					if (tipoAnotacionDD != null)
						result.setTipoAnotacion(tipoAnotacionDD.getDescripcion());
				}
				result.setFlagEmail("1".equals(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FLAG_MAIL)));
				result.setDescripcion(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION));

				// Obtener nombre y apellidos del destinatario en lugar de
				// mostrar el id
				String idDest = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESTINATARIO_NOTIFICACION);
				Usuario destinatario = getUsuario(idDest);
				if(destinatario!=null)
					result.setDestinatario(destinatario.getApellidoNombre());
				else
					result.setDestinatario(null);
				// Obtener nombre y apellidos del emisor en lugar de mostrar el
				// id
				String idEmi = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.EMISOR_NOTIFICACION);
				Usuario emisor = getUsuario(idEmi);
				
				if(emisor!=null)
					result.setEmisor(emisor.getApellidoNombre());
				else
					result.setEmisor(null);
				
				result.setIdAsunto(infoRegistro.getRegistro().getIdEntidadInformacion());
				result.setIdTarea(idTarea);
				result.setTieneResponder(false);
			} else {

				Filter fr1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA);
				Filter fr2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
				MEJInfoRegistro infoRegistroRespuesta = getInfoRegistro(fr1, fr2);

				if (!Checks.esNulo(infoRegistroRespuesta)) {
					Map<String, String> infoRespuesta = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(infoRegistroRespuesta.getRegistro().getId());
					result.setRespuesta(infoRespuesta.get(AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA));
					String fechaCreacion = infoRespuesta.get(AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.FECHA_RESPUESTA);
					if (StringUtils.hasText(fechaCreacion)) {
						Long fechaLong = Long.parseLong(fechaCreacion);
						result.setFecha(format.format(new Date(fechaLong)));
					}

					Filter f3 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA);
					Filter f4 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", infoRespuesta.get(AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA_ORIGINAL));
					MEJInfoRegistro infoRegistro2 = getInfoRegistro(f3, f4);

					Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(infoRegistro2.getRegistro().getId());

					String tipoAnotacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION);
					if ("A".equals(tipoAnotacion)) {
						result.setTipoAnotacion("Alerta");
					} else if ("R".equals(tipoAnotacion)) {
						result.setTipoAnotacion("Recordatorio");
					} else {
						result.setTipoAnotacion("Desconocido");
					}

					result.setFlagEmail("1".equals(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL)));
					result.setDescripcion(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA));
					// Obtener nombre y apellidos del destinatario en lugar de
					// mostrar el id
					String idDest = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA);
					Usuario destinatario = getUsuario(idDest);
					
					if(destinatario!=null)
						result.setDestinatario(destinatario.getApellidoNombre());
					else
						result.setDescripcion(null);
					
					// Obtener nombre y apellidos del emisor en lugar de mostrar
					// el id
					String idEmi = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA);
					Usuario emisor = getUsuario(idEmi);
					if(emisor!=null)
						result.setEmisor(emisor.getApellidoNombre());
					else
						result.setEmisor(null);
					
					result.setIdAsunto(infoRegistro2.getRegistro().getIdEntidadInformacion());
					result.setIdTarea(idTarea);
					result.setTieneResponder(true);
				}
			}
			
			MSVResolucion resolucion = proxyFactory.proxy(MSVResolucionApi.class).getResolucionByTareaNotificacion(idTarea);
			if(resolucion != null && resolucion.getAdjuntoFinal()!=null){
				result.setIdArchivoAdjunto(resolucion.getAdjuntoFinal().getId());
				result.setNombreAdjunto(resolucion.getNombreFichero());
				result.setIdResolucion(resolucion.getId());
			}
		}
		return result;
	}

	@Override
	public String getValidString() {
		return EXTSubtipoTarea.CODIGO_ANOTACION_NOTIFICACION;
	}

	private MEJInfoRegistro getInfoRegistro(Filter f1, Filter f2) {
		List<MEJInfoRegistro> infoRegistroList = genericDao.getList(MEJInfoRegistro.class, f1, f2);
		MEJInfoRegistro infoRegistro = null;
		if (!Checks.estaVacio(infoRegistroList)) {
			infoRegistro = infoRegistroList.get(0);
		}
		return infoRegistro;
	}

	private Usuario getUsuario(String idEmi) {
		try {
			Long idEmisor = Long.parseLong(idEmi);
			return proxyFactory.proxy(UsuarioApi.class).get(idEmisor);
		} catch (NumberFormatException e) {
			return genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", idEmi));
		}
	}

}
