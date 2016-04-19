package es.capgemini.pfs.tareaNotificacion;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.persona.EXTPersonaApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;

public abstract class EXTAbstractTareaNotificacionManager extends BusinessOperationOverrider<TareaNotificacionApi> {
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private EXTTareaNotificacionDao extTareaNotificacionDao;

	@Autowired
	private SubtipoTareaDao subtipoTareaDao;

	@Autowired
	private VTARBusquedaOptimizadaTareasDao vtarBusquedaOptimizadaTareasDao;
	
	@Autowired
	private CoreProjectContext projectContext;
	

	protected SubtipoTareaDao getSubtipoTareaDao() {
		return subtipoTareaDao;
	}

	protected EXTTareaNotificacionDao getExtTareaNotificacionDao() {
		return extTareaNotificacionDao;
	}

	protected Executor getExecutor() {
		return executor;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Page busquedaGenericaTareas(final DtoBuscarTareaNotificacion dto, final EXTOpcionesBusquedaTareas opcion, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass) {
		EventFactory.onMethodStart(this.getClass());

		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Perfil> perfiles = new ArrayList<Perfil>(); 
		List<DDZona> zonas = new ArrayList<DDZona>();
		
		for(ZonaUsuarioPerfil zup : usuarioLogado.getZonaPerfil()) {
		
			if(projectContext.getPerfilesConsulta() != null) {
				
				if(!projectContext.getPerfilesConsulta().contains(zup.getPerfil().getCodigo())) {
				
					if(!perfiles.contains(zup.getPerfil())) {
						perfiles.add(zup.getPerfil());
					}
					
					zonas.add(zup.getZona());
				}
			}
			else {
				perfiles.add(zup.getPerfil());
				zonas.add(zup.getZona());
			}
		}
		
		dto.setPerfiles(perfiles);
		dto.setZonas(zonas);
		dto.setUsuarioLogado(usuarioLogado);
		List listaRetorno = new ArrayList();

		Page page = null;
		if (dto.getTraerGestionVencidos() != null && dto.getTraerGestionVencidos()) {
			agregarTareasGestionVencidosSeguimiento(dto, listaRetorno, opcion);

			if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), usuarioLogado))
				informarCategoriaTarea(listaRetorno);

			listaRetorno = removeTareasDuplicadas(listaRetorno);

			page = new PageSql();
			((PageSql) page).setResults(listaRetorno);
			((PageSql) page).setTotalCount(listaRetorno.size());
		} else {
			
			if(perfiles.size() > 0 && zonas.size() > 0) {
				page = obtenerTareasPendientes(dto, opcion, modelClass);
			}
			
			if (page != null) {
				listaRetorno.addAll(removeTareasDuplicadas(page.getResults()));
				
				if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), usuarioLogado))
					informarCategoriaTarea(listaRetorno);

				
				//replaceGestorInList(listaRetorno, usuarioLogado);
				//replaceSupervisorInList(listaRetorno, usuarioLogado);
				((PageHibernate) page).setResults(listaRetorno);
			} else {
				page = new Page() {

					@Override
					public int getTotalCount() {
						return 0;
					}

					@Override
					public List<?> getResults() {
						return new ArrayList();
					}
				};
			}
		}
		//castToExtTareaNotificacion(page);
		EventFactory.onMethodStop(this.getClass());
		return page;
	}

	private List removeTareasDuplicadas(final List lista) {
		final List listaRetorno = new ArrayList();
		final List<Long> listaIds = new ArrayList<Long>();
		for (Object tarea : lista) {
			try {
				Method metodoGet = tarea.getClass().getMethod("getId", null);
				final Long tarId = (Long)metodoGet.invoke(tarea, null);
				if(!listaIds.contains(tarId)){
					listaIds.add(tarId);
					listaRetorno.add(tarea);
				}
			}catch (final Exception e) {
				logger.error(e.getMessage());
				return lista;
			}
		}
		return listaRetorno;
	}

	protected List<Long> obtenerCantidadDeTareasPendientesGenerico(final DtoBuscarTareaNotificacion dto, final EXTOpcionesBusquedaTareas opcion) {
		List<Long> result = new ArrayList<Long>();
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Perfil> perfiles = usuarioLogado.getPerfiles();
		List<DDZona> zonas = usuarioLogado.getZonas();
		dto.setZonas(zonas);
		dto.setPerfiles(perfiles);
		dto.setUsuarioLogado(usuarioLogado);
		dto.setCodigoTipoTarea(TipoTarea.TIPO_TAREA);
		Long cuentaPendiente = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		dto.setEnEspera(true);
		Long cuentaEnEspera = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		dto.setEnEspera(false);
		dto.setEsAlerta(true);
		Long cuentaAlerta = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		dto.setEsAlerta(false);
		dto.setCodigoTipoTarea(TipoTarea.TIPO_NOTIFICACION);
		Long cuentaNotificaciones = cuentaTareasPendientes(dto, usuarioLogado, opcion);
		result.add(cuentaPendiente);
		result.add(cuentaEnEspera);
		result.add(cuentaNotificaciones);
		result.add(cuentaAlerta);
		return result;
	}

	/**
	 * agregarGestionVencidos.
	 * 
	 * @param dto
	 *            dtoparametro
	 * @param opcion
	 */
	protected void agregarTareasGestionVencidosSeguimiento(final DtoBuscarTareaNotificacion dto, final List<TareaNotificacion> listaRetorno, final EXTOpcionesBusquedaTareas opcion) {

		if (!dto.isEnEspera() && !dto.isEsAlerta() && TipoTarea.TIPO_TAREA.equals(dto.getCodigoTipoTarea())) {

			DDEstadoItinerario estadoItinerario = (DDEstadoItinerario) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerario.class,
					DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);

			// Comprueba si el usuario es gestor para alguno de sus perfiles en
			// el estado de GESTION DE VENCIDOS
			Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

			Boolean isGestor = (Boolean) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_EXISTE_GESTOR_BY_PERFIL, usuario.getPerfiles(), estadoItinerario);

			if (isGestor) {
				addCantidadTareasGestionVencidos(listaRetorno, opcion);
				addCantidadTareasSeguimientoSintomatico(listaRetorno, opcion);
				addCantidadTareasSeguimientoSistematico(listaRetorno, opcion);
			}
		}
	}

	private void addCantidadTareasSeguimientoSistematico(final List<TareaNotificacion> listaRetorno, final EXTOpcionesBusquedaTareas opcion) {

		Long cantidadSeguimientoSistematico = 0L;
		if (opcion != null) {
			switch (opcion.getTipoOpcion()) {
			case EXTOpcionesBusquedaTareas.Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA:
				cantidadSeguimientoSistematico = proxyFactory.proxy(EXTPersonaApi.class).obtenerCantidadDeSeguimientoSistematicoUsuarioCarterizado();
				break;
			default:
				cantidadSeguimientoSistematico = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeSeguimientoSistematicoUsuario();
				//cantidadSeguimientoSistematico = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO);
			}
		} else {
			cantidadSeguimientoSistematico = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeSeguimientoSistematicoUsuario();
			//cantidadSeguimientoSistematico = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO);
		}

		if (cantidadSeguimientoSistematico > 0) {
			TareaNotificacion tareaGV = new TareaNotificacion();
			tareaGV.setTarea("Gestion de Seguimiento Sistematico");
			tareaGV.setDescripcionTarea("Clientes a gestionar Seguimiento Sistemático: " + cantidadSeguimientoSistematico);
			tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
			tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO));
			listaRetorno.add(tareaGV);
		}
	}

	private void addCantidadTareasSeguimientoSintomatico(final List<TareaNotificacion> listaRetorno, final EXTOpcionesBusquedaTareas opcion) {

		Long cantidadSeguimientoSintomatico = 0L;
		if (opcion != null) {
			switch (opcion.getTipoOpcion()) {
			case EXTOpcionesBusquedaTareas.Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA:
				cantidadSeguimientoSintomatico = proxyFactory.proxy(EXTPersonaApi.class).obtenerCantidadDeSeguimientoSintomaticoUsuarioCarterizado();
				break;
			default:
				cantidadSeguimientoSintomatico = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeSeguimientoSintomaticoUsuario();
				//cantidadSeguimientoSintomatico = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO);
			}
		} else {
			cantidadSeguimientoSintomatico = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeSeguimientoSintomaticoUsuario();
			//cantidadSeguimientoSintomatico = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO);
		}

		if (cantidadSeguimientoSintomatico > 0) {
			TareaNotificacion tareaGV = new TareaNotificacion();
			tareaGV.setTarea("Gestion de Seguimiento Sintomatico");
			tareaGV.setDescripcionTarea("Clientes a gestionar Seguimiento Sintomático: " + cantidadSeguimientoSintomatico);
			tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
			tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO));
			listaRetorno.add(tareaGV);
		}
	}

	private void addCantidadTareasGestionVencidos(final List<TareaNotificacion> listaRetorno, final EXTOpcionesBusquedaTareas opcion) {
		Long cantidadVencidos = 0L;
		if (opcion != null) {
			switch (opcion.getTipoOpcion()) {
			case EXTOpcionesBusquedaTareas.Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA:
				cantidadVencidos = proxyFactory.proxy(EXTPersonaApi.class).obtenerCantidadDeVencidosUsuarioCarterizado();
				break;
			default:
				cantidadVencidos = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeVencidosUsuario();
				//cantidadVencidos = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO);
			}
		} else {
			cantidadVencidos = proxyFactory.proxy(PersonaApi.class).obtenerCantidadDeVencidosUsuario();
			//cantidadVencidos = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO);
		}

		if (cantidadVencidos > 0) {
			TareaNotificacion tareaGV = new TareaNotificacion();
			tareaGV.setTarea("Gestion de Vencidos");
			tareaGV.setDescripcionTarea("Clientes a gestionar vencidos: " + cantidadVencidos);
			tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
			tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_VENCIDOS));
			listaRetorno.add(tareaGV);
		}
	}

	private PageHibernate obtenerTareasPendientes(final DtoBuscarTareaNotificacion dto, final EXTOpcionesBusquedaTareas opcion, final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass) {
		boolean conCarterizacion = false;
		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (opcion != null) {
			switch (opcion.getTipoOpcion()) {
			case EXTOpcionesBusquedaTareas.Tipos.TIPO_BUSQUEDA_TAREAS_CARTERIZADA:
				conCarterizacion = true;
				break;
			}
		}
		PageHibernate p = null;
		// Elegimos la b�squeda de tareas optimizada si el usuario tiene activada la opcion
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(
				EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), u)){
            p = (PageHibernate) vtarBusquedaOptimizadaTareasDao.buscarTareasPendiente(dto, conCarterizacion, u, modelClass);
		}else{
			p = (PageHibernate) extTareaNotificacionDao.buscarTareasPendiente(dto, conCarterizacion, u);
		}
		return p;
	}

	//TODO B�squeda optimizada
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
		// Elegimos la b�squeda de tareas optimizada si el usuario tiene activada la opcion
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(
				EXTOpcionesBusquedaTareas.getBuzonesTareasOptimizados(), usuarioLogado)){
			cuenta = vtarBusquedaOptimizadaTareasDao.obtenerCantidadDeTareasPendientes(dto, conCarterizacion, usuarioLogado);
		}else{
			cuenta = getExtTareaNotificacionDao().obtenerCantidadDeTareasPendientes(dto, conCarterizacion, usuarioLogado);
		}
		return cuenta;
	}

	/**
	 * agrega la zona al gestor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	protected void replaceGestorInList(final List<TareaNotificacion> lista, final Usuario usuario) {
		for (TareaNotificacion tarea : lista) {
			if (tarea.getDescGestor() != null && tarea.getDescGestor().trim().length() > 0) {
				String descZona = "";
				if (tarea.getGestor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (tarea.getGestor().longValue() == zp.getPerfil().getId().longValue()) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescGestor(tarea.getDescGestor() + " " + descZona);
			}
		}
	}
	
	/**
	 * Rellena el campo Categoria Tarea, según las categorías definidas en ac-plugin-coreextension-projectContext.xml
	 * @param lista
	 */
	@SuppressWarnings("rawtypes")
	protected void informarCategoriaTarea(final List lista) {
		for (Object tarea : lista) {
			try {
				Method metodoGet = tarea.getClass().getMethod("getSubtipoTareaCodigoSubtarea", null);
				String subTipoTareaCodigoSubtarea = (String)metodoGet.invoke(tarea, null);
				Method metodoSet = tarea.getClass().getMethod("setCategoriaTarea", String.class);
				 
				
				for(String categoria : projectContext.getCategoriasSubTareas().keySet()) {
					if (projectContext.getCategoriasSubTareas().get(categoria).contains(subTipoTareaCodigoSubtarea))
						metodoSet.invoke(tarea, categoria);
				}
			}catch (Exception e) {}
		}
	}
	
	
	
	/**
	 * agrega la zona al gestor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	@SuppressWarnings("deprecation")
	protected void replaceGestorInListOpt(final List<ResultadoBusquedaTareasBuzonesDto> lista, final Usuario usuario) {
		for (ResultadoBusquedaTareasBuzonesDto tarea : lista) {
			if (tarea.getDescGestor() != null && tarea.getDescGestor().trim().length() > 0) {
				String descZona = "";
				if (tarea.getGestor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (tarea.getGestor().equals(zp.getPerfil().getId().toString())) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescGestor(tarea.getDescGestor() + " " + descZona);
			}
		}
	}

	/**
	 * agrega la zona al supervisor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	protected void replaceSupervisorInList(final List<TareaNotificacion> lista, final Usuario usuario) {
		for (TareaNotificacion tarea : lista) {
			EXTTareaNotificacion extTarea = (EXTTareaNotificacion) tarea;
			if (extTarea.getDescSupervisor() != null && tarea.getDescSupervisor().trim().length() > 0) {
				String descZona = "";
				if (extTarea.getSupervisor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (extTarea.getSupervisor().longValue() == zp.getPerfil().getId().longValue()) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescSupervisor(extTarea.getDescSupervisor() + " " + descZona);
			}
		}
	}
	
	/**
	 * agrega la zona al supervisor.
	 * 
	 * @param lista
	 *            lista
	 * @param zona
	 *            zona
	 */
	@SuppressWarnings("deprecation")
	protected void replaceSupervisorInListOpt(final List<ResultadoBusquedaTareasBuzonesDto> lista, final Usuario usuario) {
		for (ResultadoBusquedaTareasBuzonesDto tarea : lista) {
			if (tarea.getDescSupervisor() != null && tarea.getDescSupervisor().trim().length() > 0) {
				String descZona = "";
				if (tarea.getSupervisor() != null) {
					for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
						if (tarea.getSupervisor().equals(zp.getPerfil().getId().toString())) {
							descZona = zp.getZona().getDescripcion();
							break;
						}
					}
				}
				tarea.setDescSupervisor(tarea.getDescSupervisor() + " " + descZona);
			}
		}
	}

	protected void castToExtTareaNotificacion(final Page tareaPendientes) {
		if ((tareaPendientes != null) && (!Checks.estaVacio(tareaPendientes.getResults()))) {
			for (Object tn : tareaPendientes.getResults()) {
				if (tn instanceof EXTTareaNotificacion) {
					tn = (EXTTareaNotificacion) tn;
				}
			}
		}
	}

}
