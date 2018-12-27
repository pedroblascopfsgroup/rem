package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;


@Component
public class MSVActualizadorCargaMasivaComunicaciones extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMUNICACIONES;
	}
	
	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	private static final int POSICION_COLUMNA_FECHA_COMUNICACION = 1;

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		List<ComunicacionGencat> lcom = new ArrayList<ComunicacionGencat>();
		lcom.add(comunicacionGencatApi.getByIdActivo(Long.parseLong(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO))));
		
		for(ComunicacionGencat  com:lcom) {
			if(com.getEstadoComunicacion().getCodigo().equals("CREADO")) {
				Date fecha = (Date) new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, POSICION_COLUMNA_FECHA_COMUNICACION));  
				
				com.setFechaComunicacion(fecha);
			}
		}
		
		
		return new ResultadoProcesarFila();
	}

}
