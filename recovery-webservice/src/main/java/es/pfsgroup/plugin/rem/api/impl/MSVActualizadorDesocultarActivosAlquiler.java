package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;

@Component
public class MSVActualizadorDesocultarActivosAlquiler extends AbstractMSVActualizador implements MSVLiberator{
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DESOCULTACION_ALQUILER;
	}
	
	private static final class COL_NUM {
		static final int ID_ACTIVO_HAYA = 0;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_NUM.ID_ACTIVO_HAYA)));
		
		DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
		dto.setIdActivo(activo.getId());
		dto.setOcultarAlquiler(false);
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