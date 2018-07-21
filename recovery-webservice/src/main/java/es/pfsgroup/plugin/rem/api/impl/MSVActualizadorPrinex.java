package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.GastoPrinex;

public class MSVActualizadorPrinex extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		Long gpvNumGasto = null;
		Boolean gastoNuevo = false;

		// obtenemos el gasto prinex si no existe lo creamos

		GastoPrinex gasto = genericDao.get(GastoPrinex.class,
				genericDao.createFilter(FilterType.EQUALS, "id", gpvNumGasto));

		if (gasto == null) {
			gasto = new GastoPrinex();
			gasto.setId(gpvNumGasto);
			gastoNuevo = true;
		}
		
		actualizarEntidad(gasto, 1, exc, fila);

		if (gastoNuevo) {
			genericDao.save(GastoPrinex.class, gasto);
		} else {
			genericDao.update(GastoPrinex.class, gasto);
		}
		return null;
	}

	private void actualizarEntidad(GastoPrinex entidad, Integer columna, MSVHojaExcel exc, int fila)
			throws IllegalArgumentException, IOException, ParseException {
		if (exc.dameCelda(fila, columna) == null
				|| !exc.dameCelda(fila, columna).isEmpty()) {
			return;
		}

		switch (columna) {
		case 1:
			Date fechaContable = dameFecha(exc, fila, columna);
			entidad.setFechaContable(fechaContable);
			break;
		default:
			logger.error("columna no procesada");
		}
	}
	
	private Date dameFecha(MSVHojaExcel exc, int fila,Integer columna) throws IllegalArgumentException, IOException, ParseException{
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		String stringDate = exc.dameCelda(fila, columna);
		Date fecha = null;

		if (stringDate != null && !stringDate.isEmpty()) {
			fecha = format.parse(stringDate);
		}
		
		return fecha;
	}

}
