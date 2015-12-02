package es.capgemini.pfs.procesosJudiciales;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaRecuperacionDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaRecuperacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.recuperacion.dao.RecuperacionDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Tarea externa manager.
 *
 * @author jbosnjak
 *
 */
@Service
public class TareaExternaManager {

    @Autowired
    private Executor executor;

    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;

    @Autowired
    private RecuperacionDao recuperacionDao;

    @Autowired
    private TareaExternaDao tareaExternaDao;

    @Autowired
    private TareaExternaRecuperacionDao tareaExternaRecuperacionDao;

    /**
     * Metodo que retrocede a partir de una tarea dada.
     *
     * @param idTareaExterna Tarea Externa que se va a retroceder
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_VUELTA_ATRAS)
    @Transactional(readOnly = false)
    public void vueltaAtras(Long idTareaExterna) {

        //Recuperamos la tarea y el token que origina la vuelta atrás
        TareaExterna tareaExterna = get(idTareaExterna);
        Long idTokenMaster = tareaExterna.getTokenIdBpm();

        //tareaExternaValorDao.getByTareaExterna(idTareaExterna).get(0).get

        //this.getByIdTareaProcedimientoIdProcedimiento(idProcedimiento, idTareaProcedimiento);

        //tareaExterna.getTareaPadre().getProcedimiento().getProcedimientoPadre().getId();

        String nombreNodo = tareaExterna.getTareaProcedimiento().getCodigo();
        String nombreVariable = BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + nombreNodo;
        String listadoTareas = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_PROCESS_VARIABLES, idTokenMaster, nombreVariable);

        if (listadoTareas != null && listadoTareas.trim().length() > 0) {
            //Listado con las tareas que se van a volver atrás
            ArrayList<String> vCodigosTareas = new ArrayList<String>(CollectionUtils.arrayToList(StringUtils
                    .tokenizeToStringArray(listadoTareas, ",")));

            if (vCodigosTareas.size() > 0) {
                List<Long> vIdTokens = new ArrayList<Long>();

                //Tareas activas del procedimiento
                List<TareaExterna> vTareas = getActivasByIdProcedimiento(tareaExterna.getTareaPadre().getProcedimiento().getId());
                Iterator<TareaExterna> itTareas = vTareas.iterator();

                //Recorremos todas las tareas activas del procedimiento
                while (itTareas.hasNext()) {
                    TareaExterna tarea = itTareas.next();

                    //Si la tarea se encuentra entre las tareas de vuelta atrás la guardamos y la borramos del vector 'vueltaAtras'
                    String codigoTarea = tarea.getTareaProcedimiento().getCodigo();
                    if (vCodigosTareas.contains(codigoTarea)) {
                        vCodigosTareas.remove(codigoTarea);
                        vIdTokens.add(tarea.getTokenIdBpm());
                    }
                }

                //Si el vector 'vueltaAtras' no tiene más tareas (si todas las tareas marcadas como vueltaAtrás se encuentran activas)
                if (vCodigosTareas.size() == 0) {

                    //Lanzamos el signal al token maestro
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, idTokenMaster, BPMContants.TRANSICION_VUELTA_ATRAS);

                    //Lanzamos todos los signal al resto de tokens
                    for (Long idToken : vIdTokens) {
                        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, idToken, BPMContants.TRANSICION_VUELTA_ATRAS);
                    }
                } else {
                    throw new UserException("bpm.error.vueltaAtras");
                }
            }
        } else {
            //Lanzamos el signal al token maestro
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, idTokenMaster, BPMContants.TRANSICION_VUELTA_ATRAS);
        }
    }

    /**
     * metodo save or update de tarea externa.
     *
     * @param tarea
     *            tarea a grabar
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void saveOrUpdate(TareaExterna tarea) {
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea.getTareaPadre());
        tareaExternaDao.saveOrUpdate(tarea);
    }

    /**
     * Creación de una tarea externa.
     * @param codigoSubtipoTarea string
     * @param plazo long
     * @param descripcion string
     * @param idProcedimiento long
     * @param idTareaProcedimiento long
     * @param tokenIdBpm long
     * @return Long
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA)
    @Transactional(readOnly = false)
    public Long crearTareaExterna(String codigoSubtipoTarea, Long plazo, String descripcion, Long idProcedimiento, Long idTareaProcedimiento,
            Long tokenIdBpm) {
        DtoGenerarTarea dto = new DtoGenerarTarea(idProcedimiento, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, codigoSubtipoTarea, false, false,
                plazo, descripcion);
        long idTarea = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dto);

        //Cambiamos el nombre de la tarea
        TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTarea);
        tareaPadre.setTarea(descripcion);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaPadre);

        TareaExterna tarea = new TareaExterna();
        tarea.setTareaPadre(tareaPadre);
        tarea.setTareaProcedimiento((TareaProcedimiento) executor.execute(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET, idTareaProcedimiento));
        tarea.setTokenIdBpm(tokenIdBpm);
        tarea.setDetenida(false);

        Long idTareaExterna = tareaExternaDao.save(tarea);
        registraRecuperacionContrato(tarea);

        return idTareaExterna;
    }

    /**
     * Registra los pasos de recuperación de contratos en el momento de creación de la tarea.
     * @param tarea
     */
    @Transactional(readOnly = false)
    private void registraRecuperacionContrato(TareaExterna tarea) {

        //Recuperamos los contratos asociados a la tarea
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
     * Detiene una tarea por una paralización de BPM. La marca como borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_DETENER)
    @Transactional(readOnly = false)
    public void detener(TareaExterna tareaExterna) {
        if (!tareaExterna.getDetenida()) {
            tareaExterna.setDetenida(true);
            tareaExterna.getTareaPadre().setBorrado(true);
            saveOrUpdate(tareaExterna);
        }
    }

    /**
     * Activa una tarea detenida por una paralización de BPM. La desmarca de borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_ACTIVAR)
    @Transactional(readOnly = false)
    public void activar(TareaExterna tareaExterna) {
        if (tareaExterna.getDetenida()) {
            tareaExterna.setDetenida(false);
            tareaExterna.getTareaPadre().setBorrado(false);
            saveOrUpdate(tareaExterna);
        }
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param tareaExterna tareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_ACTIVAR_ALERTA)
    @Transactional(readOnly = false)
    public void activarAlerta(TareaExterna tareaExterna) {
        tareaExterna.getTareaPadre().setAlerta(true);
        saveOrUpdate(tareaExterna);
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param idToken Long
     * @return TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREA_POR_TOKEN)
    @Transactional(readOnly = false)
    public TareaExterna obtenerTareaPorToken(Long idToken) {
        return tareaExternaDao.obtenerTareaPorToken(idToken);
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param id Long
     * @return TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET_BY_ID_TAREA_NOTIF)
    public TareaExterna getByIdTareaNotificacion(Long id) {
        return tareaExternaDao.getByIdTareaNotificacion(id);
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param idProcedimiento Long
     * @return List TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTO)
    public List<TareaExterna> obtenerTareasPorProcedimiento(Long idProcedimiento) {
        return tareaExternaDao.obtenerTareasPorProcedimiento(idProcedimiento);
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param idProcedimiento Long
     * @return List TareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTO)
    public List<TareaExterna> obtenerTareasDeUsuarioPorProcedimiento(Long idProcedimiento) {
        Long idUsuarioLogado = null;
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        if (usuario != null) {
            idUsuarioLogado = usuario.getId();
        }

        Procedimiento procedimiento = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
        Long idGestor = procedimiento.getAsunto().getGestor().getUsuario().getId();
        Long idSupervisor = procedimiento.getAsunto().getSupervisor().getUsuario().getId();

        List<TareaExterna> list = null;

        if (idGestor.equals(idUsuarioLogado)) {
            list = tareaExternaDao.obtenerTareasGestorPorProcedimiento(idProcedimiento);
        } else if (idSupervisor.equals(idUsuarioLogado)) {
            list = tareaExternaDao.obtenerTareasSupervisorPorProcedimiento(idProcedimiento);
        } else {
            list = new ArrayList<TareaExterna>();
        }

        for (TareaExterna tex : list) {
            Boolean hasTransition = (Boolean) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_HAS_TRANSITION_TOKEN, tex.getTokenIdBpm(),
                    BPMContants.TRANSICION_VUELTA_ATRAS);

            if (tex.getTokenIdBpm() != null && hasTransition
                    && (tex.getTareaProcedimiento().getAlertVueltaAtras() != null && !"".equals(tex.getTareaProcedimiento().getAlertVueltaAtras()))) {
                tex.setVueltaAtras(true);
            } else {
                tex.setVueltaAtras(false);
            }
        }

        return list;
    }

    /**
     * Get tarea externa.
     * @param id long
     * @return tarea externa
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET)
    public TareaExterna get(Long id) {
        return tareaExternaDao.get(id);
    }

    /**
     * Lista de tareas externas valor de la tarea externa.
     * @param idTareaExterna long
     * @return Lista de tareas externa valor
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA)
    public List<TareaExternaValor> obtenerValoresTarea(Long idTareaExterna) {
        return tareaExternaValorDao.getByTareaExterna(idTareaExterna);
    }

    /**
     * Lista de tareas externas del procedimiento.
     * @param idProcedimiento long
     * @param idTareaProcedimiento Long
     * @return Lista de tareas externas
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET_TARS_EXTERNA_BY_TAREA_PROC)
    public List<TareaExterna> getByIdTareaProcedimientoIdProcedimiento(Long idProcedimiento, Long idTareaProcedimiento) {
        return tareaExternaDao.getByIdTareaProcedimientoIdProcedimiento(idProcedimiento, idTareaProcedimiento);
    }

    /**
     * Lista de tareas externas activas del procedimiento.
     * @param idProcedimiento long
     * @return Lista de tareas externas
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET_ACTIVAS_BY_PROC)
    public List<TareaExterna> getActivasByIdProcedimiento(Long idProcedimiento) {
        return tareaExternaDao.getActivasByIdProcedimiento(idProcedimiento);
    }

    /**
     * Borrar tarea externa.
     * @param tareaExterna tareaExterna
     */
    @BusinessOperation(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_BORRAR)
    @Transactional(readOnly = false)
    public void borrar(TareaExterna tareaExterna) {
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_DELETE, tareaExterna.getTareaPadre());
        tareaExternaDao.delete(tareaExterna);
        
// LLamada al executor.        
    }
    
    public Date dameFechaFinTareaProcedimientoPadre(Long idProcedimiento, String codigoTarea) {
		
		Procedimiento procedimiento = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
		if (procedimiento.getProcedimientoPadre()==null) {
			return null;
		}
		List<TareaExterna> tareas = this.obtenerTareasPorProcedimiento(procedimiento.getProcedimientoPadre().getId());
		if (tareas != null) {
			for (TareaExterna tarea : tareas) {
				if(tarea != null) {
					String codigo = tarea.getTareaProcedimiento().getCodigo();
					if(codigo.equals(codigoTarea)) {
						return tarea.getTareaPadre().getFechaFin();
					}
				}
			}
		}
		return null;
	}
	
}
