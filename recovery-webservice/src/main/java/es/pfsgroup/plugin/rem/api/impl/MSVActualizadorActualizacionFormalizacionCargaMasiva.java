package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;

@Component
public class MSVActualizadorActualizacionFormalizacionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	private static final int COL_NUM_EXPEDIENTE_COMERCIAL = 0;
	private static final int COL_FINANCIACION = 1;
	private static final int COL_ENTIDAD_FINANCIERA = 2;
	private static final int COL_NUM_EXPEDIENTE = 3;
	private static final int COL_TIPO_DE_FINANCIACION = 4;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final String SI = "SI";
	private static final String NO = "NO";
	

	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FORMALIZACION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException, Exception {
				
		CondicionanteExpediente coe = genericDao.get(CondicionanteExpediente.class, genericDao.createFilter(FilterType.EQUALS,"expediente.numExpediente", Long.parseLong(exc.dameCelda(fila, COL_NUM_EXPEDIENTE_COMERCIAL))));
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_FINANCIACION)))  {
			if(exc.dameCelda(fila,COL_FINANCIACION).trim().equals("@")) {
				coe.setSolicitaFinanciacion(null);
			}
			else if(SI.equals(exc.dameCelda(fila,COL_FINANCIACION))) {
				coe.setSolicitaFinanciacion(1);
				DDEntidadFinanciera entidadFinanciera = genericDao.get(DDEntidadFinanciera.class, genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA)));
				coe.setEntidadFinanciera(entidadFinanciera);
			} else if (NO.equals(exc.dameCelda(fila,COL_FINANCIACION))) {
				coe.setSolicitaFinanciacion(0);
			}			
		}
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA))) {
			if(exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA).trim().equals("@")) {
				coe.setEntidadFinanciera(null);
			}else {
				DDEntidadFinanciera entidadFinanciera = genericDao.get(DDEntidadFinanciera.class, genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA)));
				coe.setEntidadFinanciera(entidadFinanciera);
			}
		
			
		}
		
		//Numero de expediente
		Formalizacion form = genericDao.get(Formalizacion.class,genericDao.createFilter(FilterType.EQUALS,"numExpediente", exc.dameCelda(fila, COL_NUM_EXPEDIENTE)));	
		if(exc.dameCelda(fila, COL_NUM_EXPEDIENTE).trim().equals("@")) {		
			form.setNumExpediente(null);
		}else {						
			form.setNumExpediente(exc.dameCelda(fila, COL_NUM_EXPEDIENTE));
	}
		
		
		if(!Checks.esNulo(exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION))) {
			
			if(exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION).trim().equals("@")) {
				coe.setEstadoFinanciacion(null);
			}else {
				DDEstadoFinanciacion estadoFinanciacion = genericDao.get(DDEstadoFinanciacion.class, genericDao.createFilter(FilterType.EQUALS,"codigo", exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION)));
				coe.setEstadoFinanciacion(estadoFinanciacion);
			}
		
		}
		
		
		genericDao.update(CondicionanteExpediente.class, coe);	
		genericDao.update(Formalizacion.class, form);
		
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
