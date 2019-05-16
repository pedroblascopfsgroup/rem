package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;

@Component
public class MSVActualizadorAutorizarEdicion extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	ActivoApi activoApi;

	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	protected static final Log logger = LogFactory.getLog(MSVActualizadorAutorizarEdicion.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			// TODO: Llamar al nuevo publicacion o bien, si no se sabe que hace
			// este msv, eliminarlo.
			/*
			 * DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion =
			 * activoEstadoPublicacionApi.getState(activo.getId());
			 * activoEstadoPublicacionApi.publicacionChangeState(
			 * dtoCambioEstadoPublicacion);
			 */
		} catch (Exception e) {
			resultado.setCorrecto(false);
			resultado.setErrorDesc(e.getMessage());
			logger.error("Error proceso masivo", e);
		}
		return resultado;
	}

}