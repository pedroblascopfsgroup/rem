package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.rest.dto.HistoricoPropuestasPreciosDto;

@Component
public class MSVActualizadorGestionPeticionesDePrecios extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ActivoApi activoApi;

	@Override
	public String getValidOperation() {
		return "";//MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_PETICIONES_PRECIOS;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		String codPeticion = exc.dameCelda(fila, 1);
		
		HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto = new HistoricoPropuestasPreciosDto();
		historicoPropuestasPreciosDto.setIdActivo(activo.getId());
		historicoPropuestasPreciosDto.setIdPeticion(Long.parseLong(exc.dameCelda(fila, 1)));
		historicoPropuestasPreciosDto.setTipoFecha(exc.dameCelda(fila, 2));
		historicoPropuestasPreciosDto.setFechaSolicitud(exc.dameCelda(fila, 3));
		historicoPropuestasPreciosDto.setFechaSancion(exc.dameCelda(fila, 4));
		historicoPropuestasPreciosDto.setObservaciones(exc.dameCelda(fila, 5));

		if(codPeticion == null || "".equals(codPeticion)) {
			activoApi.createHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
		} else {
			activoApi.updateHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
		}

		return new ResultadoProcesarFila();
	}

}