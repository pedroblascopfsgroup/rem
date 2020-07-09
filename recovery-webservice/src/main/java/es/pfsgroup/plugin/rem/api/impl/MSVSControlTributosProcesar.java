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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTributo;


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
		static final int COL_NUM_TIPO_TRIBUTO=1;
		static final int COL_NUM_FECHA_RECEPCION_TRIBUTO=2;
		static final int COL_NUM_FECHA_EMISION = 3;
		static final int COL_NUM_FECHA_RECEPCION_PROPIETARIO = 4;
		static final int COL_NUM_FECHA_RECEPCION_GESTORIA = 5;
		static final int COL_NUM_TIPO_SOLICITUD = 6;
		static final int COL_NUM_OBSERVACIONES = 7;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_BANKIA = 8;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA = 9;
		static final int COL_NUM_FECHA_RESPUESTA = 10;
		static final int COL_NUM_RESULTADO_SOLICITUD = 11;
		static final int COL_NUM_HAYA_VINCULADO=12;
		static final int COL_NUM_EXISTE_DOC=13;
		static final int COL_NUM_NUMERO_EXPEDIENTE=14;
		static final int COL_NUM_FECHA_COMUNICADO_DEVOLUCION_INGRESO=15;
		static final int COL_NUM_IMPORTE_RECUPERADO=16;
		static final int COL_NUM_ACCION = 17;
		static final int COL_ID_TRIBUTO = 18;
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
		DDTipoTributo tipoTributo;
		Date fechaRecepcionTributo;
		Date fechaEmision;
		Date fechaRecepcionPropietario;
		Date fechaRecepcionGestoria;
		DDTipoSolicitudTributo tipoSolicitudTributo;
		String observaciones;
		Date fechaRecepcionRecursoPropietario;
		Date fechaRecepcionRecursoGestoria;
		Date fechaRespuestaRecurso;
		DDFavorable resultado;
		Long numGastoHaya;
		ExpedienteComercial expediente;
		Date fechaComunicadoDevolucionIngreso;
		Double importeRecuperado;
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
		numGastoHaya = Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_NUM_HAYA_VINCULADO));
		String celdaIdTributo = exc.dameCelda(fila, COL_NUM.COL_ID_TRIBUTO);
		String celdaExisteDoc = exc.dameCelda(fila, COL_NUM.COL_NUM_EXISTE_DOC);
		if(exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO) != null && !exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO).isEmpty())
			importeRecuperado = Double.parseDouble(exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO));
		
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
			fechaComunicadoDevolucionIngreso = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_COMUNICADO_DEVOLUCION_INGRESO));

			observaciones = exc.dameCelda(fila, COL_NUM.COL_NUM_OBSERVACIONES);

			fechaRecepcionRecursoPropietario = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_BANKIA));
			fechaRecepcionRecursoGestoria = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA));
			fechaRespuestaRecurso = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RESPUESTA));
			fechaRecepcionTributo = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_RECEPCION_TRIBUTO));

			fechaComunicadoDevolucionIngreso = formatter.parse(exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_COMUNICADO_DEVOLUCION_INGRESO));
			
			Filter filtroResultado = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_NUM.COL_NUM_RESULTADO_SOLICITUD));
			resultado = genericDao.get(DDFavorable.class, filtroResultado);
			
			if(exc.dameCelda(fila, COL_NUM.COL_NUM_NUMERO_EXPEDIENTE) != null && !exc.dameCelda(fila, COL_NUM.COL_NUM_NUMERO_EXPEDIENTE).isEmpty()) {
				Long numExpediente = Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_NUM_NUMERO_EXPEDIENTE));
				Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "id", numExpediente);
				expediente =  genericDao.get(ExpedienteComercial.class, filtroExpediente);
				if(expediente != null && expediente.getId() != null) {
					activoTributos.setExpediente(expediente);
				}
			}

			Filter filtroTipoTributo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(exc.dameCelda(fila, COL_NUM.COL_NUM_TIPO_TRIBUTO)));
			tipoTributo = genericDao.get(DDTipoTributo.class, filtroTipoTributo);
			
			
			Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya",	numGastoHaya);
								
			gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
			if(celdaExisteDoc != null) {
				if("S".equalsIgnoreCase(celdaExisteDoc) || "SI".equalsIgnoreCase(celdaExisteDoc)) {
					gastoProveedor.setExisteDocumento(1);
				}else {
					gastoProveedor.setExisteDocumento(0);
				}
			}
			activoTributos.setGastoProveedor(gastoProveedor);
			if(exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO) != null && !exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO).isEmpty()) {
				importeRecuperado = Double.parseDouble(exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE_RECUPERADO));
				activoTributos.setImporteRecuperadoRecurso(importeRecuperado);
			}
			
			activoTributos.setFechaRecepcionPropietario(fechaRecepcionPropietario);
			activoTributos.setFechaRecepcionGestoria(fechaRecepcionGestoria);
			activoTributos.setFechaRecepcionTributo(fechaRecepcionTributo);
			activoTributos.setObservaciones(observaciones);
			activoTributos.setFechaRecepcionRecursoPropietario(fechaRecepcionRecursoPropietario);
			activoTributos.setFechaRecepcionRecursoGestoria(fechaRecepcionRecursoGestoria);
			activoTributos.setFechaRespuestaRecurso(fechaRespuestaRecurso);
			activoTributos.setFavorable(resultado);
			activoTributos.setTipoTributo(tipoTributo);
			activoTributos.setFechaComunicacionDevolucionIngreso(fechaComunicadoDevolucionIngreso);
						
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
