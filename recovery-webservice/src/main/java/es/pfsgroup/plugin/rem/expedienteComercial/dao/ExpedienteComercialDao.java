package es.pfsgroup.plugin.rem.expedienteComercial.dao;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface ExpedienteComercialDao extends AbstractDao<ExpedienteComercial, Long> {

	/**
	 * Recupera una lista de compradores de un expediente comercial
	 * @param idExpediente
	 * @param webDto
	 * @return
	 */
	public Page getCompradoresByExpediente(Long idExpediente, WebDto webDto);
	
	/**
	 * Recupera una lista de observaciones de un expediente comercial
	 * @param idExpediente
	 * @param dto
	 * @return
	 */
	public Page getObservacionesByExpediente(Long idExpediente, WebDto dto);
	
	/**
	 * Recupera una lista de proveedores filtrado por tipoProveedor y nombre
	 * @param codigoTipoProveedor
	 * @param nombreBusqueda
	 * @param codigoProvinciaActivo 
	 * @param proveedoresIDporCartera 
	 * @return 
	 */
	public Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String codigoProvinciaActivo, List<Long> proveedoresIDporCartera, WebDto webDto);
	
	/**
	 * Eliminar la relación entre un comprador y un expediente
	 * @param idExpediente
	 * @param idComprador
	 * @return 
	 */
	public void deleteCompradorExpediente(Long idExpediente, Long idComprador);
	
	/**
	 * Devuelve el expedienteComercial asociado al trabajo
	 * @param idTrabajo
	 * @return
	 */
	public ExpedienteComercial getExpedienteComercialByTrabajo(Long idTrabajo);
	
	/**
	 * Devuelve los documentos de tipo y subtipo del expediente 
	 * @param idExp
	 * @param idTipo
	 * @param idSubtipo
	 * @return 
	 */
	
	public Long hayDocumentoSubtipo(Long idExp, Long idTipo, Long idSubtipo);
	
}
