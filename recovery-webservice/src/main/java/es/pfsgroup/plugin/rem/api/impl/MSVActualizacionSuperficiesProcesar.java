package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;

@Component
public class MSVActualizacionSuperficiesProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_ID_ACTIVO_HAYA = 0;
		static final int COL_NUM_SUP_CONSTRUIDA = 1;
		static final int COL_NUM_SUP_UTIL = 2;
		static final int COL_NUM_REPERCUSION_EECC = 3;
		static final int COL_NUM_PARCELA = 4;		
	}


	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZACION_SUPERFICIE;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		
		ActivoInfoRegistral infoRegistral = new ActivoInfoRegistral();
		
		Activo activo = null;
			
		if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA))) {
			activo = activoApi.getByNumActivo(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA)));
			infoRegistral.setActivo(activo);
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_SUP_CONSTRUIDA))) {
			NMBInformacionRegistralBien infoRegBien = new NMBInformacionRegistralBien();
			infoRegBien.setSuperficieConstruida(this.obtenerBigDecimalExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_SUP_CONSTRUIDA)));
			infoRegistral.setInfoRegistralBien(infoRegBien);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_SUP_UTIL))) {
			infoRegistral.setSuperficieUtil(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_SUP_UTIL)));
		}
	
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_REPERCUSION_EECC))) {
			infoRegistral.setSuperficieElementosComunes(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_REPERCUSION_EECC)));
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_PARCELA))) {
			infoRegistral.setSuperficieParcela(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_PARCELA)));
		}
		
		genericDao.save(ActivoInfoRegistral.class, infoRegistral);
		
		return new ResultadoProcesarFila();
	}

	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}
	
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}
	
	private BigDecimal obtenerBigDecimalExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return BigDecimal.valueOf(this.obtenerDoubleExcel(celdaExcel));
	}

	
	@Override
	public int getFilaInicial() {
		return COL_NUM.DATOS_PRIMERA_FILA;
	}


}
