package es.pfsgroup.recovery.panelcontrol.judicial.tareas.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.pfsgroup.recovery.panelcontrol.judicial.manager.DtoBuscarTareasPanelControl;

public interface PanelControlTareasPendientesDao {

	public Page getListaTareasPendientesVencidas(DtoBuscarTareaNotificacion dto);
	public Page getListaTareasPendientesHoy(DtoBuscarTareaNotificacion dto);
	public Page getListaTareasPendientesSemana(DtoBuscarTareaNotificacion dto);
	public Page getListaTareasPendientesMes(DtoBuscarTareaNotificacion dto);
	public Long obtenerCantidadDeTareasPendientesVencidas(DtoBuscarTareaNotificacion dto);
	public Long obtenerCantidadDeTareasPendientesHoy(DtoBuscarTareaNotificacion dto);
	public Long obtenerCantidadDeTareasPendientesSemana(DtoBuscarTareaNotificacion dto);
	public Long obtenerCantidadDeTareasPendientesMes(DtoBuscarTareaNotificacion dto);
	public Page getListaTareasByCodigo(DtoBuscarTareasPanelControl dtoBuscarTarea);
}
