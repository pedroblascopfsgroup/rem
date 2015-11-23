package es.pfsgroup.gestorDocumental.api;

import java.util.List;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public interface GestorDocumentalApi {

	public static final String BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.altaDocumento";
	public static final String BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.listadoDocumentos";
	public static final String BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.recuperacionDocumento";

	/**
	 * idEntidad id del asunto/procedimiento/contrato/expediente/persona en el que nos encontramos
	 * tipoEntidadGrid entidad del grid (asunto/procedimiento/contrato/expediente/persona)
	 * tipoDocumento tipoDocumento seleccionado
	 */
	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	String altaDocumento(Long idEntidad, String tipoEntidadGrid, String tipoDocumento, WebFileItem uploadForm);

	/**
	 * idEntidad id del asunto/procedimiento/contrato/expediente/persona en el que nos encontramos
	 * tipoEntidadGrid entidad del grid (asunto/procedimiento/contrato/expediente/persona)
	 * tipoDocumento tipoDocumento seleccionado
	 */
	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	List<AdjuntoGridDto> listadoDocumentos(String claveAsociacion, String tipoEntidadGrid, String tipoDocumento);

	/**
	 * idRefCentera id del documento que queremos descargar
	 */
	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	String recuperacionDocumento(String idRefCentera);

}
