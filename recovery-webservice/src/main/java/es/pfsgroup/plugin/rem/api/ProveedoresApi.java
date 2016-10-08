package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDireccionDelegacion;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoPersonaContacto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;

public interface ProveedoresApi {
	
	/**
	 * Devuelve una lista de proveedores aplicando el filtro que recibe.
	 * 
	 * @param dtoProveedorFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un objeto Page de Proveedor.
	 */
	public List<DtoProveedorFilter> getProveedores(DtoProveedorFilter dtoProveedorFiltro);

	/**
	 * Este método devuelve un proveedor por el ID de proveedor.
	 * 
	 * @param dtoProveedorFiltro: dto con los filtros de busqueda a aplicar.
	 * @return Devuelve un dto con los datos de proveedor.
	 */
	public DtoActivoProveedor getProveedorById(Long id);

	/**
	 * Este método almacena en la DDBB los datos del proveedor que recibe por el ID
	 * del proveedor.
	 * 
	 * @param dto: dto con los datos del proveedor a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean saveProveedorById(DtoActivoProveedor dto);

	/**
	 * Este método obtiene las personas de contacto según el ID de proveedor y/o el ID
	 *  de la delegacion seleccionada.
	 * 
	 * @param dtoPersonaContacto : dto con los filtros.
	 * @return Devuelve una lista de DtoPersonaContacto con los resultados obtenidos.
	 */
	public List<DtoPersonaContacto> getPersonasContactoByProveedor(DtoPersonaContacto dtoPersonaContacto);

	/**
	 * Este método obtiene las delegaciones según el ID de proveedor.
	 * 
	 * @param dtoDireccionDelegacion : dto con los filtros.
	 * @return Devuelve una lista de DtoDireccionDelegacion con los resultados obtenidos.
	 */
	public List<DtoDireccionDelegacion> getDireccionesDelegacionesByProveedor(DtoDireccionDelegacion dtoDireccionDelegacion);

	/**
	 * Este método obtiene los activos integrados según el ID de proveedor.
	 * 
	 * @param dtoActivoIntegrado : dto con los filtros.
	 * @return Devuelve una lista de DtoActivoIntegrado con los resultados obtenidos.
	 */
	public List<DtoActivoIntegrado> getActivoIntegradoByProveedor(DtoActivoIntegrado dtoActivoIntegrado);

	/**
	 * Este método almacena en la DDBB los datos de la nueva delegación.
	 * 
	 * @param dtoDireccionDelegacion : dto con los datos a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean createDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion);
	
	/**
	 * Este método almacena en la DDBB los datos modificados de la delegación.
	 * 
	 * @param dtoDireccionDelegacion : dto con los datos a modificar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean updateDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion);

	/**
	 * Este método borra de manera lógica un registro de dirección delegación de la DDBB
	 * por su ID.
	 * 
	 * @param dtoDireccionDelegacion : dto con el ID a borrar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean deleteDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion);

	/**
	 * Este método almacena en la DDBB los datos de la nueva persona contacto.
	 * 
	 * @param dtoPersonaContacto : dto con los datos a almacenar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean createPersonasContacto(DtoPersonaContacto dtoPersonaContacto);
	
	/**
	 * Este método almacena en la DDBB los datos a cambiar de la persona contacto.
	 * 
	 * @param dtoPersonaContacto : dto con los datos a actualizar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean updatePersonasContacto(DtoPersonaContacto dtoPersonaContacto);

	/**
	 * Este método borra de manera lógica un registro de dpersona contacto de la DDBB
	 * por su ID.
	 * 
	 * @param dtoPersonaContacto : dto con el ID a borrar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean deletePersonasContacto(DtoPersonaContacto dtoPersonaContacto);

	/**
	 * Este método establece la persona contacto del ID que recibe como principal y quita el estado a cualquier
	 * otra persona que lo tuviese para el ID proveedor dado.
	 * 
	 * @param dtoPersonaContacto : dto con el ID de la persona contacto y el ID del proveedor al que pertenece.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean setPersonaContactoPrincipal(DtoPersonaContacto dtoPersonaContacto);

	/**
	 * Este método elimina un adjunto de la lista de documentos asociados a proveedores.
	 * 
	 * @param dtoAdjunto : dto con el ID a borrar.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 */
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * Este método obtiene una lista de documentos asociados al ID del proveedor.
	 * 
	 * @param id : ID del proveedor.
	 * @return Devuelve una lista de docuemtnos con los resultados obtenidos.
	 */
	public Object getAdjuntos(Long id);

	/**
	 * Este método sube un archivo al servidor.
	 * 
	 * @param fileItem: archivo a subir.
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 * @throws Exception : Si no se ha podido subir el archivo lanza una excepción.
	 */
	public String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Este método obtiene el fichero del adjunto del proveedor.
	 * 
	 * @param dtoAdjunto : dto con los filtros para obtener el fichero.
	 * @return Devuelve un el fichero solicitado.
	 */
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * Este método crea un nuevo proveedor.
	 * 
	 * @param dtoProveedorFilter : dto con los datos del proveedor (NIF).
	 * @return Devuelve si la operación ha sido satisfactoria, o no.
	 * @throws Exception 
	 */
	public boolean createProveedor(DtoProveedorFilter dtoProveedorFilter) throws Exception;

	/**
	 * Este método obtiene una lista de proveedores de tipo mediador filtrados por la cartera y
	 * la localidad del ID del activo.
	 * 
	 * @param dto : dto con los datos a filtrar.
	 * @return Devulve una lista de proveedores de tipo mediador mapeada en el DTO.
	 */
	public List<DtoMediador> getMediadorListFiltered(DtoMediador dto);

}
