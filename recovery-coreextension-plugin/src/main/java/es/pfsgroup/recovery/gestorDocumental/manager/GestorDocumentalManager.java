package es.pfsgroup.recovery.gestorDocumental.manager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.recovery.gestorDocumental.api.GestorDocumentalApi;

@Component
public class GestorDocumentalManager implements GestorDocumentalApi {

	private final Log logger = LogFactory.getLog(getClass());

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	@Transactional(readOnly = false)
	public void altaDocumento(String tipoEntidad) {

	}
	
	@BusinessOperation(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	@Transactional(readOnly = false)
	public void listadoDocumentos(Long id, String tipoEntidad) {

	}
	
	@BusinessOperation(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	@Transactional(readOnly = false)
	public void recuperacionDocumento(Long id) {

	}

}
