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

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVInfoDetallePrinexLbkExcelValidator;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.model.GastoPrinex;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Component
public class MSVActualizadorPrinex extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoApi gastoApi;

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INFO_DETALLE_PRINEX_LBK;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		Long gpvNumGasto = Long.valueOf(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPV_NUM_GASTO_HAYA));
		Boolean gastoNuevo = false;

		// obtenemos el gasto prinex si no existe lo creamos
		GastoProveedor gastoProveedor = gastoApi.getByNumGasto(gpvNumGasto);
		
		if(gastoProveedor == null){
			throw new Exception("No existe el gasto");
		}

		GastoPrinex gasto = genericDao.get(GastoPrinex.class,
				genericDao.createFilter(FilterType.EQUALS, "id", gastoProveedor.getId()));

		if (gasto == null) {
			gasto = new GastoPrinex();
			gasto.setId(gastoProveedor.getId());
			gastoNuevo = true;
		}
		
		for(int columna = 1; columna < 49; columna++){
			actualizarEntidad(gasto, columna, exc, fila);
		}

		

		if (gastoNuevo) {
			genericDao.save(GastoPrinex.class, gasto);
		} else {
			genericDao.update(GastoPrinex.class, gasto);
		}
		return resultado;
	}

	private void actualizarEntidad(GastoPrinex entidad, Integer columna, MSVHojaExcel exc, int fila)
			throws IllegalArgumentException, IOException, ParseException {
		if (exc.dameCelda(fila, columna) == null || exc.dameCelda(fila, columna).isEmpty()) {
			return;
		}

		switch (columna) {
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_CONTABLE:
			entidad.setFechaContable(
					dameFecha(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_CONTABLE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO_CONTB:
			entidad.setDiarioContable(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO_CONTB));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_D347:
			entidad.setD347(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_D347));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DELEGACION:
			entidad.setDelegacion(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DELEGACION));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_BASE_RETENCION:
			entidad.setRetencionBase(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_BASE_RETENCION));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROCENTAJE_RETEN:
			entidad.setPorcentajeRetencion(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROCENTAJE_RETEN));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_RENTE:
			entidad.setImporteRetencion(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_RENTE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APLICAR_RETENCION:
			entidad.setAplicarRetencion(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APLICAR_RETENCION));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_BASE_IRPF:
			entidad.setBaseIrpf(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_BASE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROCENTAJE_IRPF:
			entidad.setPorcentajeIrpf(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROCENTAJE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_IRPF:
			entidad.setImporteIrpf(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_IRPF:
			entidad.setClaveIrpf(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SUBCLAVE_IRPF:
			entidad.setSubClaveIrpf(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SUBCLAVE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CEUTA:
			entidad.setCeuta(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CEUTA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_IVAD:
			entidad.setCtaIvad(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_IVAD));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_IVAD:
			entidad.setSctaIvad(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_IVAD));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONDICIONES:
			entidad.setCondiciones(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONDICIONES));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_BANCO:
			entidad.setCtaBanco(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_BANCO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_BANCO:
			entidad.setSctaBanco(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_BANCO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_EFECTOS:
			entidad.setCtaEfectos(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_EFECTOS));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_EFECTOS:
			entidad.setSctaEfectos(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_EFECTOS));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APUNTE:
			entidad.setApunte(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APUNTE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CENTRODESTINO:
			entidad.setCentroDestino(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CENTRODESTINO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_FRA_SII:
			entidad.setTipoFraSii(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_FRA_SII));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE:
			entidad.setClaveRe(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD1:
			entidad.setClaveReAd1(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD1));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD2:
			entidad.setClaveReAd2(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD2));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_OP_INTRA:
			entidad.setTipoOpIntra(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_OP_INTRA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESC_BIENES:
			entidad.setDescBienes(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESC_BIENES));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESCRIPCION_OP:
			entidad.setDescripcionOp(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESCRIPCION_OP));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SIMPLIFICADA:
			entidad.setSimplificada(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SIMPLIFICADA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FRA_SIMPLI_IDEN:
			entidad.setFraSimpliIden(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FRA_SIMPLI_IDEN));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1:
			entidad.setDiario1(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2:
			entidad.setDiario2(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_PARTIDA:
			entidad.setTipoPartida(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_PARTIDA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APARTADO:
			entidad.setApartado(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APARTADO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CAPITULO:
			entidad.setCapitulo(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CAPITULO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PARTIDA:
			entidad.setPartida(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PARTIDA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_GASTO:
			entidad.setCtaGasto(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_GASTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_GASTO:
			entidad.setSctaGasto(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_GASTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_REPERCUTIR:
			entidad.setRepercutir(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_REPERCUTIR));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONCEPTO_FAC:
			entidad.setConceptoFac(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONCEPTO_FAC));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_FAC:
			entidad.setFechaFac(dameFecha(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_FAC));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_COD_COEF:
			entidad.setCodCoef(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_COD_COEF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CODI_DIAR_IVA_V:
			entidad.setCodiDiarIvaV(
					exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CODI_DIAR_IVA_V));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PCTJE_IVA_V:
			entidad.setPctjeIvaV(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PCTJE_IVA_V));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_NOMBRE:
			entidad.setNombre(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_NOMBRE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CARACTERISTICA:
			entidad.setCaracteristica(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CARACTERISTICA));
			break;

		default:
			
		}
	}

	private Date dameFecha(MSVHojaExcel exc, int fila, Integer columna)
			throws IllegalArgumentException, IOException, ParseException {
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		String stringDate = exc.dameCelda(fila, columna);
		Date fecha = null;

		if (stringDate != null && !stringDate.isEmpty()) {
			fecha = format.parse(stringDate);
		}

		return fecha;
	}

	private Double dameNumero(MSVHojaExcel exc, int fila, Integer columna)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		Double resultado = null;
		resultado = Double.valueOf(exc.dameCelda(fila, columna));
		return resultado;
	}	
	

}
