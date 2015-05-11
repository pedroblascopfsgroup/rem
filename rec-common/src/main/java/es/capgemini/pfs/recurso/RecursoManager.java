package es.capgemini.pfs.recurso;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.recurso.dao.RecursoDao;
import es.capgemini.pfs.recurso.dto.DtoRecurso;
import es.capgemini.pfs.recurso.model.Recurso;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * PONER JAVADOC FO.
 * @author FO
 *
 */
@Service
public class RecursoManager {

    @Autowired
    private Executor executor;

    @Autowired
    private RecursoDao recursoDao;

    /**
     * get recuros.
     * @param idProcedimiento id
     * @return recurso
     */
    @BusinessOperation
    public List<Recurso> getRecursosPorProcedimiento(Long idProcedimiento) {
        return recursoDao.getRecursosPorProcedimiento(idProcedimiento);
    }

    /**
     * PONER JAVADOC.
     * @param id ID
     * @return RECURSO
     */
    @BusinessOperation(ExternaBusinessOperation.BO_RECURSO_GET)
    public Recurso get(Long id) {
        return recursoDao.get(id);
    }

    /**
     * PONER JAVADOC.
     * @param idProcedimiento ID
     * @return RECURSO
     */
    @BusinessOperation(ExternaBusinessOperation.BO_RECURSO_GET_INSTANCE)
    public Recurso getInstance(Long idProcedimiento) {
        Procedimiento procedimiento = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
        Recurso recurso = new Recurso();
        recurso.setProcedimiento(procedimiento);
        recurso.setAuditoria(Auditoria.getNewInstance());
        return recurso;
    }

    /** si hay algï¿½n recurso sin finalizar, no podemos crear uno nuevo.
     * @param idProcedimiento id
     * @return boleano
     */
    @BusinessOperation
    public boolean puedeCrearRecurso(Long idProcedimiento) {
        Procedimiento procedimiento = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
        for (Recurso recurso : procedimiento.getRecursos()) {
            if (recurso.getFechaResolucion() == null) { return false; }
        }
        return true;
    }

    /**
     * PONER JAVADOC.
     * @param dtoRecurso dto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_RECURSO_CREATE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void createOrUpdate(DtoRecurso dtoRecurso) {

        Recurso recurso = dtoRecurso.getRecurso();
        boolean recursoNuevo = recurso.getId() == null;

        if (recurso.getProcedimiento() != null) {
            recurso.setProcedimiento((Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, recurso
                    .getProcedimiento().getId()));
        }

        if (recursoNuevo && !puedeCrearRecurso(recurso.getProcedimiento().getId())) { throw new UserException(
                "recursoProcedimiento.excepcion.existenRecursosEnMarcha"); }

        //Seteamos las fechas porque en el javascript no he podido hacerlo
        if (recurso.getConfirmarVista() == null || !recurso.getConfirmarVista()) {
            recurso.setFechaVista(null);
        }
        if (recurso.getConfirmarImpugnacion() == null || !recurso.getConfirmarImpugnacion()) {
            recurso.setFechaImpugnacion(null);
        }

        recursoDao.saveOrUpdate(recurso);

        if (recursoNuevo) {
            notificarSupervisor(recurso, false);
            crearTareaActualizarEstado(recurso);
            paralizarTareas(recurso);
        }

        if (recursoFinalizado(recurso)) {
            notificarSupervisor(recurso, true);
            activarTareas(recurso);
        }

        actualizaTareaNotificacion(recurso);
    }

    private void crearTareaActualizarEstado(Recurso recurso) {
        Procedimiento procedimiento = recurso.getProcedimiento();

        Long idGestor = procedimiento.getAsunto().getGestor().getUsuario().getId();
        Long idSupervisor = procedimiento.getAsunto().getSupervisor().getUsuario().getId();

        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

        Long idUsuarioLogado = usuarioLogado.getId();

        String idSubtipoTarea = null;

        if (idUsuarioLogado.equals(idGestor)) {
            idSubtipoTarea = SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR;
        } else if (idUsuarioLogado.equals(idSupervisor)) {
            idSubtipoTarea = SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR;
        }

        String descripcion = ((SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE, idSubtipoTarea))
                .getDescripcionLarga();
        Long plazo = calculaPlazoTareaActualizarEstado();
        DtoGenerarTarea dto = new DtoGenerarTarea(procedimiento.getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, idSubtipoTarea, false, false,
                plazo, descripcion);
        Long idTarea = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dto);

        TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTarea);
        recurso.setTareaNotificacion(tarea);
        recursoDao.saveOrUpdate(recurso);
    }

    private static final long UN_DIA = 30 * 24 * 60 * 60 * 1000L;

    private void actualizaTareaNotificacion(Recurso recurso) {
        TareaNotificacion tarea = recurso.getTareaNotificacion();

        //Recogemos las 4 fechas
        Date fechaInicio = new Date();

        fechaInicio.setTime(recurso.getFechaRecurso().getTime());
        Date fechaImpugnacion = recurso.getFechaImpugnacion();
        Date fechaResolucion = recurso.getFechaResolucion();
        Date fechaVista = recurso.getFechaVista();

        //Comprobamos cual de ellas es mayor
        if (fechaImpugnacion != null && fechaInicio.before(fechaImpugnacion)) {
            fechaInicio.setTime(fechaImpugnacion.getTime());
        }
        if (fechaResolucion != null && fechaInicio.before(fechaResolucion)) {
            fechaInicio.setTime(fechaResolucion.getTime());
        }
        if (fechaVista != null && fechaInicio.before(fechaVista)) {
            fechaInicio.setTime(fechaVista.getTime());
        }

        //Le sumamos a la mayor 30 dÃ­as y actualizamos la tarea
        fechaInicio.setTime(fechaInicio.getTime() + UN_DIA);
        Long plazo = calculaPlazoTareaActualizarEstado();
        Date fechaVenc = new Date(fechaInicio.getTime() + plazo);

        tarea.setFechaInicio(fechaInicio);
        tarea.setFechaVenc(fechaVenc);

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);

        //Si tiene resoluciï¿½n, no es necesario que exista la tarea, la finalizamos
        if (fechaResolucion != null) {
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
        }
    }

    private Long calculaPlazoTareaActualizarEstado() {
        //Calcular el plazo de la tarea consultando el defecto la BD
        PlazoTareasDefault plazo = (PlazoTareasDefault) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
                PlazoTareasDefault.CODIGO_ACTUALIZAR_ESTADO_RECURSO);
        return plazo.getPlazo();
    }

    private void notificarSupervisor(Recurso recurso, boolean isRecursoFinalizado) {
        //Crear una notificaciÃ³n al supervisor
        Long idEntidadInformacion = recurso.getProcedimiento().getId();
        String codigoTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECURSO;
        String descripcion = "Se ha interpuesto un recurso que ha interrumpido el procedimiento "
                + recurso.getProcedimiento().getNombreProcedimiento();

        if (isRecursoFinalizado) {
            descripcion = "Se ha finalizado la interrupción por recurso del procedimiento  " + recurso.getProcedimiento().getNombreProcedimiento();
        }

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea,
                descripcion);
    }

    private boolean recursoFinalizado(Recurso recurso) {
        return recurso.getFechaResolucion() != null && recurso.getResultadoResolucion() != null;
    }

    private void activarTareas(Recurso recurso) {
        Procedimiento procedimiento = recurso.getProcedimiento();

        //Si no tiene BPM asociado no se puede activar nada
        if (procedimiento.getProcessBPM() == null) { return; }

        //Agregamos al BPM la fecha de activaciï¿½n
        Map<String, Object> hVariables = new HashMap<String, Object>();
        hVariables.put(BPMContants.FECHA_ACTIVACION_TAREAS, recurso.getFechaResolucion());
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_ADD_VARIABLES_TO_PROCESS, procedimiento.getProcessBPM(), hVariables);

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_ACTIVAR_PROCESOS_BPM, procedimiento.getProcessBPM());

    }

    private void paralizarTareas(Recurso recurso) {
        Procedimiento procedimiento = recurso.getProcedimiento();

        //Si no tiene BPM asociado no se puede paralizar nada
        if (procedimiento.getProcessBPM() == null) { return; }
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_PARALIZAR_PROCESOS_BPM, procedimiento.getProcessBPM());

    }

}
