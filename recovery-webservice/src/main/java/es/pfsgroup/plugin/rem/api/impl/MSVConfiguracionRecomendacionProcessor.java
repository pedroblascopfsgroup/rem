package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.RecomendacionApi;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionRecomendacion;

@Component
public class MSVConfiguracionRecomendacionProcessor extends AbstractMSVActualizador implements MSVLiberator {
	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_RECOMENDACION;
	
	public static final class COL_NUM {
		static final int COL_CARTERA = 0;
		static final int COL_SUBCARTERA = 1;
		static final int COL_TIPO_COMERCIALIZACION = 2;
		static final int COL_EQUIPO_GESTION = 3;
		static final int COL_DESCUENTO = 4;
		static final int COL_IMPORTE_MINIMO = 5;
		static final int COL_RECOMENDACION = 6;
	}
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private RecomendacionApi recomendacionApi;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		
		final String cartera = exc.dameCelda(fila, COL_NUM.COL_CARTERA);		
		final String subcartera = exc.dameCelda(fila, COL_NUM.COL_SUBCARTERA);	
		final String tipoComercializacion = exc.dameCelda(fila, COL_NUM.COL_TIPO_COMERCIALIZACION);	
		final String equipoGestion = exc.dameCelda(fila, COL_NUM.COL_EQUIPO_GESTION);	
		final String descuento = exc.dameCelda(fila, COL_NUM.COL_DESCUENTO);	
		final String importeMinimo = exc.dameCelda(fila, COL_NUM.COL_IMPORTE_MINIMO);	
		final String recomendacion = exc.dameCelda(fila, COL_NUM.COL_RECOMENDACION);	
		
		DtoConfiguracionRecomendacion dtoConfiguracionRecomendacion = new DtoConfiguracionRecomendacion();
		
		if(!cartera.isEmpty() || cartera != null || cartera != "") {	
			dtoConfiguracionRecomendacion.setCartera(cartera);
		} 
		if(!subcartera.isEmpty() || subcartera != null || subcartera != "") {	
			dtoConfiguracionRecomendacion.setSubcartera(subcartera);
		} 
		if(!tipoComercializacion.isEmpty() || tipoComercializacion != null || tipoComercializacion != "") {	
			dtoConfiguracionRecomendacion.setTipoComercializacion(tipoComercializacion);
		} 
		if(!equipoGestion.isEmpty() || equipoGestion != null || equipoGestion != "") {	
			dtoConfiguracionRecomendacion.setEquipoGestion(equipoGestion);
		} 
		if(!descuento.isEmpty() || descuento != null || descuento != "") {	
			Double porcentajeDescuento = stringToDouble(descuento);
			dtoConfiguracionRecomendacion.setPorcentajeDescuento(porcentajeDescuento);
		} 
		if(!importeMinimo.isEmpty() || importeMinimo != null || importeMinimo != "") {	
			Double importe = stringToDouble(importeMinimo);
			dtoConfiguracionRecomendacion.setImporteMinimo(importe);
		} 
		if(!recomendacion.isEmpty() || recomendacion != null || recomendacion != "") {	
			dtoConfiguracionRecomendacion.setRecomendacionRCDC(recomendacion);
		}
			
		recomendacionApi.saveConfigRecomendacion(dtoConfiguracionRecomendacion);
		
		return new ResultadoProcesarFila();	
	}
	
	private Double stringToDouble(String numero) {

		if(numero != null && !numero.isEmpty()){
			if(numero.contains(",")){
				numero = numero.replace(",", ".");
			}
		}
		
		Double number = !Checks.esNulo(numero) ? Double.parseDouble(numero) : null;

		return number;
	}

}


