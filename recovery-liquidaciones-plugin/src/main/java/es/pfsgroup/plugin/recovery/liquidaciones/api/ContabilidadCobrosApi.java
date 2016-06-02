package es.pfsgroup.plugin.recovery.liquidaciones.api;

import java.util.List;

import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.excepciones.STAContabilidadException;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;



/**
 * Interfaz que define los metodos del DAO de Contabilidad Cobros.
 * 
 * @author Kevin
 * 
 */
public interface ContabilidadCobrosApi {

	/**
	 * Guarda la Contabilidad Cobros.
	 * 
	 * @param dto
	 */
	void saveContabilidadCobro(DtoContabilidadCobros dto);
	
	
	/**
	 * Elimina un cobro por su ID.
	 * 
	 * @param dto
	 */
	void deleteContabilidadCobro(Long idContabilidadCobro);


	/**
	 * Obtiene una lista de Contabilidad Cobros por asunto ID.
	 * 
	 * @param dto
	 * @return
	 */
	List<ContabilidadCobros> getListadoContabilidadCobros(
			DtoContabilidadCobros dto);


	/**
	 * Obtiene un rgistro de Contabilidad Cobro por ID.
	 * 
	 * @param dto
	 * @return
	 */
	ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto);

	/**
	 * Genera una nueva Tarea Notificacion de Contabilidad Cobro.
	 * 
	 * @param dto
	 * @param id : ID del cobro.
	 * @throws STAContabilidadException 
	 */
	void crearTarea(DtoGenerarTarea dto, Long id) throws STAContabilidadException;
	
	/**
	 * Finaliza las tareas asociadas a los cobros y pone el estado de contabilizado
	 * del cobro a true.
	 * 
	 * @param dto
	 * @throws Exception 
	 */
	void contabilizarCobrosYFinalizarTareas(DtoContabilidadCobros dto) throws STAContabilidadException;

}