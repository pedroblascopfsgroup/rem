package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.albaran.dto.DtoAlbaranFiltro;
import es.pfsgroup.plugin.rem.model.DtoAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetalleAlbaran;
import es.pfsgroup.plugin.rem.model.DtoDetallePrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

public interface AlbaranApi {

	@BusinessOperationDefinition("albaranManager.findAll")
	public DtoPage findAll(DtoAlbaranFiltro dto);
	
	@BusinessOperationDefinition("albaranManager.findAllDetalle")
	public List<DtoDetalleAlbaran> findAllDetalle( Long numAlbaran);
	
	@BusinessOperationDefinition("albaranManager.findPrefectura")
	public List<DtoDetallePrefactura> findPrefectura(Long numPrefactura) ;
	
	public Boolean validarPrefactura(Long id, String listaString);
	
	public Boolean validarAlbaran(Long id);
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran();
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura();
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo();
	
//	public DtoDetallePrefactura getTotalAlbaran(Long numAlbaran);
//	
//	public DtoDetallePrefactura getTotalPrefactura(Long numPrefactura);
	
	
}
