package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;

public interface ExpedienteComercialDao extends AbstractDao<ExpedienteComercial, Long> {

	/**
	 * Recupera una lista de compradores de un expediente comercial.
	 *
	 * @param idExpediente: ID del expediente.
	 * @param webDto: dto con los datos a filtrar.
	 * @return Devuelve los compradores paginados.
	 */
	Page getCompradoresByExpediente(Long idExpediente, WebDto webDto, boolean activoBankia);

	/**
	 * Recupera una lista de observaciones de un expediente comercial.
	 *
	 * @param idExpediente: ID del expediente.
	 * @param dto: dto con los datos a filtrar.
	 * @return Devuelve las observaciones paginadas.
	 */
	Page getObservacionesByExpediente(Long idExpediente, WebDto dto);

	/**
	 * Recupera una lista de proveedores filtrado por tipoProveedor y nombre.
	 *
	 * @param codigoTipoProveedor: código del tipo de proveedor.
	 * @param nombreBusqueda: filtrado por nombre del proveedor.
	 * @param codigoProvinciaActivo : código de la provincia del activo.
	 * @param proveedoresIDporCartera: ?.
	 * @return Devuelve los resultados a mostrar en el combo filtrado.
	 */
	Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String codigoProvinciaActivo, List<Long> proveedoresIDporCartera, WebDto webDto);

	/**
	 * Eliminar la relación entre un comprador y un expediente.
	 *
	 * @param idExpediente: ID del expediente.
	 * @param idComprador: ID del comprador.
	 */
	void deleteCompradorExpediente(Long idExpediente, Long idComprador, String usuarioBorrar);

	/**
	 * Devuelve el expedienteComercial asociado al trabajo
	 *
	 * @param idTrabajo: ID del trabajo.
	 * @return Devuelve una entidad ExpedienteComercial.
	 */
	ExpedienteComercial getExpedienteComercialByIdTrabajo(Long idTrabajo);

	/**
	 * Este método obtiene un expediente por el número de expediente.
	 *
	 * @param numeroExpediente: número único del expediente a buscar.
	 * @return Devuelve una entidad ExpedienteComercial.
	 */
	ExpedienteComercial getExpedienteComercialByNumeroExpediente(Long numeroExpediente);

	/**
	 * Este método obtiene un expediente comercial por el ID de la oferta que lo ha creado.
	 *
	 * @param idOferta: ID de la oferta del expediente comercial.
	 * @return Devuelve una entidad ExpedienteComercial.
	 */
	ExpedienteComercial getExpedienteComercialByIdOferta(Long idOferta);
	
	/**
	 * Devuelve el expedienteComercial asociado al trabajo
	 * @param idTrabajo
	 * @return
	 */
	ExpedienteComercial getExpedienteComercialByTrabajo(Long idTrabajo);

	/**
	 * Devuelve los documentos de tipo y subtipo del expediente
	 * @param idExp
	 * @param idTipo
	 * @param idSubtipo
	 * @return
	 */
	Long hayDocumentoSubtipo(Long idExp, Long idTipo, Long idSubtipo);

	/**
	 * Este método obtiene un expediente comercial por el número de expediente comercial asociado.
	 *
	 * @param numeroExpediente: número del expediente comercial.
	 * @return Devuelve un objeto ExpedienteComercial si coincide con el número de expediente pasado por parámetro.
	 */
	ExpedienteComercial getExpedienteComercialByNumExpediente(Long numeroExpediente);
	
	List<VListadoOfertasAgrupadasLbk> getListActivosOfertaPrincipal(Long numOferta);

	Float getPorcentajeCompra(Long idExpediente);
	
	void flush();
	
}
