package es.pfsgroup.plugin.recovery.mejoras.cliente;

import java.util.List;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.persona.model.DDSituacConcursal;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJBuscarClientesDto;

public interface MEJClienteApi {
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsConsultaClienteRight();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_LEFT)
	List<DynamicElement> getButtonsConsultaClienteLeft();

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_CLIENTES_TABS_FAST)
	List<DynamicElement> getTabsFast();

	@BusinessOperationDefinition(PluginMejorasBOConstants.GET_LIST_TIPO_CONCURSO)
	List<DDSituacConcursal> getListTipoConcursoData();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_DELEGATOR)
	public Page findClientesPageDelegator(MEJBuscarClientesDto clientes);
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES)
	public Page findClientesPage(MEJBuscarClientesDto clientes);
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_CARTERIZADO)
	public Page findClientesPageCarterizado(MEJBuscarClientesDto clientes);
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_EXCEL_DELEGATOR)
	public List<Persona> findClientesExcelDelegator(MEJBuscarClientesDto clientes);
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.BO_PER_MGR_FIND_CLIENTES_EXCEL)
	public List<Persona> findClientesExcel(MEJBuscarClientesDto clientes);

	@BusinessOperationDefinition(PluginMejorasBOConstants.BO_PER_MGR_FIND_CLIENTES_EXCEL_CARTERIZADO)
	public List<Persona> findClientesExcelCarterizado(MEJBuscarClientesDto clientes);

}
