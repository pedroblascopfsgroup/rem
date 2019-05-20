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
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;

@Component
public class MSVAgruparActivosObraNueva extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	ProcessAdapter processAdapter;
	
	protected static final Log logger = LogFactory.getLog(MSVAgruparActivosObraNueva.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_NEW_BUILDING;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Long numAgrupRem = new Long(exc.dameCelda(1, 0));
			Long agrupacionId = agrupacionAdapter.getAgrupacionIdByNumAgrupRem(numAgrupRem);
			agrupacionAdapter.createActivoAgrupacion(new Long(exc.dameCelda(fila, 1)), agrupacionId, null,false);	
			resultado.setCorrecto(true);
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}	
		return resultado;
	}

}
