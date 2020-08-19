package es.pfsgroup.plugin.rem.api;

import java.util.HashSet;
import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

public interface GastoLineaDetalleApi {

	List<DtoLineaDetalleGasto> getGastoLineaDetalle(Long idGasto) throws Exception;

	boolean saveGastoLineaDetalle(DtoLineaDetalleGasto dto) throws Exception;

	boolean deleteGastoLineaDetalle(Long idLineaDetalleGasto) throws Exception;

	Double calcularPrincipioSujetoLineasDetalle(GastoProveedor gasto);
	
	List<Activo> devolverActivosDeLineasDeGasto(GastoProveedor gasto);

	DtoLineaDetalleGasto calcularCuentasYPartidas(Long idGasto, Long idLineaDetalleGasto, String subtipoGastoCodigo);

	HashSet<String> devolverNumeroLineas(List<GastoLineaDetalle> gastoLineaDetalleList, HashSet<String> tipoGastoImporteList);

	void createLineasDetalleGastosRefacturados(List<String> tipoGastoImpuestoList, List<String> listaNumerosGasto,
			GastoProveedor gastoProveedor);

	boolean tieneLineaDetalle(GastoProveedor gasto);

	String devolverSubGastoImpuestImpositivo(GastoLineaDetalle gastoLineaDetalle);

	GastoLineaDetalle devolverLineaBk(GastoProveedor gasto);
	
}

