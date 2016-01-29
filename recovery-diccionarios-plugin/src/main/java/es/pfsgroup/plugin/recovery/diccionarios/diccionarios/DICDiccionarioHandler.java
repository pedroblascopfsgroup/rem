package es.pfsgroup.plugin.recovery.diccionarios.diccionarios;

import java.util.List;

import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoValorDiccionario;

/**
 * Manejador de Diccionarios.
 * 
 * Estas clases son las encargadas de proporcionarle al manager de diccionarios la funcionalidad de edición.
 * @author sergio
 *
 */
public interface DICDiccionarioHandler {

	/**
	 * Este método nos dice si la clase maneja un tipo de diccionario concreto.
	 * @param tableName Nombre de la tabla en la que se persiste el diccionario.
	 * @return
	 */
	public boolean manejasDiccionario(String tableName);

	/**
	 * Nos devuelve los valores para el diccionario que maneja la clase.
	 * @return
	 */
	public List<DICDtoValorDiccionario> getValoresDiccionario(Long idDiccionario);

	/**
	 * Nos devuelve los valores para una entrada concreta en el diccionario
	 * @return
	 */
	public DICDtoValorDiccionario getValoresEntradaDiccionario(Long idLineaEnDiccionario, Long idDiccionario);
	
	/**
	 * Crea una nueva entrada en el diccionario indicado segun el dto.
	 * @return
	 */
	public void guardarNuevaEntradaDiccionario(DICDtoValorDiccionario dto);
	
	/**
	 * Sobreescrive los datos del diccionario con los datos recividos del dto
	 * @return
	 */
	public void editarDiccionarioDatosLinea(DICDtoValorDiccionario dto);
	
	/**
	 * Registra un suceso en la tabla de log de diccionarios editables 
	 * @return
	 */
	public void createSucesoDiccionarioLog(DICDtoValorDiccionario dto);
	
}
