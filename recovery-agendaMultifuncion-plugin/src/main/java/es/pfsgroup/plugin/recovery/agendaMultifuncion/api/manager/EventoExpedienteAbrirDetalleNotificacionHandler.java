package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoMostrarAnotacion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.evento.EventoAbrirDetalleHandler;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class EventoExpedienteAbrirDetalleNotificacionHandler implements
		EventoAbrirDetalleHandler {

	 	@Autowired
	    GenericABMDao genericDao;

	    @Autowired
	    private ApiProxyFactory proxyFactory;
	
	@Override
	public String getJspName() {
		  return "plugin/agendaMultifuncion/asunto/detalleAnotacionHistorico";
	}

	@Override
	public Object getViewData(Long idTarea, Long idTraza, Long idEntidad) {
		  DtoMostrarAnotacion result = new DtoMostrarAnotacion();

	        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");

	        Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(idTraza);

	        String fechaCreacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FECHA_CREACION_NOTIFICACION);
	        if (StringUtils.hasText(fechaCreacion)) {
	            Long fechaLong = Long.parseLong(fechaCreacion);
	            result.setFecha(format.format(new Date(fechaLong)));
	        }
	        

	        String tipoAnotacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION);
	        DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, 
	        		genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
	        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	       
	        if(tipoAnotacionDD !=null)
	        	result.setTipoAnotacion(tipoAnotacionDD.getDescripcion());


	        result.setFlagEmail("1".equals(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.FLAG_MAIL)));
	        result.setDescripcion(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION));
	        
	        
	        //Obtener nombre y apellidos del destinatario en lugar de mostrar el id
	        Long idDestinatario=Long.parseLong(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESTINATARIO_NOTIFICACION));
	        Usuario destinatario = proxyFactory.proxy(UsuarioApi.class).get(idDestinatario);
	        result.setDestinatario(destinatario.getApellidoNombre());
	        //Obtener nombre y apellidos del emisor en lugar de mostrar el id
	        Long idEmisor=Long.parseLong(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.EMISOR_NOTIFICACION));
	        Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(idEmisor);
	        result.setEmisor(emisor.getApellidoNombre());
	        
	        
	        result.setSituacion("Expediente");
	        result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
	        result.setIdAsunto(idEntidad);
	        result.setIdTarea(idTarea);
	        result.setIdTraza(idTraza);

	        return result;
	}

	@Override
	public boolean isValid(String tipoTarea, String codUg) {
		 if (!Checks.esNulo(tipoTarea) && !Checks.esNulo(codUg) 
				 && tipoTarea.equals(EXTSubtipoTarea.CODIGO_ANOTACION_NOTIFICACION) 
				 && codUg.equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE)) {
	            return true;
	     }
		 return false;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

}
