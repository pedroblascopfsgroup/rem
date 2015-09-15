package es.capgemini.pfs.politica;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dao.ObjetivoDao;
import es.capgemini.pfs.politica.dto.DtoObjetivo;
import es.capgemini.pfs.politica.model.DDCampoDestinoObjetivo;
import es.capgemini.pfs.politica.model.DDEstadoCumplimiento;
import es.capgemini.pfs.politica.model.DDEstadoObjetivo;
import es.capgemini.pfs.politica.model.DDTendencia;
import es.capgemini.pfs.politica.model.DDTipoObjetivo;
import es.capgemini.pfs.politica.model.DDTipoOperador;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Clase con los métodos de negocio relativos a los Objetivos.
 * @author pamuller
 *
 */
@Service
public class ObjetivoManager {

    @Autowired
    private Executor executor;

    @Autowired
    private ObjetivoDao objetivoDao;

    @Autowired
    private SubtipoTareaDao subtipoTareaDao;

    @Resource
    private MessageService messageService;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Crear o modifica el objetivo con los datos del Dto.
     * @param dto DtoObjetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_GUARDAR_OBJETIVO)
    @Transactional(readOnly = false)
    public void guardarObjetivo(DtoObjetivo dto) {
        Objetivo objetivo;
        if (dto.getIdObjetivo() != null) {
            objetivo = objetivoDao.get(dto.getIdObjetivo());
        } else {
            objetivo = new Objetivo();
            DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_PROPUESTO);
            objetivo.setEstadoObjetivo(estadoObjetivo);
            DDEstadoCumplimiento estadoCumplimiento = (DDEstadoCumplimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoCumplimiento.class, DDEstadoCumplimiento.ESTADO_PENDIENTE);
            objetivo.setEstadoCumplimiento(estadoCumplimiento);
        }

        //Si es una justificacion
        if (dto.getIsJustificacion()) {
            //Marcamos justificado el antiguo y borramos su tarea
            DDEstadoCumplimiento estadoJustificado = (DDEstadoCumplimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoCumplimiento.class, DDEstadoCumplimiento.ESTADO_JUSTIFICADO);

            objetivo.setJustificacion(dto.getJustificacion());
            objetivo.setEstadoCumplimiento(estadoJustificado);
            objetivoDao.update(objetivo);

            //Borramos sus tareas de justificacion
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREA_JUSTIFICACION_OBJETIVO, objetivo.getId());

            //Creamos el nuevo objetivo como una propuesta
            objetivo = new Objetivo();
            DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_PROPUESTO);
            objetivo.setEstadoObjetivo(estadoObjetivo);
            DDEstadoCumplimiento estadoCumplimiento = (DDEstadoCumplimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoCumplimiento.class, DDEstadoCumplimiento.ESTADO_PENDIENTE);
            objetivo.setEstadoCumplimiento(estadoCumplimiento);

            objetivo = extraeDatosDto(objetivo, dto);

            if (compruebaValidezObjetivo(objetivo)) {
                objetivoDao.save(objetivo);
            } else {
                throw new BusinessOperationException("editar.objetivo.error.politicaNoDefinida");
            }

            PlazoTareasDefault plazoPropuesta = (PlazoTareasDefault) executor.execute(
                    ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, PlazoTareasDefault.CODIGO_PLAZO_PROPUESTA_OBJETIVO);

            DtoGenerarTarea dtoTarea = new DtoGenerarTarea(objetivo.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                    SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO, true, false, plazoPropuesta.getPlazo(), null);

            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dtoTarea);
        }

        //Si es una creación de objetivo normal
        else {

            objetivo = extraeDatosDto(objetivo, dto);

            if (compruebaValidezObjetivo(objetivo)) {
                objetivoDao.saveOrUpdate(objetivo);
            } else {
                throw new BusinessOperationException("editar.objetivo.error.politicaNoDefinida");
            }

            // Si es un alta de objetivo Y LA POLITICA ES VIGENTE creamos la tarea de propuesta
            if (dto.getIdObjetivo() == null && objetivo.getPolitica().getEsVigente()) {

                PlazoTareasDefault plazoPropuesta = (PlazoTareasDefault) executor
                        .execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
                                PlazoTareasDefault.CODIGO_PLAZO_PROPUESTA_OBJETIVO);

                DtoGenerarTarea dtoTarea = new DtoGenerarTarea(objetivo.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                        SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO, true, false, plazoPropuesta.getPlazo(), null);
                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dtoTarea);
            }
        }

    }

    private Objetivo extraeDatosDto(Objetivo objetivo, DtoObjetivo dto) {
        Politica politica = null;
        if (dto.getIdPolitica() != null) {
            politica = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_GET, dto.getIdPolitica());
        }
        if (politica == null) { throw new BusinessOperationException("editar.objetivo.error.sinPolitica"); }

        objetivo.setPolitica(politica);

        DDTipoOperador tipoOperador = (DDTipoOperador) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoOperador.class, dto
                .getTipoOperador());
        objetivo.setTipoOperador(tipoOperador);
        Contrato contrato = null;
        if (dto.getContrato() != null) {
            contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, dto.getContrato());
        }
        objetivo.setContrato(contrato);
        objetivo.setFechaLimite(FormatUtils.strADate(dto.getFechaLimite(), FormatUtils.DDMMYYYY));
        DDTipoObjetivo tipoObjetivo = (DDTipoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoObjetivo.class, dto
                .getTipoObjetivo());
        objetivo.setTipoObjetivo(tipoObjetivo);
        objetivo.setValor(dto.getValor());
        objetivo.setObservacion(dto.getObservacion());
        objetivo.setResumen(dto.getResumen());

        return objetivo;
    }

    /**
     * Comprueba si un objetivo es válido para la política en la que se enmarca.
     * @param objetivo objetivo
     * @return boolean
     */
    public Boolean compruebaValidezObjetivo(Objetivo objetivo) {
        //Si falta algún dato la validez no es correcta
        if (objetivo == null || objetivo.getPolitica() == null || objetivo.getPolitica().getTipoPolitica() == null
                || objetivo.getPolitica().getTipoPolitica().getTendencia() == null) { return false; }

        DDTipoObjetivo tipoObjetivo = objetivo.getTipoObjetivo();
        Float valor = objetivo.getValor();
        DDTipoOperador tipoOperador = objetivo.getTipoOperador();
        String codigoTendenciaPolitica = objetivo.getPolitica().getTipoPolitica().getTendencia().getCodigo();

        if (tipoObjetivo.getAutomatico()) {
            if (valor == null) { throw new BusinessOperationException("editar.objetivo.error.objAutomatico.limiteNulo"); }
            if (tipoOperador == null) { throw new BusinessOperationException("editar.objetivo.error.objAutomatico.operadorNulo"); }
            // Si la tendencia de la política del objetivo es 'restrictiva', el operador debe ser 'menor o igual'
            if (DDTendencia.TEN_DESCENDENTE.equals(codigoTendenciaPolitica)) {
                if (!tipoOperador.getCodigo().equals(DDTipoOperador.ESTADO_MENOR)) {
                    DDTipoOperador tipoOperadorMenor = (DDTipoOperador) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDTipoOperador.class, DDTipoOperador.ESTADO_MENOR);

                    String tendencia = ((DDTendencia) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTendencia.class,
                            DDTendencia.TEN_DESCENDENTE)).getDescripcion();

                    throw new BusinessOperationException("editar.objetivo.error.politica.operadorInvalido", tendencia, tipoOperadorMenor
                            .getDescripcion());
                }
                if (valor > getValorReferenciadoPoObjetivo(objetivo)) { throw new BusinessOperationException("editar.objetivo.error.montoInvalido",
                        tipoOperador.getCodigo().toLowerCase(), getValorReferenciadoPoObjetivo(objetivo)); }
            }

            else if (DDTendencia.TEN_ASCENDENTE.equals(codigoTendenciaPolitica)) {
                if (!tipoOperador.getCodigo().equals(DDTipoOperador.ESTADO_MAYOR)) {
                    DDTipoOperador tipoOperadorMayor = (DDTipoOperador) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDTipoOperador.class, DDTipoOperador.ESTADO_MAYOR);
                    String tendencia = ((DDTendencia) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTendencia.class,
                            DDTendencia.TEN_ASCENDENTE)).getDescripcion();
                    throw new BusinessOperationException("editar.objetivo.error.politica.operadorInvalido", tendencia, tipoOperadorMayor
                            .getDescripcion());
                }

                if (valor < getValorReferenciadoPoObjetivo(objetivo)) { throw new BusinessOperationException("editar.objetivo.error.montoInvalido",
                        tipoOperador.getCodigo().toLowerCase(), getValorReferenciadoPoObjetivo(objetivo)); }
            }
        }

        return true;
    }

    /**
     * Devuelve los objetivos pendientes (BATCH-102).
     * @return la lista de objetivos pendientes
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_GET_OBJETIVOS_PENDIENTES)
    public List<Objetivo> getObjetivosPendientes() {
        return null;
    }

    /**
     * Ejecuta la fórmula de un objetivo.
     * @param o el objetivo.
     * @return el resultado de la fórmula.
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_EJECUTAR_FORMULA)
    public boolean ejecutarFormula(Objetivo o) {
        //TODO Implementar este método!!!
        return false;
    }

    /**
     * Revisa un objetivo (BATCH-104).
     * @param o el objetivo a revisar.
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_REVISAR_OBJETIVO)
    public void revisarObjetivo(Objetivo o) {
        //TODO Implementar este método!!!
    }

    /**
     * Recupera todos los objetivos para el estado indicado.
     * @param idEstado Long
     * @return lista de Objetivos
     */
    /*
        @BusinessOperation
        public List<Objetivo> buscarObjetivosParaEstado(Long idEstado) {
            return politicaDao.buscarObjetivosParaEstado(idEstado);
        }
    */
    /**
     * Devuelve el objetivo.
     * @param idObjetivo Long
     * @return Objetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_GET_OBJETIVO)
    public Objetivo getObjetivo(Long idObjetivo) {
        return objetivoDao.get(idObjetivo);
    }

    /**
     * Borra, cancela,rechaza o propone el borrad del objetivo indicado.
     * @param idObjetivo long
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_BORRAR_OBJETIVO)
    @Transactional(readOnly = false)
    public void borrarObjetivo(Long idObjetivo) {
        Objetivo obj = objetivoDao.get(idObjetivo);

        Politica pol = obj.getPolitica();
        if (pol.getEsVigente()) {
            if (obj.getEstaPropuesto()) {
                cancelarObjetivo(obj);
                return;
            }
            proponerBorrado(obj);
            return;
        }
        if (pol.getEsPropuesta()) {
            if (obj.getDefinidoEstadoAnterior() != null && obj.getDefinidoEstadoAnterior()) {
                rechazarObjetivo(obj);
            } else {
                borrarObjetivo(obj);
            }
        }
    }

    /**
     * Acepta la propuesta de borrado del objetivo indicado.
     * @param idObjetivo long
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_ACEPTAR_PROPUESTA_BORRADO)
    @Transactional(readOnly = false)
    public void aceptarPropuestaBorrado(Long idObjetivo) {
        Objetivo obj = objetivoDao.get(idObjetivo);
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_ACEPTACION_PROPUESTA_BORRADO_OBJETIVO, null);
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_CANCELADO);
        obj.setEstadoObjetivo(estadoObjetivo);
        objetivoDao.update(obj);
    }

    /**
     * Rechaza la propuesta de borrado del objetivo indicado.
     * @param idObjetivo long
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_RECHAZAR_PROPUESTA_BORRADO)
    @Transactional(readOnly = false)
    public void rechazarPropuestaBorrado(Long idObjetivo) {
        Objetivo obj = objetivoDao.get(idObjetivo);
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_RECHAZO_PROPUESTA_BORRADO_OBJETIVO, null);
    }

    private void borrarTareaObjetivo(Objetivo obj, String subtipo) {
        for (TareaNotificacion tarea : obj.getTareas()) {
            if (tarea.getSubtipoTarea().getCodigoSubtarea().equals(subtipo)) {
                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
            }
        }
    }

    /**
     * Acepta la propuesta de de alta del objetivo indicado.
     * @param idObjetivo long
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_ACEPTAR_PROPUESTA_OBJETIVO)
    @Transactional(readOnly = false)
    public void aceptarPropuestaObjetivo(Long idObjetivo) {
        Objetivo obj = objetivoDao.get(idObjetivo);
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_CONFIRMADO);
        obj.setEstadoObjetivo(estadoObjetivo);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put(ObjetivoBPMConstants.ID_OBJETIVO, idObjetivo);

        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ObjetivoBPMConstants.OBJETIVO_PROCESO, param);
        obj.setProcessBpm(bpmid);

        objetivoDao.saveOrUpdate(obj);
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_ACEPTADO, messageService.getMessage("aceptar.tarea.objetivoAceptado", new Object[] { obj
                        .getId() }));

    }

    /**
     * Rechaza la propuesta de alta del objetivo indicado.
     * @param idObjetivo long
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_RECHAZAR_PROPUESTA_OBJETIVO)
    @Transactional(readOnly = false)
    public void rechazarPropuestaObjetivo(Long idObjetivo) {
        Objetivo obj = objetivoDao.get(idObjetivo);
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_CANCELADO);
        obj.setEstadoObjetivo(estadoObjetivo);
        objetivoDao.saveOrUpdate(obj);
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_RECHAZADO, messageService.getMessage("aceptar.tarea.objetivoAceptado",
                        new Object[] { obj.getId() }));
    }

    //CU WEB 116
    private void proponerBorrado(Objetivo obj) {
        //Si no esta pendiente no lo puedo borrar
        if (!obj.getEstaPendiente()) { return; }
        DtoGenerarTarea dto = new DtoGenerarTarea(obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO, true, false, null, null);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dto);
    }

    //CU WEB 119
    private void cancelarObjetivo(Objetivo obj) {
        //Eliminar tareas asociadas
        for (TareaNotificacion tarea : obj.getTareas()) {
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
        }
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_CANCELADO);
        obj.setEstadoObjetivo(estadoObjetivo);
        objetivoDao.update(obj);

        if (obj.getProcessBpm() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
        }
    }

    //CU WEB 111
    private void rechazarObjetivo(Objetivo obj) {
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_RECHAZADO);
        obj.setEstadoObjetivo(estadoObjetivo);
        objetivoDao.update(obj);
        objetivoDao.delete(obj);

        if (obj.getProcessBpm() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
        }
    }

    //CU WEB 110
    private void borrarObjetivo(Objetivo obj) {
        DDEstadoObjetivo estadoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_BORRADO);
        obj.setEstadoObjetivo(estadoObjetivo);
        objetivoDao.update(obj);
        objetivoDao.delete(obj);

        if (obj.getProcessBpm() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
        }
    }

    /**
     * Se propone el cumplimiento de un objetivo.
     * @param dto DtoObjetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_PROPONER_CUMPLIMIENTO)
    @Transactional(readOnly = false)
    public void proponerCumplimiento(DtoObjetivo dto) {
        Objetivo obj = objetivoDao.get(dto.getIdObjetivo());
        obj.setPropuestaCumplimiento(dto.getPropuesta());
        objetivoDao.update(obj);
        DtoGenerarTarea dtoTarea = new DtoGenerarTarea(obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO, true, false, null, null);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dtoTarea);
    }

    /**
     * Se acepta el cumplimiento de un objetivo.
     * @param dto DtoObjetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_ACEPTAR_CUMPLIMIENTO)
    @Transactional(readOnly = false)
    public void aceptarCumplimiento(DtoObjetivo dto) {
        Objetivo obj = objetivoDao.get(dto.getIdObjetivo());
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO);
        DDEstadoCumplimiento estadoCumplimiento = (DDEstadoCumplimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoCumplimiento.class, DDEstadoCumplimiento.ESTADO_CUMPLIDO);
        obj.setEstadoCumplimiento(estadoCumplimiento);
        obj.setRespuestaPropuestaCumplimiento(dto.getRespuesta());
        objetivoDao.update(obj);

        String codigoSubtipoTarea = SubtipoTarea.CODIGO_ACEPTACION_PROPUESTA_CUMPLIMIENTO_OBJETIVO;
        SubtipoTarea subtipoTarea = subtipoTareaDao.buscarPorCodigo(codigoSubtipoTarea);
        String descripcion = subtipoTarea.getDescripcionLarga() + ". Resumen del objetivo: " + obj.getResumen();

        if (descripcion.length() > APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION)
            descripcion = descripcion.substring(0, APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION);

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, obj.getId(), DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO,
                SubtipoTarea.CODIGO_ACEPTACION_PROPUESTA_CUMPLIMIENTO_OBJETIVO, null);
    }

    /**
     * Se rechazar el cumplimiento de un objetivo.
     * @param dto DtoObjetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_RECHAZAR_CUMPLIMIENTO)
    @Transactional(readOnly = false)
    public void rechazarCumplimiento(DtoObjetivo dto) {
        Objetivo obj = objetivoDao.get(dto.getIdObjetivo());
        borrarTareaObjetivo(obj, SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO);
        DDEstadoCumplimiento estadoCumplimiento = (DDEstadoCumplimiento) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoCumplimiento.class, DDEstadoCumplimiento.ESTADO_INCUMPLIDO);
        obj.setEstadoCumplimiento(estadoCumplimiento);
        obj.setRespuestaPropuestaCumplimiento(dto.getRespuesta());
        objetivoDao.update(obj);

        if (obj.getProcessBpm() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
        }
        objetivoDao.update(obj);

        //Enviar notificación al gestor
        Long idEntidad = obj.getId();
        String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO;
        String subtipoTarea = SubtipoTarea.CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO;
        String codigoPlazo = PlazoTareasDefault.CODIGO_PLAZO_JUSTIFICACION_OBJETIVO;

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, idEntidad, tipoEntidad, subtipoTarea, codigoPlazo);
    }

    /**
     * retorna la lista de objetivos para el gestor.
     * @return lista de obejtivos
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_BUSCAR_OBJETIVOS_GESTOR)
    public List<Objetivo> buscarObjetivosGestor() {
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<DDZona> zonas = (List<DDZona>) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_ZONAS_USUARIO_LOGADO);
        return objetivoDao.buscarObjetivosPendientesGestor(usuario, zonas);
    }

    /**
     * Devuelve la cantidad de objetivos pendientes para el gestor.
     * @return integer
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_OBTENER_CANTIDAD_OBJETIVOS_PENDIENTES)
    public Integer obtenerCantidadObjetivosPendientes() {
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<DDZona> zonas = (List<DDZona>) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_ZONAS_USUARIO_LOGADO);
        return objetivoDao.cantidadObjetivosPendientesGestor(usuario, zonas);
    }

    /**
     * @param obj Objetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_SAVE)
    public void save(Objetivo obj) {
        objetivoDao.save(obj);
    }

    /**
     * @param obj Objetivo
     */
    @BusinessOperation(InternaBusinessOperation.BO_OBJ_MGR_UPDATE)
    public void update(Objetivo obj) {
        objetivoDao.update(obj);
    }

    /**
     * Recupera todos los objetivos para el estado indicado.
     * @param idPolitica Long
     * @return lista de Objetivos
     */
    @BusinessOperation
    public List<Objetivo> buscarObjetivosPolitica(Long idPolitica) {
        return objetivoDao.getObjetivosActivos(idPolitica);
    }

    private boolean evaluar(float valorEsperado, float valorReal, DDTipoOperador tipoOperador) {

        if (DDTipoOperador.ESTADO_MAYOR.equals(tipoOperador.getCodigo())) {
            return valorReal > valorEsperado;
        } else if (DDTipoOperador.ESTADO_MENOR.equals(tipoOperador.getCodigo())) {
            return valorReal < valorEsperado;
        } else
            return valorReal != valorEsperado;
    }

    /**
     * Revisa la fórmula de un objetivo automático.
     * @param obj el objetivo para revisar.
     * @return true si la fórmula se cumple.
     */
    private boolean revisarFormula(Objetivo obj) {
        DDTipoOperador top = obj.getTipoOperador();

        Float valorReal = getValorReferenciadoPoObjetivo(obj);

        if (valorReal == null) return false;
        return evaluar(obj.getValor(), valorReal, top);
    }

    /**
     * Recupera el valor referenciado por el objetivo
     * @param obj
     * @return
     */
    private Float getValorReferenciadoPoObjetivo(Objetivo obj) {
        final float CIEN = 100;

        DDCampoDestinoObjetivo cdo = obj.getTipoObjetivo().getCampoDestino();

        //OBJETIVOS DE CONTRATOS
        Movimiento mov = null;
        if (obj.getContrato() != null) mov = obj.getContrato().getLastMovimiento();

        Persona per = obj.getPolitica().getCicloMarcadoPolitica().getPersona();

        if (DDCampoDestinoObjetivo.DISPUESTO_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getDispuesto();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getRiesgo();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_IRREGULAR_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getDeudaIrregular();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_GARANTIZADO_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getRiesgoGarantizado();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_NO_GARANTIZADO_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getRiesgo() - mov.getRiesgoGarantizado();
        }

        else if (DDCampoDestinoObjetivo.LIMITE_DESCUBIERTO_CONTRATO.equals(cdo.getCodigo()) && mov != null) {
            return mov.getLimiteDescubierto();
        }

        //OBJETIVOS DE PERSOSAS
        else if (DDCampoDestinoObjetivo.RIESGO_DIRECTO_PERSONA.equals(cdo.getCodigo())) {
            return per.getRiesgoDirecto();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_INDIRECTO_PERSONA.equals(cdo.getCodigo())) {
            return per.getRiesgoIndirecto();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_IRREGULAR_PERSONA.equals(cdo.getCodigo())) {
            return per.getDeudaIrregularDirecta();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_GARANTIZADO_PERSONA.equals(cdo.getCodigo())) {
            return per.getRiesgoGarantizadoPersona();
        }

        else if (DDCampoDestinoObjetivo.RIESGO_NO_GARANTIZADO_PRSONA.equals(cdo.getCodigo())) {
            float rng = per.getRiesgoNoGarantizadoPersona();
            return rng;
        }

        else if (DDCampoDestinoObjetivo.PORCENTAJE_RNG_RD_PERSONA.equals(cdo.getCodigo())) {
            float rng = per.getRiesgoNoGarantizadoPersona();
            float rd = per.getRiesgoDirecto();
            return rng / rd * CIEN;
        }

        else if (DDCampoDestinoObjetivo.PORCENTAJE_RIRR_RD_PERSONA.equals(cdo.getCodigo())) {
            float rirr = per.getDeudaIrregular();
            float rd = per.getRiesgoDirecto();
            return rirr / rd * CIEN;
        }

        throw new BusinessOperationException("objetivo.error.sinContrato");
    }

    /**
     * Método que revisa un objetivo.
     * @param obj el objetivo a revisar.
     * @param revision indica si es la revisión general o se disparó por el timer de un objetivo
     */
    public void revisarObjetivo(Objetivo obj, boolean revision) {
        if (!obj.getEstadoCumplimiento().getCodigo().equals(DDEstadoCumplimiento.ESTADO_PENDIENTE)) {
            //No estaba pendiente (Solo por precaución, sería un caso extraño pero
            //se pudo haber ejecutado el timer propio del objetivo)
            return;
        }
        boolean cumpleFormula = false;
        if (obj.getTipoObjetivo().getAutomatico()) {
            //El objetivo es automático, reviso la fórmula
            cumpleFormula = revisarFormula(obj);
            if (cumpleFormula) {
                //Se cumple al fórmula, marco el objetivo como cumplido
                logger.info("-- Marcado como cumplido Objetivo " + obj.getId() + " - " + obj.getResumen());
                objetivoDao.marcarComoCumplido(obj);
                if (revision) {
                    //Destruyo el posible timer.
                    if (obj.getProcessBpm() != null) {
                        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
                    }
                }
            } else {
                logger.info("-- Es Automático y no cumple al fórmula " + obj.getId() + " - " + obj.getResumen());
            }
        }
        if (!obj.getTipoObjetivo().getAutomatico() || !cumpleFormula) {
            //Si venció la fecha límite
            if (System.currentTimeMillis() > obj.getFechaLimite().getTime() || !revision) {
                //marco como incumplido
                objetivoDao.marcarComoIncumplido(obj);
                if (revision) {
                    //Elimino el timer
                    if (obj.getProcessBpm() != null) {
                        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());
                    }
                }
                logger.info("-- Marco como incumplido al objetivo: " + obj.getId() + " - " + obj.getResumen());

                //Enviar notificación al gestor
                Long idEntidad = obj.getId();
                String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO;
                String subtipoTarea = SubtipoTarea.CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO;
                String codigoPlazo = PlazoTareasDefault.CODIGO_PLAZO_JUSTIFICACION_OBJETIVO;

                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM, idEntidad, tipoEntidad, subtipoTarea, codigoPlazo);
            }
        }
    }

    /**
     * Método que inicia la revisión general de los objetivos.
     * CU F3_BATCH-104
     */
    @Transactional
    public void revisarObjetivosPendientes() {
        List<Objetivo> objetivosPendientes = objetivoDao.getObjetivosPendientes();
        for (Objetivo obj : objetivosPendientes) {
            revisarObjetivo(obj, true);
        }
    }

}
