package es.pfsgroup.plugin.rem.api.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVValidatorConfiguracionPeriodosVoluntarios.COL_NUM;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.ConfiguracionImpuestosActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;



@Component
public class MSVActualizadorConfiguracionPeriodosVoluntarios extends AbstractMSVActualizador implements MSVLiberator {
	private static final class COL_NUM {
		static final int COL_NUM_POBLACION = 0;
		static final int COL_NUM_MUNICIPIO = 1;
		static final int COL_NUM_TIPO_DE_IMPUESTO = 2;
		static final int COL_NUM_FECHA_INICIO = 3;
		static final int COL_NUM_FECHA_FIN = 4;
		static final int COL_NUM_PERIODICIDAD = 5;
		static final int COL_NUM_CALCULO = 6;
		
	}
	protected static final Log logger = LogFactory.getLog(MSVActualizadorConfiguracionPeriodosVoluntarios.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_PERIODOS_VOLUNTARIOS;
	}
	
	
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();

		String colpoblacion = exc.dameCelda(fila, COL_NUM.COL_NUM_POBLACION);
		String colmunicipio = exc.dameCelda(fila, COL_NUM.COL_NUM_MUNICIPIO);
		String coltipoDeImpuesto = exc.dameCelda(fila, COL_NUM.COL_NUM_TIPO_DE_IMPUESTO);
		String colfechaDeInicio = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_INICIO);
		String colfechaFin = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_FIN);
		String colperiodicidad = exc.dameCelda(fila, COL_NUM.COL_NUM_PERIODICIDAD);
		String colcalculo = exc.dameCelda(fila, COL_NUM.COL_NUM_CALCULO);
		
		final String codigo = "codigo";
		
		Localidad poblacion = null;
		DDUnidadPoblacional municipio = null;
		DDSubtipoGasto tipoImpuesto = null;
		DDTipoPeriocidad periocidiad = null;
		DDCalculoImpuesto calculo = null;
		
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;
		ConfiguracionImpuestosActivo configuracionImpuestoActivo = new ConfiguracionImpuestosActivo();
		
		if (coltipoDeImpuesto != null && colfechaDeInicio != null ) {
			if (colpoblacion != null && !colpoblacion.isEmpty()) {
				Filter filtroPoblacion = genericDao.createFilter(FilterType.EQUALS, codigo, colpoblacion);
				poblacion = genericDao.get(Localidad.class, filtroPoblacion);
				if(poblacion != null) {
					configuracionImpuestoActivo.setLocalidad(poblacion);
				}
				
			}

			if (colmunicipio != null && !colmunicipio.isEmpty()) {
				Filter filtroMunicipio = genericDao.createFilter(FilterType.EQUALS, codigo, colmunicipio);
				municipio = genericDao.get(DDUnidadPoblacional.class, filtroMunicipio);
				if(municipio !=null) {
				configuracionImpuestoActivo.setUnidadPoblacional(municipio);
				}
			}

		
				Filter filtroTipoDeImpuesto = genericDao.createFilter(FilterType.EQUALS, codigo, coltipoDeImpuesto);
				tipoImpuesto = genericDao.get(DDSubtipoGasto.class, filtroTipoDeImpuesto);
				if(tipoImpuesto != null && colfechaDeInicio != null) {
					
				
				configuracionImpuestoActivo.setSubtipoGasto(tipoImpuesto);
			fecha = formato.parse(colfechaDeInicio);
				configuracionImpuestoActivo.setFechaInicio(fecha);
				}
			

			if (colfechaFin != null && !colfechaFin.isEmpty()) {
				fecha = formato.parse(colfechaFin);
				configuracionImpuestoActivo.setFechaFin(fecha);
			}

			if (colperiodicidad != null && !colperiodicidad.isEmpty() ) {
				Filter filtroPeriocidad = genericDao.createFilter(FilterType.EQUALS, codigo, colperiodicidad);
				periocidiad = genericDao.get(DDTipoPeriocidad.class, filtroPeriocidad);
				if(periocidiad != null) {
				configuracionImpuestoActivo.setTipoPeriocidad(periocidiad);
				}
			}
			if (colcalculo != null && !colcalculo.isEmpty()) {
				Filter filtroCalculo = genericDao.createFilter(FilterType.EQUALS, codigo, colcalculo);
				calculo = genericDao.get(DDCalculoImpuesto.class, filtroCalculo);
				if(calculo != null) {
					configuracionImpuestoActivo.setCalculoImpuesto(calculo);
				}
				
			}
		
			genericDao.save(ConfiguracionImpuestosActivo.class,configuracionImpuestoActivo);

		}
		return resultado;
	}


	
}


