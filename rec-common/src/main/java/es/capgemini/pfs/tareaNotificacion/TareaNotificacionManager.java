package es.capgemini.pfs.tareaNotificacion;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.dao.ComunicacionBPMDao;
import es.capgemini.pfs.tareaNotificacion.dao.PlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.dto.DtoTareaNotificaciones;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;

/**
 * Manager de Notificaciones.
 * @author pamuller
 *
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class TareaNotificacionManager {

    private static final Long UN_DIA = 1000L * 60L * 60L * 24L;

    @Autowired
    private Executor executor;

    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;

    @Autowired
    private SubtipoTareaDao subtipoTareaDao;

    @Autowired
    private ComunicacionBPMDao comunicacionBPMDao;

    @Autowired
    private PlazoTareasDefaultDao plazoTareasDefaultDao;

    private final int maxlength = 49;

    /**
     * Crea una notificación para un expediente.
     * @param idEntidadInformacion el id de la entidad que genera la notificación.
     * @param idTipoEntidadInformacion indica a que tipo de entidad corresponde el id anterior.
     * @param codigoSubtipoTarea el código de la notificacion a insertar.
     * @param descripcion descripcion
     * @return el id de la notificación que se creó.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION)
    public Long crearNotificacion(Long idEntidadInformacion, String idTipoEntidadInformacion, String codigoSubtipoTarea, String descripcion) {
        TareaNotificacion notificacion = new TareaNotificacion();
        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(codigoSubtipoTarea);
        if (subtipoTarea == null) { throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", codigoSubtipoTarea); }
        if (!TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) { throw new GenericRollbackException(
                "tareaNotificacion.subtipoTarea.notificacionIncorrecta", codigoSubtipoTarea); }
        notificacion.setEspera(Boolean.FALSE);
        notificacion.setAlerta(Boolean.FALSE);
        return saveNotificacionTarea(notificacion, subtipoTarea, idEntidadInformacion, idTipoEntidadInformacion, null, descripcion);
    }

    /**
     * Crea una tarea.
     * @param dto DtoGenerarTarea.
     * @return el id de la tarea creada
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA)
    public Long crearTarea(DtoGenerarTarea dto) {
        TareaNotificacion tarea = new TareaNotificacion();
        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(dto.getSubtipoTarea());
        if (subtipoTarea == null) { throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", dto.getSubtipoTarea()); }
        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) { throw new GenericRollbackException(
                "tareaNotificacion.subtipoTarea.notificacionIncorrecta", dto.getSubtipoTarea()); }

        tarea.setEspera(dto.isEnEspera());
        tarea.setAlerta(dto.isEsAlerta());
        return saveNotificacionTarea(tarea, subtipoTarea, dto.getIdEntidad(), dto.getCodigoTipoEntidad(), dto.getPlazo(), dto.getDescripcion());
    }

    /**
     * Crea una tarea.
     * @param dtoGenerarTarea dto de tare notificaciones
     * @return el id de la tarea creada
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_COMUNICACION)
    public Long crearTareaComunicacion(DtoGenerarTarea dtoGenerarTarea) {
        if (dtoGenerarTarea.getIdTareaAsociada() != null) {
            //Respondo la tarea
            return responderComunicacion(dtoGenerarTarea);
        }

        if (SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR.equals(dtoGenerarTarea.getSubtipoTarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR.equals(dtoGenerarTarea.getSubtipoTarea())) {
            //Envio una comunicacion de tipo solo Ida.
            return (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, dtoGenerarTarea.getIdEntidad(), dtoGenerarTarea
                    .getCodigoTipoEntidad(), dtoGenerarTarea.getSubtipoTarea(), dtoGenerarTarea.getDescripcion());
            //return crearNotificacion(dtoGenerarTarea.getIdEntidad(), dtoGenerarTarea.getCodigoTipoEntidad(), dtoGenerarTarea.getSubtipoTarea(),
            //        dtoGenerarTarea.getDescripcion());
        }
        //Envio una comunicacion esperando respuesta. La misma genera un proceso bpm.
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, dtoGenerarTarea.getIdEntidad());
        param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, dtoGenerarTarea.getCodigoTipoEntidad());
        param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, dtoGenerarTarea.getSubtipoTarea());
        Long plazo = dtoGenerarTarea.getFecha().getTime() - new Date().getTime();
        param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazo);
        ComunicacionBPM comunicacion = new ComunicacionBPM();
        param.put(TareaBPMConstants.COMUNICACION_BPM, comunicacion);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);

        Long idComu = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_COMUNICACION_BPM, comunicacion);
        //Long idComu = saveComunicacionBPM(comunicacion);

        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);

        Long idTareaAsociada = (Long) executor
                .execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid, TareaBPMConstants.ID_TAREA);

        TareaNotificacion tarea = get(idTareaAsociada);

        //param.put(TareaBPMConstants.DESCRIPCION_TAREA, dtoGenerarTarea.getDescripcion());
        tarea.setDescripcionTarea(dtoGenerarTarea.getDescripcion());
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
        //saveOrUpdate(tarea);

        comunicacion.setIdBPM(bpmid);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM, comunicacion);
        //saveOrUpdateComunicacionBPM(comunicacion);
        return idComu;
    }

    /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     * @return id
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_SAVE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public Long saveComunicacionBPM(ComunicacionBPM comu) {
        return comunicacionBPMDao.save(comu);
    }

    /**
     * save de la comunicacion bpm.
     * @param comu comunucaion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public void saveOrUpdateComunicacionBPM(ComunicacionBPM comu) {
        comunicacionBPMDao.saveOrUpdate(comu);
    }

    /**
     * responde una cominicacion.
     * @param dtoGenerarTarea dto
     * @return comunicacion
     */
    private Long responderComunicacion(DtoGenerarTarea dtoGenerarTarea) {
        TareaNotificacion tareaOriginal = this.get(dtoGenerarTarea.getIdTareaAsociada());
        if (tareaOriginal.getComunicacionBPM() != null && tareaOriginal.getComunicacionBPM().getIdBPM() != null) {
            Long idBPM = tareaOriginal.getComunicacionBPM().getIdBPM();
            try {
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
            } catch (IllegalStateException ex) {
                throw new BusinessOperationException("comunicaciones.error.respuestaduplicada");
            }
        }
        TareaNotificacion tarea = new TareaNotificacion();
        tarea.setTareaId(tareaOriginal);
        //Borro la comunicacion original, para que quede solo la respuesta.
        if (SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR);
        }
        if (SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR);
        }

        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(dtoGenerarTarea.getSubtipoTarea());

        if (subtipoTarea == null) { throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", dtoGenerarTarea.getSubtipoTarea()); }
        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea())
                && !TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) { throw new GenericRollbackException(
                "tareaNotificacion.subtipoTarea.notificacionIncorrecta", dtoGenerarTarea.getSubtipoTarea()); }
        tareaNotificacionDao.delete(tareaOriginal);
        tarea.setEspera(false);
        tarea.setAlerta(false);

        return saveNotificacionTarea(tarea, subtipoTarea, dtoGenerarTarea.getIdEntidad(), dtoGenerarTarea.getCodigoTipoEntidad(), null,
                dtoGenerarTarea.getDescripcion());
    }

    /**
     * Crea una Prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_PRORROGA)
    public void crearProrroga(DtoSolicitarProrroga dto) {

        Prorroga prorroga = (Prorroga) executor.execute(InternaBusinessOperation.BO_PRORR_MGR_CREAR_NUEVA_PRORROGA, dto);

        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, dto
                .getIdTipoEntidadInformacion());
        Map<String, Object> param = new HashMap<String, Object>();
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdEntidadInformacion());

            String codigoEstado = exp.getEstadoItinerario().getCodigo();
            if (validarExisteProrroga(exp.getId(), codigoEstado)) { throw new BusinessOperationException("expediente.prorroga.existente"); }
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, exp.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
            if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE);
            } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE);
            } else if (DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_ENSAN);
            } else if (DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_SANC);
            } else {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC);
            }
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {

            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto
                    .getIdEntidadInformacion());

            //No es necesario indicarle al BPM que se está cursando una prorroga, solo hay que avisar de la confirmaci�n de la prorroga
            //TareaNotificacion tareaProc = prorroga.getTareaAsociada();
            //jbpmUtils.signalToken(tareaProc.getTareaExterna().getTokenIdBpm(), BPMContants.TRANSICION_ACTIVAR_APLAZAMIENTO);
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, proc.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
            param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO);
        }

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
        PlazoTareasDefault plazoDefault = plazoTareasDefaultDao.buscarPorCodigo(PlazoTareasDefault.CODIGO_SOLICITUD_PRORROGA);
        param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazoDefault.getPlazo());
        param.put(TareaBPMConstants.PRORROGA_ASOCIADA, prorroga);
        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);
        prorroga.setBpmProcess(bpmid);

        Long idTareaAsociada = (Long) executor
                .execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid, TareaBPMConstants.ID_TAREA);
        TareaNotificacion tarea = get(idTareaAsociada);

        //param.put(TareaBPMConstants.DESCRIPCION_TAREA, dto.getDescripcionCausa());
        tarea.setDescripcionTarea(dto.getDescripcionCausa());
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
        //saveOrUpdate(tarea);

        executor.execute(InternaBusinessOperation.BO_PRORR_MGR_SAVE_OR_UPDATE, prorroga);
    }

    /**
     * Crea una tarea a traves del proceso bpm generico.
     * @param idEntidad id de la entidad
     * @param tipoEntidad cdigo de tipo de entidad
     * @param subtipoTarea c�digo del subtipo de tarea.
     * @param codigoPlazo c�digo del plazo default.
     * @param enEspera Dice si la tarea se debe crear o no en espera
     * @return bpm id
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA)
    @Transactional(readOnly = false)
    public Long crearTareaConBPMConEspera(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo, Boolean enEspera) {
        PlazoTareasDefault plazoDefault = plazoTareasDefaultDao.buscarPorCodigo(codigoPlazo);
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, idEntidad);
        param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, tipoEntidad);
        param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, subtipoTarea);
        param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazoDefault.getPlazo());
        param.put(TareaBPMConstants.ESPERA, enEspera);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
        Long bpmProcess = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);
        return bpmProcess;
    }

    /**
     * Crea una tarea a traves del proceso bpm generico.
     * @param idEntidad id de la entidad
     * @param tipoEntidad cdigo de tipo de entidad
     * @param subtipoTarea c�digo del subtipo de tarea.
     * @param codigoPlazo c�digo del plazo default.
     * @return bpm id
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM)
    public Long crearTareaConBPM(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo) {
        return (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, idEntidad, tipoEntidad, subtipoTarea,
                codigoPlazo, false);
        //return crearTareaConBPMConEspera(idEntidad, tipoEntidad, subtipoTarea, codigoPlazo, false);
    }

    /**
     * valida que no existe otra prorroga ya creada para el mismo estado itinerario.
     * @param idExpediente id del expediente
     * @param codigoEstado estado
     * @return condicion
     */
    private boolean validarExisteProrroga(Long idExpediente, String codigoEstado) {
        List<TareaNotificacion> prorrogas = tareaNotificacionDao.obtenerProrrogaExpediente(idExpediente);
        for (TareaNotificacion tarea : prorrogas) {
            if (tarea.getEstadoItinerario().getCodigo().equals(codigoEstado)) { return true; }
        }
        return false;
    }

    /**
     * Contesta una prorroga.
     * @param dto dto solicitar prorroga
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CONTESTAR_PRORROGA)
    @Transactional(readOnly = false)
    public void contestarProrroga(DtoSolicitarProrroga dto) {
        TareaNotificacion tareaOri = this.get(dto.getIdTareaOriginal());
        dto.setIdProrroga(tareaOri.getProrroga().getId());

        Prorroga prorroga = (Prorroga) executor.execute(InternaBusinessOperation.BO_PRORR_MGR_RESPONDER_PRORROGA, dto);

        dto.setFechaPropuesta(prorroga.getFechaPropuesta());
        //Avanzo el bpm para que finalice
        if (prorroga.getBpmProcess() != null) {
            //Pongo esta validacion porque en fase 1 no existia este proceso bpm
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, prorroga.getBpmProcess(),
                    TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);

        }
        String subtipoTarea = null;
        String timerName = null;
        Long idBPM = null;
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, dto
                .getIdTipoEntidadInformacion());

        //Seteo de variables si se trata de una prorroga para expedientes
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdEntidadInformacion());

            String codigoEstado = exp.getEstadoItinerario().getCodigo();

            if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_CE;
            } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_RE;
            } else if (DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_ENSAN;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_ENSAN;
            } else if (DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_SANC;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_SANC;
            } else {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_DC;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_DC;
            }
            idBPM = exp.getProcessBpm();
        } else {
            if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
                //Seteo de variables si se trata de una prorroga para procedimientos
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_PROCEDIMIENTO;
                timerName = "";
            }
        }

        //Si se acepta la prorroga
        if ("on".equals(dto.getAceptada())) {
            TareaNotificacion tareaAsociada = prorroga.getTareaAsociada();
            tareaAsociada.setFechaVenc(dto.getFechaPropuesta());
            tareaAsociada.setAlerta(false);
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaAsociada);
            //this.saveOrUpdate(tareaAsociada);

            //Se acepto la prorroga, se cambia la fecha fin de la tarea asociada
            if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
                // Ahora si se regenerara el timer.
                // BUG no entiendo porque se hacia saltar el timer de solicitar prorroga y luego volver a saltar el timer a generar notificaci�n
                //jbpmUtils.recalculaTimer(idBPM, timerName, dto.getFechaPropuesta(), ExpedienteBPMConstants.TRANSITION_PRORROGA_EXTRA);

                //Directamente se setea el timer para que salte a generar notificaci�n
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_O_RECALCULA_TIMER, idBPM, timerName, dto.getFechaPropuesta(),
                        ExpedienteBPMConstants.GENERAR_NOTIFICACION);
            } else {
                if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
                    //Ejecutamos un signal de prorroga sobre la tarea a la que se le ha concedido la prorroga
                    //NOTA: Es necesario que FECHA_VENC sea correcta en BD
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, tareaAsociada.getTareaExterna().getTokenIdBpm(),
                            BPMContants.TRANSICION_PRORROGA);
                }
            }
        } else {
            //Si se rechaza la prorroga
            //Se rechaza y se notifica
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, dto.getIdEntidadInformacion(), tipoEntidad.getCodigo(),
                    subtipoTarea, dto.getDescripcionCausa());
            //this.crearNotificacion(dto.getIdEntidadInformacion(), tipoEntidad.getCodigo(), subtipoTarea, dto.getDescripcionCausa());
        }
    }

    private void decodificarEntidadInformacion(Long idEntidad, String codigoTipoEntidad, TareaNotificacion tareaNotificacion) {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codigoTipoEntidad)) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idEntidad);

            tareaNotificacion.setExpediente(exp);
            tareaNotificacion.setEstadoItinerario(exp.getEstadoItinerario());
            setearEmisorExpediente(tareaNotificacion, exp);
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codigoTipoEntidad)) {

            Cliente cli = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_GET, idEntidad);

            tareaNotificacion.setCliente(cli);
            tareaNotificacion.setEstadoItinerario(cli.getEstadoItinerario());
            setearEmisorCliente(tareaNotificacion);
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codigoTipoEntidad)) {
            Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idEntidad);

            tareaNotificacion.setAsunto(asu);
            tareaNotificacion.setEstadoItinerario(asu.getEstadoItinerario());
            tareaNotificacion.setEmisor(asu.getGestor().getUsuario().getApellidoNombre());
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(codigoTipoEntidad)) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idEntidad);
            tareaNotificacion.setProcedimiento(proc);
            tareaNotificacion.setAsunto(proc.getAsunto());
            tareaNotificacion.setEstadoItinerario(proc.getAsunto().getEstadoItinerario());
            tareaNotificacion.setEmisor(proc.getAsunto().getGestor().getUsuario().getApellidoNombre());
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(codigoTipoEntidad)) {
            Objetivo objetivo = (Objetivo) executor.execute(InternaBusinessOperation.BO_OBJ_MGR_GET_OBJETIVO, idEntidad);

            tareaNotificacion.setObjetivo(objetivo);
            //Si el obj. es del estado vigente, el mismo tiene que tener la asociacion que se asigna cuando entra en vigencia
            tareaNotificacion.setEstadoItinerario(objetivo.getPolitica().getEstadoItinerarioPolitica().getEstadoItinerario());
            setearEmisorObjetivo(tareaNotificacion, objetivo);
        }
    }

    /**
     * setea el emisor de la tarea.
     * @param tareaNotificacion tarea
     * @param Objetivo obj
     */
    private void setearEmisorObjetivo(TareaNotificacion tareaNotificacion, Objetivo obj) {
        String emisor;
        if (tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO)
                || tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO)
                || tareaNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO)) {
            emisor = obj.getPolitica().getPerfilGestor().getDescripcion();
        } else {
            emisor = obj.getPolitica().getPerfilSupervisor().getDescripcion();
        }
        tareaNotificacion.setEmisor(emisor);
    }

    /**
     * setea el emisor de la tarea.
     * @param tareaNotificacion tarea
     * @param exp expediente
     */
    private void setearEmisorExpediente(TareaNotificacion tareaNotificacion, Expediente exp) {
        String descZona = exp.getOficina().getZona().getDescripcion();
        Perfil gestor = exp.getArquetipo().getItinerario().getEstado(exp.getEstadoItinerario().getCodigo()).getGestorPerfil();
        String descPerfil = "";
        if (gestor != null) {
            descPerfil = gestor.getDescripcion();
        }
        String emisor = (descPerfil + " - " + descZona);
        if (emisor.length() > maxlength) {
            emisor = emisor.substring(0, maxlength);
        }
        tareaNotificacion.setEmisor(emisor);
    }

    /**
     * setea el emisor de la tarea.
     * @param tareaNotificacion tarea
     */
    private void setearEmisorCliente(TareaNotificacion tareaNotificacion) {
        try {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

            Perfil perfil = usuario.getZonaPerfil().iterator().next().getPerfil();
            String descPerfil = perfil.getDescripcion();
            String descZona = "";
            for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
                if (perfil.getId().longValue() == zp.getPerfil().getId().longValue()) {
                    descZona = zp.getZona().getDescripcion();
                    break;
                }
            }
            String emisor = (descPerfil + " - " + descZona);
            if (emisor.length() > maxlength) {
                emisor = emisor.substring(0, maxlength);
            }
            tareaNotificacion.setEmisor(emisor);
        } catch (Exception e) {
            //Por si no estoy logueado y es un proceso del sistema
            tareaNotificacion.setEmisor("Autom�tico");
        }
    }

    private Long saveNotificacionTarea(TareaNotificacion notificacionTarea, SubtipoTarea subtipoTarea, Long idEntidad, String codigoTipoEntidad,
            Long plazo, String descripcion) {
        notificacionTarea.setTarea(subtipoTarea.getDescripcion());
        if (descripcion == null || descripcion.length() == 0) {
            notificacionTarea.setDescripcionTarea(subtipoTarea.getDescripcionLarga());
        } else {
            notificacionTarea.setDescripcionTarea(descripcion);
        }
        notificacionTarea.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
        notificacionTarea.setSubtipoTarea(subtipoTarea);
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                codigoTipoEntidad);
        notificacionTarea.setTipoEntidad(tipoEntidad);
        Date ahora = new Date(System.currentTimeMillis());
        notificacionTarea.setFechaInicio(ahora);
        if (plazo != null) {
            //Date aux = new Date(ahora.getTime());
            //Calendar c = new GregorianCalendar();
            //c.setTime(aux);
            //Long plazoSegundos = plazo/1000;
            //c.add(Calendar.SECOND, plazoSegundos.intValue());
            Date fin = new Date(System.currentTimeMillis() + plazo);
            notificacionTarea.setFechaVenc(fin);
        }
        //Seteo la entidad en el campo que corresponda
        decodificarEntidadInformacion(idEntidad, codigoTipoEntidad, notificacionTarea);
        return tareaNotificacionDao.save(notificacionTarea);

    }

    /**
     * Hace el borrado l�gico de una tarea/notificacion/prorroga.
     * @param idEntidadInformacion el id de la entidad a borrar.
     * @param idTipoEntidadInformacion el c�digo del tipo de entidad.
     * @param codigoSubtipoTarea el c�digo de subtarea.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA)
    public void borrarNotificacionTarea(Long idEntidadInformacion, String idTipoEntidadInformacion, String codigoSubtipoTarea) {
        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(codigoSubtipoTarea);
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                idTipoEntidadInformacion);
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(idTipoEntidadInformacion)) {
            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idEntidadInformacion);

            tareaNotificacionDao.borradoLogico(exp, subtipoTarea, tipoEntidad);
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(idTipoEntidadInformacion)) {
            Cliente cliente = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_GET, idEntidadInformacion);

            tareaNotificacionDao.borradoLogico(cliente, subtipoTarea, tipoEntidad);
        }
    }

    /**
     *	Borra una tarea.
     * @param idTarea id de la tarea
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID)
    @Transactional(readOnly = false)
    public void borrarNotificacionTarea(Long idTarea) {
        tareaNotificacionDao.deleteById(idTarea);
    }

    /**
     * borra todas las tareas asociadas a un expediente cancelado.
     * @param exp id del expediente
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE_ID)
    public void borrarTareasAsociadasExpedienteId(Expediente exp) {
        tareaNotificacionDao.borradoTareasExpediente(exp);
    }

    /**
     * Borra la tarea de justificaci�n de un objetivo
     * @param idObjetivo 
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREA_JUSTIFICACION_OBJETIVO)
    @Transactional(readOnly = false)
    public void borrarTareaJustificacionObjetivo(Long idObjetivo) {
        tareaNotificacionDao.borrarTareaJustificacionObjetivo(idObjetivo);
    }

    /**
     * borra todas las tareas asociadas a un expediente cancelado.
     * @param idExpediente id del expediente
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE)
    public void borrarTareasAsociadasExpediente(Long idExpediente) {
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE_ID, exp);
        //borrarTareasAsociadasExpedienteId(exp);
    }

    /**
     * Activa el flag de alerta de una tarea determinada.
     * @param idTarea el id de la tarea.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_CREAR_ALERTA)
    public void crearAlerta(Long idTarea) {
        tareaNotificacionDao.crearAlerta(idTarea);
    }

    /**
     * Guarda una tarea en la base de datos.
     * @param tareaNotificacion la tarea a guardar.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(TareaNotificacion tareaNotificacion) {
        tareaNotificacionDao.saveOrUpdate(tareaNotificacion);
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de un tipo determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param subtipoTarea ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO)
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea) {
        return tareaNotificacionDao.getListByProcedimientoSubtipo(idProcedimiento, subtipoTarea);
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de una lista de tipos determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param Set<subtipoTarea> ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_LIST_SUBTIPO)
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, Set<String> subtipoTarea) {
        return tareaNotificacionDao.getListByProcedimientoSubtipo(idProcedimiento, subtipoTarea);
    }

    /**
     * recupera las alertas de la base.
     * @return las alertas.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_NOTIF_ALERTAS)
    public List<TareaNotificacion> getNotificacionesAlertas() {
        List<TareaNotificacion> lista = new ArrayList<TareaNotificacion>();
        lista = tareaNotificacionDao.getList();
        return lista;
    }

    /**
     * Obtiene una tareaNotificacion.
     * @param id id de la tarea
     * @return entidad TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET)
    @Transactional
    public TareaNotificacion get(Long id) {
    	EventFactory.onMethodStart(this.getClass());
        return tareaNotificacionDao.get(id);
    }

    private Integer diasDiferencia(Date inicio, Date fin) {
        if (inicio == null || fin == null) { return 0; }
        long diferencia = fin.getTime() - inicio.getTime();
        if (diferencia < 0) { return 0; }
        return Math.round(diferencia / UN_DIA);

    }

    /**
     * Busca la tarea del expediente que corresponde a este momento.
     * @param idExpediente el id del expediente a buscar.
     * @return la tarea.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREA_ACTUAL_EXP)
    public DtoTareaNotificaciones buscarTareaActualExpediente(Long idExpediente) {
        Date d = tareaNotificacionDao.buscarFechaFinEstadoExpediente(idExpediente);
        DtoTareaNotificaciones dto = new DtoTareaNotificaciones();
        if (d == null) { return dto; }
        dto.setPlazo(diasDiferencia(d, new Date(System.currentTimeMillis())));
        dto.setPlazoDias("" + dto.getPlazo() + " dias");
        //dto.setUsuarioDetails(SecurityUtils.getCurrentUser());
        return dto;
    }

    /**
     * Buscar las tareas pendientes.
     * @param dto dto
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE)
    @Transactional
    public Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto) {
        EventFactory.onMethodStart(this.getClass());
    	Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        List<DDZona> zonas = usuarioLogado.getZonas();
        dto.setPerfiles(perfiles);
        dto.setZonas(zonas);
        dto.setUsuarioLogado(usuarioLogado);
        List<TareaNotificacion> listaRetorno = new ArrayList<TareaNotificacion>();

        Page page;
        if (dto.getTraerGestionVencidos() != null && dto.getTraerGestionVencidos()) {
            agregarTareasGestionVencidosSeguimiento(dto, listaRetorno);

            page = new PageSql();
            ((PageSql) page).setResults(listaRetorno);
            ((PageSql) page).setTotalCount(listaRetorno.size());
        } else {
            page = (PageHibernate) tareaNotificacionDao.buscarTareasPendiente(dto);
            listaRetorno.addAll((List<TareaNotificacion>) page.getResults());
            replaceGestorInList(listaRetorno, usuarioLogado);
            replaceSupervisorInList(listaRetorno, usuarioLogado);
            ((PageHibernate) page).setResults(listaRetorno);
        }
        EventFactory.onMethodStop(this.getClass());
        return page;
    }

    /**
     * agrega la zona al gestor.
     * @param lista lista
     * @param zona zona
     */
    private void replaceGestorInList(List<TareaNotificacion> lista, Usuario usuario) {
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
     * agrega la zona al supervisor.
     * @param lista lista
     * @param zona zona
     */
    private void replaceSupervisorInList(List<TareaNotificacion> lista, Usuario usuario) {
        for (TareaNotificacion tarea : lista) {
            if (tarea.getDescSupervisor() != null && tarea.getDescSupervisor().trim().length() > 0) {
                String descZona = "";
                if (tarea.getSupervisor() != null) {
                    for (ZonaUsuarioPerfil zp : usuario.getZonaPerfil()) {
                        if (tarea.getSupervisor().longValue() == zp.getPerfil().getId().longValue()) {
                            descZona = zp.getZona().getDescripcion();
                            break;
                        }
                    }
                }
                tarea.setDescSupervisor(tarea.getDescSupervisor() + " " + descZona);
            }
        }
    }

    /**
     * agregarGestionVencidos.
     * @param dto dtoparametro
     */
    private void agregarTareasGestionVencidosSeguimiento(DtoBuscarTareaNotificacion dto, List<TareaNotificacion> listaRetorno) {

        if (!dto.isEnEspera() && !dto.isEsAlerta() && TipoTarea.TIPO_TAREA.equals(dto.getCodigoTipoTarea())) {

            DDEstadoItinerario estadoItinerario = (DDEstadoItinerario) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoItinerario.class, DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);

            //Comprueba si el usuario es gestor para alguno de sus perfiles en el estado de GESTION DE VENCIDOS
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

            Boolean isGestor = (Boolean) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_EXISTE_GESTOR_BY_PERFIL, usuario.getPerfiles(),
                    estadoItinerario);

            if (isGestor) {
                Long cantidadVencidos = (Long) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO);
                if (cantidadVencidos > 0) {
                    TareaNotificacion tareaGV = new TareaNotificacion();
                    tareaGV.setTarea("Gestion de Vencidos");
                    tareaGV.setDescripcionTarea("Clientes por gestionar: " + cantidadVencidos);
                    tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                            DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
                    tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_VENCIDOS));
                    listaRetorno.add(tareaGV);
                }

                Long cantidadSeguimientoSintomatico = (Long) executor
                        .execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO);
                if (cantidadSeguimientoSintomatico > 0) {
                    TareaNotificacion tareaGV = new TareaNotificacion();
                    tareaGV.setTarea("Gestion de Seguimiento Sintomatico");
                    tareaGV.setDescripcionTarea("Clientes por gestionar: " + cantidadSeguimientoSintomatico);
                    tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                            DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
                    tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO));
                    listaRetorno.add(tareaGV);
                }

                Long cantidadSeguimientoSistematico = (Long) executor
                        .execute(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO);
                if (cantidadSeguimientoSistematico > 0) {
                    TareaNotificacion tareaGV = new TareaNotificacion();
                    tareaGV.setTarea("Gestion de Seguimiento Sistematico");
                    tareaGV.setDescripcionTarea("Clientes por gestionar: " + cantidadSeguimientoSistematico);
                    tareaGV.setTipoEntidad((DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                            DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE));
                    tareaGV.setSubtipoTarea(subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO));
                    listaRetorno.add(tareaGV);
                }
            }
        }
    }

    /**
     * M�todo encargado de buscar todas las tareas para un id de un cliente determinado.
     * @param id Long
     * @return TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COM_CLIENTE)
    public TareaNotificacion buscarComunicacionesCliente(Long id) {
        DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
        dto.setIdEntidadInformacion(id);
        dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);

        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, id);

        Cliente cliente = persona.getClienteActivo();
        if (cliente != null) {
            dto.setIdEntidadInformacion(cliente.getId());
        }
        return (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COMUNICACIONES, dto);
        //return buscarComunicaciones(dto);
    }

    /**
     * M�todo encargado de buscar todas las tareas para un id de un expediente determinado.
     * @param id Long
     * @return TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COM_EXP)
    public TareaNotificacion buscarComunicacionesExpediente(Long id) {
        DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
        dto.setIdEntidadInformacion(id);
        dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);

        return (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COMUNICACIONES, dto);
        //return buscarComunicaciones(dto);
    }

    /**
     * M�todo encargado de buscar todas las tareas para un id de un asunto determinado.
     * @param id Long
     * @return TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COM_ASU)
    public TareaNotificacion buscarComunicacionesAsunto(Long id) {
        DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
        dto.setIdEntidadInformacion(id);
        dto.setIdTipoEntidadInformacion(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        return (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COMUNICACIONES, dto);
        //return buscarComunicaciones(dto);
    }

    /**
     * M�todo encargado de buscar todas las tareas para un id de una entidad informaci�n determinada.
     * @param dtoBuscarTareaNotificacion DtoBuscarTareaNotificacion
     * @return TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_COMUNICACIONES)
    public TareaNotificacion buscarComunicaciones(DtoBuscarTareaNotificacion dtoBuscarTareaNotificacion) {

        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

        dtoBuscarTareaNotificacion.setPerfiles(usuario.getPerfiles());
        TareaNotificacion tarea = null;

        List<TareaNotificacion> tareas = tareaNotificacionDao.buscarComunicaciones(dtoBuscarTareaNotificacion);

        if (tareas.size() > 0) {
            tarea = tareas.get(0);
        }

        return tarea;
    }

    /**
     * obtiene si un expediente tiene una prorroga asociada.
     * @param idExpediente id del expediente
     * @return prorroga
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_PRORROGA_EXP)
    public TareaNotificacion obtenerProrrogaExpediente(Long idExpediente) {
        List<TareaNotificacion> lista = tareaNotificacionDao.obtenerProrrogaExpediente(idExpediente);
        if (lista != null && lista.size() > 0) { return lista.get(0); }
        return null;
    }

    /**
     * obtiene si un expediente tiene una solicitud de cancelacion asociada.
     * @param idExpediente id del expediente
     * @return prorroga
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_SOL_CANCEL_EXP)
    public TareaNotificacion obtenerSolicitudCancelacionExpediente(Long idExpediente) {
        List<TareaNotificacion> lista = tareaNotificacionDao.obtenerSolicitudCancelacionExpediente(idExpediente);
        if (lista != null && lista.size() > 0) { return lista.get(0); }
        return null;
    }

    /**
     * obtiene el count de todas las tareas pendientes.
     * @param dto dto
     * @return cuenta
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_CANT_TAREAS_PENDIENTES)
    public List<Long> obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto) {
        List<Long> result = new ArrayList<Long>();
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
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
        return result;
    }

    /**
     * finalizar una tarea.
     * @param idTarea id tarea
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_FINALIZAR_NOTIF)
    public void finalizarNotificacion(Long idTarea) {
        TareaNotificacion tarea = get(idTarea);
        tarea.setTareaFinalizada(true);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
        //saveOrUpdate(tarea);
    }

    /**
     * elimina tareas de comunicacion, prorroga y cancelacion antes de enviar al proximo estado.
     * @param idExpediente expediente
     * @param estadoItinerario estado
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_ELIMINAR_TAREAS_INVALIDAS_ELEVACION_EXP)
    public void eliminarTareasInvalidasElevacionExpediente(Long idExpediente, String estadoItinerario) {
        List<TareaNotificacion> tareas = tareaNotificacionDao.obtenerTareasInvalidasElevacionExpediente(idExpediente, estadoItinerario);
        for (TareaNotificacion tarea : tareas) {
            tareaNotificacionDao.delete(tarea);
        }
    }

    /**
     * Crea una notificacion para el gestor indicando que su solicitud de cancelaci�n de un expediente fue rechazada.
     * @param expediente el expediente que se quer�a cancelar.
     * @param sc la solicitud de cancelaci�n.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA)
    public void notificarSolCancelacRechazada(Expediente expediente, SolicitudCancelacion sc) {
        TareaNotificacion notificacion = new TareaNotificacion();
        notificacion.setSolicitudCancelacion(sc);
        notificacion.setEspera(Boolean.FALSE);
        notificacion.setAlerta(Boolean.FALSE);
        saveNotificacionTarea(notificacion, subtipoTareaDao
                .buscarPorCodigo(SubtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA), expediente.getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null, null);
    }

    /**
     * Devuelve la tarea asociada a la solicitud de cancelaci�n de un expediente.
     * @param idSolicitud el id de la solicitud.
     * @param idExpediente el id del expediente.
     * @return la tarea asociada.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREA_SOLICITUD_CANCELADA_EXPEDIENTE)
    public TareaNotificacion buscarTareaSolCancExp(Long idSolicitud, Long idExpediente) {
        return tareaNotificacionDao.buscarSolCancExp(idSolicitud, idExpediente);
    }

    /**
     * solicita una cancelacion de un expediente.
     * @param idExpediente id expediente
     * @param detalle el detalle de la solicitud de cancelaci�n.
     * @param esSupervisor indica si el usuario es supervisor, para que no se genere una tarea.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_SOL_CANCELACION_EXP)
    @Transactional(readOnly = false)
    public void solicitarCancelacionExpediente(Long idExpediente, String detalle, Boolean esSupervisor) {

        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);

        TareaNotificacion notificacion = new TareaNotificacion();
        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR);
        //Bloquea el expediente

        SolicitudCancelacion sc = new SolicitudCancelacion();
        sc.setExpediente(exp);
        sc.setDetalle(detalle);
        executor.execute(InternaBusinessOperation.BO_EXP_MGR_GUARDAR_SOLICITUD_CANCELACION, sc);
        if (!esSupervisor) {
            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO);
            exp.setEstadoExpediente(estadoExpediente);

            executor.execute(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE, exp);

            GregorianCalendar calendar = new GregorianCalendar();
            final int dias = 5;
            calendar.add(Calendar.DAY_OF_MONTH, dias);
            notificacion.setFechaVenc(calendar.getTime());
            notificacion.setTarea(subtipoTarea.getDescripcion());
            notificacion.setDescripcionTarea(detalle);
            notificacion.setEspera(Boolean.TRUE);
            notificacion.setAlerta(Boolean.FALSE);
            notificacion.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
            notificacion.setSubtipoTarea(subtipoTarea);
            DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class,
                    DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
            notificacion.setTipoEntidad(tipoEntidad);
            notificacion.setFechaInicio(new Date(System.currentTimeMillis()));
            notificacion.setSolicitudCancelacion(sc);
            //Seteo la entidad en el campo que corresponda
            notificacion.setExpediente(exp);
            notificacion.setEstadoItinerario(exp.getEstadoItinerario());
            setearEmisorExpediente(notificacion, exp);

            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, notificacion);
            //saveOrUpdate(notificacion);
        } else {
            executor.execute(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE, exp.getId(), true);
        }
    }

    /**
     * Busca en el diccionario de la BBDD el subtipo de tarea.
     * @param codigo String: codigo del subtipo de tarea
     * @return SubtipoTarea
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_SUBTIPO_TAREA_POR_CODIGO)
    public SubtipoTarea buscarSubtipoTareaPorCodigo(String codigo) {
        return subtipoTareaDao.buscarPorCodigo(codigo);
    }

    /**
     * Indica si se puede responder una comunicaci�n.
     * En el caso de que la entidad sobre la que se genera la comunicaci�n sea un Asunto, se fija si fue enviada por el gestor, en cuyo caso
     * solo la puede responder el supervisor del Asunto, y viceversa. En el caso de que la entidad no sea un asunto, siempre puede responder.
     * @param dto el dto con los datos necesarios.
     * @return true si puede responder la tarea, false si no.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_PUEDE_RESPONDER)
    public Boolean puedeResponder(DtoGenerarTarea dto) {
        if (dto.getCodigoTipoEntidad().equals(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO)) {
            //Es un asunto, así que tengo que revisar si el usuario logueado es el gestor o el supervisor de acuerdo al subtipo de tarea
            TareaNotificacion tarea = tareaNotificacionDao.get(dto.getIdTareaAsociada());

            Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdEntidad());

            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            if (tarea.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR)) {
                //Como el emisor es el gestor, entonces el supervisor del asunto debe coincidir con el usuario logueado.
                if (usuario.getId().longValue() == asunto.getSupervisor().getUsuario().getId().longValue()) { return Boolean.TRUE; }
            } else if (tarea.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR)) {
                //Como el emisor es el supervisor, entonces el gestor del asunto debe coincidir con el usuario logueado.
                if (usuario.getId().longValue() == asunto.getGestor().getUsuario().getId().longValue()) { return Boolean.TRUE; }
            }
            return Boolean.FALSE;
        }

        return Boolean.TRUE;
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento ordenadas por fecha de creacion.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC)
    public List<TareaNotificacion> getListByProcedimiento(Long idProcedimiento) {
        return tareaNotificacionDao.getListByProcedimiento(idProcedimiento);
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Asunto ordenadas por fecha de creacion.
     * @param idAsunto ID del asunto al que pertenece la tarea
     * @return Un listado de tareasNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_ASUNTO)
    public List<TareaNotificacion> getListByAsunto(Long idAsunto) {
        return tareaNotificacionDao.getListByAsunto(idAsunto);
    }

    /**
     * Actualiza la pareja ASU_ID - PRC_ID de las tareas notificacion asociadas al conjunto de asuntos que se le pasa como par�metro.
     * Este m�todo se utiliza cuando se cambia de Despacho en un asunto, para que los procedimientos se enteren.
     * @param asuntos lista
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_ACTUALIZAR_ASUNTOS_PROCEDIMIENTOS)
    @Transactional(readOnly = false)
    public void actualizaAsuntosProcedimientos(List<Asunto> asuntos) {

        //Recorremos todos los asuntos implicados
        for (Asunto asu : asuntos) {

            //Recorremos todos los procedimientos del asunto
            for (Procedimiento prc : asu.getProcedimientos()) {

                //Recorremos todas las tareas del procedimiento
                for (TareaNotificacion tn : prc.getTareas()) {

                    //Para cada tarea, le seteamos el asunto correspondiente al procedimiento (por si el procedimiento ha cambiado de asunto)
                    tn.setAsunto(prc.getAsunto());
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tn);
                    //saveOrUpdate(tn);
                }
            }
        }

    }

    /**
     * Borra todas las tareas asociadas a un cliente.
     * @param idCliente long
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_CLIENTE)
    public void borrarTareasAsociadasCliente(Long idCliente) {
        tareaNotificacionDao.borrarTareasAsociadasCliente(idCliente);
    }

    /**
     * Realiza la b�squeda de Tareas NOtificaciones para reporte Excel.
     * @param dto DtoBuscarTareaNotificacion
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL)
    public List<TareaNotificacion> buscarTareasParaExcel(DtoBuscarTareaNotificacion dto) {
        dto.setLimit(Integer.MAX_VALUE - 1);
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        List<DDZona> zonas = usuarioLogado.getZonas();
        dto.setPerfiles(perfiles);
        dto.setZonas(zonas);
        dto.setUsuarioLogado(usuarioLogado);
        List<TareaNotificacion> listaRetorno = new ArrayList<TareaNotificacion>();
        //agregarGestionVencidos(dto, listaRetorno);
        PageHibernate page = (PageHibernate) tareaNotificacionDao.buscarTareasPendiente(dto);
        listaRetorno.addAll((List<TareaNotificacion>) page.getResults());
        replaceGestorInList(listaRetorno, usuarioLogado);
        replaceSupervisorInList(listaRetorno, usuarioLogado);
        page.setResults(listaRetorno);
        return (List<TareaNotificacion>) page.getResults();

    }

    /**
     * Devuelve si el usuario logueado puede ver las columnas VR y VR Vencido.
     * @return si puede o no ver las columnas
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_PUEDE_MOSTRAR_VR)
    public Boolean puedeMostrarVR() {
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        for (Perfil per : perfiles) {
            for (Funcion fun : per.getFunciones()) {
                if (fun.getDescripcion().equals("MOSTRAR_VR_TAREAS")) { return true; }
            }
        }
        return false;
    }

    /**
     * @param codigoSubtipo String
     * @return SubtipoTarea
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE)
    public SubtipoTarea getSubtipoTareaByCode(String codigoSubtipo) {
        return subtipoTareaDao.buscarPorCodigo(codigoSubtipo);
    }

    /**
     * Busca un PlazoTareasDefault por su c�digo.
     * @param codigo el c�digo del subtipo de tarea que se busca.
     * @return el subtipo de tarea si existe.
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO)
    public PlazoTareasDefault buscarPlazoTareasDefaultPorCodigo(String codigo) {
        return plazoTareasDefaultDao.buscarPorCodigo(codigo);
    }

    /**
     * Busca las tareas relacionadas a un cliente.
     * @param idCliente el id del cliente
     * @return la lista de tareas asociadas al cliente
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_ASOCIADAS_A_CLIENTE)
    public List<TareaNotificacion> buscarTareasAsociadasACliente(Long idCliente) {
        return tareaNotificacionDao.buscarTareasAsociadasACliente(idCliente);
    }

    /**
     * Busca las tareas o notificaciones para la entidad cliente.
     * @param dto dtoparametro
     * @return lista de tareas
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE_CLIENTE_DEL_USUARIO)
    List<TareaNotificacion> buscarTareasPendienteClienteDelUsuario(DtoBuscarTareaNotificacion dto) {
        return tareaNotificacionDao.buscarTareasPendienteClienteDelUsuario(dto);
    }

    /**
     * se hace override para que setee la fecha fin de la tarea.
     * @param tarea TareaNotificacion
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_MGR_DELETE)
    public void delete(TareaNotificacion tarea) {
        tareaNotificacionDao.delete(tarea);
    }
}
