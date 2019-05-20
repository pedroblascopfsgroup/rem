package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


@Component
public class MSVFechaIngresoChequeProcesar extends AbstractMSVActualizador implements MSVLiberator {
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_EXPDTE_COMERCIAL = 0;
		static final int COL_NUM_FECHA_INGRESO_CHEQUE = 1;
	}

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZADOR_FECHA_INGRESO_CHEQUE;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		ExpedienteComercial expedienteComercial = null;
		
		if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
			expedienteComercial = expedienteComercialApi.findOneByNumExpediente(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)));
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE))) {
				expedienteComercial.setFechaContabilizacionPropietario(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE)));
			}		
	
			genericDao.update(ExpedienteComercial.class, expedienteComercial);
		
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM.COL_NUM_EXPDTE_COMERCIAL);
		}
		
		return new ResultadoProcesarFila();
	}

	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return fecha;
	}
}
