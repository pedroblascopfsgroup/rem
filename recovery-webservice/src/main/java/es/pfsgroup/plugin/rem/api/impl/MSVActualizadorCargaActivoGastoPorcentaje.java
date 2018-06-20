package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.gastoProveedor.GastoProveedorManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;


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

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_ACTIVOS_GASTOS_PORCENTAJE;
	}

	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		GastoProveedor gasto= gastoApi.getByNumGasto(Long.parseLong(exc.dameCelda(fila, 1)));
		GastoProveedorActivo relacion = gastoProveedorApi.buscarRelacionPorActivoYGasto(activo, gasto);
		Float porcentajeParticipacion = this.obtenerFloatExcel(exc.dameCelda(fila, 2));
		relacion.getGastoProveedor();
		
		if(!Checks.esNulo(activo) && !Checks.esNulo(gasto) && !Checks.esNulo(relacion) && !Checks.esNulo(porcentajeParticipacion)){
			if(exc.getNumeroFilas().equals(fila+1)){
				gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(), gasto.getId(), porcentajeParticipacion);
				List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
				gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(), gasto.getId(), gastoProveedorApi.regulaPorcentajeUltimoGasto(gastosActivosList, porcentajeParticipacion));
			}
			else{
				gastoProveedorApi.actualizarPorcentajeParticipacionGastoProveedorActivo(activo.getId(), gasto.getId(), porcentajeParticipacion);
			}
		}
		else{
			throw new JsonViewerException("Gasto, Activo o la relacion entre ambos no existe");
		}
		
	}
	
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}

}
