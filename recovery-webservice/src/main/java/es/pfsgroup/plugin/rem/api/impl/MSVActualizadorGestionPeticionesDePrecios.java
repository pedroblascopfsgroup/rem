package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.HistoricoPeticionesPrecios;
import es.pfsgroup.plugin.rem.rest.dto.HistoricoPropuestasPreciosDto;

@Component
public class MSVActualizadorGestionPeticionesDePrecios extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_PETICIONES_PRECIOS;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		String codPeticion = exc.dameCelda(fila, 1);
		String codTipoPeticion = exc.dameCelda(fila, 2);
		String fechaSolicitud = exc.dameCelda(fila, 3);
		String fechaSancion = exc.dameCelda(fila, 4);
		String observaciones = exc.dameCelda(fila, 5);
		
		HistoricoPeticionesPrecios peticion = null;
		if(codPeticion != null && !codPeticion.isEmpty())
			peticion = genericDao.get(HistoricoPeticionesPrecios.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(codPeticion)));

		HistoricoPropuestasPreciosDto historicoPropuestasPreciosDto = new HistoricoPropuestasPreciosDto();
		historicoPropuestasPreciosDto.setIdActivo(activo.getId());
		
		if(codPeticion != null && !codPeticion.isEmpty())
			historicoPropuestasPreciosDto.setIdPeticion(Long.parseLong(codPeticion));
		
		if(codTipoPeticion != null && !codTipoPeticion.isEmpty()) {
			historicoPropuestasPreciosDto.setTipoPeticion(codTipoPeticion);
			historicoPropuestasPreciosDto.setTipoFecha(codTipoPeticion);
		}
		
		if(fechaSolicitud != null && !fechaSolicitud.isEmpty())
			historicoPropuestasPreciosDto.setFechaSolicitud(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(new SimpleDateFormat("dd/MM/yyyy").parse(fechaSolicitud)));
		
		if(fechaSancion != null && !fechaSancion.isEmpty())
			historicoPropuestasPreciosDto.setFechaSancion(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(new SimpleDateFormat("dd/MM/yyyy").parse(fechaSancion)));
		
		if(observaciones != null && !observaciones.isEmpty())
			historicoPropuestasPreciosDto.setObservaciones(observaciones);
		
		if((peticion != null && peticion.getTipoPeticionPrecio() != null) 
				|| (peticion != null && peticion.getTipoPeticionPrecio() != null 
					&& Boolean.FALSE.equals(peticion.getTipoPeticionPrecio().getCodigo().equals(codTipoPeticion)))){
			historicoPropuestasPreciosDto.setEsEditable(true);
		}

		if(codPeticion == null || codPeticion.isEmpty()) {
			activoApi.createHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
		} else {
			activoApi.updateHistoricoSolicitudPrecios(historicoPropuestasPreciosDto);
		}

		return new ResultadoProcesarFila();
	}

}