package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.trabajo.dao.impl.TrabajoDaoImpl;
import es.pfsgroup.plugin.rem.api.TrabajoApi;

@Component
public class MSVActualizadorCargaSuperGestEcoTrabajosProcesar extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private TrabajoDaoImpl trabajoDaoImpl;
	
    @Autowired
    private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_ECONOMICA_TRABAJOS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(Long.parseLong(exc.dameCelda(fila, 0)));
		TrabajoConfiguracionTarifa trabajoConfiguracionTarifa = genericDao.get(TrabajoConfiguracionTarifa.class,genericDao.createFilter(FilterType.EQUALS,"trabajo", trabajo),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		if(!Checks.esNulo(trabajo)){
			trabajo.setImporteTotal(Double.parseDouble(exc.dameCelda(fila, 3)));
			trabajoConfiguracionTarifa.setPrecioUnitario(Float.parseFloat(exc.dameCelda(fila, 1)));
		}
		return new ResultadoProcesarFila();
	}
}
	

