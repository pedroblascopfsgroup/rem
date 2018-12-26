package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;

@Component
public class MSVActualizadorAutorizarEdicion extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoApi activoApi;

	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		// TODO: Llamar al nuevo publicacion o bien, si no se sabe que hace este msv, eliminarlo.
		/*DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
		activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);*/
		return new ResultadoProcesarFila();
	}
	

}