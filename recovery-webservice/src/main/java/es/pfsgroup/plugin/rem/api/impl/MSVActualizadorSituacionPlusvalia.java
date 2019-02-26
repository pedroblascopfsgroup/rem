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
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.PlusvaliaAdapter;

@Component
public class MSVActualizadorSituacionPlusvalia extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	PlusvaliaAdapter plusvaliaAdapter;
	
	@Autowired
	ProcessAdapter processAdapter;
	



	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SITUACION_PLUSVALIA;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {

		plusvaliaAdapter.updatePlusvalia(new Long(exc.dameCelda(fila, 0)), new String(exc.dameCelda(fila, 1)), new String(exc.dameCelda(fila, 2)),new String(exc.dameCelda(fila, 3)),new String(exc.dameCelda(fila, 4)));	
		return new ResultadoProcesarFila();
	}
	
	@Override
	public int getFilaInicial() {
		return 1;
	}

}
