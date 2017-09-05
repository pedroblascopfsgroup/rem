package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;

@Component
public class MSVActualizadorDespublicarForzado implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoApi activoApi;

	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_PUBLICAR_FORZADO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, SQLException, JsonViewerException, ParseException {

		// Desmarcar publicacion forzada: el activo pasa a estado publicacion "No publicado"
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
	
		Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
		for (int fila = 1; fila < numFilas; fila++) {
			Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			String motivo = exc.dameCelda(fila, 1);
			if(Checks.esNulo(motivo)) {
				motivo = "";
			}
			DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
			
			dtoCambioEstadoPublicacion.setActivo(activo.getId());
			dtoCambioEstadoPublicacion.setPublicacionForzada(false);
			dtoCambioEstadoPublicacion.setOcultacionPrecio(false);
			dtoCambioEstadoPublicacion.setMotivoDespublicacionForzada(motivo);
			
			activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);
		}

		return true;
	}

}
