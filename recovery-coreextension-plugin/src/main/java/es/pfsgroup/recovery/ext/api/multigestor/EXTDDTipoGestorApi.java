package es.pfsgroup.recovery.ext.api.multigestor;

import java.util.List;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTDDTipoGestorApi {
	
	String EXT_BO_TIPOGESTOR_GETLIST = "es.pfsgroup.recovery.ext.api.multigestor.getList";
	String EXT_BIO_TIPOGESTOR_GETBYCOD = "es.pfsgroup.recovery.ext.api.multigestor.getByCod";
	
	@BusinessOperationDefinition(EXT_BO_TIPOGESTOR_GETLIST)
	List<EXTDDTipoGestor> getList();

	@BusinessOperationDefinition(EXT_BIO_TIPOGESTOR_GETBYCOD)
	EXTDDTipoGestor getByCod(String codigo); 

}
