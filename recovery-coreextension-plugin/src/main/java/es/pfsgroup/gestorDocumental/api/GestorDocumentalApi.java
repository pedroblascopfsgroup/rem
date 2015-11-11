package es.pfsgroup.gestorDocumental.api;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalOutputDto;

public interface GestorDocumentalApi {

	public static final String BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.altaDocumento";
	public static final String BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.listadoDocumentos";
	public static final String BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.recuperacionDocumento";

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	GestorDocumentalOutputDto altaDocumento(GestorDocumentalInputDto inputDto, String codEntidad, WebFileItem uploadForm);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	GestorDocumentalOutputDto listadoDocumentos(Long id, String codEntidad);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	GestorDocumentalOutputDto recuperacionDocumento(Long id);

}
