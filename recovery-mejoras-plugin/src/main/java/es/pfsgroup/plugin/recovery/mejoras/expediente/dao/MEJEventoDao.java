package es.pfsgroup.plugin.recovery.mejoras.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

public interface MEJEventoDao extends AbstractDao<TareaNotificacion, Long> {

	 public List<TareaNotificacion> getTareasAsunto(Long idAsunto);

	public List<TareaNotificacion> getComunicacionesAsunto(Long idAsunto);
	
	public List<TareaNotificacion> getComunicacionesProcedimiento(Long idProcedimiento);
	
	 public List<TareaNotificacion> getTareasPersona(Long idPersona);
	 
	 public List<TareaNotificacion> getTareasExpediente(Long idExpediente);
	 
	 public void deletePersonaExpediente(Long idExpediente,Long idPersona);

}
