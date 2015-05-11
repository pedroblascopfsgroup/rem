package es.pfsgroup.plugin.recovery.instruccionesExterna.api;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.instruccionesExterna.PluginInstruccionesExternaBusinessOperations;

public interface instruccionesExternaApi {

	@BusinessOperationDefinition(PluginInstruccionesExternaBusinessOperations.INS_MGR_LISTATAREAS)
	public List<TareaProcedimiento> listaTareasProcedimiento(Long idProcedimiento);

}
