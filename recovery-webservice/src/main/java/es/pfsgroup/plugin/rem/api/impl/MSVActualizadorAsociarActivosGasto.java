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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;


@Component
public class MSVActualizadorAsociarActivosGasto extends AbstractMSVActualizador implements MSVLiberator {
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GastoApi gastoApi;
	
	@Autowired
	private GastoProveedorApi gastoProveedorManager;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ASOCIAR_ACTIVOS_GASTO;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		GastoProveedor gasto= gastoApi.getByNumGasto(Long.parseLong(exc.dameCelda(fila, 1)));
		
		if(!Checks.esNulo(activo) && !Checks.esNulo(gasto)){
			gastoProveedorManager.createGastoActivo(gasto.getId(),activo.getNumActivo(), null);
		}
		else{
			throw new JsonViewerException("Gasto o Activo no existe");
		}
		return new ResultadoProcesarFila();
	}
	
}
