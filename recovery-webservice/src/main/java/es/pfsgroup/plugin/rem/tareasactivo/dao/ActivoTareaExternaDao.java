package es.pfsgroup.plugin.rem.tareasactivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

/**
 * Interfaz para manejar el acceso a datos de los trámites de Activo.
 * @author Daniel Gutiérrez
 */


public interface ActivoTareaExternaDao extends AbstractDao<TareaExterna, Long>{

	/**
	 * Devuelve las tareas asociadas a un trámite para el usuario logado. Puede ser el destinatario de la tarea, 
	 * pertenecer al grupo destinatario de la tarea o ser el supervisor de la tarea.
	 * @param idTramite el id del trámite
	 * @return la lista de tareas de activo
	 */
	List<TareaExterna> getTareasTramite(Long idTramite, Usuario usuarioLogado, List<EXTGrupoUsuarios> grupos);
	
	/**
	 * Devuelve las tareas asociadas a un trámite y que se encuentren activas
	 * @param idTramite el id del trámite
	 * @return la lista de tareas del trámite
	 */
	List<TareaExterna> getTareasTramiteTodas(Long idTramite);
	
	List<TareaExterna> getTareasTramiteHistorico(Long idTramite);

	List<TareaExterna> getTareasTramiteTipo(Long idTramite, Long idTareaProcedimiento);
	
	List<TareaExterna> getTareasTramiteCodigoTipo(Long idTramite, String codigoTareaProcedimiento);
	//void borrar(TareaExterna tareaExterna);
	
    List<TareaExternaValor> getByTareaExterna(Long idTareaExterna);

	List<Long> getTareasExternasIdByOfertaId(Long idOferta);
}
