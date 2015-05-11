package es.capgemini.pfs.exceptuar.api;

import java.util.List;

import es.capgemini.pfs.exceptuar.dto.DtoExceptuacion;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;
import es.capgemini.pfs.exceptuar.model.ExceptuacionMotivo;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * Mánager de la entidad.
 * 
 * @author Oscar
 * 
 */
public interface ExceptuacionApi {

	public static final String BO_EXISTE_EXCEPTUACION_BY_DTO = "es.pfsgroup.recovery.expediente.api.existeExceptuacionByDto";
	public static final String BO_EXISTE_EXCEPTUACION_BY_PERID_TIPO = "es.pfsgroup.recovery.expediente.api.existeExceptuacionByPerIdTipo";
	public static final String BO_GET_EXCEPTUACION_BY_ID = "es.pfsgroup.recovery.expediente.api.getExceptuacionById";
	public static final String BO_GET_EXCEPTUACION_BY_ID_TIPO = "es.pfsgroup.recovery.expediente.api.getExceptuacionByIdTipo";
	public static final String BO_GUARDAR_EXCEPTUACION = "es.pfsgroup.recovery.expediente.api.guardarExceptuacion";
	public static final String BO_BORRAR_EXCEPTUACION = "es.pfsgroup.recovery.expediente.api.borrarExceptuacion";
	public static final String BO_GET_LISTADO_MOTIVOS_EXCEPTUACION = "es.pfsgroup.recovery.expediente.api.getListadoMotivosExceptuacion";

	@BusinessOperationDefinition(BO_EXISTE_EXCEPTUACION_BY_DTO)
	Boolean existeExceptuacion(DtoExceptuacion dto);

	@BusinessOperationDefinition(BO_EXISTE_EXCEPTUACION_BY_PERID_TIPO)
	Boolean existeExceptuacion(Long id, String tipo);

	@BusinessOperationDefinition(BO_GET_EXCEPTUACION_BY_ID)
	Exceptuacion getExceptuacion(Long id);

	@BusinessOperationDefinition(BO_GUARDAR_EXCEPTUACION)
	void guardarExceptuacion(DtoExceptuacion dto);

	@BusinessOperationDefinition(BO_BORRAR_EXCEPTUACION)
	void borrarExceptuacion(Long id);

	@BusinessOperationDefinition(BO_GET_LISTADO_MOTIVOS_EXCEPTUACION)
	List<ExceptuacionMotivo> getListadoMotivosExceptuacion();
	
	@BusinessOperationDefinition(BO_GET_EXCEPTUACION_BY_ID_TIPO)
	Exceptuacion getExceptuacionByIdTipo(Long id, String tipo);
	

}