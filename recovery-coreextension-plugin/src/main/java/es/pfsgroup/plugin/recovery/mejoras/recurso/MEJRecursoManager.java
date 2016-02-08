package es.pfsgroup.plugin.recovery.mejoras.recurso;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.MEJRecursoDao;
import es.pfsgroup.plugin.recovery.mejoras.recurso.dto.MEJDtoRecurso;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class MEJRecursoManager implements MEJRecursoAPI {

	@Autowired
	private Executor executor;

	@Autowired
	private MEJRecursoDao recursoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private IntegracionBpmService integrationService;	

	@Override
	@BusinessOperation(MEJ_BO_RECURSO_GETINSTANCE)
	public MEJRecurso getInstance(Long idProcedimiento) {
		Procedimiento procedimiento = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				idProcedimiento);
		MEJRecurso recurso = new MEJRecurso();
		recurso.setProcedimiento(procedimiento);
		recurso.setAuditoria(Auditoria.getNewInstance());
		return recurso;
	}
	
	@Override
	@BusinessOperation(MEJ_IS_PARALIZADO)
	public Boolean isParalizado(Long idProcedimiento) {

		MEJProcedimiento prc = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if(prc.isEstaParalizado()){
			return true;
		}
		return false;
	}
	
	@Override
	@BusinessOperation(MEJ_IS_FINALIZADO)
	public Boolean isFinalizado(Long idProcedimiento){

		MEJProcedimiento prc = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		List<Recurso> recursos = prc.getRecursos();
		if (recursos != null || recursos.size() > 0){
			for (Recurso recurso : recursos) {
				if (!recursoFinalizado(recurso)){
					return false;
				}
			}
		}
		return true;


	}
	
	@Override
	@BusinessOperation(MEJ_BO_RECURSO_CREATE_OR_UPDATE)
	@Transactional(readOnly = false)
	public void createOrUpdate(MEJDtoRecurso dtoRecurso) {
		MEJRecurso recurso = dtoRecurso.getRecurso();
		if (recurso.getProcedimiento() != null) {
			recurso.setProcedimiento((Procedimiento) executor.execute(
					ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
					recurso.getProcedimiento().getId()));
		}
		Procedimiento procedimiento = recurso.getProcedimiento();
		boolean esGestor = proxyFactory.proxy(AsuntoApi.class).esGestor(procedimiento.getAsunto().getId()); 
		boolean esSupervisor = proxyFactory.proxy(AsuntoApi.class).esSupervisor(procedimiento.getAsunto().getId()); 
		createOrUpdateUserInfo(dtoRecurso, esGestor, esSupervisor);
	}
	
	@Override
	@BusinessOperation(MEJ_BO_RECURSO_CREATE_OR_UPDATE_USER_INFO)
	@Transactional(readOnly = false)
	public void createOrUpdateUserInfo(MEJDtoRecurso dtoRecurso, boolean esGestor, boolean esSupervisor) {

		MEJRecurso recurso = dtoRecurso.getRecurso();
		if (recurso.getSuspensivo() == null ){
			// por defecto es suspensivo
			recurso.setSuspensivo(false);
		}
		boolean recursoNuevo = recurso.getId() == null;

		if (recurso.getProcedimiento() != null) {
			recurso.setProcedimiento((Procedimiento) executor.execute(
					ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
					recurso.getProcedimiento().getId()));
		}

		if (recursoNuevo
				&& !puedeCrearRecurso(recurso.getProcedimiento().getId())) {
			throw new UserException(
					"recursoProcedimiento.excepcion.existenRecursosEnMarcha");
		}

		// Seteamos las fechas porque en el javascript no he podido hacerlo
		if (recurso.getConfirmarVista() == null || !recurso.getConfirmarVista()) {
			recurso.setFechaVista(null);
		}
		if (recurso.getConfirmarImpugnacion() == null
				|| !recurso.getConfirmarImpugnacion()) {
			recurso.setFechaImpugnacion(null);
		}

		recursoDao.saveOrUpdate(recurso);
		
		if (recursoNuevo) {
			notificarSupervisor(recurso, false);
			TareaNotificacion tar = crearTareaActualizarEstado(recurso, esGestor, esSupervisor);
			if (recurso.getSuspensivo()) {
				paralizarTareas(recurso);
			}
		}

		if (recursoFinalizado(recurso)) {
			notificarSupervisor(recurso, true);
			if (recurso.getSuspensivo()) {
				if (recurso.getProcedimiento() != null){
					
					MEJProcedimiento prc = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", recurso.getProcedimiento().getId()),
							genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
					
					//if (!prc.isEstaParalizado()){						
					activarTareas(recurso);
					//}
				}
				
			}
		}

		actualizaTareaNotificacion(recurso);
		integrationService.actualizar(recurso);
	}
	
	@Override
	@BusinessOperation(MEJ_BO_RECURSO_REVISADO)
	@Transactional(readOnly = false)
	public void recursoRevisado(MEJDtoRecurso dtoRecurso) {
		MEJRecurso recurso = dtoRecurso.getRecurso();
		
		TareaNotificacion tarea = recurso.getTareaNotificacion();

		// Recogemos las 4 fechas
		Date fechaInicio = new Date();


		// Le sumamos a la mayor 30 días y actualizamos la tarea
		fechaInicio.setTime(fechaInicio.getTime() + UN_DIA);
		Long plazo = calculaPlazoTareaActualizarEstado();
		Date fechaVenc = new Date(fechaInicio.getTime() + plazo);

		MEJTrazaDto trazaRecursoRevisado = generaTrazaRevisionRegistro(dtoRecurso,
				tarea.getFechaVenc(), fechaVenc);
		proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(
				trazaRecursoRevisado);
		
		tarea.setFechaInicio(fechaInicio);
		tarea.setFechaVenc(fechaVenc);
		tarea.setAlerta(false);

		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
				tarea);

		
	}

	public boolean puedeCrearRecurso(Long idProcedimiento) {
		Procedimiento procedimiento = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				idProcedimiento);
		for (Recurso recurso : procedimiento.getRecursos()) {
			if (recurso.getFechaResolucion() == null) {
				return false;
			}
		}
		return true;
	}

	private void notificarSupervisor(Recurso recurso,
			boolean isRecursoFinalizado) {
		// Crear una notificación al supervisor
		Long idEntidadInformacion = recurso.getProcedimiento().getId();
		String codigoTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
		String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECURSO;
		String descripcion = "Se ha interpuesto un recurso que ha interrumpido el procedimiento "
				+ recurso.getProcedimiento().getNombreProcedimiento();

		if (isRecursoFinalizado) {
			descripcion = "Se ha finalizado la interrupci�n por recurso del procedimiento  "
					+ recurso.getProcedimiento().getNombreProcedimiento();
		}

		executor.execute(
				ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION,
				idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea,
				descripcion);
	}

	private TareaNotificacion crearTareaActualizarEstado(Recurso recurso,boolean esGestor, boolean esSupervisor) {
		Procedimiento procedimiento = recurso.getProcedimiento();
		
		String idSubtipoTarea = null;

		if (esGestor) {
			idSubtipoTarea = SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR;
		} else if (esSupervisor) {
			idSubtipoTarea = SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR;
		}
		
		String descripcion = ((SubtipoTarea) executor.execute(
				ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
				idSubtipoTarea)).getDescripcionLarga();
		Long plazo = calculaPlazoTareaActualizarEstado();
		DtoGenerarTarea dto = new DtoGenerarTarea(procedimiento.getId(),
				DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, idSubtipoTarea,
				false, false, plazo, descripcion);
		Long idTarea = (Long) executor.execute(
				ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dto);

		TareaNotificacion tarea = (TareaNotificacion) executor.execute(
				ComunBusinessOperation.BO_TAREA_MGR_GET, idTarea);
		recurso.setTareaNotificacion(tarea);
		recursoDao.saveOrUpdate(recurso);
		return tarea;
	}

	private Long calculaPlazoTareaActualizarEstado() {
		// Calcular el plazo de la tarea consultando el defecto la BD
		PlazoTareasDefault plazo = (PlazoTareasDefault) executor
				.execute(
						ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
						PlazoTareasDefault.CODIGO_ACTUALIZAR_ESTADO_RECURSO);
		return plazo.getPlazo();
	}

	private void paralizarTareas(Recurso recurso) {
		Procedimiento procedimiento = recurso.getProcedimiento();

		// Si no tiene BPM asociado no se puede paralizar nada
		if (procedimiento.getProcessBPM() == null) {
			return;
		}
		executor.execute(
				ComunBusinessOperation.BO_JBPM_MGR_PARALIZAR_PROCESOS_BPM,
				procedimiento.getProcessBPM());

	}

	private boolean recursoFinalizado(Recurso recurso) {
		return recurso.getFechaResolucion() != null
				&& recurso.getResultadoResolucion() != null;
	}

	private void activarTareas(Recurso recurso) {
		Procedimiento procedimiento = recurso.getProcedimiento();

		// Si no tiene BPM asociado no se puede activar nada
		if (procedimiento.getProcessBPM() == null) {
			return;
		}

		// Agregamos al BPM la fecha de activaci�n
		Map<String, Object> hVariables = new HashMap<String, Object>();
		hVariables.put(BPMContants.FECHA_ACTIVACION_TAREAS, recurso
				.getFechaResolucion());
		executor.execute(
				ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS,
				procedimiento.getProcessBPM(), hVariables);

		executor.execute(
				ComunBusinessOperation.BO_JBPM_MGR_ACTIVAR_PROCESOS_BPM,
				procedimiento.getProcessBPM());

	}

	private static final long UN_DIA = 30 * 24 * 60 * 60 * 1000L;

	private void actualizaTareaNotificacion(Recurso recurso) {
		TareaNotificacion tarea = recurso.getTareaNotificacion();

		// Recogemos las 4 fechas
		Date fechaInicio = new Date();
		Date hoy = new Date();

		fechaInicio.setTime(recurso.getFechaRecurso().getTime());
		Date fechaImpugnacion = recurso.getFechaImpugnacion();
		Date fechaResolucion = recurso.getFechaResolucion();
		Date fechaVista = recurso.getFechaVista();

		// Comprobamos cual de ellas es mayor
		if (fechaImpugnacion != null && fechaInicio.before(fechaImpugnacion)) {
			fechaInicio.setTime(fechaImpugnacion.getTime());
		}
		if (fechaResolucion != null && fechaInicio.before(fechaResolucion)) {
			fechaInicio.setTime(fechaResolucion.getTime());
		}
		if (fechaVista != null && fechaInicio.before(fechaVista)) {
			fechaInicio.setTime(fechaVista.getTime());
		}

		// Le sumamos a la mayor 30 días y actualizamos la tarea
		fechaInicio.setTime(fechaInicio.getTime() + UN_DIA);
		Long plazo = calculaPlazoTareaActualizarEstado();
		Date fechaVenc = new Date(fechaInicio.getTime() + plazo);

		tarea.setFechaInicio(fechaInicio);
		tarea.setFechaVenc(fechaVenc);
		
		if (hoy.after(fechaVenc)){
			tarea.setAlerta(false);
		}

		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
				tarea);
		
		// Si tiene resoluci�n, no es necesario que exista la tarea, la
		// finalizamos
		if (fechaResolucion != null) {
			executor
					.execute(
							ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID,
							tarea.getId());
		}
	}
	
	private MEJTrazaDto generaTrazaRevisionRegistro(
			MEJDtoRecurso dto, Date fechaVencimientoOriginal, Date fechaVencimientoFinal) {

		Map<String, Object> informacion = new HashMap<String, Object>();
		informacion
				.put(
						MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_ID_RECURSO,
						dto.getRecurso().getId());
		informacion
				.put(
						MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_ID_TAREA_NOTIFICACION,
						dto.getRecurso().getTareaNotificacion().getId());
		informacion
				.put(
						MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_VENCIMIENTO_INICIAL,
						fechaVencimientoOriginal);
		informacion
		.put(
				MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_VENCIMIENTO_FINAL,
				fechaVencimientoFinal);
		informacion
		.put(
				MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_REVISION_RECURSO,
				new Date());

		Map<String, Object> datosTraza = new HashMap<String, Object>();
		datosTraza.put(MEJTrazaDto.ID_UNIDAD_GESTION, dto.getRecurso().getProcedimiento().getId());
		datosTraza.put(MEJTrazaDto.TIPO_EVENTO,
				MEJDDTipoRegistro.CODIGO_REVISION_RECURSO);
		datosTraza.put(MEJTrazaDto.TIPO_UNIDAD_GESTION, 5);
		datosTraza.put(MEJTrazaDto.USUARIO, proxyFactory.proxy(
				UsuarioApi.class).getUsuarioLogado().getId());
		datosTraza.put(MEJTrazaDto.INFORMACION_ADICIONAL, informacion);

		MEJTrazaDto traza = DynamicDtoUtils.create(
				MEJTrazaDto.class, datosTraza);
		return traza;
	}

	public MEJRecurso getRecursoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		MEJRecurso recurso = genericDao.get(MEJRecurso.class, filtro);
		return recurso;
	}

	public void prepareGuid(MEJRecurso recurso) {
		if (Checks.esNulo(recurso.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(getRecursoByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			recurso.setGuid(guid);
		}
		recursoDao.saveOrUpdate(recurso);
	}
	
}
