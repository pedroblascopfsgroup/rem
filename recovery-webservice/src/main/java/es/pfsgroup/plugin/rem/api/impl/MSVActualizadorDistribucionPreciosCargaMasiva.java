
package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.recovery.api.ExpedienteApi;

@Component
public class MSVActualizadorDistribucionPreciosCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	private static final int FILA_CABECERA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int EXP_NUM_EXPEDIENTE = 0;
	private static final int ACT_NUM_ACTIVO = 1;
	private static final int ACT_IMPORTE_PARTICIPACION = 2;
	
	private static final String SI = "SI";
	private static final String NO = "NO";
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_DISTRIBUCION_PRECIOS;
	}
	
	@Autowired
	private ActivoApi activoApi;
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, ACT_NUM_ACTIVO)));
		ExpedienteComercial expediente = expedienteComercialApi.getExpedientePorActivo(activo);
		
		Double importeParticipacionActivo = Double.parseDouble(exc.dameCelda(fila, ACT_IMPORTE_PARTICIPACION));
		// Aqui buscamos el activo y el expediente si se encuentran, que deben encontrarse
		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "primaryKey.activo.id", activo.getId());
		Filter filterOferta = genericDao.createFilter(FilterType.EQUALS, "primaryKey.oferta.id", expediente.getOferta().getId());
		ActivoOferta activoOferta = genericDao.get(ActivoOferta.class, filterActivo, filterOferta);
		
		Double importeOferta = expediente.getOferta().getImporteOferta();
		activoOferta.setImporteActivoOferta(importeParticipacionActivo);
		activoOferta.setPorcentajeParticipacion(100 * (importeParticipacionActivo / importeOferta));
	
			
		genericDao.update(ActivoOferta.class, activoOferta);			
		
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}