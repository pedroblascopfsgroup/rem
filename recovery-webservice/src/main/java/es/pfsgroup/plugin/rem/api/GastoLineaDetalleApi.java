package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.HashSet;
import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoComboLineasDetalle;
import es.pfsgroup.plugin.rem.model.DtoElementosAfectadosLinea;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VElementosLineaDetalle;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

public interface GastoLineaDetalleApi {

	GastoLineaDetalle getLineaDetalleByIdLinea(Long idLinea);
	
	GastoLineaDetalleEntidad getLineaDetalleEntidadByIdLineaEntidad(Long idEntidad);
	
	List<DtoLineaDetalleGasto> getGastoLineaDetalle(Long idGasto) throws Exception;

	boolean saveGastoLineaDetalle(DtoLineaDetalleGasto dto) throws Exception;

	boolean deleteGastoLineaDetalle(Long idLineaDetalleGasto) throws Exception;

	Double calcularPrincipioSujetoLineasDetalle(GastoProveedor gasto);

	DtoLineaDetalleGasto calcularCuentasYPartidas(GastoProveedor gasto, Long idLineaDetalleGasto, String subtipoGastoCodigo, Trabajo trabajo);

	HashSet<String> devolverNumeroLineas(List<GastoLineaDetalle> gastoLineaDetalleList, HashSet<String> tipoGastoImporteList);

	void createLineasDetalleGastosRefacturados(List<String> tipoGastoImpuestoList, List<String> listaNumerosGasto,
			GastoProveedor gastoProveedor);

	boolean tieneLineaDetalle(GastoProveedor gasto);

	String devolverSubGastoImpuestImpositivo(GastoLineaDetalle gastoLineaDetalle);

	GastoLineaDetalle devolverLineaBk(GastoProveedor gasto);

	void recalcularPorcentajeParticipacion(GastoProveedor gasto);

	void eliminarLineasRefacturadas(Long gastoPadre);

	List<DtoComboLineasDetalle> getLineasDetalleGastoCombo(Long idGasto);

	String asociarElementosAgastos(DtoElementosAfectadosLinea dto);

	boolean desasociarElementosAgastos(Long idElemento);

	boolean updateElementosDetalle(DtoElementosAfectadosLinea dto);

	List<VElementosLineaDetalle> getElementosAfectados(Long idLinea);

	boolean updateLineaSinActivos(Long idLinea);

	DDCartera getCarteraLinea(GastoLineaDetalle gastoLineaDetalle);

	boolean actualizarReparto(Long idLinea);

	boolean actualizarRepartoTrabajo(Long idLinea);

	boolean asignarTrabajosLineas(Long idGasto, Long[] trabajos);

	boolean eliminarTrabajoLinea(Long idTrabajo, Long idGasto) throws Exception;

	void actualizarParticipacionTrabajosAfterInsert(Long idGasto);

	void actualizarDiariosLbk(Long idGasto);

	List<Activo> devolverActivosDeLineasDeGasto(Long idLineaDetalleGasto);

	DDSubcartera getSubcarteraLinea(List<Activo> activos);

	GastoLineaDetalle setCuentasPartidasDtoToObject(GastoLineaDetalle gastoLineaDetalle, DtoLineaDetalleGasto dto);

	boolean updateCuentasPartidas(DtoLineaDetalleGasto dto);
	
	List<VElementosLineaDetalle> getTodosElementosAfectados (Long idLinea);

	List<Activo> devolverActivoDePromocionesDeLineasDeGasto(Long idLineaDetalleGasto);

    boolean asignarTasacionesGastos(Long idGasto, Long[] tasaciones);
}

