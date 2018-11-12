package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.ComunidadesPropietariosAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;

@Component
public class MSVActualizadorSituacionComunidadesPropietarios extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	ComunidadesPropietariosAdapter comunidadesPropietariosAdapter;
	
	@Autowired
	ProcessAdapter processAdapter;
	

	@Autowired
	private ApiProxyFactory proxyFactory;
	



	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SITUACION_COMUNIDADEDES_PROPIETARIOS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		

		comunidadesPropietariosAdapter.updateComunidad(new Long(exc.dameCelda(fila, 1)), new String(exc.dameCelda(fila, 2)), new String(exc.dameCelda(fila, 3)),new String(exc.dameCelda(fila, 4)));	
		return new ResultadoProcesarFila();
	}
	
	@Override
	public int getFilaInicial() {
		return 1;
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, ParseException {
		
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);		
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			
			comunidadesPropietariosAdapter.updateComunidad(new Long(exc.dameCelda(fila, 0)), new String(exc.dameCelda(fila, 1)), new String(exc.dameCelda(fila, 2)),new String(exc.dameCelda(fila, 3)));	
	
		}

		return true;
	}

}
