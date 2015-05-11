package es.pfsgroup.recovery.ext.api.adjunto;

import java.util.List;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public interface AdjuntoAsuntoApi {

	public static final String BO_GET_LISTA_DD_TIPO_FICHERO_ADJUNTOS ="recovery.plugin.coreextension.adjuntos.tipoFichero.getList";
	
	@BusinessOperationDefinition(BO_GET_LISTA_DD_TIPO_FICHERO_ADJUNTOS)
	public List<DDTipoFicheroAdjunto> getList(List<DDTipoActuacion> listaActuaciones);
}
