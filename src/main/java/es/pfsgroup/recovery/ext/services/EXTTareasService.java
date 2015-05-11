package es.pfsgroup.recovery.ext.services;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;

public interface EXTTareasService extends Remote {

	public List<Long> obtenerCantidadDeTareasPendientesCarterizacion(
			DtoBuscarTareaNotificacion dto,
			final EXTOpcionesBusquedaTareas opcion, Usuario usuarioLogado)
			throws RemoteException;

	public List<Long> obtenerCantidadDeTareasPendientes(
			DtoBuscarTareaNotificacion dto, Usuario usuarioLogado)
			throws RemoteException;

}
