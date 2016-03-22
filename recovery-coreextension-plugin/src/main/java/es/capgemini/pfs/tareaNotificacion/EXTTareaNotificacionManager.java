package es.capgemini.pfs.tareaNotificacion;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.registro.AceptarProrrogaListener;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.NFADDTipoRevisionAlerta;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;
import es.pfsgroup.recovery.ext.impl.tareas.ExportarTareasBean;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class EXTTareaNotificacionManager extends EXTAbstractTareaNotificacionManager implements TareaNotificacionApi {

    private static final TipoCalculo TIPO_CALCULO_FECHA_POR_DEFECTO = TipoCalculo.TODO;
    private static final String BO_TAREA_MGR_OBTENER_COMUNICACION = "EXTtareaNotificacionManager.obtenerComunicacion";
    private final static String[] NOMBRES_COLUMNAS = new String[] { "ID", "Nombre", "Unidad de Gestión", "Descripción", "Fecha Inicio", "Fecha Vencimiento", "Tipo Solicitud", "Días Vencida",
            "Responsable de la tarea", "Supervisor", "Letrado", "VR", "VR Vencido" };
    private final static String LISTA_ASUNTOS_XLS = "ListaTarea.xls";
    private final static String LISTA_ASUNTOS = "Lista Tareas";
    private final static String VACIO = "";
    public final static String EXPORTAR_ASUNTOS_LIMITE_SIMULTANEO = "exportar.excel.limite.tareas.simultaneos";
    private final static String EXPORTAR_ASUNTOS_RUTA = "exportar.excel.limite.tareas.ruta";
    private static ExportarTareasBean[] exportarExcelPool = null;
    private final Log logger = LogFactory.getLog(getClass());

    private static final long DAY_MILISECONDS = 1000 * 60 * 60 * 24;

    private final int maxlength = 49;

    @Autowired
    Executor executor;

    @Autowired
    GenericABMDao genericDao;

    @Autowired
    private VTARBusquedaOptimizadaTareasDao vtarBusquedaOptimizadaTareasDao;

    @Resource
    Properties appProperties;

    @Autowired(required = false)
    private List<AceptarProrrogaListener> listeners;
    
    @Autowired
    private EXTModelClassFactory modelClassFactory;
    
    @Autowired
    private ExpedienteManagerApi expedienteManager;

	@Autowired
	private IntegracionBpmService integracionBPMService;
	
	@Autowired
	private CoreProjectContext coreProjectContext;
    
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_GET)
    @Transactional
    public TareaNotificacion get(Long id) {
        EventFactory.onMethodStart(this.getClass());
        return parent().get(id);
    }

    @Override
    public String managerName() {
        return "tareaNotificacionManager";
    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CONTESTAR_PRORROGA)
    @Transactional(readOnly = false)
    public void contestarProrroga(DtoSolicitarProrroga dto) {
        TareaNotificacion tareaOri = this.get(dto.getIdTareaOriginal());
        dto.setIdProrroga(tareaOri.getProrroga().getId());
        if (dto.getCodigoRespuesta().equals("11") || dto.getCodigoRespuesta().equals("7")) {
            dto.setAceptada("on");
        }

        Prorroga prorroga = (Prorroga) executor.execute(InternaBusinessOperation.BO_PRORR_MGR_RESPONDER_PRORROGA, dto);

        dto.setFechaPropuesta(prorroga.getFechaPropuesta());
        // Avanzo el bpm para que finalice
        if (prorroga.getBpmProcess() != null) {
            // Pongo esta validacion porque en fase 1 no existia este proceso
            // bpm
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, prorroga.getBpmProcess(), TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);

        }
        String subtipoTarea = null;
        String timerName = null;
        Long idBPM = null;
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, dto.getIdTipoEntidadInformacion());

        // Seteo de variables si se trata de una prorroga para expedientes
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdEntidadInformacion());

            String codigoEstado = exp.getEstadoItinerario().getCodigo();

            if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_CE;
            } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(codigoEstado)) {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_RE;
            } else {
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_DC;
                timerName = ExpedienteBPMConstants.TIMER_TAREA_DC;
            }
            idBPM = exp.getProcessBpm();
        } else {
            if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
                // Seteo de variables si se trata de una prorroga para
                // procedimientos
                subtipoTarea = SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_PROCEDIMIENTO;
                timerName = "";
            }
        }

        // Si se acepta la prorroga
        // se deja traza del evento
        Long idTareaAComunicar = null;
        if (("on".equals(dto.getAceptada())) || ("true".equals(dto.getAceptada()))) {
            TareaNotificacion tareaAsociada = prorroga.getTareaAsociada();
            idTareaAComunicar = tareaAsociada.getId();
            tareaAsociada.setAlerta(false);
            Map<String, Object> map = new HashMap<String, Object>();
            map.put(AceptarProrrogaListener.CLAVE_ID_TAREA_NOTIFICACION, tareaAsociada.getId());
            map.put(AceptarProrrogaListener.CLAVE_FECHA_VENCIMIENTO_ORIGINAL, tareaAsociada.getFechaVenc());
            map.put(AceptarProrrogaListener.CLAVE_FECHA_VENCIMIENTO_PROPUESTA, dto.getFechaPropuesta());
            map.put(AceptarProrrogaListener.CLAVE_PRORROGA_ASOCIADA, dto.getIdProrroga());
            map.put(AceptarProrrogaListener.CLAVE_MOTIVO, prorroga.getCausaProrroga().getDescripcion());
            map.put(AceptarProrrogaListener.CLAVE_DETALLE, dto.getDescripcionCausa());
            if (tareaAsociada instanceof EXTTareaNotificacion) {
                EXTTareaNotificacion tar = (EXTTareaNotificacion) tareaAsociada;
                tar.setVencimiento(VencimientoUtils.getFecha(dto.getFechaPropuesta(), TipoCalculo.PRORROGA));
                this.saveOrUpdate(tar);
            } else {
                tareaAsociada.setFechaVenc(dto.getFechaPropuesta());
                this.saveOrUpdate(tareaAsociada);
            }
            // guardo la informaci�n sobre la prorroga aceptada en un escuchador
            if (listeners != null) {
                for (AceptarProrrogaListener l : listeners) {
                    l.fireEvent(map);
                }
            }
            
            // Si acepto la prorroga, se cambia la fecha fin de la tarea
            // asociada
            if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
                // Ahora si se regenerara el timer.
                // BUG no entiendo porque se hacia saltar el timer de solicitar
                // prorroga y luego volver a saltar el timer a generar
                // notificaci�n
                // jbpmUtils.recalculaTimer(idBPM, timerName,
                // dto.getFechaPropuesta(),
                // ExpedienteBPMConstants.TRANSITION_PRORROGA_EXTRA);

                // Directamente se setea el timer para que salte a generar
                // notificaci�n
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_O_RECALCULA_TIMER, idBPM, timerName, dto.getFechaPropuesta(), ExpedienteBPMConstants.GENERAR_NOTIFICACION);
            } else {
                if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
                    if (!Checks.esNulo(tareaAsociada.getTareaExterna())) {
                        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, tareaAsociada.getTareaExterna().getTokenIdBpm(), BPMContants.TRANSICION_PRORROGA);
                    }
                    // Ejecutamos un signal de prorroga sobre la tarea a la que
                    // se le ha concedido la prorroga
                    // NOTA: Es necesario que FECHA_VENC sea correcta en BD
                }
            }
        } else {
            // Si se rechaza la prorroga
            // Se rechaza y se notifica
        	idTareaAComunicar = this.crearNotificacion(dto.getIdEntidadInformacion(), tipoEntidad.getCodigo(), subtipoTarea, dto.getDescripcionCausa());
        }

        // Comunicación de la tarea creada a mensajería.
        if (!Checks.esNulo(idTareaAComunicar)) {
	        TareaNotificacion tarea = this.get(idTareaAComunicar);
	    	integracionBPMService.notificaTarea(tarea);
        }

    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION)
    @Transactional(readOnly = false)
    public Long crearNotificacion(Long idEntidadInformacion, String idTipoEntidadInformacion, String codigoSubtipoTarea, String descripcion) {
        EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
        SubtipoTarea subtipoTarea = getSubtipoTarea(codigoSubtipoTarea);
        if (subtipoTarea == null) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", codigoSubtipoTarea);
        }
        if (!TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTarea.notificacionIncorrecta", codigoSubtipoTarea);
        }
        notificacion.setEspera(Boolean.FALSE);
        notificacion.setAlerta(Boolean.FALSE);
        return saveNotificacionTarea(notificacion, subtipoTarea, idEntidadInformacion, idTipoEntidadInformacion, null, descripcion, TipoCalculo.TODO);
    }

    /**
     * Guarda una tarea en la base de datos.
     * 
     * @param tareaNotificacion
     *            la tarea a guardar.
     */
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    @Override
    public void saveOrUpdate(TareaNotificacion tareaNotificacion) {
        if (tareaNotificacion != null) {
            if (tareaNotificacion instanceof EXTTareaNotificacion) {
                if (tareaNotificacion.getId() == null) {
                    genericDao.save(EXTTareaNotificacion.class, (EXTTareaNotificacion) tareaNotificacion);
                } else {
                    genericDao.update(EXTTareaNotificacion.class, (EXTTareaNotificacion) tareaNotificacion);
                }
            } else {
                parent().saveOrUpdate(tareaNotificacion);
            }
        }

    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA)
    @Transactional(readOnly = false)
    public Long crearTarea(DtoGenerarTarea dto) {
        EXTTareaNotificacion tarea = new EXTTareaNotificacion();
        String codigoSubtarea = dto.getSubtipoTarea();
        SubtipoTarea subtipoTarea = getSubtipoTarea(codigoSubtarea);
        TipoCalculo tipoCalculo = null;
        if (dto instanceof EXTDtoGenerarTarea) {
            EXTDtoGenerarTarea sandto = (EXTDtoGenerarTarea) dto;
            tipoCalculo = sandto.getTipoCalculo();
        }
        if (subtipoTarea == null) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", dto.getSubtipoTarea());
        }
        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTarea.notificacionIncorrecta", dto.getSubtipoTarea());
        }

        tarea.setEspera(dto.isEnEspera());
        tarea.setAlerta(dto.isEsAlerta());
        return saveNotificacionTarea(tarea, subtipoTarea, dto.getIdEntidad(), dto.getCodigoTipoEntidad(), dto.getPlazo(), dto.getDescripcion(), tipoCalculo);

    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA)
    public void notificarSolCancelacRechazada(Expediente expediente, SolicitudCancelacion sc) {
        EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
        notificacion.setSolicitudCancelacion(sc);
        notificacion.setEspera(Boolean.FALSE);
        notificacion.setAlerta(Boolean.FALSE);
        saveNotificacionTarea(notificacion, getSubtipoTarea(SubtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA), expediente.getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                null, null, null);

    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_SOL_CANCELACION_EXP)
    @Transactional(readOnly = false)
    public void solicitarCancelacionExpediente(Long idExpediente, String detalle, Boolean esSupervisor) {
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);

        EXTTareaNotificacion notificacion = new EXTTareaNotificacion();
        SubtipoTarea subtipoTarea = getSubtipoTarea(SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR);
        // Bloquea el expediente

        SolicitudCancelacion sc = new SolicitudCancelacion();
        sc.setExpediente(exp);
        sc.setDetalle(detalle);
        executor.execute(InternaBusinessOperation.BO_EXP_MGR_GUARDAR_SOLICITUD_CANCELACION, sc);
        if (!esSupervisor) {
            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoExpediente.class,
                    DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO);
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
            DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
            notificacion.setTipoEntidad(tipoEntidad);
            notificacion.setFechaInicio(new Date(System.currentTimeMillis()));
            notificacion.setSolicitudCancelacion(sc);
            // Seteo la entidad en el campo que corresponda
            notificacion.setExpediente(exp);
            notificacion.setEstadoItinerario(exp.getEstadoItinerario());
            setearEmisorExpediente(notificacion, exp);
            saveOrUpdate(notificacion);
        } else {
        	if ((!Checks.esNulo(exp.getTipoExpediente())) && exp.getTipoExpediente().getCodigo().equals(DDTipoExpediente.TIPO_EXPEDIENTE_RECOBRO))
        		executor.execute(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE, exp.getId(), true); //La BO está sobreescrita y lleva al plugin de recobro
        	else
        		expedienteManager.cancelacionExp(idExpediente, true); //Así ejecuta el método de Expediente
        }

    }

    /**
     * Crea una tarea.
     * 
     * @param dtoGenerarTarea
     *            dto de tare notificaciones
     * @return el id de la tarea creada
     */
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_COMUNICACION)
    @Transactional(readOnly = false)
    public Long crearTareaComunicacion(DtoGenerarTarea dtoGenerarTarea) {
        if (dtoGenerarTarea.getIdTareaAsociada() != null) {
            // Respondo la tarea
            return responderComunicacion(dtoGenerarTarea);
        }

        if (SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR.equals(dtoGenerarTarea.getSubtipoTarea())
                || SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR.equals(dtoGenerarTarea.getSubtipoTarea())
                || EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE.equals(dtoGenerarTarea.getSubtipoTarea())
                || EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE.equals(dtoGenerarTarea.getSubtipoTarea())
                || EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE.equals(dtoGenerarTarea.getSubtipoTarea())
                || EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE.equals(dtoGenerarTarea.getSubtipoTarea())) {
            // Envio una comunicacion de tipo solo Ida.
            return crearNotificacion(dtoGenerarTarea.getIdEntidad(), dtoGenerarTarea.getCodigoTipoEntidad(), dtoGenerarTarea.getSubtipoTarea(), dtoGenerarTarea.getDescripcion());
        }
        // Envio una comunicacion esperando respuesta. La misma genera un
        // proceso bpm.
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, dtoGenerarTarea.getIdEntidad());
        param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, dtoGenerarTarea.getCodigoTipoEntidad());
        param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, dtoGenerarTarea.getSubtipoTarea());
        Long plazo = dtoGenerarTarea.getFecha().getTime() - new Date().getTime();
        param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazo);
        ComunicacionBPM comunicacion = new ComunicacionBPM();
        param.put(TareaBPMConstants.COMUNICACION_BPM, comunicacion);
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);

        Long idComu = saveComunicacionBPM(comunicacion);

        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);

        Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid, TareaBPMConstants.ID_TAREA);

        TareaNotificacion tarea = get(idTareaAsociada);

        tarea.setDescripcionTarea(dtoGenerarTarea.getDescripcion());
        saveOrUpdate(tarea);

        comunicacion.setIdBPM(bpmid);
        saveOrUpdateComunicacionBPM(comunicacion);
        return idComu;
    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public void saveOrUpdateComunicacionBPM(ComunicacionBPM comu) {
        if (comu != null) {
            if (comu.getId() == null) {

                genericDao.save(ComunicacionBPM.class, comu);
            } else {
                genericDao.update(ComunicacionBPM.class, comu);
            }
        }

    }

    /**
     * save de la comunicacion bpm.
     * 
     * @param comu
     *            comunucaion
     * @return id
     */
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_SAVE_COMUNICACION_BPM)
    @Transactional(readOnly = false)
    public Long saveComunicacionBPM(ComunicacionBPM comu) {
        return genericDao.save(ComunicacionBPM.class, comu).getId();
    }

    /**
     * Borra una tarea.
     * 
     * @param idTarea
     *            id de la tarea
     */
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID)
    @Transactional(readOnly = false)
    public void borrarNotificacionTarea(Long idTarea) {
        parent().borrarNotificacionTarea(idTarea);

    }

    /**
     * Crea una Prorroga.
     * 
     * @param dto
     *            dto solicitar prorroga
     */
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_CREAR_PRORROGA)
    @Transactional(readOnly = false)
    public void crearProrroga(DtoSolicitarProrroga dto) {
        EventFactory.onMethodStart(this.getClass());
        Prorroga prorroga = (Prorroga) executor.execute(InternaBusinessOperation.BO_PRORR_MGR_CREAR_NUEVA_PRORROGA, dto);

        // FIXME Pasamos un c�digo pero en el DTO la propiedad hace referencia a
        // un ID
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, dto.getIdTipoEntidadInformacion());

        Map<String, Object> param = new HashMap<String, Object>();
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {

            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdEntidadInformacion());

            String codigoEstado = exp.getEstadoItinerario().getCodigo();
            if (validarExisteProrroga(exp.getId(), codigoEstado)) {
                throw new BusinessOperationException("expediente.prorroga.existente");
            }
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, exp.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
            if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE);
            } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(codigoEstado)) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE);
            } else if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(codigoEstado)){
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC);
            }else if(DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA.equals(codigoEstado)){
            	param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_FP);
            }
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {

            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto.getIdEntidadInformacion());

            // No es necesario indicarle al BPM que se está cursando una
            // prorroga, solo hay que avisar de la confirmaci�n de la prorroga
            // TareaNotificacion tareaProc = prorroga.getTareaAsociada();
            // jbpmUtils.signalToken(tareaProc.getTareaExterna().getTokenIdBpm(),
            // BPMContants.TRANSICION_ACTIVAR_APLAZAMIENTO);
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, proc.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
            
            ///Comprobamos si el supervisor de la tarea tiene un subtipo de tarea
            EXTTareaProcedimiento ExtTareaPro = genericDao.get(EXTTareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prorroga.getTareaAsociada().getTareaExterna().getTareaProcedimiento().getId()));
            if(!Checks.esNulo(ExtTareaPro) && !Checks.esNulo(ExtTareaPro.getTipoGestorSupervisor())){
                String sbt = coreProjectContext.getTipoSupervisorProrroga().get(ExtTareaPro.getTipoGestorSupervisor().getCodigo());
                if(!Checks.esNulo(sbt)){
                	param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, sbt); 
                }else{
                	param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO);	
                }
            }else{
            	param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO);
            }

            
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto.getIdEntidadInformacion());
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, proc.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
            param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, PluginCoreextensionConstantes.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION);
        }

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
        Filter filtroPlazoByCodigo = genericDao.createFilter(FilterType.EQUALS, "codigo", PlazoTareasDefault.CODIGO_SOLICITUD_PRORROGA);
        PlazoTareasDefault plazoDefault = genericDao.get(PlazoTareasDefault.class, filtroPlazoByCodigo);
        // PlazoTareasDefault plazoDefault =
        // plazoTareasDefaultDao.buscarPorCodigo(PlazoTareasDefault.CODIGO_SOLICITUD_PRORROGA);
        param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazoDefault.getPlazo());
        param.put(TareaBPMConstants.PRORROGA_ASOCIADA, prorroga);
        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);
        prorroga.setBpmProcess(bpmid);

        Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid, TareaBPMConstants.ID_TAREA);
        TareaNotificacion tarea = get(idTareaAsociada);

        // param.put(TareaBPMConstants.DESCRIPCION_TAREA,
        // dto.getDescripcionCausa());
        tarea.setDescripcionTarea(dto.getDescripcionCausa());
        saveOrUpdate(tarea);

        executor.execute(InternaBusinessOperation.BO_PRORR_MGR_SAVE_OR_UPDATE, prorroga);

        EventFactory.onMethodStop(this.getClass());

    }

    @Override
    public Long crearTareaConBPM(Long idEntidad, String tipoEntidad, String subtipoTarea, String codigoPlazo) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea) {
        return parent().getListByProcedimientoSubtipo(idProcedimiento, subtipoTarea);
    }
    
    @Override
	public List<TareaNotificacion> getListByProcedimientoSubtipo(
			Long idProcedimiento, Set<String> subtipoTarea) {
		return parent().getListByProcedimientoSubtipo(idProcedimiento, subtipoTarea);
	}

    @Override
    @BusinessOperation(EXT_BO_TAREA_EDITAR_ALERTA)
    @Transactional(readOnly = false)
    public void editarAlertaTarea(Long id, Boolean revisada, Long tipoRevision, String comentarios) {
        Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "id", id);
        EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, filtroTarea);
        if (!Checks.esNulo(tipoRevision)) {
            Filter filtroTipoRev = genericDao.createFilter(FilterType.EQUALS, "id", tipoRevision);
            NFADDTipoRevisionAlerta tipoRev = genericDao.get(NFADDTipoRevisionAlerta.class, filtroTipoRev);
            tarea.setTipoRevision(tipoRev);
        }
        tarea.setRevisada(revisada);
        tarea.setComentariosAlertaSupervisor(comentarios);
        tarea.setFechaRevisionAlerta(new Date());

        genericDao.save(EXTTareaNotificacion.class, tarea);

    }

    /**
     * obtiene el count de todas las tareas pendientes.
     * 
     * @param dto
     *            dto
     * @return cuenta
     */
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_OBTENER_CANT_TAREAS_PENDIENTES)
    public List<Long> obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto) {
        List<Long> result = obtenerCantidadDeTareasPendientesGenerico(dto, null);
        return result;
    }

    /**
     * valida que no existe otra prorroga ya creada para el mismo estado
     * itinerario.
     * 
     * @param idExpediente
     *            id del expediente
     * @param codigoEstado
     *            estado
     * @return condicion
     */
    private boolean validarExisteProrroga(Long idExpediente, String codigoEstado) {
        List<TareaNotificacion> prorrogas = getExtTareaNotificacionDao().obtenerProrrogaExpediente(idExpediente);
        for (TareaNotificacion tarea : prorrogas) {
            if (tarea.getEstadoItinerario().getCodigo().equals(codigoEstado)) {
                return true;
            }
        }
        return false;
    }

    /**
     * responde una cominicacion.
     * 
     * @param dtoGenerarTarea
     *            dto
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
        EXTTareaNotificacion tarea = new EXTTareaNotificacion();
        tarea.setTareaId(tareaOriginal);
        // Borro la comunicacion original, para que quede solo la respuesta.
        if (SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR);
        }
        if (SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR);
        }
        if (EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR_EXPTE);
        }
        if (EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_GESTOR_CONFECCION_EXPTE);
        }
        if (EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE.equals(tareaOriginal.getSubtipoTarea().getCodigoSubtarea())) {
            dtoGenerarTarea.setSubtipoTarea(EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_SUPERVISOR_CONFECCION_EXPTE);
        }

        SubtipoTarea subtipoTarea = getSubtipoTarea(dtoGenerarTarea.getSubtipoTarea());

        if (subtipoTarea == null) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", dtoGenerarTarea.getSubtipoTarea());
        }
        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea()) && !TipoTarea.TIPO_NOTIFICACION.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTarea.notificacionIncorrecta", dtoGenerarTarea.getSubtipoTarea());
        }
        delete(tareaOriginal);
        tarea.setEspera(false);
        tarea.setAlerta(false);

        return saveNotificacionTarea(tarea, subtipoTarea, dtoGenerarTarea.getIdEntidad(), dtoGenerarTarea.getCodigoTipoEntidad(), null, dtoGenerarTarea.getDescripcion(), null);
    }

    private void delete(TareaNotificacion tarea) {
        if ((tarea != null) && (tarea.getId() != null)) {
            genericDao.deleteById(TareaNotificacion.class, tarea.getId());
        }
    }

    private Long saveNotificacionTarea(EXTTareaNotificacion notificacionTarea, SubtipoTarea subtipoTarea, Long idEntidad, String codigoTipoEntidad, Long plazo, String descripcion,
            TipoCalculo tipoCalculo) {
        notificacionTarea.setTarea(subtipoTarea.getDescripcion());
        if (descripcion == null || descripcion.length() == 0) {
            notificacionTarea.setDescripcionTarea(subtipoTarea.getDescripcionLarga());
        } else {
            notificacionTarea.setDescripcionTarea(descripcion);
        }
        notificacionTarea.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
        notificacionTarea.setSubtipoTarea(subtipoTarea);
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoEntidad.class, codigoTipoEntidad);
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
            notificacionTarea.setVencimiento(VencimientoUtils.getFecha(fin, tipoCalculo));
        }
        // Seteo la entidad en el campo que corresponda
        decodificarEntidadInformacion(idEntidad, codigoTipoEntidad, notificacionTarea);
        EXTTareaNotificacion tarea = genericDao.save(EXTTareaNotificacion.class, notificacionTarea);
        return tarea.getId();
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
            if (Checks.esNulo(asu.getGestor())) {
            	tareaNotificacion.setEmisor("Automático");
            } else {
            	tareaNotificacion.setEmisor(asu.getGestor().getUsuario().getApellidoNombre());
            }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(codigoTipoEntidad)) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idEntidad);
            tareaNotificacion.setProcedimiento(proc);
            tareaNotificacion.setAsunto(proc.getAsunto());
            tareaNotificacion.setEstadoItinerario(proc.getAsunto().getEstadoItinerario());
            if (proc.getAsunto().getGestor() != null) {
                tareaNotificacion.setEmisor(proc.getAsunto().getGestor().getUsuario().getApellidoNombre());
            } else {
            	tareaNotificacion.setEmisor("Automático");
            }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_NOTIFICACION.equals(codigoTipoEntidad)) {
            Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idEntidad);
            tareaNotificacion.setProcedimiento(proc);
            tareaNotificacion.setAsunto(proc.getAsunto());
            tareaNotificacion.setEstadoItinerario(proc.getAsunto().getEstadoItinerario());
            if (proc.getAsunto().getGestor() != null) {
                tareaNotificacion.setEmisor(proc.getAsunto().getGestor().getUsuario().getApellidoNombre());
            }
            tareaNotificacion.setEmisor("Automatico");
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(codigoTipoEntidad)) {
            Objetivo objetivo = (Objetivo) executor.execute(InternaBusinessOperation.BO_OBJ_MGR_GET_OBJETIVO, idEntidad);

            tareaNotificacion.setObjetivo(objetivo);
            // Si el obj. es del estado vigente, el mismo tiene que tener la
            // asociacion que se asigna cuando entra en vigencia
            tareaNotificacion.setEstadoItinerario(objetivo.getPolitica().getEstadoItinerarioPolitica().getEstadoItinerario());
            setearEmisorObjetivo(tareaNotificacion, objetivo);
        }
    }

    /**
     * setea el emisor de la tarea.
     * 
     * @param tareaNotificacion
     *            tarea
     * @param exp
     *            expediente
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
     * 
     * @param tareaNotificacion
     *            tarea
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
            // Por si no estoy logueado y es un proceso del sistema
            tareaNotificacion.setEmisor("Autom�tico");
        }
    }

    /**
     * setea el emisor de la tarea.
     * 
     * @param tareaNotificacion
     *            tarea
     * @param Objetivo
     *            obj
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

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE)
    @Transactional
    public Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto) {

        // Conversi�n de los operadores para evitar el car�cter = en las urls
        if (dto.getFechaVencDesdeOperador() != null) {
            if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencDesdeOperador(">=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("<=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("=");
            }
        }
        if (dto.getFechaVencimientoHastaOperador() != null) {
            if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador(">=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("<=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("=");
            }
        }

        final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass = modelClassFactory.getModelFor(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PENDIETE, DtoResultadoBusquedaTareasBuzones.class);
        return busquedaGenericaTareas(dto, null, modelClass);
    }

    @BusinessOperation(TareaNotificacionApi.BO_TAREA_MGR_EXPORTAR_TAREAS_PARA_EXCEL)
    public FileItem exportaTareasExcel(DtoBuscarTareaNotificacion dto) {
        try {
            dto.setDescripcionTarea(URLDecoder.decode(dto.getDescripcionTarea(), "iso-8859-1"));
            dto.setNombreTarea(URLDecoder.decode(dto.getNombreTarea(), "iso-8859-1"));
        } catch (UnsupportedEncodingException e) {
            logger.error(e);
        }
        // Conversi�n de los operadores para evitar el car�cter = en las urls
        if (dto.getFechaVencDesdeOperador() != null) {
            if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencDesdeOperador(">=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("<=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("=");
            }
        }
        if (dto.getFechaVencimientoHastaOperador() != null) {
            if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador(">=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("<=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("=");
            }
        }

        List<ResultadoBusquedaTareasBuzonesDto> result = buscarTareasParaExcel(dto);
        ExportarTareasBean bean = null;
        FileItem fileItem = null;
        try {
            bean = operationExportToExcel(result);
            fileItem = bean.getFileItem();
        } catch (Throwable e) {
            logger.error(e);
        } finally {
            if (bean != null)
                bean.setEnUso(false);
        }
        return fileItem;
    }

    /**
     * Realiza la b�squeda de Tareas NOtificaciones para reporte Excel.
     * 
     * @param dto
     *            DtoBuscarTareaNotificacion
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL)
    @Override
    // TODO B�sqeda optimizada
    public List<ResultadoBusquedaTareasBuzonesDto> buscarTareasParaExcel(DtoBuscarTareaNotificacion dto) {

        dto.setLimit(Integer.MAX_VALUE - 1);
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        List<DDZona> zonas = usuarioLogado.getZonas();
        dto.setPerfiles(perfiles);
        dto.setZonas(zonas);
        dto.setUsuarioLogado(usuarioLogado);
        List<ResultadoBusquedaTareasBuzonesDto> listaRetorno = new ArrayList<ResultadoBusquedaTareasBuzonesDto>();
        final Class<? extends ResultadoBusquedaTareasBuzonesDto> modelClass = modelClassFactory.getModelFor(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL, ResultadoBusquedaTareasBuzonesDto.class);
        // agregarGestionVencidos(dto, listaRetorno);
        PageHibernate page = (PageHibernate) vtarBusquedaOptimizadaTareasDao.buscarTareasPendiente(dto, false, usuarioLogado, modelClass);
        listaRetorno.addAll((List<ResultadoBusquedaTareasBuzonesDto>) page.getResults());
        replaceGestorInListOpt(listaRetorno, usuarioLogado);
        replaceSupervisorInListOpt(listaRetorno, usuarioLogado);
        page.setResults(listaRetorno);
        return (List<ResultadoBusquedaTareasBuzonesDto>) page.getResults();

    }

    /**
     * Realiza la b�squeda de Tareas NOtificaciones para reporte Excel.
     * 
     * @param dto
     *            DtoBuscarTareaNotificacion
     * @return numero de tareas encontradas
     */
    @BusinessOperation(TareaNotificacionApi.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL_COUNT)
    @Override
    public Integer buscarTareasParaExcelCount(DtoBuscarTareaNotificacion dto) {

        // Conversi�n de los operadores para evitar el car�cter = en las urls
        if (dto.getFechaVencDesdeOperador() != null) {
            if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencDesdeOperador(">=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("<=");
            } else if (dto.getFechaVencDesdeOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencDesdeOperador("=");
            }
        }
        if (dto.getFechaVencimientoHastaOperador() != null) {
            if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MAYOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador(">=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_MENOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("<=");
            } else if (dto.getFechaVencimientoHastaOperador().equals(PluginCoreextensionConstantes.OPERADOR_IGUAL)) {
                dto.setFechaVencimientoHastaOperador("=");
            }
        }

        dto.setLimit(Integer.MAX_VALUE - 1);
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<Perfil> perfiles = usuarioLogado.getPerfiles();
        List<DDZona> zonas = usuarioLogado.getZonas();
        dto.setPerfiles(perfiles);
        dto.setZonas(zonas);
        dto.setUsuarioLogado(usuarioLogado);
        final Class<? extends ResultadoBusquedaTareasBuzonesDto> modelClass = modelClassFactory.getModelFor(TareaNotificacionApi.BO_TAREA_MGR_BUSCAR_TAREAS_PARA_EXCEL_COUNT, ResultadoBusquedaTareasBuzonesDto.class);
        return vtarBusquedaOptimizadaTareasDao.buscarTareasPendienteCount(dto, false, usuarioLogado, modelClass);
    }

    @SuppressWarnings("unchecked")
    private Page fusionaPagina(Page result1, Page result2) {
        ArrayList container = new ArrayList();
        int counter = 0;
        if (result1 != null && (!Checks.estaVacio(result1.getResults()))) {
            container.addAll(result1.getResults());
            counter = result1.getTotalCount();
        }
        if (result2 != null && (!Checks.estaVacio(result2.getResults()))) {
            container.addAll(result2.getResults());
            counter += result2.getTotalCount();
        }

        Page page;
        page = new PageSql();
        ((PageSql) page).setResults(container);
        ((PageSql) page).setTotalCount(counter);
        return page;
    }

    @BusinessOperation(BO_TAREA_MGR_OBTENER_COMUNICACION)
    public Map<String, Object> obtenerComunicacion(DtoGenerarTarea dto) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("respuestaComunicacion", "");
        param.put("textoComunicacion", "");
        param.put("requiereRespuesta", "");
        param.put("emisor", "");
        param.put("finalizada", "");
        param.put("fuerzaChkLeida", "false");

        if (dto == null)
            return param;

        try {
            param.put("respuestaComunicacion", dto.getDescripcion());
            param.put("textoComunicacion", dto.getDescripcionTareaAsociada());

            if (dto.getIdTareaAsociada() != null) {
                TareaNotificacion tareaNotificacion = getExtTareaNotificacionDao().get(dto.getIdTareaAsociada());

                if (dto.getDescripcionTareaAsociada() == null) {
                    // En este caso se trata de una comunicacion pendiente de
                    // responder
                    param.put("textoComunicacion", tareaNotificacion.getDescripcionTarea());
                    param.put("respuestaComunicacion", "");
                } else {

                    List<TareaNotificacion> tareaNotificacionRespuesta = null;
                    if (tareaNotificacion != null && tareaNotificacion.getDescripcionTarea() != null) {
                        tareaNotificacionRespuesta = getExtTareaNotificacionDao().buscarRespuestaAsociadaAComunicacion(tareaNotificacion);

                        if (tareaNotificacionRespuesta != null && !tareaNotificacionRespuesta.isEmpty()) {
                            param.put("respuestaComunicacion", tareaNotificacionRespuesta.get(0).getDescripcionTarea());
                            param.put("textoComunicacion", tareaNotificacion.getDescripcionTarea());
                        }

                    } else {
                        param.put("textoComunicacion", "");
                        param.put("respuestaComunicacion", "");
                    }
                }

            }

            if (dto instanceof EXTDtoGenerarTarea) {
                EXTDtoGenerarTarea EXTdto = (EXTDtoGenerarTarea) dto;
                TareaNotificacion tarNotificacion = getExtTareaNotificacionDao().get(EXTdto.getIdTarea());
                if (tarNotificacion != null) {

                    // Indicamos si la comunicaci�n requiere respuesta o no
                    if (tarNotificacion.getSubtipoTarea() != null) {
                        if (tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RECURSO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACUERDO_PROPUESTO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_ACUERDO_RECHAZADO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_SUPERVISOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_GESTOR)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_PROCEDIMIENTO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR)) {
                            param.put("requiereRespuesta", "false");
                        } else if (tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR)) {
                            param.put("requiereRespuesta", "true");
                        }

                        // Independientemente del emisor y destinatario para
                        // estas notificaciones siempre mostramos el check
                        // leido.
                        if (tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RECURSO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_CANCELADO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_CLIENTE_CANCELADO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_PAGADO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_CE_VENCIDA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RE_VENCIDA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_DC_VENCIDA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_CIERRA_SESION)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(SubtipoTarea.CODIGO_NOTIFICACION_GESTOR_PROPUESTA_SUBASTA)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_NOTIFICACION_ACUERDOS)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_NUEVO_RIESGO)
                                || tarNotificacion.getSubtipoTarea().getCodigoSubtarea().equals(EXTSubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_SCORING_GRAVE)
                               ) {
                            param.put("fuerzaChkLeida", "true");
                        }
                    }

                    // A�adimos en par�metros el emisor de la tarea
                    if (tarNotificacion.getAuditoria() != null && tarNotificacion.getAuditoria().getUsuarioCrear() != null) {
                        param.put("emisor", tarNotificacion.getAuditoria().getUsuarioCrear());
                    }

                    // A�adimos el parametro finalizada para saber si ya se ha
                    // leido la comunicaci�n
                    if (tarNotificacion.getTareaFinalizada() != null && tarNotificacion.getTareaFinalizada()) {
                        param.put("finalizada", "true");
                    } else {
                        param.put("finalizada", "false");
                    }
                }
            }
        } catch (Exception e) {
            return param;
        }
        return param;
    }

    private SubtipoTarea getSubtipoTarea(String codigoSubtarea) {
        return genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", codigoSubtarea));
    }

    private ExportarTareasBean operationExportToExcel(List<ResultadoBusquedaTareasBuzonesDto> listaDto) {
        WritableWorkbook workbook1 = null;
        ResultadoBusquedaTareasBuzonesDto dto = null;
        FileItem fileItem = null;
        File file = null;
        Label row = null;
        try {
            if (exportarExcelPool == null)
                inicializaPoolExportacionExcel();
            int numeroColumnas = NOMBRES_COLUMNAS.length;
            int j = 0;
            for (j = 0; j < exportarExcelPool.length; j++) {
                if (!exportarExcelPool[j].isEnUso()) {
                    exportarExcelPool[j].setEnUso(true);
                    file = new File(exportarExcelPool[j].getRuta());
                    if (!file.exists())
                        file.createNewFile();
                    if (file.canWrite()) {

                        workbook1 = Workbook.createWorkbook(file);
                        WritableSheet sheet1 = workbook1.createSheet(LISTA_ASUNTOS, 0);

                        // Pintamos las cabeceras de las columnas.
                        WritableFont cellFontBold10 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
                        WritableFont cellFontBold12 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);

                        WritableCellFormat cellFormatCabeceras = new WritableCellFormat(cellFontBold12);
                        cellFormatCabeceras.setFont(cellFontBold10);
                        cellFormatCabeceras.setAlignment(Alignment.CENTRE);
                        cellFormatCabeceras.setBackground(Colour.PLUM2);
                        cellFormatCabeceras.setBorder(Border.ALL, BorderLineStyle.THIN);
                        cellFormatCabeceras.setWrap(false);
                        for (int i = 0; i < numeroColumnas; i++) {
                            Label column = new Label(i, 0, NOMBRES_COLUMNAS[i], cellFormatCabeceras);
                            sheet1.addCell(column);
                        }

                        int i = 1;

                        Iterator<ResultadoBusquedaTareasBuzonesDto> it = listaDto.iterator();
                        while (it.hasNext()) {
                            dto = (ResultadoBusquedaTareasBuzonesDto) it.next();

                            if (dto.getId() != null) {
                                row = new Label(0, i, dto.getId().toString());
                            } else {
                                row = new Label(0, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getNombreTarea() != null) {
                                row = new Label(1, i, dto.getNombreTarea());
                            } else {
                                row = new Label(1, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getEntidadInformacion() != null) {
                                row = new Label(2, i, dto.getEntidadInformacion());
                            } else {
                                row = new Label(2, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getDescripcionEntidad() != null) {
                                row = new Label(3, i, dto.getDescripcionEntidad().toString());
                            } else {
                                row = new Label(3, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getFechaInicio() != null) {
                                row = new Label(4, i, dto.getFechaInicio().toString());
                            } else {
                                row = new Label(4, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getFechaVenc() != null) {
                                row = new Label(5, i, dto.getFechaVenc().toString());
                            } else {
                                row = new Label(5, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getSubtipoTareaDescripcion() != null) {
                                row = new Label(6, i, dto.getSubtipoTareaDescripcion());
                            } else {
                                row = new Label(6, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getDiasVencidoSQL() != null && !dto.getDiasVencidoSQL().equals("")) {
                                row = new Label(7, i, dto.getDiasVencidoSQL());
                            } else if (dto.getFechaVenc() != null) {
                                Long dif = new Date().getTime() - dto.getFechaVenc().getTime();
                                Integer diasVenc = Math.round(dif / DAY_MILISECONDS);
                                if (diasVenc > 0) {
                                    row = new Label(7, i, diasVenc.toString());
                                } else {
                                    row = new Label(7, i, VACIO);
                                }
                            } else {
                                row = new Label(7, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getGestor() != null) {
                                row = new Label(8, i, dto.getGestor());
                            } else {
                                row = new Label(8, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getSupervisor() != null) {
                                row = new Label(9, i, dto.getSupervisor());
                            } else {
                                row = new Label(9, i, VACIO);
                            }
                            sheet1.addCell(row);
                            if (dto.getGestor() != null) {
                                row = new Label(10, i, dto.getGestor());
                            } else {
                                row = new Label(10, i, VACIO);
                            }
                            sheet1.addCell(row);
                            try {
                                if (dto.getVolumenRiesgoSQL() != null) {
                                    row = new Label(11, i, dto.getVolumenRiesgoSQL().toString());
                                } else {
                                    row = new Label(11, i, VACIO);
                                }
                            } catch (Throwable e) {
                                row = new Label(11, i, VACIO);
                            }
                            sheet1.addCell(row);
                            try {
                                if (dto.getVolumenRiesgoSQL() != null) {
                                    row = new Label(12, i, dto.getVolumenRiesgoSQL().toString());
                                } else {
                                    row = new Label(12, i, VACIO);
                                }
                            } catch (Throwable e) {
                                row = new Label(12, i, VACIO);
                            }
                            sheet1.addCell(row);
                            i++;
                        }
                        workbook1.write();
                        fileItem = new FileItem(file);
                        fileItem.setFileName(LISTA_ASUNTOS_XLS);
                        exportarExcelPool[j].setFileItem(fileItem);
                        return exportarExcelPool[j];
                    }
                }
            }
        } catch (Throwable ex) {
            logger.error(ex);
        } finally {
            try {
                workbook1.close();
            } catch (Throwable e) {
                logger.error(e);
            }
        }
        return null;
    }

    private void inicializaPoolExportacionExcel() {
        String fileNameExtension = ".xls";
        exportarExcelPool = new ExportarTareasBean[Integer.parseInt(appProperties.getProperty(EXPORTAR_ASUNTOS_LIMITE_SIMULTANEO))];
        ExportarTareasBean bean = null;
        for (int i = 0; i < exportarExcelPool.length; i++) {
            bean = new ExportarTareasBean();
            bean.setEnUso(false);
            bean.setRuta(appProperties.getProperty(EXPORTAR_ASUNTOS_RUTA) + i + fileNameExtension);
            exportarExcelPool[i] = bean;
        }

    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_MGR_FINALIZAR_NOTIF)
    @Transactional(readOnly = false)
    public void finalizarNotificacion(Long idTarea) {
        TareaNotificacion tarea = get(idTarea);
        tarea.setTareaFinalizada(true);
        tarea.setFechaFin(new Date());
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
        // saveOrUpdate(tarea);
    }

	public EXTTareaNotificacion getTareaNoficiacionByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		EXTTareaNotificacion tareaNotif = genericDao.get(EXTTareaNotificacion.class, filtro);
		return tareaNotif;
	}

	
	@Transactional(readOnly=false)
	public EXTTareaNotificacion prepareGuid(TareaNotificacion tareaNotif) {
		EXTTareaNotificacion extTareaNotif = EXTTareaNotificacion.instanceOf(tareaNotif); 
		if (tareaNotif == null) return null;
		if (Checks.esNulo(extTareaNotif.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(getTareaNoficiacionByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			extTareaNotif.setGuid(guid);
			genericDao.save(EXTTareaNotificacion.class, extTareaNotif);
		}
		return extTareaNotif;
	}
	
}
