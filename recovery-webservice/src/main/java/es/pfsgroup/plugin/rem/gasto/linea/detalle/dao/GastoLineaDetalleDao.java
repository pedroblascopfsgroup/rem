package es.pfsgroup.plugin.rem.gasto.linea.detalle.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;	

public interface GastoLineaDetalleDao extends AbstractDao<GastoLineaDetalle, Long> {

	public List<GastoLineaDetalle> getGastoLineaDetalleBySubtipoGastoAndImpuesto(List<Long> listaIds, String tipoGastoImporte);

	List<Object[]> getListaEntidadesByGastoProveedor(GastoProveedor gpv);

	List<Object[]> getListaEntidadesByGastoProveedorAndEntidad(GastoProveedor gpv, List<Long> listaActivos);
	
	public Double getParticipacionTotalLinea(Long idLinea);
	
	public void updateParticipacionEntidadesLineaDetalle(Long idLinea, Double participacion, String userName);
	
	public Long getNextIdGastoLineaDetalle();

	void saveGastoLineaDetalle(GastoLineaDetalle gasto);

	void actualizarDiariosLbk(Long idGasto, String userName);

	boolean tieneListaEntidadesByGastoProveedorAndTipoEntidad(GastoProveedor gpv, String codigoEntidadGasto);

	
}
