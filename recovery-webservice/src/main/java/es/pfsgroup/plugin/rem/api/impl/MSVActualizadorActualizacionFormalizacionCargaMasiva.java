package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDSnsSiNoNosabe;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRiesgoClase;

@Component
public class MSVActualizadorActualizacionFormalizacionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	private static final int COL_NUM_EXPEDIENTE_COMERCIAL = 0;
	private static final int COL_FINANCIACION = 1;
	private static final int COL_ENTIDAD_FINANCIERA = 2;
	private static final int COL_NUM_EXPEDIENTE = 3;
	private static final int COL_TIPO_DE_FINANCIACION = 4;
	private static final int COL_CAPITAL_CONCEDIDO = 5;
	private static final int COL_FECHA_POSICIONAMIENTO_PREVISTA = 6;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final String SI = "SI";
	private static final String NO = "NO";
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FORMALIZACION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		ExpedienteComercial expediente= expedienteComercialApi.findOneByNumExpediente(Long.parseLong(exc.dameCelda(fila, COL_NUM_EXPEDIENTE_COMERCIAL)));
		CondicionanteExpediente coe = genericDao.get(CondicionanteExpediente.class,
				genericDao.createFilter(FilterType.EQUALS, "expediente.id",expediente.getId()));

		if (!Checks.esNulo(exc.dameCelda(fila, COL_FINANCIACION))) {
			Filter solFinanciacion = null;
			if (exc.dameCelda(fila, COL_FINANCIACION).trim().equals("@")) {
				coe.setSolicitaFinanciacion(null);
				coe.setEntidadFinanciera(null);
			} else if (NO.equals(exc.dameCelda(fila, COL_FINANCIACION))) {
				solFinanciacion = genericDao.createFilter(FilterType.EQUALS, "codigo", "02");
				
				coe.setEntidadFinanciera(null);
			} else {
				solFinanciacion = genericDao.createFilter(FilterType.EQUALS, "codigo", "01");
				
				if (!Checks.esNulo(exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA))) {
					DDEntidadFinanciera entidadFinanciera = genericDao.get(DDEntidadFinanciera.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo",
									exc.dameCelda(fila, COL_ENTIDAD_FINANCIERA)));
					coe.setEntidadFinanciera(entidadFinanciera);
				}
			}
			if (!Checks.esNulo(solFinanciacion)) {
				DDSnsSiNoNosabe sns = genericDao.get(DDSnsSiNoNosabe.class,solFinanciacion);
				coe.setSolicitaFinanciacion(sns);
			}
			
		}
		
		String fechaPosPrevista = exc.dameCelda(fila, COL_FECHA_POSICIONAMIENTO_PREVISTA);
		if (Checks.esNulo(fechaPosPrevista) || "@".equals(fechaPosPrevista.trim())) {
			expediente.setFechaPosicionamientoPrevista(null);
		} else {
			fechaPosPrevista = fechaPosPrevista.replaceAll(" ", "").replaceAll("-", "").replaceAll("/", "");
			SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy");
			df.setLenient(false);		
			expediente.setFechaPosicionamientoPrevista(df.parse(fechaPosPrevista));			
		}		

		// Numero de expediente
		Formalizacion form = genericDao.get(Formalizacion.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id",expediente.getId()));

		if (!Checks.esNulo(exc.dameCelda(fila, COL_NUM_EXPEDIENTE))) {
			if (exc.dameCelda(fila, COL_NUM_EXPEDIENTE).trim().equals("@")) {
				form.setNumExpediente(null);
			} else {
				form.setNumExpediente(exc.dameCelda(fila, COL_NUM_EXPEDIENTE));
			}
		}

		if (!Checks.esNulo(exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION))) {
			if (exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION).trim().equals("@")) {
				form.setTipoRiesgoClase(null);
			} else {
				DDTipoRiesgoClase tipoRiesgoClase = genericDao.get(DDTipoRiesgoClase.class, genericDao
						.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_DE_FINANCIACION)));
				form.setTipoRiesgoClase(tipoRiesgoClase);
			}
		}
		
		if (!Checks.esNulo(exc.dameCelda(fila, COL_CAPITAL_CONCEDIDO))) {
			if (exc.dameCelda(fila, COL_CAPITAL_CONCEDIDO).trim().equals("@")) {
				form.setCapitalConcedido(null);
			} else {
				form.setCapitalConcedido(Double.parseDouble(exc.dameCelda(fila, COL_CAPITAL_CONCEDIDO)));
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
