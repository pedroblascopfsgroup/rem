package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;

@Component
public class MSVActualizadorPreciosActivoBloqueo implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
    @Autowired
    private GenericAdapter adapter;
	
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException, ParseException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
	
		Usuario gestorBloqueoPrecio = adapter.getUsuarioLogado();
		
		Integer numFilas = exc.getNumeroFilasByHoja(0,file.getProcesoMasivo().getTipoOperacion());
		for (int fila = 1; fila < numFilas; fila++) {
			Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			activo.setBloqueoPrecioFechaIni(new Date());
			activo.setGestorBloqueoPrecio(gestorBloqueoPrecio);
			activoApi.saveOrUpdate(activo);
		}

		return true;
	}

}
