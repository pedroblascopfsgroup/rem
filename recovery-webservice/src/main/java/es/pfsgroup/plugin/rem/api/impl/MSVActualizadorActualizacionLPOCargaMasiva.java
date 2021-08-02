package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Component
public class MSVActualizadorActualizacionLPOCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int ACT_NUM_ACTIVO = 0;
	private static final int ACT_ES_LPO = 1;
	private static final int ACT_ESTADO = 2;
	private static final int ACT_FECHA_SOLICITUD = 3;
	private static final int ACT_FECHA_OBTENCION = 4;
	private static final int ACT_FECHA_VALIDACION = 5;
	private static final String SI = "SI";
	private static final String NO = "NO";
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_LPO;
	}
	@Autowired
	private ActivoApi activoApi;

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, ACT_NUM_ACTIVO)));
		// Aqui buscamos el activo si se encuentra (que debe encontrarse)
		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter filterLPO = genericDao.createFilter(FilterType.EQUALS, "configDocumento.tipoDocumentoActivo.codigo", DDTipoDocumentoActivo.CODIGO_LPO_GESTOR);
		Filter filterEstado = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, ACT_ESTADO));
		Filter filterTipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", activo.getTipoActivo().getCodigo());
		Filter filterLPOCFD = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", DDTipoDocumentoActivo.CODIGO_LPO_GESTOR);
		
		ActivoAdmisionDocumento activoAdmisionDocumento = genericDao.get(ActivoAdmisionDocumento.class, filterActivo, filterLPO);
		if (Checks.esNulo(activoAdmisionDocumento)) {
			activoAdmisionDocumento = new ActivoAdmisionDocumento();
			activoAdmisionDocumento.setActivo(activo);
			ActivoConfigDocumento activoConfigDocumento = genericDao.get(ActivoConfigDocumento.class, filterTipoActivo, filterLPOCFD);
			activoAdmisionDocumento.setConfigDocumento(activoConfigDocumento);
			String lpo = exc.dameCelda(fila, ACT_ES_LPO).toUpperCase().toString();
			if (lpo.equals(SI) || lpo.equals("S")){
				activoAdmisionDocumento.setAplica(true);
			}else if (lpo.equals(NO) || lpo.equals("N")){
				activoAdmisionDocumento.setAplica(false);
			}
			activoAdmisionDocumento.setNoValidado(true);
			activoAdmisionDocumento.setEstadoDocumento(genericDao.get(DDEstadoDocumento.class, filterEstado));
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			activoAdmisionDocumento.setFechaSolicitud(format.parse(exc.dameCelda(fila, ACT_FECHA_SOLICITUD)));
			activoAdmisionDocumento.setFechaObtencion(format.parse(exc.dameCelda(fila, ACT_FECHA_OBTENCION)));
			activoAdmisionDocumento.setFechaVerificado(format.parse(exc.dameCelda(fila, ACT_FECHA_VALIDACION)));
			
			genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);
		
		}else {
			activoAdmisionDocumento.setAplica(exc.dameCelda(fila, ACT_ES_LPO).equals(SI));
			activoAdmisionDocumento.setEstadoDocumento(genericDao.get(DDEstadoDocumento.class, filterEstado));
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			Date fecha;
			fecha = format.parse(exc.dameCelda(fila, ACT_FECHA_SOLICITUD));
			activoAdmisionDocumento.setFechaSolicitud(fecha);
			fecha = format.parse(exc.dameCelda(fila, ACT_FECHA_OBTENCION));
			activoAdmisionDocumento.setFechaObtencion(fecha);
			fecha = format.parse(exc.dameCelda(fila, ACT_FECHA_VALIDACION));
			activoAdmisionDocumento.setFechaVerificado(fecha);	
			
			genericDao.update(ActivoAdmisionDocumento.class, activoAdmisionDocumento);
		}
			
		
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
