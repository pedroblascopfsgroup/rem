package es.pfsgroup.recovery.ext.services;

import java.io.Serializable;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;

@Service(value = "extTareasService")
public class EXTTareasServiceImpl implements EXTTareasService, Serializable {

	private static final long serialVersionUID = 8152327707368725881L;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private VTARBusquedaOptimizadaTareasDao vtarBusquedaOptimizadaTareasDao;

	@Autowired
	private EXTTareaNotificacionDao extTareaNotificacionDao;

    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;

	public EXTTareasServiceImpl() throws RemoteException {
		super();
	}

	@Override
	public List<Long> obtenerCantidadDeTareasPendientesCarterizacion(
			DtoBuscarTareaNotificacion dto,
			final EXTOpcionesBusquedaTareas opcion, Usuario usuarioLogado)
			throws RemoteException {
		
		System.out.println("[Negocio---EXTTareasServiceImpl:obtenerCantidadDeTareasPendientesCarterizacion] Entrando: " + new Date());

		List<Long> result = new ArrayList<Long>();
		List<Perfil> perfiles = usuarioLogado.getPerfiles();
		List<DDZona> zonas = usuarioLogado.getZonas();
		dto.setZonas(zonas);
		dto.setPerfiles(perfiles);
		dto.setUsuarioLogado(usuarioLogado);
		dto.setCodigoTipoTarea(TipoTarea.TIPO_TAREA);
		Long cuentaPendiente = cuentaTareasPendientes(dto, usuarioLogado,
				opcion);
		dto.setEnEspera(true);
		Long cuentaEnEspera = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		dto.setEnEspera(false);
		dto.setEsAlerta(true);
		Long cuentaAlerta = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		dto.setEsAlerta(false);
		dto.setCodigoTipoTarea(TipoTarea.TIPO_NOTIFICACION);
		Long cuentaNotificaciones = cuentaTareasPendientes(dto, usuarioLogado,
				opcion);
		result.add(cuentaPendiente);
		result.add(cuentaEnEspera);
		result.add(cuentaNotificaciones);
		result.add(cuentaAlerta);

		System.out.println("[Negocio---EXTTareasServiceImpl:obtenerCantidadDeTareasPendientesCarterizacion] Saliendo: " + new Date());

		return result;
	}

	@Override
	public List<Long> obtenerCantidadDeTareasPendientes(
			DtoBuscarTareaNotificacion dto, Usuario usuarioLogado) throws RemoteException {

		System.out.println("[Negocio---EXTTareasServiceImpl:obtenerCantidadDeTareasPendientes] Entrando: " + new Date());

        List<Long> result = new ArrayList<Long>();
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        List<DDZona> zonas = usuarioLogado.getZonas();
        dto.setZonas(zonas);
        dto.setPerfiles(perfiles);
        dto.setUsuarioLogado(usuarioLogado);
        dto.setCodigoTipoTarea(TipoTarea.TIPO_TAREA);
        Long cuentaPendiente = tareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto);
        dto.setEnEspera(true);
        Long cuentaEnEspera = tareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto);
        dto.setEnEspera(false);
        dto.setEsAlerta(true);
        Long cuentaAlerta = tareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto);
        dto.setEsAlerta(false);
        dto.setCodigoTipoTarea(TipoTarea.TIPO_NOTIFICACION);
        Long cuentaNotificaciones = tareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto);
        result.add(cuentaPendiente);
        result.add(cuentaEnEspera);
        result.add(cuentaNotificaciones);
        result.add(cuentaAlerta);

		System.out.println("[Negocio---EXTTareasServiceImpl:obtenerCantidadDeTareasPendientes] Saliendo: " + new Date());
        return result;

	}

	//TODO Búsqueda optimizada
	private Long cuentaTareasPendientes(final DtoBuscarTareaNotificacion dto, final Usuario usuarioLogado, final EXTOpcionesBusquedaTareas opcion) {
		boolean conCarterizacion = false;
		if (opcion != null) {
			switch (opcion.getTipoOpcion()) {
			case EXTOpcionesBusquedaTareas.Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA:
				conCarterizacion = true;
				break;
			}
		}
		
		Long cuenta = 0L;
		// Elegimos la búsqueda de tareas optimizada si el usuario tiene activada la opcion
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(
				EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), usuarioLogado)){
			cuenta = vtarBusquedaOptimizadaTareasDao.obtenerCantidadDeTareasPendientes(dto, conCarterizacion, usuarioLogado);
		}else{
			cuenta = extTareaNotificacionDao.obtenerCantidadDeTareasPendientes(dto, conCarterizacion, usuarioLogado);
		}
		return cuenta;
	}

}
