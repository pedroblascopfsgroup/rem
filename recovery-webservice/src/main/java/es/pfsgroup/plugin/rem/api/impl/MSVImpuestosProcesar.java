package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ImpuestosActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;

@Component
public class MSVImpuestosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_ID_ACTIVO_HAYA = 0;
		static final int COL_NUM_IMPUESTO = 1;
		static final int COL_NUM_FECHA_INICIO = 2;
		static final int COL_NUM_FECHA_FIN = 3;	
		static final int COL_NUM_PERIODICIDAD = 4;
		static final int COL_NUM_CALCULO = 5;
	}


	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_IMPUESTOS;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		
		ImpuestosActivo impuestosActivo = new ImpuestosActivo();
		
		Activo activo = null;
		DDSubtipoGasto tipoImpuesto = null;
		DDTipoPeriocidad tipoPeriocidad = null;
		DDCalculoImpuesto calculo = null;
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA))) {
			activo = activoApi.getByNumActivo(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA)));
			impuestosActivo.setActivo(activo);
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_IMPUESTO))) {
			Filter filtroImpuesto = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.COL_NUM_IMPUESTO));
			tipoImpuesto = (DDSubtipoGasto) genericDao.get(DDSubtipoGasto.class, filtroImpuesto,filtroBorrado);
			impuestosActivo.setSubtipoGasto(tipoImpuesto);
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM.COL_NUM_IMPUESTO);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_INICIO))) {
		impuestosActivo.setFechaInicio(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_INICIO)));
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_FIN))) {
		impuestosActivo.setFechaFin(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_FIN)));
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_PERIODICIDAD))) {
		Filter filtroPeriocidad = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.COL_NUM_PERIODICIDAD));
		tipoPeriocidad = (DDTipoPeriocidad) genericDao.get(DDTipoPeriocidad.class, filtroPeriocidad,filtroBorrado);
		impuestosActivo.setPeriodicidad(tipoPeriocidad);
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_NUM.COL_NUM_CALCULO))) {
		Filter filtroCalculo = genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_NUM.COL_NUM_CALCULO));
		calculo = (DDCalculoImpuesto) genericDao.get(DDCalculoImpuesto.class, filtroCalculo,filtroBorrado);
		impuestosActivo.setCalculoImpuesto(calculo);		
		}
		
		genericDao.save(ImpuestosActivo.class, impuestosActivo);
		
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
	
	@Override
	public int getFilaInicial() {
		return COL_NUM.DATOS_PRIMERA_FILA;
	}


}
