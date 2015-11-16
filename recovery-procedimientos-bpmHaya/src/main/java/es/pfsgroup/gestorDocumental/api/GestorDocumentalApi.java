package es.pfsgroup.gestorDocumental.api;

import java.util.List;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public interface GestorDocumentalApi {

	public static final String BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.altaDocumento";
	public static final String BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.listadoDocumentos";
	public static final String BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.recuperacionDocumento";

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	String altaDocumento(Long id, String codEntidad, String tipoDocumento, WebFileItem uploadForm);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	List<AdjuntoGridDto> listadoDocumentos(Long id, String tipoDocumento, String codEntidad);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	AdjuntoGridDto recuperacionDocumento(Long id);

}
