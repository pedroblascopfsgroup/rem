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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoMostrarAnotacion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.evento.EventoAbrirDetalleHandler;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class EventoPersonaNoClienteAbrirDetalleTareaHandler implements
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

	        String fechaCreacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_CREACION_TAREA);
	        if (StringUtils.hasText(fechaCreacion)) {
	            Long fechaLong = Long.parseLong(fechaCreacion);
	            result.setFecha(format.format(new Date(fechaLong)));
	        }

	        String fechaVencimiento = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FECHA_VENCIMIENTO_TAREA);
	        if (StringUtils.hasText(fechaVencimiento)) {
	            Long fechaLong = Long.parseLong(fechaVencimiento);
	            result.setFechaVencimiento(format.format(new Date(fechaLong)));
	        }

	        String tipoAnotacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION);
	        DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, 
	        		genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
	        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	       
	        if(tipoAnotacionDD !=null)
	        	result.setTipoAnotacion(tipoAnotacionDD.getDescripcion());
	 
	        result.setFlagEmail("1".equals(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.FLAG_MAIL)));
	        result.setDescripcion(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA));
	        //Obtener nombre y apellidos del destinatario en lugar de mostrar el id
	        Long idDestinatario=Long.parseLong(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESTINATARIO_TAREA));
	        Usuario destinatario = proxyFactory.proxy(UsuarioApi.class).get(idDestinatario);
	        result.setDestinatario(destinatario.getApellidoNombre());
	        //Obtener nombre y apellidos del emisor en lugar de mostrar el id
	        Long idEmisor=Long.parseLong(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.EMISOR_TAREA));
	        Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(idEmisor);
	        result.setEmisor(emisor.getApellidoNombre());
	        result.setIdAsunto(idEntidad);
	        result.setSituacion("Persona");
	        result.setCodUg("9");
	        
	        //TENEMOS QUE BUSCAR, SI ESTA TAREA, TIENE UNA RESPUESTA PARA MOSTRARLA JUNTO CON LA TAREA
	        
	        Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA_ORIGINAL);
	        Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
	        Filter f3 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
	        MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
	        
	        if(infoRegistro != null){//ESQUE HAY RESPUESTA
	        	  f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA);
	              f2 = genericDao.createFilter(FilterType.EQUALS, "registro.id", infoRegistro.getRegistro().getId());
	              MEJInfoRegistro infoRegistroRespuestaTarea = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
	              if(infoRegistroRespuestaTarea != null){
	            	  result.setRespuesta(infoRegistroRespuestaTarea.getValor());
	              }
	           
	        }

	        return result;
	}

	@Override
	public boolean isValid(String tipoTarea, String codUg) {
		 if (!Checks.esNulo(tipoTarea) && !Checks.esNulo(codUg) 
				 && tipoTarea.equals(EXTSubtipoTarea.CODIGO_ANOTACION_TAREA) 
				 && codUg.equals("9")) {
	            return true;
	     }
		 return false;
	}

}
