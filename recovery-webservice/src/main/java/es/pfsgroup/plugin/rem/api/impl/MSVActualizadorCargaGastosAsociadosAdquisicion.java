package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.impl.MSVSDocAdministrativaProcesar.COL_NUM;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.GastoAsociadoAdquisicion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoAsociado;

@Component
public class MSVActualizadorCargaGastosAsociadosAdquisicion extends AbstractMSVActualizador implements MSVLiberator {
	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GASTOS_ASOCIADOS_ADQUISICION;
	
	public static final class COL_NUM {
	static final int COL_NUM_ACTIVO = 0;
	static final int COL_TIPO_GASTO = 1;
	static final int COL_F_SOLICITUD = 2;
	static final int COL_F_PAGO = 3;
	static final int COL_OBSERVACIONES = 4;
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

		final String celdaNumActivo = exc.dameCelda(fila, COL_NUM.COL_NUM_ACTIVO);
		final String celdaTipoGasto = exc.dameCelda(fila, COL_NUM.COL_TIPO_GASTO);
		final String celdaFSolicitud = exc.dameCelda(fila, COL_NUM.COL_F_SOLICITUD);
		final String celdaFPago = exc.dameCelda(fila, COL_NUM.COL_F_PAGO);
		final String celdaObservaciones = exc.dameCelda(fila, COL_NUM.COL_OBSERVACIONES);

		
		final String FILTRO_CODIGO = "codigo";		
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaNumActivo));
		
		//Tipo Gasto Asociado
		Filter filtroCeldaTipoGasto = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaTipoGasto);
		DDTipoGastoAsociado tipoGastoAsociado = genericDao.get(DDTipoGastoAsociado.class, filtroCeldaTipoGasto);
		GastoAsociadoAdquisicion gasAdq = new GastoAsociadoAdquisicion();
						
		//ACTIVO 
		if(gasAdq != null) {
			gasAdq.setActivo(activo);				
		}
		
		//Gasto Asociado
		if(tipoGastoAsociado !=null) {
			gasAdq.setGastoAsociado(tipoGastoAsociado);
		}
		
		//Fechas
		if(celdaFPago!= null && celdaFSolicitud!=null) {
			gasAdq.setFechaSolicitudGastoAsociado(formato.parse(celdaFSolicitud));
			gasAdq.setFechaPagoGastoAsociado(formato.parse(celdaFPago));
		}
		
		//Observaciones
		if(celdaObservaciones!=null) {
			gasAdq.setObservaciones(celdaObservaciones);
		}
		
		genericDao.save(GastoAsociadoAdquisicion.class, gasAdq);
		return new ResultadoProcesarFila();		
	}

}


