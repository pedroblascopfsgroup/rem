package es.pfsgroup.recovery.recobroCommon.adecuaciones.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.model.Adecuaciones;

/**
 * Interfaz de métodos para las operaciones de negocio de las acciones
 * judiciales de recobro
 * 
 * @author Guillem
 * 
 */
public interface AdecuacionesApi {

	public final String BO_EXP_GET_LISTADO_ADECUACIONES_PAGE = "adecuacionesApi.getListadoAdecuacionesPage";
	public final String BO_EXP_GET_LISTADO_ADECUACIONES = "adecuacionesApi.getListadoAdecuaciones";
	public final String BO_EXP_GET_ADECUACION_BY_ID = "adecuacionesApi.getAdecuacionById";


	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_LISTADO_ADECUACIONES)
	public List<Adecuaciones> getListadoAdecuaciones(Long cntId);
	
	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_LISTADO_ADECUACIONES_PAGE)
	public Page getListadoAdecuaciones(AdecuacionesDto dto);

	@BusinessOperationDefinition(AdecuacionesApi.BO_EXP_GET_ADECUACION_BY_ID)
	public Adecuaciones getAdecuacionById(Long id);

}
