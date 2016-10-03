package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;

@Component
public class MSVAgruparActivosAsistidaPDV implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	ProcessAdapter processAdapter;

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_ASISTIDA.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {
		
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);		
		Long numAgrupRem = new Long(exc.dameCelda(1, 0));
		Long agrupacionId = agrupacionAdapter.getAgrupacionIdByNumAgrupRem(numAgrupRem);
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			agrupacionAdapter.createActivoAgrupacion(new Long(exc.dameCelda(fila, 1)), agrupacionId, null);		
		}

		return true;
	}

}
