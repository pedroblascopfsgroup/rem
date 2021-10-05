package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;
import net.sf.json.JSONObject;

public interface ClienteComercialApi {

	/**
	 * Devuelve un ClienteComercial por id.
	 * 
	 * @param id
	 *            del ClienteComercial a consultar
	 * @return ClienteComercial
	 */
	public ClienteComercial getClienteComercialById(Long id);

	/**
	 * Devuelve un ClienteComercial por idClienteWebcom o idClienteRem almacenados en el dto.
	 * 
	 * @param clienteDto
	 * @return ClienteComercial
	 */
	public ClienteComercial getClienteComercialByIdClienteWebcomOrIdClienteRem(ClienteDto clienteDto);

	/**
	 * Devuelve un ClienteComercial por idClienteRem
	 * 
	 * @param idClienteRem
	 *            a consultar
	 * @return ClienteComercial
	 */
	public ClienteComercial getClienteComercialByIdClienteRem(Long idClienteRem);

	/**
	 * Devuelve un ClienteComercial por idClienteWebcom y idClienteRem.
	 * 
	 * @param idClienteWebcom
	 *            a consultar
	 * @param idClienteRem
	 *            a consultar
	 * @return ClienteComercial
	 */
	public ClienteComercial getClienteComercialByIdWebcomIdRem(Long idClienteWebcom, Long idClienteRem)
			throws Exception;

	/**
	 * Devuelve una lista de clienteComercial aplicando el filtro que recibe.
	 * 
	 * @param clienteDto
	 *            con los parametros de filtro
	 * @return List<ClienteComercial>
	 */
	public List<ClienteComercial> getListaClienteComercial(ClienteDto clienteDto);


	/**
	 * Crea un nuevo ClienteComercial a partir de la información pasada por
	 * parámetro.
	 * 
	 * @param clienteDto
	 *            con la información del clienteComercial a dar de alta
	 * @return ClienteComercial
	 */
	public ClienteComercial saveClienteComercial(ClienteDto clienteDto) throws Exception;

	/**
	 * Actualiza un ClienteComercial a partir de la información pasada por
	 * parámetro.
	 * 
	 * @param clienteDto
	 *            con la información del clienteComercial a actualizar
	 * @param jsonFields
	 *            estructura con los parámetros a actualizar. Si no vienen, no
	 *            hay que actualizar. Si vienen y están a null, hay que seterlos
	 *            a null
	 * @return void
	 */
	public void updateClienteComercial(ClienteComercial cliente, ClienteDto clienteDto, Object jsonFields)  throws Exception;

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones DELETE.
	 * 
	 * @param clienteDto
	 *            con los parametros de entrada
	 * @return List<String>
	 */
	public List<String> validateClienteDeleteRequestData(ClienteDto clienteDto);

	/**
	 * Elimina un ClienteComercial a partir de los datos pasados por parámetro.
	 * 
	 * @param clienteDto
	 *            con la información del clienteComercial a borrar
	 * @return List<String> con la lista de errores detectados
	 */
	public List<String> deleteClienteComercial(ClienteDto clienteDto);
	
	
	/**
	 * Elimina una lista de ClienteComercial a partir de los datos pasados por parámetro.
	 * 
	 * @param listaClienteDto
	 * @return
	 */
	public ArrayList<Map<String, Object>> deleteClienteComercial(List<ClienteDto> listaClienteDto);

	/**
	 * Persiste una lista de clientes comerciales
	 * 
	 * @param listaClienteDto
	 * @return
	 */
	public ArrayList<Map<String, Object>> saveOrUpdate(List<ClienteDto> listaClienteDto, JSONObject jsonFields) throws Exception;

	public ClienteComercial getClienteComercialByDocumento(String documento);

}
