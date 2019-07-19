package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


@Component
public class MSVSReclamacionesPlusvaliasProcesar extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
		
	@Autowired
	private ParticularValidatorApi particularValidator;

	protected static final Log logger = LogFactory.getLog(MSVSReclamacionesPlusvaliasProcesar.class);
	
	private static final String DD_ACM_DEL = "02";
	private static final String COD_SI = "S";

	public static final class COL_NUM {
		
		private static final int POSICION_COLUMNA_NUM_ACTIVO_HAYA = 0;
		private static final int POSICION_COLUMNA_FECHA_RECEPCION_PLUSVALIA = 1;
		private static final int POSICION_COLUMNA_FECHA_PLUSVALIA = 2;
		private static final int POSICION_COLUMNA_FECHA_PRESENTACION_RECURSO = 3;
		private static final int POSICION_COLUMNA_FECHA_RESPUESTA_RECURSO = 4;
		private static final int POSICION_COLUMNA_APERTURA_EXP = 5;
		private static final int POSICION_COLUMNA_IMPORTE_PAGADO_PLUSVALIA = 6;
		private static final int POSICION_COLUMNA_GASTO_ASOCIADO = 7;
		private static final int POSICION_COLUMNA_MINUSVALIA = 8;
		private static final int POSICION_COLUMNA_EXENTO = 9;
		private static final int POSICION_COLUMNA_AUTOLIQUIDACION = 10;
		private static final int POSICION_COLUMNA_OBSERVACIONES = 11;
		private static final int POSICION_COLUMNA_ACCION = 12;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES_PLUSVALIAS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		// PK Número de activo, Fecha presentación Plusvalia
		Activo activo;
		GastoProveedor gastoProveedor;
		
		ActivoPlusvalia activoPlusvalia = new ActivoPlusvalia();;
		
		DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		String celdaAccion = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_ACCION);
		String celdaActivo = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_NUM_ACTIVO_HAYA);
		String celdaFechaRecPlusvalia = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_FECHA_RECEPCION_PLUSVALIA);
		String celdaFechaPlusvalia = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_FECHA_PLUSVALIA);
		String celdaFechaRespRecurso = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_FECHA_RESPUESTA_RECURSO);
		String celdaFechePresRecu = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_FECHA_PRESENTACION_RECURSO);
		String celdaMinusvalia = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_MINUSVALIA);
		String celdaExento = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_EXENTO);
		String celdaAutoliquidacion = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_AUTOLIQUIDACION);
		String celdaGastoAsociado = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_GASTO_ASOCIADO);
		String celdaAperturaSeguimiento = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_APERTURA_EXP);
		String celdaImportePagado = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_IMPORTE_PAGADO_PLUSVALIA);
		String celdaObservaciones = exc.dameCelda(fila, COL_NUM.POSICION_COLUMNA_OBSERVACIONES);
		
		try {
			
			String idActivoPlusvalia = particularValidator.getActivoPlusvalia(celdaActivo, celdaFechaPlusvalia);
			
			if(!Checks.esNulo(idActivoPlusvalia)) {
				Filter filtroIdActivoPlusvalia = genericDao.createFilter(FilterType.EQUALS, "id",  Long.parseLong(idActivoPlusvalia));
				activoPlusvalia = genericDao.get(ActivoPlusvalia.class, filtroIdActivoPlusvalia);
			}
			
			if(DD_ACM_DEL.equals(celdaAccion)) {
				
				if(!Checks.esNulo(activoPlusvalia)) {
					genericDao.deleteById(ActivoPlusvalia.class, activoPlusvalia.getId());
					return new ResultadoProcesarFila();
				}else {
					throw new IllegalArgumentException(
							"MSVSReclamacionesPlusvaliasProcesar::ResultadoProcesarFila -> No existe registro del activoPlusvalia para eliminar");
				}
				
			}else{
	
				activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));
				
				Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_SI);
				Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_NO);
				
				DDSinSiNo ddSi = genericDao.get(DDSinSiNo.class, filtroSi);
				DDSinSiNo ddNo = genericDao.get(DDSinSiNo.class,filtroNo);
				
				activoPlusvalia.setActivo(activo);
				activoPlusvalia.setDateRecepcionPlus(formatter.parse(celdaFechaRecPlusvalia));
				activoPlusvalia.setDatePresentacionPlus(formatter.parse(celdaFechaPlusvalia));
				activoPlusvalia.setDatePresentacionRecu(formatter.parse(celdaFechePresRecu));
				activoPlusvalia.setDateRespuestaRecu(formatter.parse(celdaFechaRespRecurso));
				activoPlusvalia.setExento(COD_SI.equals(celdaExento) ? ddSi : ddNo );
				activoPlusvalia.setAutoliquidacion(COD_SI.equals(celdaAutoliquidacion) ? ddSi : ddNo);
				activoPlusvalia.setObservaciones(celdaObservaciones);
				activoPlusvalia.setAperturaSeguimientoExp(COD_SI.equals(celdaAperturaSeguimiento) ? ddSi : ddNo);
				activoPlusvalia.setMinusvalia(COD_SI.equals(celdaMinusvalia) ? ddSi : ddNo);				
				activoPlusvalia.setImportePagado(new BigDecimal(celdaImportePagado));
				
				if(!Checks.esNulo(celdaGastoAsociado)) {
					Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya",	Long.parseLong(celdaGastoAsociado));				
					gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
					activoPlusvalia.setGastoProveedor(gastoProveedor);
				}else {
					activoPlusvalia.setGastoProveedor(null);
				}
				
				genericDao.save(ActivoPlusvalia.class, activoPlusvalia);

			}

		} catch (Exception e) {
			logger.error("Error en MSVSReclamacionesPlusvaliasProcesar", e);			
		}

		return new ResultadoProcesarFila();
		
	}

}
