package es.capgemini.pfs.decisionProcedimiento;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.dao.EstadoProcedimientoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.decisionProcedimiento.dao.DecisionProcedimientoDao;
import es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimientoDerivado.ProcedimientoDerivadoManager;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Creado el Mon Jan 12 15:48:55 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Service
public class DecisionProcedimientoManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private Executor executor;
    @Autowired
    private EstadoProcedimientoDao estadoProcedimientoDao;
    @Autowired
    private DecisionProcedimientoDao decisionProcedimientoDao;
    @Autowired
    private ProcedimientoDao procedimientoDao;
    @Autowired
    private PersonaDao personaDao;
    @Autowired
    private ProcedimientoManager procedimientoManager;
    @Autowired
    private ProcedimientoDerivadoManager procedimientoDerivadoManager;
    @Autowired
    private TareaNotificacionManager tareaNotificacionManager;
    @Autowired
    private JBPMProcessManager jbpmUtil;
    @Resource
    private MessageService messageService;
    @Autowired
    private TipoProcedimientoDao tipoProcedimientoDao;

    /**
     * PONER JAVADOC FO.
     * @param idProcedimiento id
     * @return dp
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET_LIST)
    public List<DecisionProcedimiento> getList(Long idProcedimiento) {
        return decisionProcedimientoDao.getByIdProcedimiento(idProcedimiento);
    }

    /**
     * PONER JAVADOC FO.
     * @param id id
     * @return dp
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET)
    public DecisionProcedimiento get(Long id) {
        return decisionProcedimientoDao.get(id);
    }

    /**
     * PONER JAVADOC FO.
     * @param idProcedimiento id
     * @return dp
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET_INSTANCE)
    public DecisionProcedimiento getInstance(Long idProcedimiento) {
        Procedimiento prc = procedimientoDao.get(idProcedimiento);
        DecisionProcedimiento decisionProcedimiento = new DecisionProcedimiento();
        decisionProcedimiento.setProcedimiento(prc);
        // decisionProcedimiento.setEstadoDecision((DDEstadoDecision)
        // dictionaryManager.getByCode(DDEstadoDecision.class,
        // DDEstadoDecision.ESTADO_PROPUESTO));
        decisionProcedimiento.setAuditoria(Auditoria.getNewInstance());
        return decisionProcedimiento;
    }

    /**
     * Para crear o actualizar una propuesta de decision desde un rol de gestor.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_CREAR_PROPUESTA)
    @Transactional
    public void crearPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception {

        // seteo en estado propuesto la decision
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, DDEstadoDecision.ESTADO_PROPUESTO);

        dtoDecisionProcedimiento.getDecisionProcedimiento().setEstadoDecision(estadoDecision);

        DecisionProcedimiento decisionProcedimiento;
        decisionProcedimiento = createOrUpdate(dtoDecisionProcedimiento);

        // enviar mensaje al supervisor
        notificarSupervisor(dtoDecisionProcedimiento.getDecisionProcedimiento());

        //Comprobamos si existe alguna tarea de decisión para este procedimiento y se la asociamos a la decisión
        List<TareaNotificacion> vTareas = (List<TareaNotificacion>) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_PROC_SUBTIPO,
                dtoDecisionProcedimiento.getDecisionProcedimiento().getProcedimiento().getId(), SubtipoTarea.CODIGO_TOMA_DECISION_BPM);
        //List<TareaNotificacion> vTareas = tareaNotificacionManager.getListByProcedimientoSubtipo(dtoDecisionProcedimiento.getDecisionProcedimiento()
        //        .getProcedimiento().getId(), SubtipoTarea.CODIGO_TOMA_DECISION_BPM);

        //Si tiene alguna tarea, borramos la primera de ellas
        if (vTareas != null && vTareas.size() > 0) {

            Iterator<TareaNotificacion> it = vTareas.iterator();
            boolean tareaEncontrada = false;

            //Recorremos las tareas decisión del procedimiento
            while (it.hasNext() && !tareaEncontrada) {
                TareaNotificacion tarea = it.next();

                // Buscamos la primera tarea que no esté asignada ya a una
                // decisión y no esté borrada; para asignarla a la decisión
                // actual
                if (tarea.getDecisionAsociada() == null && !tarea.getAuditoria().isBorrado()) {

                    tarea.getAuditoria().setBorrado(true);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
                    //tareaNotificacionManager.saveOrUpdate(tarea);

                    decisionProcedimiento.setTareaAsociada(tarea);
                    decisionProcedimientoDao.update(decisionProcedimiento);

                    tareaEncontrada = true;
                }
            }

        }

    }

    /**
     * Crea o Actualiza un objeto DecisionProcedimiento en la BD.
     *
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @return DecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_CREATE_OR_UPDATE)
    @Transactional
    public DecisionProcedimiento createOrUpdate(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception {

        DecisionProcedimiento decisionProcedimiento = null;
        if (dtoDecisionProcedimiento.getDecisionProcedimiento().getId() != null) {
            decisionProcedimiento = decisionProcedimientoDao.get(dtoDecisionProcedimiento.getDecisionProcedimiento().getId());
        } else {
            decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();
        }
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, dtoDecisionProcedimiento.getStrEstadoDecision());

        decisionProcedimiento.setEstadoDecision(estadoDecision);

        DDCausaDecision causaDecision = (DDCausaDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCausaDecision.class,
                dtoDecisionProcedimiento.getCausaDecision());
        decisionProcedimiento.setCausaDecision(causaDecision);
        decisionProcedimiento.setFinalizada(dtoDecisionProcedimiento.getFinalizar());
        decisionProcedimiento.setParalizada(dtoDecisionProcedimiento.getParalizar());
        if (decisionProcedimiento.getProcedimientosDerivados() == null) {
            decisionProcedimiento.setProcedimientosDerivados(new ArrayList<ProcedimientoDerivado>());
        }
        int counter = 0;
        for (DtoProcedimientoDerivado procDerivado : dtoDecisionProcedimiento.getProcedimientosDerivados()) {
            if (procDerivado.getProcedimientoPadre() == null) {
                continue;
            }

            ProcedimientoDerivado prc = null;
            if (procDerivado.getId() != null) {
                prc = procedimientoDerivadoManager.get(procDerivado.getId());
            }
            if (prc != null) {
                counter++;
                continue;
            }

            prc = crearProcedimientoDerivado(procDerivado, decisionProcedimiento);
            // procedimientoDerivadoDao.saveOrUpdate(prc);
            counter++;
            // Busco si el objeto existe en la lista de procedmientos derivados
            if (prc.getId() != null) {
                for (int i = 0; i < decisionProcedimiento.getProcedimientosDerivados().size(); i++) {
                    ProcedimientoDerivado prd = decisionProcedimiento.getProcedimientosDerivados().get(i);
                    if (prd.getId() == (prc.getId())) {
                        decisionProcedimiento.getProcedimientosDerivados().set(i, prc);
                    }
                }
            } else {
                decisionProcedimiento.getProcedimientosDerivados().add(prc);
            }

        }
        if (counter == 0 && decisionProcedimiento.getCausaDecision() == null) { throw new Exception(messageService
                .getMessage("decisionProcedimiento.errores.procedimientosacciones")); }
        // return decisionProcedimiento;
        decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
        return decisionProcedimiento;
    }

    /**
     * PONER JAVADOC FO.
     * @param idDecisionProcedimiento idDecisionProcedimiento
     * @return pd
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_GET_PROCEDIMIENTOS_DERIVADOS)
    public List<ProcedimientoDerivado> getProcedimientosDerivados(Long idDecisionProcedimiento) {
        DecisionProcedimiento dp = null;
        List<ProcedimientoDerivado> ls = new ArrayList<ProcedimientoDerivado>();
        try {
            dp = decisionProcedimientoDao.get(idDecisionProcedimiento);
        } catch (Exception e) {
            logger.error("Error al recoger los procedimientos derivados", e);
        }
        if (dp != null) {
            ls = dp.getProcedimientosDerivados();
        }

        return ls;
    }

    /**
     * Crea un objeto ProcedimientoDerivado a partir del
     * DtoProcedimientoDerivado y crea el procedimiento Hijo, del procedimiento
     * asociado a la decision.
     *
     * @param dtoProc El DtoProcedimientoDerivado
     * @param decisionProcedimiento el objeto DecisionProcedimiento
     *
     * @return ProcedimientoDerivado
     */
    private ProcedimientoDerivado crearProcedimientoDerivado(DtoProcedimientoDerivado dtoProc, DecisionProcedimiento decisionProcedimiento) {
        Procedimiento procHijo = new Procedimiento();
        Procedimiento procPadre = procedimientoManager.getProcedimiento(dtoProc.getProcedimientoPadre());

        procHijo.setAuditoria(Auditoria.getNewInstance());
        procHijo.setPlazoRecuperacion(dtoProc.getPlazoRecuperacion());
        procHijo.setSaldoRecuperacion(dtoProc.getSaldoRecuperacion());
        procHijo.setPorcentajeRecuperacion(dtoProc.getPorcentajeRecuperacion());
        procHijo.setProcedimientoPadre(procPadre);

        procHijo.setAsunto(procPadre.getAsunto());
        procHijo.setExpedienteContratos(procPadre.getExpedienteContratos());
        procHijo.setDecidido(procPadre.getDecidido());
        procHijo.setFechaRecopilacion(procPadre.getFechaRecopilacion());
        procHijo.setJuzgado(procPadre.getJuzgado());
        procHijo.setCodigoProcedimientoEnJuzgado(procPadre.getCodigoProcedimientoEnJuzgado());
        procHijo.setObservacionesRecopilacion(procPadre.getObservacionesRecopilacion());

        procHijo.setSaldoOriginalNoVencido(procPadre.getSaldoOriginalNoVencido());
        procHijo.setSaldoOriginalVencido(procPadre.getSaldoOriginalVencido());
        // procHijo.setSaldoRecuperacion(procPadre.getSaldoRecuperacion());

        // seteo el procedimiento como 'derivado'

        DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO);
        procHijo.setEstadoProcedimiento(estadoProcedimiento);

        DDTipoActuacion tipoActuacion = (DDTipoActuacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoActuacion.class,
                dtoProc.getTipoActuacion());
        procHijo.setTipoActuacion(tipoActuacion);

        TipoProcedimiento tipoProcedimiento = tipoProcedimientoDao.getByCodigo(dtoProc.getTipoProcedimiento());

        procHijo.setTipoProcedimiento(tipoProcedimiento);

        DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDTipoReclamacion.class, dtoProc.getTipoReclamacion());
        procHijo.setTipoReclamacion(tipoReclamacion);

        // Agrego las personas al procedimiento
        List<Persona> personas = new ArrayList<Persona>();
        for (Long idPersona : dtoProc.getPersonas()) {
            if (idPersona == 0) {
                continue;
            }
            personas.add(personaDao.get(idPersona));
        }
        procHijo.setPersonasAfectadas(personas);

        procedimientoManager.saveOrUpdateProcedimiento(procHijo);

        ProcedimientoDerivado procedimientoDerivado = new ProcedimientoDerivado();
        procedimientoDerivado.setId(dtoProc.getId());
        procedimientoDerivado.setProcedimiento(procHijo);
        procedimientoDerivado.setDecisionProcedimiento(decisionProcedimiento);
        procedimientoDerivado.setAuditoria(Auditoria.getNewInstance());

        return procedimientoDerivado;
    }

    /**
     * Da por aceptada la propuesta de Decision<br>
     * Lanza los correspondientes BPM.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA)
    @Transactional(readOnly = false)
    public void aceptarPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception {

        DecisionProcedimiento decision = null;
        decision = createOrUpdate(dtoDecisionProcedimiento);

        DecisionProcedimiento dp = decision;

        // Flag para saber si el estado estaba propuesto, y enviar una
        // notificacion al gestor con el resultado
        boolean estabaPropuesto = dp.getEstadoDecision() != null && dp.getEstadoDecision().getCodigo().equals(DDEstadoDecision.ESTADO_PROPUESTO);

        Procedimiento p = procedimientoManager.getProcedimiento(dp.getProcedimiento().getId());

        // VALIDACIONES
        // No existen los procedimientos con los códigos pasados como
        // parámetros.
        // El procedimiento origen no está activo.
        if (p.getEstadoProcedimiento() != null
                && (p.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO || p.getEstadoProcedimiento()
                        .getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)) { throw new UserException(
                "El procedimiento de origen no está activo"); }

        for (ProcedimientoDerivado prd : dp.getProcedimientosDerivados()) {
            Procedimiento prc = procedimientoManager.getProcedimiento(prd.getProcedimiento().getId());
            // Validar estado del procedimiento
            if (!prc.getEstadoProcedimiento().getCodigo().equals(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO)) { throw new UserException(
                    "El procedimiento " + prc.getId() + " no está en estado derivado"); }

            // Registrar los saldos vencido y no vencido originales del último
            // movimiento de los contratos
            Movimiento mv = null;
            BigDecimal saldoOriginalNoVencido = new BigDecimal("0.0");
            BigDecimal saldoOriginalVencido = new BigDecimal("0.0");
            for (ExpedienteContrato ec : prc.getExpedienteContratos()) {
                mv = ec.getContrato().getLastMovimiento();
                if (mv != null) {
                    saldoOriginalNoVencido = saldoOriginalNoVencido.add(new BigDecimal(mv.getPosVivaNoVencida().floatValue()));
                    saldoOriginalVencido = saldoOriginalVencido.add(new BigDecimal(mv.getPosVivaVencida().floatValue()));
                }
            }
            prc.setSaldoOriginalNoVencido(saldoOriginalNoVencido);
            prc.setSaldoOriginalVencido(saldoOriginalVencido);

            // Lanzar los JBPM para cada procedimiento
            String nombreJBPM = prc.getTipoProcedimiento().getXmlJbpm();
            Map<String, Object> param = new HashMap<String, Object>();
            param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, prc.getId());
            Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);
            //
            prc.setProcessBPM(idBPM);
            procedimientoDao.update(prc);

        }

        // Lanzar el/los proceso/s correspondiente/s (incluidos en la
        // derivación)

        // Verificar si se da por finalizado el procedimiento origen
        if (dp.getCausaDecision() != null) {
            Long idProcessBPM = p.getProcessBPM();
            if (dp.getFinalizada()) {
                // FINALIZADO:Parar definitivamente el procedimiento origen
                try {
                    jbpmUtil.finalizarProcedimiento(p.getId());
                    p.setEstadoProcedimiento(estadoProcedimientoDao.buscarPorCodigo(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));

                } catch (Exception e) {
                    logger.error("Error al finalizar el procedimiento " + p.getId(), e);
                }
            }
            if (dp.getParalizada()) {
                // PARALIZADO: Paralizar* durante el periodo especificado en la
                // decisión el procedimiento origen.
                jbpmUtil.aplazarProcesosBPM(idProcessBPM, dp.getFechaParalizacion());

            }

        }
        // Setear Decision como aceptada
        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, DDEstadoDecision.ESTADO_ACEPTADO);

        dp.setEstadoDecision(estadoDecision);

        decisionProcedimientoDao.saveOrUpdate(dp);

        // Enviar al gestor una notificaciÃ³n con el resultado de aceptaciÃ³n.
        if (estabaPropuesto) {
            notificarGestor(dp, true);
        }

        // Si tiene una tarea asignada a la decisión la finalizamos
        TareaNotificacion tarea = dp.getTareaAsociada();
        if (tarea != null) {
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
            //tareaNotificacionManager.borrarNotificacionTarea(tarea.getId());
        }

        // borrar la tarea
        if (dp.getProcessBPM() != null) {
            finalizarTarea(dp.getProcessBPM());
        }

        //Actualizamos el estado del asunto
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO, p.getAsunto().getId());
    }

    /**
     * Rechaza la propuesta de Decision.
     *
     * @param dtoDecisionProcedimiento dto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA)
    @Transactional
    public void rechazarPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) {
        // Setear Decision como rechazada
        DecisionProcedimiento decisionProcedimiento = dtoDecisionProcedimiento.getDecisionProcedimiento();

        // Si tiene una tarea asignada a la decisión la revivimos y le borramos
        // la decisión asignada
        TareaNotificacion tarea = decisionProcedimiento.getTareaAsociada();
        if (tarea != null) {
            tarea.getAuditoria().setBorrado(false);
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
            //tareaNotificacionManager.saveOrUpdate(tarea);

            decisionProcedimiento.setTareaAsociada(null);
        }

        //Cancelamos todos los procedimientos de la decisión rechazada
        for (ProcedimientoDerivado pd : decisionProcedimiento.getProcedimientosDerivados()) {
            Procedimiento prc = procedimientoManager.getProcedimiento(pd.getProcedimiento().getId());

            prc.setEstadoProcedimiento(estadoProcedimientoDao.buscarPorCodigo(DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO));
            procedimientoManager.saveOrUpdateProcedimiento(prc);
        }

        DDEstadoDecision estadoDecision = (DDEstadoDecision) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoDecision.class, DDEstadoDecision.ESTADO_RECHAZADO);
        decisionProcedimiento.setEstadoDecision(estadoDecision);
        // enviar notificacion
        decisionProcedimientoDao.saveOrUpdate(decisionProcedimiento);
        notificarGestor(decisionProcedimiento, false);
        // borrar la tarea
        finalizarTarea(decisionProcedimiento.getProcessBPM());
    }

    private void notificarGestor(DecisionProcedimiento dp, boolean aceptada) {
        // Crear una notificaciÃ³n al gestor
        Long idEntidadInformacion = dp.getProcedimiento().getId();
        String codigoTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO;
        String ok = "";
        Object[] param = new Object[] { dp.getProcedimiento().getNombreProcedimiento() };
        if (aceptada) {
            ok = messageService.getMessage("decisionProcedimiento.resultado.aceptado", param);
        } else {
            ok = messageService.getMessage("decisionProcedimiento.resultado.rechazado", param);
        }
        // String descripcion = "Se ha " + ok +
        // " la propuesta de decision del procedimiento  " +
        // dp.getProcedimiento().getNombreProcedimiento();
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea, ok);
        //tareaNotificacionManager.crearNotificacion(idEntidadInformacion, codigoTipoEntidad, codigoSubtipoTarea, ok);
    }

    private void notificarSupervisor(DecisionProcedimiento dp) {
        // Crear una notificación al Supervisor
        // String descripcion =
        // "Se ha realizado una propuesta de decision sobre el  procedimiento  "
        // + dp.getProcedimiento().getNombreProcedimiento();
        // crear tareas para el supervisor
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, dp.getProcedimiento().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO,
                PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO);
        //Long idJBPM = tareaNotificacionManager.crearTareaConBPM(dp.getProcedimiento().getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO,
        //        SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO, PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO);
        dp.setProcessBPM(idJBPM);
        decisionProcedimientoDao.save(dp);
    }

    private void finalizarTarea(Long idBPM) {
        jbpmUtil.signalProcess(idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
    }
}
