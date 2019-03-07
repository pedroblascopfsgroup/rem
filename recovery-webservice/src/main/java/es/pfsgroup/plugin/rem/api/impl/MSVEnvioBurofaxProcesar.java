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
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;


@Component
public class MSVEnvioBurofaxProcesar extends AbstractMSVActualizador implements MSVLiberator {
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_ID_ACTIVO_HAYA = 0;
		static final int COL_NUM_FECHA_COMUNICACION = 1;
		static final int COL_NUM_ENVIO_CARTAS = 2;
		static final int COL_NUM_NUMERO_CARTAS = 3;	
		static final int COL_NUM_CONTACTO_TELEF = 4;
		static final int COL_NUM_VISITA = 5;
		static final int COL_NUM_BUROFAX = 6;
	}

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ENVIO_BUROFAX;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo= null;
		ActivoComunidadPropietarios actComProp = null;
		
		if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA))) {
			activo = activoApi.getByNumActivo(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA)));	
			actComProp = activo.getComunidadPropietarios();
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_COMUNICACION))) {
				actComProp.setFechaComunicacionComunidad(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_COMUNICACION)));
			}
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_ENVIO_CARTAS))) {
				actComProp.setEnvioCartas(this.obtenerBooleanExcel(exc, fila, COL_NUM.COL_NUM_ENVIO_CARTAS));
			}
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_NUMERO_CARTAS))) {
				actComProp.setNumCartas(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_NUMERO_CARTAS)));
			}
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_CONTACTO_TELEF))) {
				actComProp.setContactoTel(this.obtenerBooleanExcel(exc, fila, COL_NUM.COL_NUM_CONTACTO_TELEF));
			}
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_VISITA))) {
				actComProp.setVisita(this.obtenerBooleanExcel(exc, fila, COL_NUM.COL_NUM_VISITA));
			}
		
			if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_BUROFAX))) {
				actComProp.setBurofax(this.obtenerBooleanExcel(exc, fila, COL_NUM.COL_NUM_BUROFAX));
			}
	
			genericDao.update(ActivoComunidadPropietarios.class, actComProp);
		
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA);
		}
		
		return new ResultadoProcesarFila();
	}

	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Integer obtenerIntegerExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Integer.valueOf(celdaExcel);
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
	
	private Integer obtenerBooleanExcel(MSVHojaExcel exc, int fila, int columnNumber) throws IllegalArgumentException, IOException, ParseException {
		
		if("S".equals(exc.dameCelda(fila, columnNumber))
			|| "SI".equals(exc.dameCelda(fila, columnNumber))) {
			return 1;
		} else if ("N".equals(exc.dameCelda(fila, columnNumber)) 
				|| "NO".equals(exc.dameCelda(fila, columnNumber))) {
			return 0;
		} else if ("NA".equals(exc.dameCelda(fila, columnNumber))
				|| (exc.dameCelda(fila, columnNumber).isEmpty())){
			return null;
		}
		return null;
	}
}
