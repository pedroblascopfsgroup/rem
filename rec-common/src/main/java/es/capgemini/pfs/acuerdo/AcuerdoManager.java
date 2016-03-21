package es.capgemini.pfs.acuerdo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dao.ActuacionesAExplorarAcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.ActuacionesRealizadasAcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dao.AnalisisAcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAnalisisAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AnalisisAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDAnalisisCapacidadPago;
import es.capgemini.pfs.acuerdo.model.DDCambioSolvenciaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDConclusionTituloAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoPagoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.Guid;

/**
 * Servicio para los acuerdos de los asuntos.
 * @author marruiz
 */
@Service
public class AcuerdoManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private Executor executor;

    @Autowired
    private ActuacionesAExplorarAcuerdoDao actuacionesAExplorarAcuerdoDao;

    @Autowired
    private AcuerdoDao acuerdoDao;

    @Autowired
    private ActuacionesRealizadasAcuerdoDao actuacionesRealizadasAcuerdoDao;

    @Autowired
    private AnalisisAcuerdoDao analisisAcuerdoDao;
    
    private static final long ULTIMO_ACUERDO = -2L;

    /**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACUERDO_BY_ID)
    public Acuerdo getAcuerdoById(Long id) {
        if (id.longValue() == ULTIMO_ACUERDO) { return getUltimoAcuerdo(); }
        return acuerdoDao.get(id);
    }

    /**
     * Devuelve el �ltimo acuerdo ingresado.
     * @return
     */
    private Acuerdo getUltimoAcuerdo() {
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        logger.debug("Obteniendo ultimo acuerdo de " + usuario.getNombre());
        return acuerdoDao.getUltimoAcuerdoUsuario(usuario);
    }

    /**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACUERDO_DEL_ASUNTO)
    public List<Acuerdo> getAcuerdosDelAsunto(Long id) {
        logger.debug("Obteniendo acuerdos del asunto" + id);
        return acuerdoDao.getAcuerdosDelAsunto(id);
    }

    /**
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACTUACIONES_REALIZADAS_ACUERDO)
    public List<ActuacionesRealizadasAcuerdo> getActuacionesRealizadasAcuerdo(Long idAcuerdo) {
        return actuacionesRealizadasAcuerdoDao.buscarPorAcuerdo(idAcuerdo);
    }

    /**
     * Pasa un acuerdo a estado Aceptado.
     * @param idAcuerdo el id del acuerdo a aceptar.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_ACEPTAR_ACUERDO)
    @Transactional(readOnly = false)
    public void aceptarAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        //NO PUEDE HABER OTROS ACUERDOS VIGENTES.
        if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(), idAcuerdo)) { throw new BusinessOperationException(
                "acuerdos.hayOtrosVigentes"); }
        DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_ACEPTADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
        acuerdo.setFechaEstado(new Date());
        //Cancelo las tareas del supervisor
        cancelarTareasAcuerdoPropuesto(acuerdo);
        //Genero tareas al gestor para el cierre del acuerdo.
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, acuerdo.getAsunto().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, PlazoTareasDefault.CODIGO_CIERRE_ACUERDO);
        acuerdo.setIdJBPM(idJBPM);
        acuerdoDao.save(acuerdo);
    }

    private void cancelarTareasCerrarAcuerdo(Acuerdo acuerdo) {
        for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
            if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                Long idBPM = acuerdo.getIdJBPM();
                if (idBPM!=null) {
                	executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                }
            }
        }
    }

    private void cancelarTareasAcuerdoPropuesto(Acuerdo acuerdo) {
        for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
            if (SubtipoTarea.CODIGO_ACUERDO_PROPUESTO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                Long idBPM = acuerdo.getIdJBPM();
                if (idBPM!=null) {
                	executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                }
            }
        }
    }

    /**
     * Pasa un acuerdo a estado Rechazado.
     * @param idAcuerdo el id del acuerdo a rechazar
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_RECHAZAR_ACUERDO)
    @Transactional(readOnly = false)
    public void rechazarAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        DDEstadoAcuerdo estadoAcuerdoRechazado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_RECHAZADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoRechazado);
        acuerdo.setFechaEstado(new Date());
        acuerdoDao.save(acuerdo);
        //Cancelo las tareas del supervisor
        cancelarTareasAcuerdoPropuesto(acuerdo);
        cancelarTareasCerrarAcuerdo(acuerdo);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
                SubtipoTarea.CODIGO_ACUERDO_RECHAZADO, acuerdo.getObservaciones());
    }

    /**
     * Pasa un acuerdo a estado Finalizado.
     * @param idAcuerdo el id del acuerdo a finalizar
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_FINALIZAR_ACUERDO)
    @Transactional(readOnly = false)
    public void finalizarAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        if (acuerdo.getEstadoAcuerdo().getCodigo() == DDEstadoAcuerdo.ACUERDO_CANCELADO) { throw new BusinessOperationException("acuerdos.cancelado"); }
        DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
        acuerdo.setFechaEstado(new Date());
        acuerdoDao.save(acuerdo);
        //Cancelo las tareas del supervisor
        cancelarTareasAcuerdoPropuesto(acuerdo);
        cancelarTareasCerrarAcuerdo(acuerdo);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
                SubtipoTarea.CODIGO_ACUERDO_CERRADO, acuerdo.getObservaciones());

    }

    /**
     * Guarda un acuerdo.
     * Si es nuevo lo da de alta, si no lo modifica.
     * @param dto el dto con los datos
     * @return el id del acuerdo.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GUARDAR_ACUERDO)
    @Transactional(readOnly = false)
    public Long guardarAcuerdo(DtoAcuerdo dto) {

        //NO PUEDE HABER OTROS ACUERDOS VIGENTES.
        if (DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(dto.getEstado()) && acuerdoDao.hayAcuerdosVigentes(dto.getIdAsunto(), dto.getIdAcuerdo())) { throw new BusinessOperationException(
                "acuerdos.hayOtrosVigentes"); }

        Acuerdo acuerdo;
        if (dto.getIdAcuerdo() == null) {
            acuerdo = new Acuerdo();
            acuerdo.setFechaPropuesta(new Date());
            Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdAsunto());
            acuerdo.setAsunto(asunto);
        } else {
            acuerdo = acuerdoDao.get(dto.getIdAcuerdo());
        }
        DDEstadoAcuerdo estadoAcuerdo = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAcuerdo.class,
                dto.getEstado());
        acuerdo.setEstadoAcuerdo(estadoAcuerdo);
        acuerdo.setFechaEstado(new Date());
        if (dto.getImportePago() != null) {
            acuerdo.setImportePago(Double.valueOf(dto.getImportePago()));
        }
        acuerdo.setObservaciones(dto.getObservaciones());
        DDSolicitante solicitante = (DDSolicitante) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDSolicitante.class, dto
                .getSolicitante());
        acuerdo.setSolicitante(solicitante);
        DDTipoAcuerdo tipoAcuerdo = (DDTipoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoAcuerdo.class, dto
                .getTipoAcuerdo());
        acuerdo.setTipoAcuerdo(tipoAcuerdo);
        if (dto.getTipoPago() != null) {
            DDTipoPagoAcuerdo tipoPagoAcuerdo = (DDTipoPagoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDTipoPagoAcuerdo.class, dto.getTipoPago());

            acuerdo.setTipoPagoAcuerdo(tipoPagoAcuerdo);
        }
        if (dto.getPeriodicidad() != null) {
            DDPeriodicidadAcuerdo periodicidadAcuerdo = (DDPeriodicidadAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDPeriodicidadAcuerdo.class, dto.getPeriodicidad());
            acuerdo.setPeriodicidadAcuerdo(periodicidadAcuerdo);
        }
        acuerdo.setPeriodo(dto.getPeriodo());

        //Boolean matarTareas = false;

        //Si se ha cancelado el acuerdo O se ha cerrado se deben matar las tareas
        if (DDEstadoAcuerdo.ACUERDO_CANCELADO.equals(dto.getEstado()) || DDEstadoAcuerdo.ACUERDO_FINALIZADO.equals(dto.getEstado())
                || DDEstadoAcuerdo.ACUERDO_RECHAZADO.equals(dto.getEstado()) || (dto.getFechaCierre() != null)) {

            for (TareaNotificacion tarea : acuerdo.getAsunto().getTareas()) {
                if (SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                    Long idBPM = acuerdo.getIdJBPM();
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                }
            }
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, acuerdo.getAsunto().getId(),
                    DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_CERRADO, null);

        }

        //VEO SI ESTAN CERRANDO EL ACUERDO
        if (dto.getFechaCierre() != null) {
            //Esta fecha solo viene cuando el estado es vigente y el gestor la carga
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            try {
                acuerdo.setFechaCierre(sdf1.parse(dto.getFechaCierre()));
            } catch (ParseException e) {
                logger.error("Error parseando la fecha", e);
            }
            DDEstadoAcuerdo estadoAcuerdoFinalizado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);

            acuerdo.setEstadoAcuerdo(estadoAcuerdoFinalizado);
        } else if (DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(dto.getEstado())) {
            Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, acuerdo.getAsunto().getId(),
                    DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, PlazoTareasDefault.CODIGO_CIERRE_ACUERDO);

            acuerdo.setIdJBPM(idJBPM);
        }
        acuerdoDao.saveOrUpdate(acuerdo);
        return acuerdo.getId();
    }

    /**
     * Pasa un Acuerdo en estado En Conformaci�n a Propuesto.
     * @param idAcuerdo el id del acuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_PROPONER_ACUERDO)
    @Transactional(readOnly = false)
    public void proponerAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        DDEstadoAcuerdo estadoAcuerdoPropuesto = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
        acuerdo.setEstadoAcuerdo(estadoAcuerdoPropuesto);

        //crear tareas para el supervisor
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, acuerdo.getAsunto().getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACUERDO_PROPUESTO, PlazoTareasDefault.CODIGO_ACUERDO_PROPUESTO, true);
        acuerdo.setIdJBPM(idJBPM);
        acuerdoDao.save(acuerdo);
    }

    /**
     * Pasa un Acuerdo en estado En Conformaci�n a Cancelado.
     * @param idAcuerdo el id del acuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_CANCELAR_ACUERDO)
    @Transactional(readOnly = false)
    public void cancelarAcuerdo(Long idAcuerdo) {
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        DDEstadoAcuerdo estadoAcuerdoCancelado = (DDEstadoAcuerdo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_CANCELADO);

        acuerdo.setEstadoAcuerdo(estadoAcuerdoCancelado);

        cancelarTareasAcuerdoPropuesto(acuerdo);
        cancelarTareasCerrarAcuerdo(acuerdo);

        acuerdoDao.save(acuerdo);
    }

    /**
     * @param idActuacion Long
     * @return ActuacionesRealizadasAcuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_ACTUALIZACIONES_REALIZADAS_ACUERDO)
    public ActuacionesRealizadasAcuerdo getActuacionAcuerdo(Long idActuacion) {
        return actuacionesRealizadasAcuerdoDao.get(idActuacion);
    }

    /**
     * Guarda o actualiza una actuaci�n realizada de un acuerdo.
     * @param actuacionesRealizadasAcuerdo DtoActuacionesRealizadasAcuerdo
  
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_REALIZADAS_ACUERDO)
    @Transactional
    public void saveActuacionesRealizadasAcuerdo(DtoActuacionesRealizadasAcuerdo actuacionesRealizadasAcuerdo) {
    }
*/
    
    /**
     * Guarda los cambios en el objeto análisis de un acuerd.
     * @param dto el dto con los datos.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GUARDAR_ANALISIS_ACUERDO)
    @Transactional
    public void guardarAnalisisAcuerdo(DtoAnalisisAcuerdo dto) {
        Acuerdo ac = acuerdoDao.get(dto.getIdAcuerdo());
        AnalisisAcuerdo analisis;
        if (ac.getAnalisisAcuerdo() != null) {
            analisis = ac.getAnalisisAcuerdo();
        } else {
            analisis = new AnalisisAcuerdo();
        }
        analisis.setAcuerdo(ac);

        DDConclusionTituloAcuerdo conclusionTituloAcuerdo = (DDConclusionTituloAcuerdo) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDConclusionTituloAcuerdo.class, dto.getConclusionTitulos());
        analisis.setDdConclusionTituloAcuerdo(conclusionTituloAcuerdo);
        analisis.setObservacionesTitulos(dto.getObservacionesTitulos());

        DDAnalisisCapacidadPago analisisCapacidadPago = (DDAnalisisCapacidadPago) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAnalisisCapacidadPago.class, dto.getCambioCapPago());
        analisis.setDdAnalisisCapacidadPago(analisisCapacidadPago);
        analisis.setObservacionesPago(dto.getObservacionesCapPago());
        analisis.setImportePago(dto.getAumentoCapPago());

        DDCambioSolvenciaAcuerdo cambioSolvenciaAcuerdo = (DDCambioSolvenciaAcuerdo) executor.execute(
                ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDCambioSolvenciaAcuerdo.class, dto.getCambioSolvencia());
        analisis.setDdCambioSolvenciaAcuerdo(cambioSolvenciaAcuerdo);
        analisis.setImporteSolvencia(dto.getAumentoSolvencia());
        analisis.setObservacionesSolvencia(dto.getObservacionesSolvencia());

        analisisAcuerdoDao.save(analisis);
    }

    /**
     * @param id Long
     * @return ActuacionesAExplorarAcuerdo
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACTUALIZACIONES_A_EXPLORAR_ACUERDO_BY_ID)
    public ActuacionesAExplorarAcuerdo getActuacionesAExplorarAcuerdoById(Long id) {
        return actuacionesAExplorarAcuerdoDao.get(id);
    }

    /**
     * Retorna todas las actuaciones a explorar marcadas y las no marcadas pero con tipo y subtipo activo.
     * @param idAcuerdo Long
     * @return List ActuacionesAExplorarAcuerdo: la lista si bien tiene objetos ActuacionesAExplorarAcuerdo,
     * se usa esta clase como DTO, ya que los subtipos que no fueron editados se deben desplegar también
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACTUALIZACIONES_A_EXPLORAR_ACUERDO)
    public List<ActuacionesAExplorarAcuerdo> getActuacionesAExplorarAcuerdo(Long idAcuerdo) {

        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);

        // Obtengo la lista de las actuaciones marcadas
        List<ActuacionesAExplorarAcuerdo> actuacionesAExplorarMarcadasByAcuerdo = actuacionesAExplorarAcuerdoDao
                .getActuacionesAExplorarMarcadasByAcuerdo(idAcuerdo);
        // y de todos los tipos y subtipos aunque no hayan sido marcados, excepto los inactivos
        List<DDSubtipoSolucionAmistosaAcuerdo> subtiposActivosOMarcadosByAcuerdo = actuacionesAExplorarAcuerdoDao
                .getSubtiposActivosOMarcadosByAcuerdo(idAcuerdo);

        // y unificamos ambas listas en una
        List<ActuacionesAExplorarAcuerdo> todasLasActuacionesAExplorar = new ArrayList<ActuacionesAExplorarAcuerdo>();

        todasLasActuacionesAExplorar.addAll(actuacionesAExplorarMarcadasByAcuerdo);

        boolean estaEnLista;
        for (DDSubtipoSolucionAmistosaAcuerdo subtipo : subtiposActivosOMarcadosByAcuerdo) {
            estaEnLista = false;
            for (ActuacionesAExplorarAcuerdo actuacion : actuacionesAExplorarMarcadasByAcuerdo) {
                if (actuacion.getDdSubtipoSolucionAmistosaAcuerdo().equals(subtipo)) {
                    estaEnLista = true;
                    break;
                }
            }
            if (!estaEnLista) {
                ActuacionesAExplorarAcuerdo actuacionSinExplorar = new ActuacionesAExplorarAcuerdo();
                actuacionSinExplorar.setAcuerdo(acuerdo);
                actuacionSinExplorar.setDdSubtipoSolucionAmistosaAcuerdo(subtipo);
                actuacionSinExplorar.setDdValoracionActuacionAmistosa(null);
                actuacionSinExplorar.setObservaciones(null);
                actuacionSinExplorar.setId(null);
                todasLasActuacionesAExplorar.add(actuacionSinExplorar);
            }
        }

        // Ordena la lista por tipos
        Collections.sort(todasLasActuacionesAExplorar);

        return todasLasActuacionesAExplorar;
    }

    /**
     * Guarda o actualiza la actuacion a explorar modificada o nueva.
     * @param dto DtoActuacionesAExplorar
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_A_EXPLORAR_ACUERDO)
    @Transactional(readOnly = false)
    public void saveActuacionAExplorarAcuerdo(DtoActuacionesAExplorar dto) {
    }
*/
    
    /**
     * Indica si el usuario que está conectado puede editar el acuerdo.
     * @param idAcuerdo el acuerdo que se va a mostrar
     * @return true si puede, false si no
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ACUERDO_MGR_PUEDE_EDITAR)
    public Boolean puedeEditar(Long idAcuerdo) {
        if (idAcuerdo == null || idAcuerdo.longValue() < 0) {
            //Se está buscando el �ltimo acuerdo dado de alta, por lo tanto no se dispone del id,
            //pero se puede editar de todos modos.
            return Boolean.TRUE;
        }
        Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
        Usuario u = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        //SI ES EL SUPERVISOR
        if (acuerdo.getAsunto().getSupervisor().getUsuario().getId().longValue() == u.getId().longValue()
                && DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(acuerdo.getEstadoAcuerdo().getCodigo())
                || DDEstadoAcuerdo.ACUERDO_PROPUESTO.equals(acuerdo.getEstadoAcuerdo().getCodigo())) {
            //EL GESTOR SOLO PUEDE EDITAR EL ACUERDO SI ESTA EN ESTADOS EN CONFORMACION O PROPUESTOS
            return Boolean.TRUE;

        }
        //SI ES EL GESTOR DEL ASUNTO
        if (acuerdo.getAsunto().getGestor().getUsuario().getId().longValue() == u.getId().longValue()
                && DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION.equals(acuerdo.getEstadoAcuerdo().getCodigo())
                || DDEstadoAcuerdo.ACUERDO_PROPUESTO.equals(acuerdo.getEstadoAcuerdo().getCodigo())) { return Boolean.TRUE; }
        //SI LLEGO HASTA ACA NO PUEDE EDITAR
        return Boolean.FALSE;
    }
    
	@Transactional(readOnly = false)
	public void prepareGuid(ActuacionesRealizadasAcuerdo actuacion) {
		if (Checks.esNulo(actuacion.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			
			while(actuacionesRealizadasAcuerdoDao.getByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			actuacion.setGuid(guid);
			actuacionesRealizadasAcuerdoDao.saveOrUpdate(actuacion);
		}
	}

	@Transactional(readOnly = false)
	public void prepareGuid(ActuacionesAExplorarAcuerdo actuacion) {
		if (Checks.esNulo(actuacion.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(actuacionesAExplorarAcuerdoDao.getByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			actuacion.setGuid(guid);
			actuacionesAExplorarAcuerdoDao.saveOrUpdate(actuacion);
		}
	}

    
}
