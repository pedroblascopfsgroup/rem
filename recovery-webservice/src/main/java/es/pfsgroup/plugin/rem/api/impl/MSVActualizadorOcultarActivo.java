package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

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
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;

@Component
public class MSVActualizadorOcultarActivo implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoApi activoApi;

	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, SQLException, JsonViewerException, ParseException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
	
		Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
		for (int fila = getFilaInicial(); fila < numFilas; fila++) {
			Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			String motivo = exc.dameCelda(fila, 1);
			if(Checks.esNulo(motivo)) {
				motivo = "";
			}
			DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
			
			dtoCambioEstadoPublicacion.setActivo(activo.getId());
			dtoCambioEstadoPublicacion.setOcultacionForzada(true);
			dtoCambioEstadoPublicacion.setMotivoOcultacionForzada(motivo);
			
			activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);
		}

		return true;
	}

	@Override
	public int getFilaInicial() {
		return 1;
	}

}
