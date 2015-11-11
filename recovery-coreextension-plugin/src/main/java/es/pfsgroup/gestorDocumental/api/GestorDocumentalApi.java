package es.pfsgroup.gestorDocumental.api;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GestorDocumentalApi {

	public static final String BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.altaDocumento";
	public static final String BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.listadoDocumentos";
	public static final String BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO = "es.pfsgroup.recovery.gestorDocumental.recuperacionDocumento";

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	void altaDocumento(String codEntidad, String tipoDocumento, WebFileItem uploadForm);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	void listadoDocumentos(Long id, String tipoDocumento, String codEntidad);

	@BusinessOperationDefinition(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	void recuperacionDocumento(Long id);

}
