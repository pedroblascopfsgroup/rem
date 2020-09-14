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
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoProveedorMediador;
import es.pfsgroup.plugin.rem.model.VbusquedaProveedoresCombo;
import es.pfsgroup.plugin.rem.model.VbusquedaTrabajosPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAlbaran;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

public interface AlbaranApi {

	@BusinessOperationDefinition("albaranManager.findAll")
	public Page findAll(DtoAlbaranFiltro dto);
	
	@BusinessOperationDefinition("albaranManager.findAllDetalle")
	public Page findAllDetalle( DtoDetalleAlbaran numAlbaran);
	
	@BusinessOperationDefinition("albaranManager.findPrefectura")
	public Page findPrefectura(DtoDetallePrefactura dto) ;
	
	public Boolean validarPrefactura(Long id, String listaString);
	
	public Boolean validarAlbaran(Long id);
	
	public List<DDEstadoAlbaran> getComboEstadoAlbaran();
	
	public List<DDEstEstadoPrefactura> getComboEstadoPrefactura();
	
	public List<DDEstadoTrabajo> getComboEstadoTrabajo();

	public List<VbusquedaProveedoresCombo> getProveedores();

	public Page obtenerDatosExportarTrabajosPrefactura(DtoAlbaranFiltro dto);	
}
