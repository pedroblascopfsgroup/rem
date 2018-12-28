package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.ComunicacionGencat;

public interface ComunicacionGencatApi {
	
	/**
	 * 
	 * Método que devuelve los registros relacionados con un idActivo
	 * 
	 * @param idActivo
	 * @return
	 */
	public ComunicacionGencat getByIdActivo(Long idActivo);
	
	/**
	 * Método que devuelve los registros relacionados con un idActivo y un nif
	 * 
	 * @param idActivo
	 * @param nif
	 * @return
	 */
	public List<ComunicacionGencat> getByIdActivoAndNif(Long idActivo, String nif);
	
	/**
	 * 
	 * Método que devuelve los registros relacionados con un número de activo
	 * 
	 * @param numActivoHaya
	 * @return
	 */
	public ComunicacionGencat getByNumActivoHaya(Long numActivoHaya);
	
	
	/**
	 * Método que devuelve los registros relacionados con un número de activo y un nif
	 * 
	 * @param numActivoHaya
	 * @param nif
	 * @return
	 */
	public List<ComunicacionGencat> getByNumActivoHayaAndNif(Long numActivoHaya, String nif);
	
	/**
	 * Método que devuelve los registros relacionados con un idActivo que está en estado creado
	 * 
	 * @param idActivo
	 * @return
	 */
	public ComunicacionGencat getByIdActivoEstadoCreado(Long idActivo);
	
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo ComunicacionGencat
	 * 
	 * @param comunicacionGencat
	 */
	public void saveOrUpdate(ComunicacionGencat comunicacionGencat);
	

	/**
	 * Actualiza las tareas del trámite de un expediente comercial
	 * @param idTrabajo
	 */
	public void actualizarTareas(Long idTrabajo);
	
	/**
	 * Método que devuelve la comunicacion en estado creada relacionada con un idActivo
	 * 
	 * @param idActivo
	 * @return ComunicacionGencat
	 */
	public ComunicacionGencat getByIdActivoCreado(Long idActivo);

}