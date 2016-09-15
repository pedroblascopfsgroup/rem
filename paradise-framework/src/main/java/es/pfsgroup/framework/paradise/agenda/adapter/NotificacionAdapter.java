package es.pfsgroup.framework.paradise.agenda.adapter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.dao.NotificacionDao;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionRespuestaTarea;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacionUsuario;

@Service
public class NotificacionAdapter {
    
    @Autowired
    private NotificacionDao notificacionDao;
    
    @Autowired
    private RecoveryAnotacionApi recoveryAnotacionApi;
    
    @Autowired
    private TareaNotificacionApi tareaNotificacionApi;
    
    @Autowired
    private GenericABMDao genericDao;
    
    public Object findOne(Long id) {
    	return notificacionDao.findOne(id);
    }
    
	public Notificacion saveNotificacion(Notificacion notificacion) throws ParseException
	{
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;
		
		if(!Checks.esNulo(notificacion.getStrFecha()))
			fecha = formato.parse(notificacion.getStrFecha());
		else{
			if(!Checks.esNulo(notificacion.getFecha()))
				fecha = notificacion.getFecha();
		}
		
		DtoCrearAnotacion serviceDto = new DtoCrearAnotacion();
		List<String> listaDireccionesCc = new ArrayList<String>();
		List<String> listaDireccionesPara = new ArrayList<String>();
		
		List<DtoCrearAnotacionUsuario> listaUsuarios = new ArrayList<DtoCrearAnotacionUsuario>();
		DtoCrearAnotacionUsuario du = new DtoCrearAnotacionUsuario();
		du.setId(notificacion.getDestinatario());
		du.setFecha(fecha);
		du.setIncorporar(true);
		listaUsuarios.add(du);
		serviceDto.setUsuarios(listaUsuarios);
		
		serviceDto.setTipoAnotacion("A");
		serviceDto.setCuerpoEmail(notificacion.getDescripcion());
		serviceDto.setAsuntoMail(notificacion.getTitulo());
		serviceDto.setDireccionesMailCc(listaDireccionesCc);
		serviceDto.setDireccionesMailPara(listaDireccionesPara);

		serviceDto.setIdUg(notificacion.getIdActivo());
		serviceDto.setCodUg("61");
		
		recoveryAnotacionApi.createAnotacion(serviceDto);
		
		return notificacion;
	}
	
	 public Boolean saveNotificacionRespuesta(Map<String,String[]> valores){
	    	
	    	DtoCrearAnotacionRespuestaTarea dto = new DtoCrearAnotacionRespuestaTarea();
			//Map m= request.getParameterMap();
			Set s = valores.entrySet();
			Iterator it = s.iterator();
			while (it.hasNext()) {
				@SuppressWarnings("unchecked")
				Map.Entry<String, String[]> entry = (Map.Entry<String, String[]>) it.next();
				String key = entry.getKey();
				String[] value = entry.getValue();

				if (key.equals("idTarea")) dto.setIdTarea(new Long(value[0]));
				if (key.equals("idAsunto")) dto.setIdUg(new Long(value[0]));
				if (key.equals("codUg")) dto.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_ACTIVO);
				if (key.equals("respuesta")) dto.setRespuesta(value[0]);
			}
			
			
			TareaNotificacion tarea = tareaNotificacionApi.get(dto.getIdTarea());
			tarea.setFechaFin(new Date());
			tarea.setTareaFinalizada(true);
			
			tareaNotificacionApi.saveOrUpdate(tarea);
			
			String emisorTarea = tarea.getEmisor();
			
			Usuario emisor = genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS,"username", emisorTarea),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			Long idEmisor=emisor.getId();
			dto.setIdUsuarioEmisor(idEmisor);
	       	
			recoveryAnotacionApi.createRespuesta(dto);
			
	    	return true;
	    }
	 
	 public Boolean finalizarNotificacion(Long idTarea){
		 
		 tareaNotificacionApi.finalizarNotificacion(idTarea);
		 
		 return true;
	 }
}
