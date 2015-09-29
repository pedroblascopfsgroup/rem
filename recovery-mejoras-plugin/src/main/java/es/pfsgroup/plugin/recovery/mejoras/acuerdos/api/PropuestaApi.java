package es.pfsgroup.plugin.recovery.mejoras.acuerdos.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface PropuestaApi {

	public static final String BO_PROPUESTA_GET_LISTADO_PROPUESTAS = "mejacuerdo.listadoPropuestasByExpedienteId";
	
	@BusinessOperationDefinition(BO_PROPUESTA_GET_LISTADO_PROPUESTAS)
    @Transactional(readOnly = false)
    public List<EXTAcuerdo> listadoPropuestasByExpedienteId(Long idExpediente);
}
