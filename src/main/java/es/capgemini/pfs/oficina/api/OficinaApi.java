package es.capgemini.pfs.oficina.api;

import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.oficina.model.Oficina;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface OficinaApi {

	@BusinessOperationDefinition(ComunBusinessOperation.BO_OFICINA_MGR_GET)
	Oficina get(Long id);

	@BusinessOperationDefinition(ComunBusinessOperation.BO_OFICINA_MGR_BUSCAR_POR_CODIGO)
	Oficina buscarPorCodigo(Integer codigo);

	
	@BusinessOperationDefinition(ComunBusinessOperation.BO_OFICINA_MGR_BUSCAR_POR_CODIGO_OFICINA)
	Oficina buscarPorCodigoOficina(Integer codigo);
}
