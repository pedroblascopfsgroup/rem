package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
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
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

/***
 * Clase que procesa el fichero de carga masiva documentación administrativa
 */

@Component
public class MSVSDocAdministrativaProcesar extends AbstractMSVActualizador implements MSVLiberator {

	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DOCUMENTACION_ADMINISTRATIVA;

	public static final class COL_NUM {

		static final int TIPO_DOC = 0;
		static final int NUM_ACTIVO = 1;
		static final int APLICA = 2;
		static final int ESTADO = 3;
		static final int F_SOLICITUD = 4;
		static final int F_OBTENCION = 5;
		static final int F_VALIDACION = 6;
		static final int F_CADUCIDAD = 7;
		static final int F_ETIQUETA = 8;
		static final int CALIFICACION = 9;
		static final int ID_DOC = 10;		
		static final int LETRA_CONSUMO = 11;
		static final int CONSUMO = 12;
		static final int EMISION = 13;
		static final int REGISTRO = 14;

	}

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {

		final String celdaTipoDoc = exc.dameCelda(fila, COL_NUM.TIPO_DOC);
		final String celdaActivo = exc.dameCelda(fila, COL_NUM.NUM_ACTIVO);
		final String celdaAplica = exc.dameCelda(fila, COL_NUM.APLICA);
		final String celdaEstadoDoc = exc.dameCelda(fila, COL_NUM.ESTADO);
		final String celdaFsolicitud = exc.dameCelda(fila, COL_NUM.F_SOLICITUD);
		final String celdaFobtencion = exc.dameCelda(fila, COL_NUM.F_OBTENCION);
		final String celdaFvalidacion = exc.dameCelda(fila, COL_NUM.F_VALIDACION);
		final String celdaFcaducidad = exc.dameCelda(fila, COL_NUM.F_CADUCIDAD);
		final String celdaFetiqueta = exc.dameCelda(fila, COL_NUM.F_ETIQUETA);
		final String celdaCalificacion = exc.dameCelda(fila, COL_NUM.CALIFICACION);
		final String celdaIdDoc = exc.dameCelda(fila, COL_NUM.ID_DOC);
		final String celdaLetraConsumo = exc.dameCelda(fila, COL_NUM.LETRA_CONSUMO);
		final String celdaConsumo = exc.dameCelda(fila, COL_NUM.CONSUMO);
		final String celdaEmision = exc.dameCelda(fila, COL_NUM.EMISION);
		final String celdaRegistro = exc.dameCelda(fila, COL_NUM.REGISTRO);
		
		final String FILTRO_CODIGO = "codigo";		
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		
		// Activo
		Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));

		// Tipo Documento
		Filter filtroTipoDoc = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaTipoDoc);
		DDTipoDocumentoActivo tipoDocumentoActivo = genericDao.get(DDTipoDocumentoActivo.class, filtroTipoDoc);
		
		// Config Documento
		Filter filtroTPD = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.id", tipoDocumentoActivo.getId());
		Filter filtroTPA = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.id", activo.getTipoActivo().getId());	
		Filter filtroSAC = genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.id", activo.getSubtipoActivo().getId());	
		ActivoConfigDocumento activoConfigDocumento = genericDao.get(ActivoConfigDocumento.class, filtroTPD, filtroTPA, filtroSAC);		
		
		if(Checks.esNulo(activoConfigDocumento)) {
			activoConfigDocumento = new ActivoConfigDocumento();
			activoConfigDocumento.setAuditoria(Auditoria.getNewInstance());
			activoConfigDocumento.setTipoActivo(activo.getTipoActivo());
			activoConfigDocumento.setTipoDocumentoActivo(tipoDocumentoActivo);
			
			genericDao.save(ActivoConfigDocumento.class, activoConfigDocumento);
		}
		
		// Admision Documento
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter filtroCFD = genericDao.createFilter(FilterType.EQUALS, "configDocumento.id", activoConfigDocumento.getId());		
		ActivoAdmisionDocumento ado = genericDao.get(ActivoAdmisionDocumento.class, filtroActivo, filtroCFD);
		
		if(Checks.esNulo(ado)) {
			ado = new ActivoAdmisionDocumento();
			ado.setActivo(activo);
			ado.setConfigDocumento(activoConfigDocumento);
			ado.setNoValidado(false);
			ado.setAuditoria(Auditoria.getNewInstance());			
		}
		
		// Estado del documento
		Filter filtroEstadoDoc = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaEstadoDoc);
		ado.setEstadoDocumento(genericDao.get(DDEstadoDocumento.class, filtroEstadoDoc));
				
		// Calificacion
		Filter filtroCalificacion = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaCalificacion);
		ado.setTipoCalificacionEnergetica(genericDao.get(DDTipoCalificacionEnergetica.class, filtroCalificacion));
		
		// Aplica
		ado.setAplica(celdaAplica.equals("1"));
		
		// Fechas
		ado.setFechaSolicitud(Checks.esNulo(celdaFsolicitud) ? null : formato.parse(celdaFsolicitud));		
		ado.setFechaObtencion(Checks.esNulo(celdaFobtencion) ? null : formato.parse(celdaFobtencion));		
		ado.setFechaVerificado(Checks.esNulo(celdaFvalidacion) ? null : formato.parse(celdaFvalidacion));		
		ado.setFechaCaducidad(Checks.esNulo(celdaFcaducidad) ? null : formato.parse(celdaFcaducidad));		
		ado.setFechaEtiqueta(Checks.esNulo(celdaFetiqueta) ? null : formato.parse(celdaFetiqueta));
				
		// DataId Documento		
		ado.setDataIdDocumento(celdaIdDoc);
		
		// Letra Consumo
		ado.setLetraConsumo(celdaLetraConsumo);
		
		// Consumo
		ado.setConsumo(celdaConsumo);
		
		// Emision
		ado.setEmision(celdaEmision);
		
		// Registro
		ado.setRegistro(celdaRegistro);
		
		genericDao.save(ActivoAdmisionDocumento.class, ado);
		return new ResultadoProcesarFila();		
	}

}
