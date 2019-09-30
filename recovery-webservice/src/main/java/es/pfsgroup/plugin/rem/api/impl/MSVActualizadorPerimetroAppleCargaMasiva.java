package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacionApple;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;

/***
 * Clase que procesa el fichero de carga masiva valores perímetro Apple
 */
@Component
public class MSVActualizadorPerimetroAppleCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		static final int ACTIVO = 0;
		static final int SERVICER = 1;
		static final int PERIMETRO_CARTERA = 2;
		static final int NOMBRE_CARTERA = 3;
		static final int CESION_COMERCIAL = 4;
		static final int PERIMETRO_MACC = 5;
		static final int VALOR_ORDINARIO = 6;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALORES_PERIMETRO_APPLE;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		final String[] LISTA_SI = { "SI", "S" };
		final String FILTRO_CODIGO = "codigo";

		final String celdaActivo = exc.dameCelda(fila, COL_NUM.ACTIVO);
		final String celdaServicer = exc.dameCelda(fila, COL_NUM.SERVICER);
		final String celdaPerCartera = exc.dameCelda(fila, COL_NUM.PERIMETRO_CARTERA);
		final String celdaNomCartera = exc.dameCelda(fila, COL_NUM.NOMBRE_CARTERA);
		final String celdaCesionComercial = exc.dameCelda(fila, COL_NUM.CESION_COMERCIAL);
		final String celdaPerMacc = exc.dameCelda(fila, COL_NUM.PERIMETRO_MACC);
		final String celdaValorOrdinario = exc.dameCelda(fila, COL_NUM.VALOR_ORDINARIO);
		
		boolean modificado = false;

		// Número de Activo
		Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));

		// Servicer Activo
		if (!Checks.esNulo(celdaServicer)) {
			Filter filtroServicerActivo = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaServicer.toUpperCase());
			activo.setServicerActivo(genericDao.get(DDServicerActivo.class, filtroServicerActivo));
			modificado = true;
		}

		// Cesión Comercial/Saneamiento
		if (!Checks.esNulo(celdaCesionComercial)) {
			Filter filtroCesionComercial = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaCesionComercial.toUpperCase());
			activo.setCesionSaneamiento(genericDao.get(DDCesionSaneamiento.class, filtroCesionComercial));
			modificado = true;
		}

		// Valor Ordinario
		if (!Checks.esNulo(celdaValorOrdinario)) {
			Filter filtroValorOrdinario = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaValorOrdinario);
			activo.setClasificacionApple(genericDao.get(DDClasificacionApple.class, filtroValorOrdinario));
			modificado = true;
		}

		// Perímetro cartera
		if (!Checks.esNulo(celdaPerCartera)) {
			Integer perimetroCartera = 0;
			if (Arrays.asList(LISTA_SI).contains(celdaPerCartera.toUpperCase())) {
				perimetroCartera = 1;
			}
			activo.setPerimetroCartera(perimetroCartera);
			modificado = true;
		}

		// Nombre Perímetro Cartera
		if (!Checks.esNulo(celdaNomCartera)) {
			activo.setNombreCarteraPerimetro(celdaNomCartera);
			modificado = true;
		}

		// Perímetro MACC
		if (!Checks.esNulo(celdaPerMacc)) {
			Integer perimetroMacc = 0;
			if (Arrays.asList(LISTA_SI).contains(celdaPerMacc.toUpperCase())) {
				perimetroMacc = 1;
			}
			activo.setPerimetroMacc(perimetroMacc);
			modificado = true;
		}

		if(modificado) {
			activoDao.saveOrUpdate(activo);
		}
		return new ResultadoProcesarFila();
	}

}
