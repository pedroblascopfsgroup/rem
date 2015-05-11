package es.capgemini.pfs.procesosJudiciales;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.procesosJudiciales.dao.EXTTareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaRecuperacionDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaRecuperacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.recuperacion.dao.RecuperacionDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;
import es.capgemini.pfs.tareaNotificacion.EXTDtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Component
public class EXTTareaExternaManager extends BusinessOperationOverrider<TareaExternaApi> implements TareaExternaApi {

    @Autowired
    private ApiProxyFactory proxyFactory;

    @Autowired
    private Executor executor;

    @Autowired
    private TareaExternaDao tareaExternaDao;

    @Autowired
    private RecuperacionDao recuperacionDao;

    @Autowired
    private TareaExternaRecuperacionDao tareaExternaRecuperacionDao;

    @Autowired
    private EXTTareaExternaDao extTareaExternaDao;

    @Autowired
    private GenericABMDao genericDao;

    @Override
    public String managerName() {
        return "tareaExternaManager";
    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_ACTIVAR)
    @Transactional(readOnly = false)
    public void activar(TareaExterna tareaExterna) {
        parent().activar(tareaExterna);
    }

    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTO)
    public List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimiento(Long idProcedimiento) {
        if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcionBuzonOptimizado()) {
            return this.obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(idProcedimiento);
        } else {
            return getListadoTareasSinOptimizar(idProcedimiento);
        }
    }


    @Override
    @BusinessOperation(BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTOS)
    public List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimientos(List<Long> idProcedimiento) {
    	return this.obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(idProcedimiento);
    }
    
    @Override
    @BusinessOperation(BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTOS)
    public List<? extends TareaExterna> obtenerTareasPorProcedimientos(List<Long> idProcedimiento) {
    	return this.obtenerTareasPorProcedimientoConOptimizacion(idProcedimiento);
    }
    
    private List<EXTGestorAdicionalAsunto> dameRolesUsuarioAsunto(Long idAsunto) {

        Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
        Filter filtroIdGestor = genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", usuario.getId());
        Filter borrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
        return genericDao.getList(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroIdGestor, borrado);

    }

    /*
     * private boolean esSupervisorConfeccionExpediente(Long idAsunto){ Boolean
     * esSupervisor=false; Usuario usuario =
     * proxyFactory.proxy(UsuarioApi.class) .getUsuarioLogado(); Filter
     * filtroAsunto=genericDao.createFilter(FilterType.EQUALS, "asunto.id",
     * idAsunto); Filter filtroTipoGestor
     * =genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo",
     * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP); Filter
     * filtroIdGestor = genericDao.createFilter(FilterType.EQUALS,
     * "gestor.usuario.id", usuario.getId()); EXTGestorAdicionalAsunto gaa=
     * genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto,
     * filtroIdGestor, filtroTipoGestor); if (!Checks.esNulo(gaa)){
     * esSupervisor=true; } return esSupervisor; }
     * 
     * private boolean esGestorConfeccionExpediente(Long idAsunto) { Boolean
     * esGestor=false; Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
     * .getUsuarioLogado(); Filter
     * filtroAsunto=genericDao.createFilter(FilterType.EQUALS, "asunto.id",
     * idAsunto); Filter filtroTipoGestor
     * =genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo",
     * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP); Filter filtroIdGestor =
     * genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id",
     * usuario.getId()); EXTGestorAdicionalAsunto gaa=
     * genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto,
     * filtroIdGestor, filtroTipoGestor); if (!Checks.esNulo(gaa)){
     * esGestor=true; } return esGestor; }
     */

    @Override
    public void activarAlerta(TareaExterna tareaExterna) {
        // TODO Auto-generated method stub

    }

    @Override
    public void borrar(TareaExterna tareaExterna) {
        // TODO Auto-generated method stub

    }

    @Override
    public void detener(TareaExterna tareaExterna) {
        // TODO Auto-generated method stub

    }

    /**
     * Get tarea externa.
     * 
     * @param id
     *            long
     * @return tarea externa
     */
    @Override
    @BusinessOperation(overrides = ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET)
    @Transactional
    public TareaExterna get(Long id) {
        return parent().get(id);
    }

    @Override
    @BusinessOperation(BO_CORE_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA)
    @Transactional(readOnly = false)
    public Long crearTareaExternaDto(EXTDtoCrearTareaExterna dto) {
    	DtoGenerarTarea dtoGenerarTarea = new EXTDtoGenerarTarea(dto.getIdProcedimiento(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, dto.getCodigoSubtipoTarea(), false, false, dto.getPlazo(),
                dto.getDescripcion(), dto.getTipoCalculo());
        long idTarea = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dtoGenerarTarea);

        // Cambiamos el nombre de la tarea
        TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTarea);
        tareaPadre.setTarea(dto.getDescripcion());
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaPadre);

        EXTTareaExterna tarea = new EXTTareaExterna();
        tarea.setTareaPadre(tareaPadre);
        tarea.setTareaProcedimiento((TareaProcedimiento) executor.execute(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET, dto.getIdTareaProcedimiento()));
        tarea.setTokenIdBpm(dto.getTokenIdBpm());
        tarea.setDetenida(false);
        tarea.setNumeroAutoprorrogas(0);

        Long idTareaExterna = tareaExternaDao.save(tarea);
        registraRecuperacionContrato(tarea);

        return idTareaExterna;
    }

    /**
     * Registra los pasos de recuperaci�n de contratos en el momento de creaci�n
     * de la tarea.
     * 
     * @param tarea
     */
    @Transactional(readOnly = false)
    private void registraRecuperacionContrato(TareaExterna tarea) {

        // Recuperamos los contratos asociados a la tarea
        List<ExpedienteContrato> list = tarea.getTareaPadre().getProcedimiento().getExpedienteContratos();

        for (ExpedienteContrato ec : list) {
            Contrato contrato = ec.getContrato();
            TareaExternaRecuperacion ter = new TareaExternaRecuperacion();

            Recuperacion recuperacion = recuperacionDao.getUltimaRecuperacionByContrato(contrato.getId());

            ter.setTareaExterna(tarea);
            ter.setRecuperacionAsociada(recuperacion);
            ter.setFechaRegistroRecuperacion(new Date());

            tareaExternaRecuperacionDao.save(ter);
        }

    }

    /**
     * TODO Eliminar este m�todo. S�lo es necesario si no se usa la optimizaci�n
     * de buzones de tareas
     * 
     * @deprecated
     * @param idProcedimiento
     * @return
     */
    @Deprecated
    protected List<? extends TareaExterna> getListadoTareasSinOptimizar(Long idProcedimiento) {
        // Long idUsuarioLogado = null;
        // Usuario usuario =
        // proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
        // if (usuario != null) {
        // idUsuarioLogado = usuario.getId();
        // }

        Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
        // Long idGestor =
        // procedimiento.getAsunto().getGestor().getUsuario().getId();
        // Long idSupervisor =
        // procedimiento.getAsunto().getSupervisor().getUsuario().getId();

        List<TareaExterna> list = new ArrayList<TareaExterna>();

        // cogemos los roles que tiene ese usuario para ese asunto
        List<EXTGestorAdicionalAsunto> listaRoles = dameRolesUsuarioAsunto(procedimiento.getAsunto().getId());

        for (EXTGestorAdicionalAsunto gaa : listaRoles) {
            if (gaa.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO)) {
                list.addAll(tareaExternaDao.obtenerTareasGestorPorProcedimiento(idProcedimiento));
            } else if (gaa.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR)) {
                list.addAll(tareaExternaDao.obtenerTareasSupervisorPorProcedimiento(idProcedimiento));
            } else if (gaa.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP)) {
                list.addAll(extTareaExternaDao.obtenerTareasGestorConfeccionExpediente(idProcedimiento));
            } else if (gaa.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP)) {
                list.addAll(extTareaExternaDao.obtenerTareasSupervisorConfeccionExpediente(idProcedimiento));
            } else {
                EXTSubtipoTarea subTarea = genericDao.get(EXTSubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", gaa.getTipoGestor().getCodigo()),
                        genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
                if (subTarea != null)
                    list.addAll(extTareaExternaDao.obtenerTareasPorSubtipoTareaYProcedimiento(idProcedimiento, subTarea.getCodigoSubtarea()));
            }
        }

        /*
         * if
         * (proxyFactory.proxy(AsuntoApi.class).esGestor(procedimiento.getAsunto
         * ().getId())) { list =
         * tareaExternaDao.obtenerTareasGestorPorProcedimiento(idProcedimiento);
         * } else if
         * (proxyFactory.proxy(AsuntoApi.class).esSupervisor(procedimiento
         * .getAsunto().getId())) { list =
         * tareaExternaDao.obtenerTareasSupervisorPorProcedimiento
         * (idProcedimiento); } else { list = new ArrayList<TareaExterna>(); }
         * 
         * // comprobar que el gestor externo solo ve las de gestor externo y el
         * gestor cce solo las de cce
         * if(esGestorConfeccionExpediente(procedimiento.getAsunto().getId())){
         * list = (List<TareaExterna>)
         * extTareaExternaDao.obtenerTareasGestorConfeccionExpediente
         * (idProcedimiento); }
         * if(esSupervisorConfeccionExpediente(procedimiento
         * .getAsunto().getId())){ list= (List<TareaExterna>)
         * extTareaExternaDao.
         * obtenerTareasSupervisorConfeccionExpediente(idProcedimiento); }
         */
        // list =
        // extTareaExternaDao.buscaTareasPorTipoGestorYProcedimiento(idProcedimiento);

        for (TareaExterna tex : list) {
            Boolean hasTransition = (Boolean) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_HAS_TRANSITION_TOKEN, tex.getTokenIdBpm(), BPMContants.TRANSICION_VUELTA_ATRAS);

            if (tex.getTokenIdBpm() != null && hasTransition && (tex.getTareaProcedimiento().getAlertVueltaAtras() != null && !"".equals(tex.getTareaProcedimiento().getAlertVueltaAtras()))) {
                tex.setVueltaAtras(true);
            } else {
                tex.setVueltaAtras(false);
            }
            if (tex instanceof EXTTareaExterna) {
                tex = (EXTTareaExterna) tex;
            }
        }

        return list;
    }

    protected List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(Long idProcedimiento) {
    	List<Long> id = new ArrayList<Long>();
    	id.add(idProcedimiento);
    	return obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(id);
    }    
    
    /**
     * obtiene las tareas del procedimiento del usuario logado
     * @param idProcedimiento
     * @return
     */
    protected List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(List<Long> idProcedimiento) {
        Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();        
        return obtenerTareasConOptimizacion(idProcedimiento, usuario.getId());
    }    
    
    /**
     * obtiene las tareas del procedimiento sin usuario
     * @param idProcedimiento
     * @return
     */
    protected List<? extends TareaExterna> obtenerTareasPorProcedimientoConOptimizacion(List<Long> idProcedimiento) {
        return obtenerTareasConOptimizacion(idProcedimiento, null);
    } 
    
    private List<? extends TareaExterna> obtenerTareasConOptimizacion(List<Long> idProcedimiento, Long idUsuario) {
    	List<? extends TareaExterna> list = extTareaExternaDao.obtenerTareasPorUsuarioYProcedimientoConOptimizacion(idUsuario, idProcedimiento); 
        for (TareaExterna tex : list) {
            Boolean hasTransition = (Boolean) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_HAS_TRANSITION_TOKEN, tex.getTokenIdBpm(), BPMContants.TRANSICION_VUELTA_ATRAS);

            if (tex.getTokenIdBpm() != null && hasTransition && (tex.getTareaProcedimiento().getAlertVueltaAtras() != null && !"".equals(tex.getTareaProcedimiento().getAlertVueltaAtras()))) {
                tex.setVueltaAtras(true);
            } else {
                tex.setVueltaAtras(false);
            }
            if (tex instanceof EXTTareaExterna) {
                tex = (EXTTareaExterna) tex;
            }
        }
        
        return list;

    }

    
}
