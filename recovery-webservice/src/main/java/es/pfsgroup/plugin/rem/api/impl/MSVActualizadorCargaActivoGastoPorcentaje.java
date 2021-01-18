package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Component
public class MSVActualizadorCargaActivoGastoPorcentaje extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GastoApi gastoApi;

	@Autowired
	private GastoProveedorApi gastoProveedorApi;

	protected static final Log logger = LogFactory.getLog(MSVActualizadorCargaActivoGastoPorcentaje.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_ACTIVOS_GASTOS_PORCENTAJE;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			GastoProveedor gasto = gastoApi.getByNumGasto(Long.parseLong(exc.dameCelda(fila, 1)));
			GastoLineaDetalleEntidad relacion = gastoProveedorApi.buscarRelacionPorActivoYGasto(activo, gasto);
			Float porcentajeParticipacion = this.obtenerFloatExcel(exc.dameCelda(fila, 2));
			relacion.getGastoLineaDetalle().getGastoProveedor();

			if (!Checks.esNulo(activo) && !Checks.esNulo(gasto) && !Checks.esNulo(relacion)
					&& !Checks.esNulo(porcentajeParticipacion)) {
				if (exc.getNumeroFilas().equals(fila + 1)) {
					gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(),
							gasto.getId(), porcentajeParticipacion);
					if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
						for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
							if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
								List<GastoLineaDetalleEntidad> gastosActivosList = gastoLinea.getGastoLineaEntidadList();
								gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(),
										gasto.getId(),
										gastoProveedorApi.regulaPorcentajeUltimoGasto(gastosActivosList, porcentajeParticipacion));
							}
						}
					}

				} else {
					gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(),
							gasto.getId(), porcentajeParticipacion);
				}
			} else {
				throw new JsonViewerException("Gasto, Activo o la relacion entre ambos no existe");
			}
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}

}
