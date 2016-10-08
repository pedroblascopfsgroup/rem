package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;

public interface ClienteComercialApi {
	
	
	/**
     * Devuelve un ClienteComercial por id.
     * @param id del ClienteComercial a consultar
     * @return ClienteComercial
     */
    public ClienteComercial getClienteComercialById(Long id);
    
	/**
     * Devuelve un ClienteComercial por idClienteWebcom.
     * @param idClienteWebcom a consultar
     * @return ClienteComercial
     */
    public ClienteComercial getClienteComercialByIdClienteWebcom(Long idClienteWebcom) ;
    
    
	/**
     * Devuelve un ClienteComercial por idClienteRem
     * @param idClienteRem a consultar
     * @return ClienteComercial
     */
    public ClienteComercial getClienteComercialByIdClienteRem(Long idClienteRem);
    
    /**
     * Devuelve un ClienteComercial por idClienteWebcom y idClienteRem.
     * @param idClienteWebcom a consultar
     * @param idClienteRem a consultar
     * @return ClienteComercial
     */
    public ClienteComercial getClienteComercialByIdWebcomIdRem(Long idClienteWebcom, Long idClienteRem) throws Exception;
    
    
	/**
	 * Devuelve una lista de clienteComercial aplicando el filtro que recibe.
	 * @param clienteDto con los parametros de filtro
	 * @return List<ClienteComercial> 
	 */
	public List<ClienteComercial> getListaClienteComercial(ClienteDto clienteDto);
	
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param clienteDto con los parametros de entrada
	 * @param alta true si es para validar el alta, false para validar la actualización
	 * @return List<String> 
	 */
	public List<String> validateClientePostRequestData(ClienteDto clienteDto, Boolean alta);

	
	/**
	 * Crea un nuevo ClienteComercial a partir de la información pasada por parámetro.
	 * @param clienteDto con la información del clienteComercial a dar de alta
	 * @return List<String> con la lista de errores detectados
	 */
	public void saveClienteComercial(ClienteDto clienteDto);
	
	
	/**
	 * Actualiza un ClienteComercial a partir de la información pasada por parámetro.
	 * @param clienteDto con la información del clienteComercial a actualizar
	 * @param jsonFields estructura con los parámetros a actualizar. Si no vienen, no hay que actualizar. Si vienen y están a null, hay que seterlos a null
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> updateClienteComercial(ClienteComercial cliente, ClienteDto clienteDto, Object jsonFields);
	
	
	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones DELETE.
	 * @param clienteDto con los parametros de entrada
	 * @return List<String> 
	 */
	public List<String> validateClienteDeleteRequestData(ClienteDto clienteDto);
	
	/**
	 * Elimina un ClienteComercial a partir de los datos pasados por parámetro.
	 * @param clienteDto con la información del clienteComercial a borrar
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> deleteClienteComercial(ClienteDto clienteDto);
	
	
	

}
