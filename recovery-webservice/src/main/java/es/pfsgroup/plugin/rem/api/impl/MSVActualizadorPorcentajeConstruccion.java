package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

/***
 * Clase que procesa el fichero de carga masiva valores perímetro Apple
 */
@Component
public class MSVActualizadorPorcentajeConstruccion extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		static final int COL_NUM_ACTIVO = 0;
		static final int COL_PORCENTAJE_CONSTRUCCION = 1;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PORCENTAJE_CONSTRUCCION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {;

		final String celdaNumActivo = exc.dameCelda(fila, COL_NUM.COL_NUM_ACTIVO);
		final String celdaPorcentajeConstruccion = exc.dameCelda(fila, COL_NUM.COL_PORCENTAJE_CONSTRUCCION);
		
		try {
			
			Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaNumActivo));
			Double numPorcentajeConstruccion = Double.parseDouble(celdaPorcentajeConstruccion);
			
			if(numPorcentajeConstruccion != null) {		
				activo.setPorcentajeConstruccion(numPorcentajeConstruccion);
			}
			genericDao.update(Activo.class, activo);
			
			if (activoApi.isActivoMatriz(activo.getId())) {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				if(!Checks.esNulo(agr)) {
					List<Activo> listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agr.getId());
					for (Activo ua : listaUAs) {
						ua.setPorcentajeConstruccion(numPorcentajeConstruccion);
						genericDao.update(Activo.class, activo);
					}
				}
			}
			
			return new ResultadoProcesarFila();
		}catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
	}

}
