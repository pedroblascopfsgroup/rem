package es.pfsgroup.concursal.credito.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.concursal.credito.dto.DtoCreditosContratoEdicion;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;

public interface CreditoApi {

	public static final String GET_CREDITOS_CONCURSO_ASUNTO = "plugin.procedimientos.credito.api.getCreditosAsunto";
	public static final String MODIFICAR_ESTADO_CREDITOS_CONCURSO_ASUNTO = "plugin.procedimientos.credito.api.guardarCambioEstadoCreditos";
	
	/**
	 * 
	 * @param idAsunto Identificador del asunto
	 * 
	 * Devuelve una lista de dtos con la información de todos los creditos de todos los contratos de un asunto
	 * 
	 * */
	@BusinessOperationDefinition(GET_CREDITOS_CONCURSO_ASUNTO)
	public 	List<DtoCreditosContratoEdicion> getCreditosAsunto(Long idAsunto);
	
	
	/***
	 *
	 * Modifica el estado de los creditos
	 * @param idAsunto Identificador del asunto
	 * @param estadoCredito {@link DDEstadoCredito} que se va a updatear
	 * @param creditos lista de ids de créditos separados por comas 
	 * 
	 * 
	 * */
	@BusinessOperationDefinition(MODIFICAR_ESTADO_CREDITOS_CONCURSO_ASUNTO)
	public void guardarCambioEstadoCreditos(Long idAsunto, String  estadoCredito, String creditos);
}
