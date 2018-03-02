package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;

@Component
public class MSVActualizadorDesDespublicarForzado extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ActivoApi activoApi;

	@Autowired
	UsuarioApi usuarioApi;
	
	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_DESPUBLICAR_FORZADO;
	}

	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		String motivo = exc.dameCelda(fila, 1);
		if(Checks.esNulo(motivo)) {
			motivo = "";
		}
		DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
		
		dtoCambioEstadoPublicacion.setActivo(activo.getId());
		dtoCambioEstadoPublicacion.setDespublicacionForzada(false);
		dtoCambioEstadoPublicacion.setMotivoDespublicacionForzada(motivo);
		
		activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);
	}

}
