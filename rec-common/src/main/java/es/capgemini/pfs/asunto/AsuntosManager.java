package es.capgemini.pfs.asunto;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.FichaAceptacionDao;
import es.capgemini.pfs.asunto.dao.ObservacionAceptacionDao;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.dto.FichaAceptacionDto;
import es.capgemini.pfs.asunto.dto.ProcedimientoJerarquiaDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.HistoricoCambiosAsunto;
import es.capgemini.pfs.asunto.model.ObservacionAceptacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dto.DtoListadoAsuntos;
import es.capgemini.pfs.comite.dao.SesionComiteDao;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.dao.DDEstadoItinerarioDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;


/**
 * Clase de servicios de acceso de datos del cliente.
 * @author Juan Pablo Bosnjak
 *
 */
@Service
public class AsuntosManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private Executor executor;

    @Resource
    private MessageService messageService;

    @Autowired
    private DDEstadoItinerarioDao estadoItinerarioDao; //DD

    @Autowired
    private AsuntoDao asuntoDao;

    @Autowired
    private GestorDespachoDao gestorDespachoDao;

    @Autowired
    private ObservacionAceptacionDao observacionAceptacionDao;

    @Autowired
    private FichaAceptacionDao fichaAceptacionDao;

    @Autowired
    private SesionComiteDao sesionComiteDao;

    /**
     * Actualiza el estado del asunto (abierto o cerrado) en función de sus procedimientos (abiertos o cerrados)
     * @param idAsunto
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ACTUALIZA_ESTADO_ASUNTO)
    public void actualizarEstadoAsunto(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        if (asunto == null) return;

        //Por defecto cerramos el asunto
        String estadoAsunto = DDEstadoAsunto.ESTADO_ASUNTO_CERRADO;

        for (Procedimiento p : asunto.getProcedimientos()) {
            //Si no está cerrado o cancelado, el asunto está aceptado
            if (!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(p.getEstadoProcedimiento().getCodigo())
                    && !DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(p.getEstadoProcedimiento().getCodigo())) {
                estadoAsunto = DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO;
                break;
            }
        }

        DDEstadoAsunto ddEstadoAsunto = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAsunto.class,
                estadoAsunto);

        asunto.setEstadoAsunto(ddEstadoAsunto);
        asuntoDao.update(asunto);
    }

    /**
     * Retorna los asuntos de una persona.
     * @param idPersona id de una persona
     * @return expedientes
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UNA_PERSONA)
    public List<Asunto> obtenerAsuntosDeUnaPersona(Long idPersona) {
        List<Asunto> asuntos = null;
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);

        asuntos = asuntoDao.obtenerAsuntosDeUnaPersona(persona.getId());
        return asuntos;
    }

    /**
     * Retorna los asuntos de una persona.
     * @param idPersona id de una persona
     * @return expedientes
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UNA_PERSONA_PAGINADOS)
    public Page obtenerAsuntosDeUnaPersonaPaginados(DtoListadoAsuntos dto) {
        return asuntoDao.obtenerAsuntosDeUnaPersonaPaginados(dto);
    }

    /**
     * devuelve un asunto.
     * @param id id
     * @return asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET)
    public Asunto get(Long id) {
    	EventFactory.onMethodStart(this.getClass());
        return asuntoDao.get(id);
    }

    /**
     * Obtiene los asuntos asociados a un asunto y a si mismo.
     * @param idAsunto el id del asunto
     * @return la lista de asuntos asociada a un expediente
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_ASUNTO)
    public List<Asunto> obtenerAsuntosDeUnAsunto(Long idAsunto) {
        List<Asunto> asuntos = new ArrayList<Asunto>();
        Asunto asunto = asuntoDao.get(idAsunto);
        asuntos.add(asunto);
        asuntos.addAll(asuntoDao.obtenerAsuntosDeUnAsunto(idAsunto));
        return asuntos;
    }

    /**
     * Obtiene los asuntos asociados a un expediente.
     * @param idExpediente el id del expediente
     * @return la lista de asuntos asociada a un expediente
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_EXPEDIENTE)
    public List<Asunto> obtenerAsuntosDeUnExpediente(Long idExpediente) {
        return asuntoDao.obtenerAsuntosDeUnExpediente(idExpediente);
    }

    /**
     * Devuelve el supervisor de un asunto a partir del id de la sesion de comite al que pertenecen los asuntos.
     * @param idSesionComite el id de la sesion del comite
     * @return el usuario que actua como supervisor.
     */
    @BusinessOperation
    public Usuario getSuepervisorAsunto(Long idSesionComite) {
        return sesionComiteDao.getSupervisorSesion(idSesionComite);
    }

    /**
     * Crea un nuevo preasunto en estado CONFORMACION con un gestor.
     * @param dtoAsunto el Dto de Asuntos.
     * @param idAsunto id del asunto padre
     * @return el id del nuevo asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_CREAR_PRE_ASUNTO)
    @Transactional(readOnly = false)
    public Long crearPreasunto(DtoAsunto dtoAsunto, Long idAsunto) {
        Asunto asuntoPadre = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //get(idAsunto);
        GestorDespacho gd = gestorDespachoDao.get(dtoAsunto.getIdGestor());
        GestorDespacho sup = gestorDespachoDao.get(dtoAsunto.getIdSupervisor());
        GestorDespacho procurador = null;
        if (dtoAsunto.getIdProcurador() != null) {
            procurador = gestorDespachoDao.get(dtoAsunto.getIdProcurador());
        }
        if (asuntoDao.isNombreAsuntoDuplicado(dtoAsunto.getNombreAsunto(), null))
            throw new GenericRollbackException("altaAsunto.error.nombreDuplicado");
        Long id = asuntoDao.crearAsunto(gd, sup, procurador, dtoAsunto.getNombreAsunto(), asuntoPadre.getExpediente(), dtoAsunto.getObservaciones());
        Asunto asuntoHijo = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, id); //get(id);
        asuntoHijo.setAsuntoOrigen(asuntoPadre);
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asuntoHijo);
        //saveOrUpdateAsunto(asuntoHijo);
        logger.debug("CREADO PRE-ASUNTO CON ID " + id);
        return asuntoHijo.getId();
    }

    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET_ASUNTOS_MISMO_NOMBRE)
    @Transactional(readOnly = false)
    public Long getAsuntosMismoNombre(String nombreAsunto) {
        return asuntoDao.getNumAsuntosMismoNombre(nombreAsunto);
    }

    /**
     * Crea un nuevo asunto en estado vacio con un gestor.
     * @param dtoAsunto el Dto de Asuntos.
     * @return el id del nuevo asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO_DTO)
    @Transactional(readOnly = false)
    public Long crearAsunto(DtoAsunto dtoAsunto) {
        GestorDespacho gd = gestorDespachoDao.get(dtoAsunto.getIdGestor());
        GestorDespacho sup = gestorDespachoDao.get(dtoAsunto.getIdSupervisor());
        GestorDespacho procurador = null;
        if (dtoAsunto.getIdProcurador() != null) {
            procurador = gestorDespachoDao.get(dtoAsunto.getIdProcurador());
        }
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dtoAsunto.getIdExpediente());
        return crearAsunto(gd, sup, procurador, dtoAsunto.getNombreAsunto(), exp, dtoAsunto.getObservaciones());
    }

    /**
     * Crea un nuevo asunto en estado vacio con un gestor.
     * @param gd GestorDespacho gestor
     * @param sup GestorDespacho supervisor
     * @param nombreAsunto String
     * @param exp Expediente
     * @param observaciones String
     * @return el id del nuevo asunto
     */
    @Transactional(readOnly = false)
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO)
    public Long crearAsunto(GestorDespacho gd, GestorDespacho sup, GestorDespacho procurador, String nombreAsunto, Expediente exp,
            String observaciones) {
        if (asuntoDao.isNombreAsuntoDuplicado(nombreAsunto, null)) throw new GenericRollbackException("altaAsunto.error.nombreDuplicado");
        Long id = asuntoDao.crearAsunto(gd, sup, procurador, nombreAsunto, exp, observaciones);
        logger.debug("CREADO ASUNTO CON ID " + id);
        return id;
    }

    /**
     * Modifica un Asunto.
     * @param dtoAsunto el dto con los datos nuevos
     * @return el id;
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_MODIFICAR_ASUNTO)
    @Transactional(readOnly = false)
    public Long modificarAsunto(DtoAsunto dtoAsunto) {
        if (asuntoDao.isNombreAsuntoDuplicado(dtoAsunto.getNombreAsunto(), dtoAsunto.getIdAsunto()))
            throw new GenericRollbackException("altaAsunto.error.nombreDuplicado");

        Long idAsunto = dtoAsunto.getIdAsunto();
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //get(idAsunto);
        long idGestor = asunto.getGestor().getUsuario().getId().longValue();

        //Eliminamos los favoritos de asunto y procedimiento del gestor externo solo en el caso de que haya cambiado
        if (idGestor != dtoAsunto.getIdGestor().longValue()) {
            borrarFavoritosAsunto(asunto);
        }
        GestorDespacho procurador = null;
        if (dtoAsunto.getIdProcurador() != null) {
            procurador = gestorDespachoDao.get(dtoAsunto.getIdProcurador());
        }

        GestorDespacho gd = gestorDespachoDao.get(dtoAsunto.getIdGestor());
        GestorDespacho sup = gestorDespachoDao.get(dtoAsunto.getIdSupervisor());

        return asuntoDao.modificarAsunto(dtoAsunto.getIdAsunto(), gd, sup, procurador, dtoAsunto.getNombreAsunto(), dtoAsunto.getObservaciones());
    }

    private void borrarFavoritosAsunto(Asunto asunto) {
        long idGestor = asunto.getGestor().getUsuario().getId().longValue();
        executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD, idGestor, asunto.getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        for (Procedimiento prc : asunto.getProcedimientos()) {

            executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD, idGestor, prc.getId(),
                    DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
        }
    }

    /**
     * Hace el borrado logico de un Asunto.
     * @param idAsunto el id del Asunto a borrar.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_BORRAR_ASUNTO)
    @Transactional(readOnly = false)
    public void borrarAsunto(Long idAsunto) {
        Asunto a = asuntoDao.get(idAsunto);
        if (a.getProcedimientos().size() > 0) { throw new BusinessOperationException("dc.asuntos.borrar.tieneProcedimientos"); }

        DDEstadoAsunto estadoAsunto = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAsunto.class,
                DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO);

        a.setEstadoAsunto(estadoAsunto);
        asuntoDao.update(a);

        asuntoDao.deleteById(idAsunto);
    }

    /**
     * Busca asuntos paginados.
     * @param dto los parï¿½metros para la BÃºsqueda.
     * @return Asuntos paginados
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_FIND_ASUNTOS_PAGINATED)
    public Page findAsuntosPaginated(DtoBusquedaAsunto dto) {
    	EventFactory.onMethodStart(this.getClass());
        dto.setCodigoZonas(getCodigosDeZona(dto));
        dto.setTiposProcedimiento(getTiposProcedimiento(dto));
        EventFactory.onMethodStop(this.getClass());
        return asuntoDao.buscarAsuntosPaginated(dto);
    }

    private Set<String> getTiposProcedimiento(DtoBusquedaAsunto dtoBusquedaAsuntos) {
        Set<String> tiposProcedimiento = null;
        if (dtoBusquedaAsuntos.getTipoProcedimiento() != null && dtoBusquedaAsuntos.getTipoProcedimiento().trim().length() > 0) {
            tiposProcedimiento = new HashSet<String>(Arrays.asList((dtoBusquedaAsuntos.getTipoProcedimiento().split(","))));
        }
        return tiposProcedimiento;
    }

    private Set<String> getCodigosDeZona(DtoBusquedaAsunto dtoBusquedaAsuntos) {
        Set<String> zonas;
        if (dtoBusquedaAsuntos.getCodigoZona() != null && dtoBusquedaAsuntos.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((dtoBusquedaAsuntos.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            zonas = usuario.getCodigoZonas();
        }
        return zonas;
    }

    /**
     * Salva un Asunto.
     * @param asunto el Asunto para salvar.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE)
    public void saveOrUpdateAsunto(Asunto asunto) {
        asuntoDao.saveOrUpdate(asunto);
    }

    /**
     * Devuelve los contratos y tÃ­tulos de un asunto.
     * @param idAsunto el id del asunto
     * @return los titulos.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_FIND_CONTRATOS_TITULOS)
    public Set<Contrato> findContratosTitulos(Long idAsunto) {
        Asunto asu = asuntoDao.get(idAsunto);
        return asu.getContratos();
    }

    /**
     * Generar para el asunto la tarea de 'aceptar asunto' para el gestor,
     * y para todos sus procedimientos genera las tarea de 'recopilar documentaciÓn'.
     * @param asunto Asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GENERAR_TAREA_POR_CIERRE_DECISION)
    public void generarTareasPorCierreDecision(Asunto asunto) {

        //Si el asunto ya estaba creado (es decir tiene procedimientos activos y aceptados)
        if (tieneProcedimientosAceptados(asunto)) {

            //Marcamos de nuevo el asunto como aceptado
            DDEstadoAsunto estadoAsuntoAceptado = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);

            DDEstadoAsunto estadoAceptado = estadoAsuntoAceptado;
            asunto.setEstadoAsunto(estadoAceptado);
            executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
            //this.saveOrUpdateAsunto(asunto);

            //Recorremos los procedimientos para ver cuales no están arrancados (los nuevos procedimientos creados en decisión)
            for (Procedimiento procedimiento : asunto.getProcedimientos()) {
                if (!procedimiento.getEstaAceptado()) {
                    executor.execute(ExternaBusinessOperation.BO_PRC_MGR_ACEPTAR_PROCEDIMIENTO, procedimiento.getId());
                }
            }
        } else {
            //Si el asunto no estaba creado (no tiene procedimientos activos o aceptados)
            executor.execute(ExternaBusinessOperation.BO_ASU_MGR_CREAR_TAREA_ACEPTAR_ASUNTO, asunto);
            //crearTareaAceptarAsunto(asunto);
            for (Procedimiento procedimiento : asunto.getProcedimientos()) {
                executor.execute(ExternaBusinessOperation.BO_PRC_MGR_CREAR_TAREA_RECOPILAR_DOCUMENTACION, procedimiento);
            }
        }
    }

    /**
     * Crea una tarea 'aceptar asunto' para el asunto.
     * @param asunto asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_CREAR_TAREA_ACEPTAR_ASUNTO)
    @Transactional(readOnly = false)
    public void crearTareaAceptarAsunto(Asunto asunto) {
        Long idJBPM = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA_CON_BPM_CON_ESPERA, asunto.getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR, PlazoTareasDefault.CODIGO_ACEPTAR_ASUNTO, true);
        asunto.setProcessBpm(idJBPM);
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
        //this.saveOrUpdateAsunto(asunto);
    }

    /**
     * Aceptacion del asunto por parte del gestor.
     * @param idAsunto id del asunto
     */
    @Transactional(readOnly = false)
    private void aceptarAsunto(Long idAsunto) {
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACEPTAR_ASUNTO, idAsunto, false);
        //aceptarAsunto(idAsunto, false);
    }

    /**
     * Recupera los ExpedienteContrato de un asunto.
     * @param idAsunto Long
     * @return Lista de ExpedienteContrato
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_FIND_EXPEDIENTE_CONTRATOS_POR_ID)
    public List<ExpedienteContrato> findExpedienteContratosPorId(Long idAsunto) {
    	EventFactory.onMethodStart(this.getClass());
        List<ExpedienteContrato> list = new ArrayList<ExpedienteContrato>();
        List<Asunto> listaAsuntos = (List<Asunto>) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_ASUNTO, idAsunto);
        //Recorremos todos los asuntos
        //obtenerAsuntosDeUnAsunto(idAsunto)
        for (Asunto asunto : listaAsuntos) {

            //De cada asunto recorremos todos sus procedimientos
            for (Procedimiento p : asunto.getProcedimientos()) {

                //Incluimos los expedientes-contratos de ese procedimiento
                for (ExpedienteContrato ec : p.getExpedienteContratos()) {
                    if (!list.contains(ec)) {
                        list.add(ec);
                    }
                }
            }
        }
        EventFactory.onMethodStart(this.getClass());
        //Devolvemos un listado en vez de un set
        return list;
    }

    /**
     * Aceptacion del asunto por parte del gestor.
     * @param idAsunto id del asunto
     * @param automatico boolean
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ACEPTAR_ASUNTO)
    @Transactional(readOnly = false)
    public void aceptarAsunto(Long idAsunto, boolean automatico) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);//this.get(idAsunto);
        if (!automatico) {
            //Validar que soy el gestor, sino lanzar exception
            Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            Usuario usuarioGestor = asunto.getGestor().getUsuario();
            if (!usuarioLogado.equals(usuarioGestor)) { throw new BusinessOperationException("asunto.aceptacion.usuarioErroneo"); }
        }
        //Validar que estoy en el estado Confirmado
        if (!DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO.equals(asunto.getEstadoAsunto().getCodigo())) { throw new BusinessOperationException(
                "asunto.aceptacion.estadoErroneo"); }
        //Cambiar de estado el asunto
        DDEstadoAsunto estadoAsuntoAceptado = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
        DDEstadoAsunto estadoAceptado = estadoAsuntoAceptado;
        asunto.setEstadoAsunto(estadoAceptado);
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
        //this.saveOrUpdateAsunto(asunto);

        //Finalizo la tarea de confirmacion de asunto.
        if (!automatico) {
            for (TareaNotificacion tarea : asunto.getTareas()) {
                if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                    Long idBPM = asunto.getProcessBpm();
                    if (idBPM != null)
                        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                }
            }
        }

        //Finalizo las tareas de recopilar informacion de los procedimientos.
        for (Procedimiento proc : asunto.getProcedimientos()) {
            if (!automatico) {
                Long idBPM = proc.getProcessBPM();
                if (idBPM != null)
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
            }
            //Lanzo el proceso bpm asociado.
            executor.execute(ExternaBusinessOperation.BO_PRC_MGR_ACEPTAR_PROCEDIMIENTO, proc.getId());
        }
    }

    /**
     * devolver un asunto.
     * @param idAsunto id del asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_DEVOLVER_ASUNTO)
    @Transactional(readOnly = false)
    public void devolverAsunto(Long idAsunto) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
        //this.get(idAsunto);
        //Validar que soy el gestor o supervisor, sino lanzar exception
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        Usuario usuarioGestor = asunto.getGestor().getUsuario();
        Usuario usuarioSupervisor = asunto.getSupervisor().getUsuario();
        if (!(usuarioLogado.equals(usuarioGestor) || usuarioLogado.equals(usuarioSupervisor))) { throw new BusinessOperationException(
                "asunto.devolucion.usuarioErroneo"); }

        Boolean puedoDevolverAsunto = (Boolean) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_PUEDO_DEVOLVER_ASUNTO, idAsunto);
        //puedoDevolverAsunto(idAsunto)
        if (!puedoDevolverAsunto) { throw new BusinessOperationException("asunto.devolucion.yaDevuelto"); }
        //Validar que estoy en el estado Confirmado
        if (!DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO.equals(asunto.getEstadoAsunto().getCodigo())) { throw new BusinessOperationException(
                "asunto.aceptacion.estadoErroneo"); }
        //cambiar el tipo de tarea para que cambie de usuario
        for (TareaNotificacion tarea : asunto.getTareas()) {
            if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                        SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR);
                tarea.setSubtipoTarea(subtipoTarea);
                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
            } else if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                        SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR);
                tarea.setSubtipoTarea(subtipoTarea);
                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
            }
        }
    }

    /**
     * indica si puedo devolver el asunto.
     * @param idAsunto id del asunto
     * @return puedo o no
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_PUEDO_DEVOLVER_ASUNTO)
    public boolean puedoDevolverAsunto(Long idAsunto) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //this.get(idAsunto);
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        for (TareaNotificacion tarea : asunto.getTareas()) {
            SubtipoTarea subtipo = tarea.getSubtipoTarea();
            if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(subtipo.getCodigoSubtarea())) {
                if (usuarioLogado.equals(asunto.getGestor().getUsuario())) { return true; }
            }
            if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR.equals(subtipo.getCodigoSubtarea())) {
                if (usuarioLogado.equals(asunto.getSupervisor().getUsuario())) { return true; }
            }
        }
        return false;
    }

    /**
     * Devuelve true si el asunto tiene procedimientos ya aceptados y empezados.
     * @param asunto
     * @return
     */
    private boolean tieneProcedimientosAceptados(Asunto asunto) {
        for (Procedimiento prc : asunto.getProcedimientos()) {
            if (prc.getEstaAceptado()) { return true; }
        }

        return false;
    }

    /**
     * Cierre de la toma de decision de un asunto y sus hijos.
     * Aquellos asuntos que no tienen procedimientos se ponen en estado vacio o cancelado si es el asunto de origen.
     * @param idAsunto long
     * @param observaciones observaciones de la decision
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_TOMAR_DECISIONES_COMITE)
    @Transactional(readOnly = false)
    public void tomarDecisionComite(Long idAsunto, String observaciones) {
        DecisionComite dc = new DecisionComite();
        Asunto asuOrigen = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //get(idAsunto);
        //Finalizo la tarea de confirmacion de asunto del supervisor.
        for (TareaNotificacion tarea : asuOrigen.getTareas()) {
            if (SubtipoTarea.CODIGO_ASUNTO_PROPUESTO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                Long idBPM = asuOrigen.getProcessBpm();
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
            }
        }
        Comite comite = asuOrigen.getComite();
        dc.setSesion(comite.getUltimaSesion());
        dc.setObservaciones(observaciones);
        executor.execute(InternaBusinessOperation.BO_DECISIONN_COMITE_MRG_SAVE, dc);
        List<Asunto> asuntos = (List<Asunto>) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_ASUNTO, idAsunto);
        //obtenerAsuntosDeUnAsunto(idAsunto);
        for (Asunto asunto : asuntos) {
            asunto.setAsuntoOrigen(null);

            if (asunto.getProcedimientos().size() > 0) {
                DDEstadoAsunto estadoAsuntoConfirmado = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO);

                asunto.setEstadoAsunto(estadoAsuntoConfirmado);
                asunto.setEstadoItinerario(estadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_ASUNTO).get(0));
                asunto.setDecisionComite(dc);
                asunto.setComite(comite);
                asunto.setSupervisorComite(comite.getUltimaSesion().getSupervisorSesionComite());

                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GENERAR_TAREA_POR_CIERRE_DECISION, asunto);
                //generarTareasPorCierreDecision(asunto);
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
                //saveOrUpdateAsunto(asunto);
                //marcarProcedimientosComoDecididos(asunto);
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_MARCAR_PROCEDIMIENTOS_COMO_DECIDIDOS, asunto);
            } else {
                if (asunto.getId() == asuOrigen.getId()) {
                    DDEstadoAsunto estadoAsuntoCancelado = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO);

                    asunto.setEstadoAsunto(estadoAsuntoCancelado);
                } else {
                    DDEstadoAsunto estadoAsuntoVacio = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_VACIO);

                    asunto.setEstadoAsunto(estadoAsuntoVacio);
                }
                asuntoDao.delete(asunto);
            }
        }
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_ACTUALIZAR_ASUNTOS_PROCEDIMIENTOS, asuntos);
    }

    /**
     * Marca los procedimientos del asunto como decididos.
     * @param asunto decidido
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_MARCAR_PROCEDIMIENTOS_COMO_DECIDIDOS)
    public void marcarProcedimientosComoDecididos(Asunto asunto) {
        for (Procedimiento procedimiento : asunto.getProcedimientos()) {
            //Si el procedimiento estaba en conformación o propuesto, le seteamos el estado de confirmado
            if (procedimiento.getEstaEstadoConformacion() || procedimiento.getEstaEstadoPropuesto()) {
                DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(
                        ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
                        DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO);

                procedimiento.setEstadoProcedimiento(estadoProcedimiento);
            }

            procedimiento.setDecidido(true);
        }
    }

    /**
     * Recupera los contratos del asunto indicado y de todos los asuntos 'hijos'.
     * @param idAsunto id del asunto
     * @return set de contratos
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_CONTRATO_DE_ASUNTO_E_HIJOS)
    public Set<Contrato> obtenerContratosDeUnAsuntoYSusHijos(Long idAsunto) {
        Set<Contrato> contratos = new HashSet<Contrato>();

        List<Asunto> asuntos = (List<Asunto>) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ASUNTOS_DE_UN_ASUNTO, idAsunto);
        //obtenerAsuntosDeUnAsunto(idAsunto);
        for (Asunto asunto : asuntos) {
            contratos.addAll(asunto.getContratos());
        }
        return contratos;
    }

    /**
     * eleva un asunto a comite.
     * @param idAsunto id del asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ELEVAR_COMITE_ASUNTO)
    @Transactional(readOnly = false)
    public void elevarComiteAsunto(Long idAsunto) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //this.get(idAsunto);
        //Validar que soy el supervisor, sino lanzar exception
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        Usuario usuarioSupervisor = asunto.getSupervisor().getUsuario();
        if (!usuarioLogado.equals(usuarioSupervisor)) { throw new BusinessOperationException("asunto.elevarComite.usuarioErroneo"); }

        //Validar que estoy en el estado Confirmado
        if (!DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO.equals(asunto.getEstadoAsunto().getCodigo())
                && !DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO.equals(asunto.getEstadoAsunto().getCodigo())) { throw new BusinessOperationException(
                "asunto.elevarComite.estadoErroneo"); }

        //Si el asunto no estaba aceptado se cancelan sus tareas, si estaba aceptado sus tareas ya estarán canceladas
        if (!DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO.equals(asunto.getEstadoAsunto().getCodigo())) {
            //Finalizo la tarea de confirmacion de asunto del supervisor.
            for (TareaNotificacion tarea : asunto.getTareas()) {
                if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
                    Long idBPM = asunto.getProcessBpm();
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                }
            }
            //Finalizo las tareas de recopilar informacion de los procedimientos.
            for (Procedimiento proc : asunto.getProcedimientos()) {

                //Si el procedimiento estaba en estado conformación, le seteamos el estado propuesto
                if (proc.getEstaEstadoConfirmado()) {
                    DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento) executor.execute(
                            ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoProcedimiento.class,
                            DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO);

                    proc.setEstadoProcedimiento(estadoProcedimiento);
                }

                Long idBPM = proc.getProcessBPM();
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, idBPM, TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
            }
        }

        //Cambiar de estado el asunto
        DDEstadoAsunto estadoAsunto = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoAsunto.class,
                DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO);
        DDEstadoAsunto estadoAceptado = estadoAsunto;
        asunto.setEstadoAsunto(estadoAceptado);

        //Paso el asunto al estado itinerario DC
        DDEstadoItinerario estadoItinerario = (DDEstadoItinerario) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoItinerario.class, DDEstadoItinerario.ESTADO_DECISION_COMIT);
        asunto.setEstadoItinerario(estadoItinerario);

        /** ESTO NO ESTÁ EN EL CU!!!, ¿PORQUE SE HA PUESTO ASÍ?
        //creo la tarea para el comite.
        Long idBPM = tareaNotificacionManager.crearTareaConBPM(asunto.getId(), TipoEntidad.CODIGO_ENTIDAD_ASUNTO,
                SubtipoTarea.CODIGO_ASUNTO_PROPUESTO, PlazoTareasDefault.CODIGO_ACEPTAR_ASUNTO);
        asunto.setProcessBpm(idBPM);
        **/
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);
        //this.saveOrUpdateAsunto(asunto);
    }

    /**
     * Graba una ficha de aceptaciÃ³n.
     * @param dto trae los datos para la ficha
     * @return el id del asunto.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GUARDAR_FICHA_ACEPTACION)
    @Transactional(readOnly = false)
    public Long guardarFichaAceptacion(FichaAceptacionDto dto) {
        Asunto asunto = asuntoDao.get(dto.getIdAsunto());
        asunto.getFichaAceptacion().setAceptacion(dto.getAceptacion());
        asunto.getFichaAceptacion().setConflicto(dto.getConflicto());
        asunto.getFichaAceptacion().setDocumentacionRecibida(dto.getDocumentacionRecibida());
        if (dto.getFechaRecepDoc() != null && !dto.getFechaRecepDoc().equals("")) {
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            try {
                asunto.setFechaRecepDoc(sdf1.parse(dto.getFechaRecepDoc()));
            } catch (ParseException e) {
                throw new BusinessOperationException("error.parse.fecha");
            }
        } else {
            asunto.setFechaRecepDoc(null);
        }
        ObservacionAceptacion oba = new ObservacionAceptacion();
        oba.setDetalle(dto.getObservaciones());
        oba.setFecha(new Date());
        oba.setFichaAceptacion(asunto.getFichaAceptacion());
        oba.setUsuario((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO));

        fichaAceptacionDao.save(asunto.getFichaAceptacion());
        //Ejecutar la accion
        if (FichaAceptacionDto.ACEPTAR.equals(dto.getAccion())) {
            oba.setAccion(messageService.getMessage("asunto.fichaAceptacion.aceptacion"));
            aceptarAsunto(dto.getIdAsunto());
        } else if (FichaAceptacionDto.DEVOLVER.equals(dto.getAccion())) {
            oba.setAccion(messageService.getMessage("asunto.fichaAceptacion.devolucion"));
            executor.execute(ExternaBusinessOperation.BO_ASU_MGR_DEVOLVER_ASUNTO, dto.getIdAsunto());
            //devolverAsunto(dto.getIdAsunto());
        } else if (FichaAceptacionDto.ELEVAR_COMITE.equals(dto.getAccion())) {
            oba.setAccion(messageService.getMessage("asunto.fichaAceptacion.elevacion"));
            executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ELEVAR_COMITE_ASUNTO, dto.getIdAsunto());
            //elevarComiteAsunto(dto.getIdAsunto());
        } else if (FichaAceptacionDto.EDITAR.equals(dto.getAccion())) {
            oba.setAccion(messageService.getMessage("asunto.fichaAceptacion.editar"));
        }
        observacionAceptacionDao.save(oba);

        //asunto.getTareas()

        return asunto.getId();
    }

    /**
     * Indica si el usuario puede tomar una acciï¿½n sobre el asunto o si debe completar la ficha antes.
     * @param idAsunto el id del asunto
     * @return true o false.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_PUEDE_TOMAR_ACCION_ASUNTO)
    public Boolean puedeTomarAccionAsunto(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        if (asunto.getFichaAceptacion().getObservaciones() == null || asunto.getFichaAceptacion().getObservaciones().size() == 0) {
            //Es la primera vez. Todavï¿½a nadie grabï¿½ nada.
            return true;
        }
        Usuario usuUltimaEdicion = asunto.getFichaAceptacion().getObservaciones().get(0).getUsuario();
        Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        if (usuUltimaEdicion.getId().longValue() == usuarioLogado.getId().longValue()) {
            //El ï¿½ltimo que hizo una modificaciï¿½n a la ficha fue este usuario, asÃ­ que puede tomar acciï¿½n
            return true;
        }
        return false;

    }

    /**
     * Indica si el Usuario Logado tiene que responder alguna comunicaciÃ³n.
     * Se usa para mostrar o no el botÃ³n responder.
     * @param asuntoId el id del Asunto.
     * @return true o false.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_BUSCAR_TAREA_PENDIENTE)
    public TareaNotificacion buscarTareaPendiente(Long asuntoId) {
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        return asuntoDao.buscarTareaPendiente(asuntoId, usuario.getId());
    }

    /**
     * Indica si el Usuario Logado es el gestor del asunto.
     * @param idAsunto el id del asunto
     * @return true si es el gestor.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR)
    public Boolean esGestor(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        return asunto.getGestor().getUsuario().getId().equals(usuario.getId());
    }

    /**
     * Indica si el Usuario Logado es el supervisor del asunto.
     * @param idAsunto el id del asunto
     * @return true si es el Supervisor.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ES_SUPERVISOR)
    public Boolean esSupervisor(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        return asunto.getSupervisor().getUsuario().getId().equals(usuario.getId());
    }

    /**
     * upload.
     * @param uploadForm upload
     * @return String
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_UPLOAD)
    @Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero esté vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero();

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Asunto asunto = asuntoDao.get(Long.parseLong(uploadForm.getParameter("id")));
        asunto.addAdjunto(fileItem);
        asuntoDao.save(asunto);

        return null;
    }

    /**
     * Recupera el límite de tamaño de un fichero.
     * @return integer
     */
    private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_ASUNTO);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el límite máximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
    }

    /**
     * Recupera la cadena de extensiones de archivos adjuntos que deben comprimirse en ZIP durante la descarga
     * @return String
     */    
    private String getParamZipExtensiones() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.ADJUNTOS_DESCARGA_ZIP_EXTENSIONES);
            return param.getValor();
        } catch (Exception e) {
            logger.warn("No esta parametrizado la compresion en zip de la descarga de archivos");
            return "";
        }
    }
    
    /**
     * Recupera de parametros el nivel de compresion de los archivos ZIP, entero [0-9]. Min=0, Max=9.
     * @return int
     */    
    private int getParamZipNivelCompresion() {
        final int DEFAULT_LEVEL = 8;
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.ADJUNTOS_DESCARGA_ZIP_NIVEL_COMPRESION);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el nivel de compresion en zip de la descarga de archivos");
        } 
        return DEFAULT_LEVEL;
    }
    
    /**
     * Busca por nombre de archivo si su extension es una de las que hay que comprimir en ZIP durante la descarga
     * @return Boolean
     */
    private Boolean esDescargaZip(String fileName) {
     
        //Separa nombre y extension de archivo en un vector de String(). Ej nombre: archivo1.ext1.ext2.ext3
        String[] fileExts = fileName.split("\\.");
        
        //Del vector de extensiones de un archivo, solo toma la ultima como referencia: .ext3
        //Si el nombre no tiene extensiones (o nombre vacio), retorna ".xxx" en lastFileExt
        String lastFileExt = new String();
        if (fileExts.length < 2){
            lastFileExt = ".".concat("xxx");
        } else {
            lastFileExt = ".".concat(fileExts[fileExts.length-1]);
        }
        
        //Convierte todo a minusculas
        //Busca coincidencias en el parametro de extenciones a comprimir, si existe la ultima extension del archivo: ext3
        //Si el parametro contiene "*.*" directamente retorna TRUE = Comprimir siempre
        //Si no existe el parametro zip por extensiones en PEN_PARAM_ENTIDAD, retorna siempre FALSE
        //Si el parametro es la palabra "disable", retorna siempre FALSE y no comprime nunca
        String extParam = getParamZipExtensiones().toLowerCase();
        lastFileExt = lastFileExt.toLowerCase();
        if (extParam.isEmpty() || extParam.equals("disable")){
            return false;
        } else {
            if (extParam.contains("*.*")){
                return true;
            } else {
                return extParam.toLowerCase().contains(lastFileExt);
            }
        }
    
    }
    
    /**
     * bajar un adjunto.
     * @param asuntoId exp
     * @param adjuntoId adjunto
     * @return file
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_BAJAR_ADJUNTO)
    public FileItem bajarAdjunto(Long asuntoId, Long adjuntoId) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, asuntoId);

        FileItem adjunto = asunto.getAdjunto(adjuntoId).getAdjunto().getFileItem();
        
        if (esDescargaZip(adjunto.getFileName())) {
            return zipFileItem(adjunto);
        } else {
            return adjunto;
        }
    }

    private FileItem zipFileItem (FileItem fi) {
    
        //Es importante reutilizar el nombre del archivo temporal del FileItem de entrada, mas ext. zip
        String zipFileName = fi.getFile().getName().concat(".zip");
        File zipFile = new File(zipFileName);
        FileItem fo = new FileItem();
        
        try {
            //Verifica si ya estaba creado y lo elimina para crearlo vacio
            if (zipFile.exists()) {
               zipFile.delete();
               zipFile.createNewFile();
            }
            
            // Crea un buffer de 1024
            byte[] buffer = new byte[1024];
            FileInputStream fis = new FileInputStream(fi.getFile());
            FileOutputStream fos = new FileOutputStream(zipFileName);
            ZipOutputStream zos = new ZipOutputStream(fos);

            //Define el nivel de compresion a 0 (sin)
            zos.setLevel(getParamZipNivelCompresion());

            //Incluye el archivo de entrada dentro del zip
            zos.putNextEntry(new ZipEntry(fi.getFileName()));

            int length;
            while ((length = fis.read(buffer)) > 0) {
                zos.write(buffer, 0, length);
            }

            //Cierra las entradas al zip
            zos.closeEntry();
            //Cierra FileInputStream
            fis.close();
            //Cierra ZipOutputStream
            zos.close();

        }
        catch (IOException ioe) {
            System.out.println("Error creating zip file" + ioe);
        }

        fo.setFile(zipFile);
        fo.setFileName(fi.getFileName().concat(".zip"));
        fo.setLength(zipFile.length());
        fo.setContentType("application/zip");

        return fo;
        
    }
 
    
    /**
     * delete un adjunto.
     * @param asuntoId long
     * @param adjuntoId long
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_DELETE_ADJUNTO)
    @Transactional(readOnly = false)
    public void deleteAdjunto(Long asuntoId, Long adjuntoId) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, asuntoId); //get(asuntoId);
        AdjuntoAsunto adj = asunto.getAdjunto(adjuntoId);
        if (adj == null) { return; }
        asunto.getAdjuntos().remove(adj);
        asuntoDao.save(asunto);
    }

    /**
     * @param idAsunto Long
     * @return boolean: <code>true</code> si se puede ver el tab de comite en el asunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_PUEDE_VER_DECISIONES_COMITE)
    public boolean puedeVerDecisionComite(Long idAsunto) {
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto); //get(idAsunto);

        //Si no tiene comité asignado, directamente no puede ver la decisión
        if (asunto.getComite() == null) { return Boolean.FALSE; }

        //Valido que la sesion esté iniciada
        if (asunto.getComite().getEstado() != Comite.INICIADO) {
            logger.debug("NO SE PUEDE MOSTRAR EL TAB DECISION DE COMITE, PORQUE EL COMITE NO ESTÁ INICIADO");
            return Boolean.FALSE;
        }
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

        //Valido que el usuario sea miembro del comite del asunto
        for (Perfil perfil : usuario.getPerfiles()) {
            for (PuestosComite puestoComite : perfil.getPuestosComites()) {
                //La condición de la sesion abierta también la validé en el punto anterior
                if (puestoComite.getComite().getId().equals(asunto.getComite().getId()) && Comite.INICIADO.equals(asunto.getComite().getEstado())) {
                    logger.debug("MUESTRO EL TAB DECISION COMITE");
                    return Boolean.TRUE;
                }
            }
        }
        logger.debug("NO SE PUEDE MOSTRAR LA PESTAÑA DECISION DE COMITE PORQUE NO CORRESPONDE AL USUARIO " + usuario.getUsername());
        return Boolean.FALSE;
    }

    /**
     * @param idAsunto Long
     * @return List Persona: todas las personas demandadas en los procedimientos del asunto.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_PERSONAS_DE_UN_ASUNTO)
    public List<Persona> obtenerPersonasDeUnAsunto(Long idAsunto) {
        return asuntoDao.obtenerPersonasDeUnAsunto(idAsunto);
    }

    /**
     * Devuelve en una lista el expediente del asunto si tiene adjuntos,
     * sino devuelve una lista vacía. Se envuelve en una lista para que
     * pueda ser iterado en un JSON genérico.
     * @param asuntoId Long
     * @return List Expediente
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET_EXPEDIENTE_SI_TIENE_ADJUNTO)
    public List<Expediente> getExpedienteSiTieneAdjuntos(Long asuntoId) {
        Asunto asunto = asuntoDao.get(asuntoId);
        List<Expediente> expedienteEnLista = new ArrayList<Expediente>();
        if (asunto.getExpediente().getAdjuntos().size() > 0) {
            expedienteEnLista.add(asunto.getExpediente());
        }
        return expedienteEnLista;
    }

    /**
     * Devuelve en una lista el expediente del asunto.
     * Se envuelve en una lista para que pueda ser iterado en un JSON genérico.
     * @param asuntoId Long
     * @return List Expediente
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET_EXPEDIENTE_AS_LIST)
    public List<Expediente> getExpedienteAsList(Long asuntoId) {
        List<Expediente> expedienteEnLista = new ArrayList<Expediente>();
        expedienteEnLista.add(asuntoDao.get(asuntoId).getExpediente());
        return expedienteEnLista;
    }

    /**
     * Devuelve todos los contratos relacionados al asunto que tengan archivos adjuntos.
     * @param asuntoId Long
     * @return List Contrato
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET_CONTRATOS_QUE_TIENE_ADJUNTO)
    public List<Contrato> getContratosQueTienenAdjuntos(Long asuntoId) {
        return asuntoDao.getContratosQueTienenAdjuntos(asuntoId);
    }

    /**
     * Cambia el gestor del asunto. Elimina historico de accesos al Asunto y sus procedimientos asociados del gestor anterior
     * @param dtoAsunto dtoAsunto
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_CAMBIAR_GESTOR_ASUNTO)
    @Transactional(readOnly = false)
    public void cambiarGestorAsunto(DtoAsunto dtoAsunto) {
        Asunto asunto = asuntoDao.get(dtoAsunto.getIdAsunto());
        GestorDespacho procuradorAnterior = asunto.getProcurador();
        //verifico si se cambio el procurador
        if (dtoAsunto.getIdProcurador() != null) {
            //Valido que el procurador sea uno distinto
            if (procuradorAnterior != null && (procuradorAnterior.getId().equals(dtoAsunto.getIdProcurador()))) {
                if (dtoAsunto.getIdGestor().equals(asunto.getGestor().getId())) throw new BusinessOperationException("asuntos.procuradordistinto");
            } else {
                GestorDespacho nuevoProcurador = gestorDespachoDao.get(dtoAsunto.getIdProcurador());
                asunto.setProcurador(nuevoProcurador);
            }

        }
        if (dtoAsunto.getIdGestor() != null) {
            GestorDespacho gestorAnterior = asunto.getGestor();
            //Valido que el gestor sea uno distinto
            long idAnt = gestorAnterior.getId(), idActual = dtoAsunto.getIdGestor();
            if (idAnt == idActual) {
                if (dtoAsunto.getIdProcurador() != null && asunto.getProcurador() != null && procuradorAnterior != null
                        && procuradorAnterior.getId().equals(dtoAsunto.getIdProcurador()))
                    throw new BusinessOperationException("asuntos.gestordistinto");
            } else {
                //Asignar el nuevo gestor
                GestorDespacho nuevoGestor = gestorDespachoDao.get(dtoAsunto.getIdGestor());
                asunto.setGestor(nuevoGestor);
                //Borrar historicos
                borrarFavoritosAsunto(asunto);
            }

        }
        asuntoDao.saveOrUpdate(asunto);
    }

    /**
     * Obtiene las actuaciones (Procedimientos) de un asunto en forma jerarquica.
     * @param idAsunto Long
     * @return Lista de ProcedimientoJerarquiaDto
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_JERARQUICO)
    public List<ProcedimientoJerarquiaDto> obtenerActuacionesAsuntoJerarquico(Long idAsunto) {
        List<ProcedimientoJerarquiaDto> procedimientos = new ArrayList<ProcedimientoJerarquiaDto>();
        Asunto asunto = asuntoDao.get(idAsunto);
        TreeMap<Procedimiento, TreeMap> tree = new TreeMap<Procedimiento, TreeMap>();
        for (Procedimiento proc : asunto.getProcedimientos()) {
            insertaProcedimientoJerarquia(tree, proc);
        }
        listarProcedimientos(procedimientos, tree, null);
        return procedimientos;

    }

    /**
     * Obtiene las actuaciones (Procedimientos) de un asunto.
     * @param idAsunto long
     * @return lista de procedimientos
     */
    @BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO)
    public List<Procedimiento> obtenerActuacionesAsunto(Long idAsunto) {
        return asuntoDao.getProcedimientosOrderNroJuzgado(idAsunto);
    }

    /**
     * inserta nodos en el arbol de procedimientos jerarquicamente.
     * @param tree Procedimiento-TreeMap
     * @param proc Procedimiento
     */
    @SuppressWarnings("unchecked")
    private void insertaProcedimientoJerarquia(TreeMap<Procedimiento, TreeMap> tree, Procedimiento proc) {
        //System.out.println("id:" + proc.getId() + " padre:" + proc.getProcedimientoPadre() != null ? proc.getProcedimientoPadre().getId() : "none");
        if (proc.getProcedimientoPadre() == null) {
            //no es hijo de nadie
            tree.put(proc, null);
        } else {
            TreeMap nodo = null;
            if (tree.containsKey(proc.getProcedimientoPadre())) {
                //hijo directo de la rama en la que estamos
                nodo = tree.get(proc.getProcedimientoPadre());
                if (nodo == null) {
                    nodo = new TreeMap<Procedimiento, TreeMap>();
                }
                nodo.put(proc, null);
                tree.put(proc.getProcedimientoPadre(), nodo);

            } else {
                //nieto de esta rama, o de otra
                //insertaProcedimientoJerarquia((TreeMap) tree.subMap(proc.getProcedimientoPadre(), proc.getProcedimientoPadre()), proc);
                nodo = buscaNodo(tree, proc);
                if (nodo == null) {
                    nodo = new TreeMap<Procedimiento, TreeMap>();
                }
                nodo.put(proc, null);

            }

        }
    }

    /**
     * convierte el arbol jerarquico de procedimientos en una lista por niveles 0,1,2.
     * @param procedimientos la lista de procedimientos de salida
     * @param arbol el arbol jerarquico de procedimientos
     * @param nivel parametro de nivel (automatico, inicialmente se setea en null)
     */
    @SuppressWarnings("unchecked")
    private void listarProcedimientos(List<ProcedimientoJerarquiaDto> procedimientos, TreeMap<Procedimiento, TreeMap> arbol, Integer nivel) {
        if (nivel == null) {
            nivel = 0;
        }
        for (Procedimiento proc : arbol.keySet()) {
            TreeMap nodo = arbol.get(proc);
            ProcedimientoJerarquiaDto pj = new ProcedimientoJerarquiaDto(nivel, proc);
            procedimientos.add(pj);
            if (nodo != null) {
                listarProcedimientos(procedimientos, nodo, nivel + 1);
            }
        }
    }

    /**
     * Busca el procedimiento padre en un TreeMap.<br>
     * Devuelve el nodo adonde estan listados los hijos del procedimiento Padre
     * @param tree el arbol adonde se desea buscar la clave
     * @param proc el procedimiento hijo del cual se desea buscar el padre para anidarlo
     * @return
     */
    @SuppressWarnings("unchecked")
    private TreeMap<Procedimiento, TreeMap> buscaNodo(TreeMap<Procedimiento, TreeMap> tree, Procedimiento proc) {
        TreeMap ret = null;
        if (tree.containsKey(proc.getProcedimientoPadre())) {
            ret = tree.get(proc.getProcedimientoPadre());
            if (ret == null) {
                ret = new TreeMap<Procedimiento, TreeMap>();
            }
            tree.put(proc.getProcedimientoPadre(), ret);
        } else {
            for (TreeMap<Procedimiento, TreeMap> nodo : tree.values()) {
                //llegue al final de la rama, segui participando
                if (nodo == null) {
                    continue;
                }

                if (nodo.containsKey(proc.getProcedimientoPadre())) {
                    ret = nodo.get(proc.getProcedimientoPadre());
                    if (ret == null) {
                        ret = new TreeMap<Procedimiento, TreeMap>();
                    }
                    nodo.put(proc.getProcedimientoPadre(), ret);
                    break;
                }
                ret = buscaNodo(nodo, proc);
            }
        }
        return ret;
    }

    /**
     * BusinessOperation para cambiar el supervisor del asunto
     * @param dto el Dto del asunto
     * @param temporal flag para indicar si el cambio es temporal (p.ej. vacaciones=true), o definitivo (false)
     */
    @BusinessOperation
    @Transactional(readOnly = false)
    public void cambiarSupervisor(DtoAsunto dto, boolean temporal) {
        Asunto asunto = asuntoDao.get(dto.getIdAsunto());
        GestorDespacho newSupervisor = gestorDespachoDao.get(dto.getIdSupervisor());
        //Valido que el supervisor sea uno distinto
        long idAnt = asunto.getSupervisor().getId(), idActual = dto.getIdSupervisor();
        if (idAnt == idActual) { throw new BusinessOperationException("asuntos.supervisordistinto"); }
        HistoricoCambiosAsunto his = new HistoricoCambiosAsunto();
        his.setSupervisorOrigen(asunto.getSupervisor());
        his.setSupervisorDestino(newSupervisor);
        his.setAuditoria(Auditoria.getNewInstance());
        his.setTemporal(temporal);
        asunto.addHistorico(his);
        asunto.setSupervisor(newSupervisor);
        asuntoDao.saveOrUpdate(asunto);

    }

    /**
     * B.O. para saber si el Asunto que se está consultando, en algun momento se derivó temporalmente a otro supervisor
     * @param idAsunto 
     * @return true si el usuario que lo esta consultando, en su momento fue el que lo derivó, false en cualquier otro caso
     */
    @BusinessOperation
    public boolean esSupervisorOriginal(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        if (asunto.getSupervisorOriginal() == null)
            return false;
        else {
            Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            return asunto.getSupervisorOriginal().getUsuario().getId().equals(usuarioLogado.getId());
        }

    }

    /**
     * B.O. para saber si el Asunto que se está consultando, en algun momento se derivó temporalmente a otro supervisor
     * @param idAsunto 
     * @return true si el usuario que lo esta consultando, en su momento fue el que lo derivó, false en cualquier otro caso
     */
    @BusinessOperation
    public boolean esSupervisorTemporal(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        if (asunto.getSupervisorOriginal() == null) {
            return false;
        } else {
            Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            return asunto.getSupervisorOriginal().getUsuario().getId().equals(usuarioLogado.getId());
        }
    }

    /**
     * B.O. para reasignar el asunto al supervisor que originalmente lo tenia y lo derivó a otro por vacaciones
     * @param idAsunto el id del asunto
     */
    @BusinessOperation
    @Transactional(readOnly = false)
    public void reasignarAsuntoSupervisorOriginal(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        GestorDespacho newSupervisor = asunto.getSupervisorOriginal();
        if (newSupervisor != null) {
            HistoricoCambiosAsunto his = new HistoricoCambiosAsunto();
            his.setSupervisorOrigen(asunto.getSupervisor());
            his.setSupervisorDestino(newSupervisor);
            his.setAuditoria(Auditoria.getNewInstance());
            asunto.addHistorico(his);
            asunto.setSupervisor(newSupervisor);
            asuntoDao.saveOrUpdate(asunto);
        }
    }
}
