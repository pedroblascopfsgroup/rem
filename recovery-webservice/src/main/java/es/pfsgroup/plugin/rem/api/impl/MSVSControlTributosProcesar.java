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
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
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
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoTributoDaoImpl;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;


@Component
public class MSVSControlTributosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
		
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private ActivoTributoDaoImpl tributoDaoImpl;

	protected static final Log logger = LogFactory.getLog(MSVSControlTributosProcesar.class);

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;

		static final int COL_NUM_ACTIVO = 0;
		static final int COL_NUM_FECHA_EMISION = 1;
		static final int COL_NUM_FECHA_RECEPCION_PROPIETARIO = 2;
		static final int COL_NUM_FECHA_RECEPCION_GESTORIA = 3;
		static final int COL_NUM_TIPO_SOLICITUD = 4;
		static final int COL_NUM_OBSERVACIONES = 5;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_PROPIETARIO = 6;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA = 7;
		static final int COL_NUM_FECHA_RESPUESTA = 8;
		static final int COL_NUM_RESULTADO_SOLICITUD = 9;
		static final int COL_NUM_HAYA_VINCULADO = 10;
		static final int COL_NUM_ACCION = 11;
		static final int COL_ID_TRIBUTO = 12;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CONTROL_TRIBUTOS;

	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		// PK Número de activo, Fecha presentación recurso o fecha de emisión y tipo de solicitud.
		Activo activo;
		Date fechaEmision;
		Date fechaRecepcionPropietario;
		Date fechaRecepcionGestoria;
		DDTipoSolicitudTributo tipoSolicitudTributo;
		String observaciones;
		Date fechaRecepcionRecursoPropietario;
		Date fechaRecepcionRecursoGestoria;
		Date fechaRespuestaRecurso;
		DDFavorable resultado;
		ActivoTributos activoTributos;
		GastoProveedor gastoProveedor;

		final String DD_ACM_ADD = "01";
		final String DD_ACM_DEL = "02";
		final String DD_ACM_UPD = "03";
		
		DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		String accion = exc.dameCelda(fila, COL_NUM.COL_NUM_ACCION);
		String celdaActivo = exc.dameCelda(fila, COL_NUM.COL_NUM_ACTIVO);
		String celdaEmision = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_EMISION);
		String celdaSolicitud = exc.dameCelda(fila, COL_NUM.COL_NUM_TIPO_SOLICITUD);
		String celdaGasto = exc.dameCelda(fila, COL_NUM.COL_NUM_HAYA_VINCULADO);
		String celdaIdTributo = exc.dameCelda(fila, COL_NUM.COL_ID_TRIBUTO);
		
		if(accion.equals(DD_ACM_ADD)) {
			
		activoTributos = new ActivoTributos();	
		
		activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));
		fechaEmision = formatter.parse(celdaEmision);
		Filter filtroSolicitud = genericDao.createFilter(FilterType.EQUALS, "codigo", celdaSolicitud);
		tipoSolicitudTributo = genericDao.get(DDTipoSolicitudTributo.class, filtroSolicitud);			
		
		activoTributos.setActivo(activo);
		activoTributos.setFechaPresentacionRecurso(fechaEmision);
		activoTributos.setTipoSolicitudTributo(tipoSolicitudTributo);
		
		}else {
			
			String idActivoTributo = particularValidator.getIdActivoTributo(celdaActivo, celdaEmision, celdaSolicitud, celdaIdTributo);
			
			if(!Checks.esNulo(idActivoTributo)) {
				Filter filtroIdActivoTributo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(idActivoTributo));
				activoTributos = genericDao.get(ActivoTributos.class, filtroIdActivoTributo);			
				
				if(accion.equals(DD_ACM_DEL)) {
					genericDao.deleteById(ActivoTributos.class, activoTributos.getId());
					return new ResultadoProcesarFila();
				}	
			}else {
				throw new IllegalArgumentException(
						"MSVSControlTributosProcesar::ResultadoProcesarFila -> idActivoTributo no puede ser null");
			}
			
		}
		
		try {
			
			fechaRecepcionPropietario = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_PROPIETARIO));
			fechaRecepcionGestoria = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_GESTORIA));

			observaciones = exc.dameCelda(fila, COL_NUM.COL_NUM_OBSERVACIONES);

			fechaRecepcionRecursoPropietario = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_PROPIETARIO));
			fechaRecepcionRecursoGestoria = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA));
			fechaRespuestaRecurso = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RESPUESTA));			

			Filter filtroResultado = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_NUM.COL_NUM_RESULTADO_SOLICITUD));
			resultado = genericDao.get(DDFavorable.class, filtroResultado);

			if(!Checks.esNulo(celdaGasto)) {
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya",	Long.parseLong(celdaGasto));				
				gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
				activoTributos.setGastoProveedor(gastoProveedor);
			}
			
			activoTributos.setFechaRecepcionPropietario(fechaRecepcionPropietario);
			activoTributos.setFechaRecepcionGestoria(fechaRecepcionGestoria);
			
			activoTributos.setObservaciones(observaciones);
			activoTributos.setFechaRecepcionRecursoPropietario(fechaRecepcionRecursoPropietario);
			activoTributos.setFechaRecepcionRecursoGestoria(fechaRecepcionRecursoGestoria);
			activoTributos.setFechaRespuestaRecurso(fechaRespuestaRecurso);
			activoTributos.setFavorable(resultado);
						
			if(Checks.esNulo(celdaIdTributo)) {
				Long numMaxTributo = tributoDaoImpl.getNumMaxTributo();
				activoTributos.setNumTributo(numMaxTributo + 1);
				//activoTributos.setNumTributo(Checks.esNulo(celdaIdTributo) ? null : Long.parseLong(celdaIdTributo));
			}
				
						

		} catch (Exception e) {
			logger.error("Error en MSVSControlTributosProcesar", e);			
		}		

		if (accion.equals(DD_ACM_ADD)) {
			genericDao.save(ActivoTributos.class, activoTributos);
		}
		
		if (accion.equals(DD_ACM_UPD)) {
			genericDao.update(ActivoTributos.class, activoTributos);
		}
		
		return new ResultadoProcesarFila();
		
	}

}
