package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComplementoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloComplemento;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;


@Component
public class MSVActualizadorComplementoTituloCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	

	SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
	
	private static final class COL_NUM {
		static final int COL_NUM_ACTIVO = 0;
		static final int COL_NUM_TIPO_DE_TITULO = 1;
		static final int COL_NUM_FECHA_DE_SOLICITUD = 2;
		static final int COL_NUM_FECHA_DEL_TITULO = 3;
		static final int COL_NUM_FECHA_DE_RECEPCION = 4;
		static final int COL_NUM_FECHA_DE_INSCRIPCION = 5;
		static final int COL_NUM_OBSERVACIONES = 6;
		
	}
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMPLEMENTO_TITULO;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();

		String colNActivo = exc.dameCelda(fila, COL_NUM.COL_NUM_ACTIVO);
		String colTipoDeTitulo = exc.dameCelda(fila, COL_NUM.COL_NUM_TIPO_DE_TITULO);
		String colFechaDeSolicitud = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_DE_SOLICITUD);
		String colFechaDelTitulo = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_DEL_TITULO);
		String colFechaDeRecepcion = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_DE_RECEPCION);
		String colFechaDeInscripcion = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_DE_INSCRIPCION);
		String colObservaciones = exc.dameCelda(fila, COL_NUM.COL_NUM_OBSERVACIONES);
		
		final String codigo = "codigo";
		
		
		DDTipoTituloComplemento tipoTitulo = null;
		ActivoComplementoTitulo activoComplemento = new ActivoComplementoTitulo();
		
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;
		Filter filtroTipoTitulo = genericDao.createFilter(FilterType.EQUALS, codigo, colTipoDeTitulo);
		tipoTitulo = genericDao.get(DDTipoTituloComplemento.class, filtroTipoTitulo);
		
		if (colNActivo != null && colTipoDeTitulo != null) {
			
			
			Activo activo = activoApi.getByNumActivo(Long.parseLong(colNActivo));
			
			if(activo!= null) {
				activoComplemento.setActivo(activo);
			}
			
			
			
			if(tipoTitulo != null) {
			activoComplemento.setTituloComplemento(tipoTitulo);
			}
			
			
			if (colFechaDeSolicitud != null && !colFechaDeSolicitud.isEmpty()) {
				fecha = formato.parse(colFechaDeSolicitud);
				activoComplemento.setFechaSolicitud(fecha);
			}
			
			if (colFechaDelTitulo != null && !colFechaDelTitulo.isEmpty()) {
				fecha = formato.parse(colFechaDelTitulo);
					activoComplemento.setFechaComplementoTitulo(fecha);
			}
			
			if (colFechaDeRecepcion != null && !colFechaDeRecepcion.isEmpty()) {
				fecha = formato.parse(colFechaDeRecepcion);
				activoComplemento.setFechaRecepcion(fecha);
			}
			
			if (colFechaDeInscripcion != null && !colFechaDeInscripcion.isEmpty()) {
				fecha = formato.parse(colFechaDeInscripcion);
				activoComplemento.setFechaInscripcion(fecha);
			}
			if (colObservaciones != null && !colObservaciones.isEmpty()) {
				activoComplemento.setObservaciones(colObservaciones);
			}
			
			genericDao.save(ActivoComplementoTitulo.class,activoComplemento);
			
		}
		return resultado;
	}
	
}
