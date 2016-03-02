package es.pfsgroup.recovery.ext.impl.tareas;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.EXTAbstractTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTDtoGenerarTareaIdividualizada;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;
import es.pfsgroup.recovery.ext.services.EXTRemoteServicesScan;

@Component
public class EXTTareasManager extends EXTAbstractTareaNotificacionManager
		implements EXTTareasApi {

	private static final TipoCalculo TIPO_CALCULO_FECHA_POR_DEFECTO = TipoCalculo.TODO;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private EXTModelClassFactory modelClassFactory;

	@Autowired
	private EXTRemoteServicesScan serviciosRemotos;
	
	@Override
	public String managerName() {
		return "tareaNotificacionManager";
	}

	@Override
	@Transactional
	@BusinessOperation(EXTTareasApi.EXT_CREAR_TAREA_INDIVIDUALIZADA)
	public Long crearTareaNotificacionIndividualizada(
			EXTDtoGenerarTareaIdividualizada dtoGenerarTarea)
			throws EXTCrearTareaException {

		DtoGenerarTarea dto = dtoGenerarTarea.getTarea();

		Usuario usuario = (Usuario) getExecutor().execute(
				ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET,
				dtoGenerarTarea.getDestinatario());

		if (usuario == null)
			throw new EXTCrearTareaException(
					EXTCrearTareaException.ERR_CREAR_TAREA_USER_NOT_FOUND);

		SubtipoTarea subtipoTarea = getSubtipoTarea(dto.getSubtipoTarea());

		if (subtipoTarea == null)
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTareaInexistente",
					dto.getSubtipoTarea());

		if (TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea()
				.getCodigoTarea()))
			return crearTarea(dtoGenerarTarea, dto, usuario);

		else if (TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea()
				.getCodigoTarea()))
			return crearNotificacion(dto.getIdEntidad(),
					dto.getCodigoTipoEntidad(), dto.getSubtipoTarea(),
					dto.getDescripcion(), usuario);
		else
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTarea.notificacionIncorrecta",
					subtipoTarea.getTipoTarea().getCodigoTarea());
	}

	@Override
	@BusinessOperation(EXT_BUSCAR_TAREAS_PENDIENTES_DELEGATOR)
	@Transactional
	public Page buscarTareasPendientesDelegator(DtoBuscarTareaNotificacion dto) {
		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(
				EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas(), u)) {
			return proxyFactory.proxy(EXTTareasApi.class)
					.buscarTareasPendientesConCarterizacion(dto);
		} else {
			 Page page = (Page) getExecutor().execute(
					ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE,
					dto);
			 page.getResults();
			 return page;
		}
	}

	@Override
	@Transactional
	@BusinessOperation(EXT_OBTENER_CANT_TAREAS_PENDIENTES_DELEGATOR)
	public List<Long> obtenerCantidadDeTareasPendientesDelegator(
			DtoBuscarTareaNotificacion dto) {

		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(
				EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas(), u)) {
			return proxyFactory.proxy(EXTTareasApi.class)
					.obtenerCantidadDeTareasPendientesCarterizacion(dto);
		} else {
			return proxyFactory.proxy(TareaNotificacionApi.class)
					.obtenerCantidadDeTareasPendientes(dto);
		}

//		System.out.println("[Presentacion---EXTTareasManager:obtenerCantidadDeTareasPendientesDelegator] Entrando...");
//
//		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
//		
//		EXTTareasService servicio = serviciosRemotos.getTareasService();
//		System.out.println("[Presentacion---EXTTareasManager:obtenerCantidadDeTareasPendientesDelegator] Despues de getTareasService " + servicio);
//		
//		List<Long> lista = null;
//		try {
//			EXTOpcionesBusquedaTareas opcion = EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas();
//			if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(opcion, u)) {
//				//return proxyFactory.proxy(EXTTareasApi.class).obtenerCantidadDeTareasPendientesCarterizacion(dto);
//				lista = servicio.obtenerCantidadDeTareasPendientesCarterizacion(dto, opcion, u);
//				System.out.println("[Presentacion---EXTTareasManager:obtenerCantidadDeTareasPendientesDelegator] Despues de obtenerCantidadDeTareasPendientesCarterizacion " + lista);
//			} else {
//				//return proxyFactory.proxy(TareaNotificacionApi.class).obtenerCantidadDeTareasPendientes(dto);
//				lista = servicio.obtenerCantidadDeTareasPendientes(dto, u);
//				System.out.println("[Presentacion---EXTTareasManager:obtenerCantidadDeTareasPendientesDelegator] Despues de obtenerCantidadDeTareasPendientes " + lista);
//			}
//		} catch (RemoteException e) {
//			e.printStackTrace();
//		}
//		return lista;

	}

	@Override
	@BusinessOperation(EXT_BUSCAR_TAREAS_PENDIENTES_CARTERIZACION)
	@Transactional
	public Page buscarTareasPendientesConCarterizacion(
			final DtoBuscarTareaNotificacion dto) {
		final Class<? extends ResultadoBusquedaTareasBuzonesDto> modelClass = modelClassFactory.getModelFor(EXT_BUSCAR_TAREAS_PENDIENTES_CARTERIZACION, ResultadoBusquedaTareasBuzonesDto.class);;
        return busquedaGenericaTareas(dto,
				EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas(), modelClass);
	}

	@Override
	@BusinessOperation(EXT_OBTENER_CANT_TAREAS_PENDIENTES_CARTERIZACION)
	@Transactional
	public List<Long> obtenerCantidadDeTareasPendientesCarterizacion(
			DtoBuscarTareaNotificacion dto) {
		List<Long> result = obtenerCantidadDeTareasPendientesGenerico(dto,
				EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas());
		return result;
	}

	private Long crearTarea(EXTDtoGenerarTareaIdividualizada dtoGenerarTarea,
			DtoGenerarTarea dto, Usuario usuario) {
		EXTTareaNotificacion tarea = new EXTTareaNotificacion();
		String codigoSubtarea = dto.getSubtipoTarea();
		SubtipoTarea subtipoTarea = getSubtipoTarea(codigoSubtarea);
		TipoCalculo tipoCalculo = dtoGenerarTarea.getTipoCalculo();
		// if (dto instanceof EXTDtoGenerarTarea) {
		// EXTDtoGenerarTarea sandto = (EXTDtoGenerarTarea) dto;
		// tipoCalculo = sandto.getTipoCalculo();
		// }
		if (subtipoTarea == null) {
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTareaInexistente",
					dto.getSubtipoTarea());
		}
		if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea()
				.getCodigoTarea())) {
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTarea.notificacionIncorrecta",
					dto.getSubtipoTarea());
		}

		tarea.setEspera(dto.isEnEspera());
		tarea.setAlerta(dto.isEsAlerta());
		tarea.setFechaVenc(dto.getFecha());
		tarea.setFechaVencReal(dto.getFecha());
		return saveNotificacionTarea(tarea, subtipoTarea, dto.getIdEntidad(),
				dto.getCodigoTipoEntidad(), dto.getPlazo(),
				dto.getDescripcion(), tipoCalculo, usuario);
	}

	public Long crearNotificacion(Long idEntidadInformacion,
			String idTipoEntidadInformacion, String codigoSubtipoTarea,
			String descripcion, Usuario usuario) {
		EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
		SubtipoTarea subtipoTarea = getSubtipoTarea(codigoSubtipoTarea);
		if (subtipoTarea == null) {
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTareaInexistente",
					codigoSubtipoTarea);
		}
		if (!TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea()
				.getCodigoTarea())) {
			throw new GenericRollbackException(
					"tareaNotificacion.subtipoTarea.notificacionIncorrecta",
					codigoSubtipoTarea);
		}
		notificacion.setEspera(Boolean.FALSE);
		notificacion.setAlerta(Boolean.FALSE);
		return saveNotificacionTarea(notificacion, subtipoTarea,
				idEntidadInformacion, idTipoEntidadInformacion, null,
				descripcion, TipoCalculo.TODO, usuario);
	}

	private SubtipoTarea getSubtipoTarea(String codigoSubtarea) {
		return genericDao.get(SubtipoTarea.class, genericDao.createFilter(
				FilterType.EQUALS, "codigoSubtarea", codigoSubtarea));
	}

	private Long saveNotificacionTarea(EXTTareaNotificacion notificacionTarea,
			SubtipoTarea subtipoTarea, Long idEntidad,
			String codigoTipoEntidad, Long plazo, String descripcion,
			TipoCalculo tipoCalculo, Usuario destinatario) {

		notificacionTarea.setTarea(subtipoTarea.getDescripcion());

		if (descripcion == null || descripcion.length() == 0) {
			notificacionTarea.setDescripcionTarea(subtipoTarea
					.getDescripcionLarga());
		} else {
			notificacionTarea.setDescripcionTarea(descripcion);
		}

		notificacionTarea.setCodigoTarea(subtipoTarea.getTipoTarea()
				.getCodigoTarea());
		notificacionTarea.setSubtipoTarea(subtipoTarea);
		DDTipoEntidad tipoEntidad = (DDTipoEntidad) getExecutor().execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDTipoEntidad.class, codigoTipoEntidad);
		notificacionTarea.setTipoEntidad(tipoEntidad);
		Date ahora = new Date(System.currentTimeMillis());
		notificacionTarea.setFechaInicio(ahora);
		if (plazo != null) {
			// Date aux = new Date(ahora.getTime());
			// Calendar c = new GregorianCalendar();
			// c.setTime(aux);
			// Long plazoSegundos = plazo/1000;
			// c.add(Calendar.SECOND, plazoSegundos.intValue());
			Date fin = new Date(System.currentTimeMillis() + plazo);
			if (tipoCalculo == null) {
				tipoCalculo = TIPO_CALCULO_FECHA_POR_DEFECTO;
			}
			notificacionTarea.setVencimiento(VencimientoUtils.getFecha(fin,
					tipoCalculo));
		}

		notificacionTarea
				.setTipoDestinatario(EXTTareaNotificacion.CODIGO_DESTINATARIO_USUARIO);
		notificacionTarea.setDestinatarioTarea(destinatario);

		Usuario usuLogado = (Usuario) getExecutor()
				.execute(
						ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		notificacionTarea.setEmisor(usuLogado.getUsername());

		// Seteo la entidad en el campo que corresponda
		decodificarEntidadInformacion(idEntidad, codigoTipoEntidad,
				notificacionTarea);
		return genericDao.save(EXTTareaNotificacion.class, notificacionTarea)
				.getId();

	}

	private void decodificarEntidadInformacion(Long idEntidad,
			String codigoTipoEntidad, EXTTareaNotificacion tareaNotificacion) {
		try {
			if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codigoTipoEntidad)) {
				Asunto asu = (Asunto) getExecutor().execute(
						ExternaBusinessOperation.BO_ASU_MGR_GET, idEntidad);

				tareaNotificacion.setAsunto(asu);
				tareaNotificacion
						.setEstadoItinerario(asu.getEstadoItinerario());

			}
			// A PARTIR DE AQU� ES A�ADIDO
			else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO
					.equals(codigoTipoEntidad)) {
				System.out.println("Entra  a decodificar contrato");
				EXTContrato cnt = genericDao.get(EXTContrato.class, genericDao
						.createFilter(FilterType.EQUALS, "id", idEntidad),
						genericDao.createFilter(FilterType.EQUALS,
								"auditoria.borrado", false));
				System.out.println(cnt);
				tareaNotificacion.setContrato(cnt);

			} else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
					.equals(codigoTipoEntidad)) {
				Expediente exp = (Expediente) getExecutor().execute(
						InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE,
						idEntidad);

				tareaNotificacion.setExpediente(exp);
				tareaNotificacion
						.setEstadoItinerario(exp.getEstadoItinerario());

			} else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE
					.equals(codigoTipoEntidad)) {
				Cliente cli = (Cliente) getExecutor().execute(
						PrimariaBusinessOperation.BO_CLI_MGR_GET, idEntidad);

				if(cli != null){
					tareaNotificacion.setCliente(cli);
					if(cli.getEstadoItinerario()!=null){
						tareaNotificacion
								.setEstadoItinerario(cli.getEstadoItinerario());
					}
				}
			} else if ("9" //ENTIDAD PERSONA
					.equals(codigoTipoEntidad)) {
				Persona per = (Persona) getExecutor().execute(
						PrimariaBusinessOperation.BO_PER_MGR_GET, idEntidad);

				if(per != null){
					tareaNotificacion.setPersona(per);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
