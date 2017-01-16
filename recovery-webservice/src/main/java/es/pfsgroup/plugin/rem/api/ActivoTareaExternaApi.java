package es.pfsgroup.plugin.rem.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;

/**
 * Interfaz que gestiona las TareaExterna de un trámite.
 * 
 * @author mpardo
 *
 */
public interface ActivoTareaExternaApi {

	/**
	 * Recupera todas las tareas de un trámite
	 * @param idTramite
	 * @return
	 */
	List<TareaExterna> getTareasByIdTramite(Long idTramite);

	/**
	 * Recupera las tareas activas de un trámite para un usuario específico
	 * @param idTramite
	 * @param usuarioLogado
	 * @return
	 */
	List<TareaExterna> getActivasByIdTramite(Long idTramite, Usuario usuarioLogado);
	
	/**
	 * Recupera las tareas activas de un trámite
	 * @param idTramite
	 * @return usuarioLogado
	 */
	public List<TareaExterna> getActivasByIdTramiteTodas(Long idTramite);
	
	
	/**
	 * Obtiene los valores introducidos en el formulario de una tarea.
	 * @param id
	 * @return
	 */
	List<TareaExternaValor> obtenerValoresTarea(Long id);

	/**
	 * Recupera una tarea.
	 * @param idTareaExterna
	 * @return
	 */
	TareaExterna get(Long idTareaExterna);

	/**
	 * Recupera las tareas de un trámite de un tipo determinado.
	 * @param idTramite
	 * @param idTareaProcedimiento
	 * @return
	 */
	List<TareaExterna> getByIdTareaProcedimientoIdTramite(Long idTramite, Long idTareaProcedimiento);

	/**
	 * Borra una tarea. Borrado lógico.
	 * @param tareaExterna
	 */
	void borrar(TareaExterna tareaExterna);
	
	/**
	 * 
	 * @param tareaExterna
	 */
    @Transactional(readOnly = false)
    public void activarAlerta(TareaExterna tareaExterna) ;
    
    
    
    /**
     * Activa una tarea detenida por una paralización de BPM. La desmarca de borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @Transactional(readOnly = false)
    public void activar(TareaExterna tareaExterna);
    
    
    @Transactional(readOnly = false)
    public void saveOrUpdate(TareaExterna tareaExterna);
    
    /**
     * Obtener valores de las tareas por el código de la tarea y el activo
     * @param activo
     * @param codigoTarea
     * @return
     */
    public TareaExterna obtenerTareasAdmisionByCodigo(Activo activo, String codigoTarea);

    /**
     * Comprueba si existen tareas activas para el tipo de gestor y tramite indicados
     * @param activo
     * @param codGestor
     * @return
     */
    public Boolean existenTareasActivasByTramiteAndTipoGestor(Activo activo, String codTramite, String codGestor);
}