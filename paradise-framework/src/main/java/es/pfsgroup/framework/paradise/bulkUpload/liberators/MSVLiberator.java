package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import java.io.IOException;
import java.text.ParseException;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;

public interface MSVLiberator {
	
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	public Boolean liberaFichero(MSVDocumentoMasivo fichero) throws Exception;
	
	public int getFilaInicial();
	
	public void postProcesado(MSVHojaExcel exc) throws NumberFormatException, IllegalArgumentException, IOException, ParseException;
	
}
