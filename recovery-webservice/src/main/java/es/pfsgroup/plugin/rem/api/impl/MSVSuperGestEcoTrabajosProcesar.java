package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.api.TrabajoApi;

@Component
public class MSVSuperGestEcoTrabajosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_ECONOMICA_TRABAJOS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {
		List<TrabajoConfiguracionTarifa> trabajosConfiguracionTarifa = new ArrayList<TrabajoConfiguracionTarifa>();
		Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(Long.parseLong(exc.dameCelda(fila, 0)));
		trabajosConfiguracionTarifa = genericDao.getList(TrabajoConfiguracionTarifa.class,
				genericDao.createFilter(FilterType.EQUALS, "trabajo", trabajo),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		trabajo.setImporteTotal(Double.parseDouble(exc.dameCelda(fila, 5)));

		for (int i = 0; i < trabajosConfiguracionTarifa.size(); i++) {
			if (exc.dameCelda(fila, 1) == null || exc.dameCelda(fila, 1).trim().equals("") ) {
				if (!Checks.esNulo(trabajo)) {
					trabajosConfiguracionTarifa.get(i).setMedicion(Float.parseFloat(exc.dameCelda(fila, 3)));
					trabajosConfiguracionTarifa.get(i).setPrecioUnitario(Float.parseFloat(exc.dameCelda(fila, 2)));
					genericDao.update(TrabajoConfiguracionTarifa.class, trabajosConfiguracionTarifa.get(i));
				}
			} else {
				if (trabajosConfiguracionTarifa.get(i).getConfigTarifa().getTipoTarifa().getCodigo()
						.equals(exc.dameCelda(fila, 1))) {
					if (!Checks.esNulo(trabajo)) {
						trabajosConfiguracionTarifa.get(i).setMedicion(Float.parseFloat(exc.dameCelda(fila, 3)));
						trabajosConfiguracionTarifa.get(i).setPrecioUnitario(Float.parseFloat(exc.dameCelda(fila, 2)));
						genericDao.update(TrabajoConfiguracionTarifa.class, trabajosConfiguracionTarifa.get(i));
					}
				}
			}

		}
		genericDao.update(Trabajo.class, trabajo);

		return new ResultadoProcesarFila();
	}
}
