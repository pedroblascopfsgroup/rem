package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class MSVActualizadorExlusionActivos extends AbstractMSVActualizador implements MSVLiberator{
protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_EXCLUSION_DWH;
	}
	
	private static final class COL_NUM {
		static final int NUM_ACTIVO_HAYA = 0;
		static final int FECHA_VENTA = 1;
		static final int IMPORTE_VENTA = 2;
		static final int EXCLUIR_DWH = 3;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA)));
		Double importeVenta = Double.parseDouble(exc.dameCelda(fila, COL_NUM.IMPORTE_VENTA));
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaVenta = sdf.parse(exc.dameCelda(fila, COL_NUM.FECHA_VENTA));
		Integer exluirDwh = Integer.parseInt(exc.dameCelda(fila, COL_NUM.EXCLUIR_DWH));
		
		if(exluirDwh == 1){
			activo.setExcluirDwh(true);
			activo.setFechaVentaExterna(fechaVenta);
			activo.setImporteVentaExterna(importeVenta);
			genericDao.save(Activo.class, activo);
		}
		
		return new ResultadoProcesarFila();
	}
}
