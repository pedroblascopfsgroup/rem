package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;

@Component
public class MSVActualizadorOcultarActivosVenta extends AbstractMSVActualizador implements MSVLiberator {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_OCULTACION_VENTA;
	}

	private static final class COL_NUM {
		static final int NUM_ACTIVO_HAYA = 0;
		static final int MOTIVO_OCULTACION = 1;
		static final int DESCRIPCION_MOTIVO = 2;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA)));

		DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
		dto.setIdActivo(activo.getId());
		dto.setOcultarVenta(true);
		dto.setMotivoOcultacionVentaCodigo(exc.dameCelda(fila, COL_NUM.MOTIVO_OCULTACION));
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.DESCRIPCION_MOTIVO))){
			dto.setMotivoOcultacionManualVenta(exc.dameCelda(fila, COL_NUM.DESCRIPCION_MOTIVO));
		}
		
		if (activoApi.isActivoIntegradoAgrupacionRestringida(activo.getId())) {
			if (activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
				ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
				if (!Checks.esNulo(aga)) {
					activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(aga.getAgrupacion().getId(), dto);
				}
			}

		} else {
			activoEstadoPublicacionApi.setDatosPublicacionActivo(dto);
		}

		return new ResultadoProcesarFila();
	}

}
