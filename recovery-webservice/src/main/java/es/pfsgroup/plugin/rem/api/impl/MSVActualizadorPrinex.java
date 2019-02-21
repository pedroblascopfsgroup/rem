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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVInfoDetallePrinexLbkExcelValidator;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoPrinex;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Component
public class MSVActualizadorPrinex extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoApi gastoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;

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
		Long numActivo = null;
		Activo activo = null;
		
		if(!Checks.esNulo(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.ACT_NUM_ACTIVO_HAYA))){
			numActivo = Long.valueOf(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.ACT_NUM_ACTIVO_HAYA));
			
			activo = activoApi.getByNumActivo(numActivo);
		}
		
		Boolean gastoNuevo = false;

		// obtenemos el gasto prinex si no existe lo creamos
		GastoProveedor gastoProveedor = gastoApi.getByNumGasto(gpvNumGasto);
		
		if(gastoProveedor == null){
			throw new Exception("No existe el gasto");
		}
		
		GastoPrinex gasto = null;
		
		if(!Checks.esNulo(activo)){
			Long idActivo = activo.getId();
			gasto = genericDao.get(GastoPrinex.class,
									genericDao.createFilter(FilterType.EQUALS, "idGasto", gastoProveedor.getId()),
									genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo));
		}else{
			gasto = genericDao.get(GastoPrinex.class,
									genericDao.createFilter(FilterType.EQUALS, "idGasto", gastoProveedor.getId()),
									genericDao.createFilter(FilterType.NULL, "idActivo"),
									genericDao.createFilter(FilterType.EQUALS, "promocion", Long.valueOf(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROYECTO))));
		}
				
		//SET ACT_ID Y GPV_ID
		if (Checks.esNulo(gasto)) {
			gasto = new GastoPrinex();
			gasto.setIdGasto(gastoProveedor.getId());
			if(!Checks.esNulo(activo)){
				gasto.setIdActivo(activo.getId());
			}
			gastoNuevo = true;
		}
		
		for(int columna = 1; columna < 63; columna++){
			actualizarEntidad(gasto, columna, exc, fila);
		}

		if (gastoNuevo) {
			genericDao.save(GastoPrinex.class, gasto);
		} else {
			genericDao.update(GastoPrinex.class, gasto);
		}
		gastoProveedorApi.updateGastoByPrinexLBK(exc.dameCelda(fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPV_NUM_GASTO_HAYA));
		return resultado;
	}
	
	//SET DEL RESTO DE CAMPOS
	private void actualizarEntidad(GastoPrinex entidad, Integer columna, MSVHojaExcel exc, int fila)
			throws IllegalArgumentException, IOException, ParseException {
		
		switch (columna) {
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROYECTO:
			entidad.setPromocion(dameLong(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PROYECTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_INMUEBLE:
			entidad.setTipoInmueble(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_INMUEBLE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_1:
			entidad.setClave1(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_1));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_2:
			entidad.setClave2(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_2));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_3:
			entidad.setClave3(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_3));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_4:
			entidad.setClave4(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_4));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_GASTO:
			entidad.setImporteGasto(
					dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_IMPORTE_GASTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_CONTABLE:
			entidad.setFechaContable(
					dameFecha(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_CONTABLE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO_CONTB:
			entidad.setDiarioContable(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO_CONTB));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_D347:
			entidad.setD347(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_D347));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DELEGACION:
			entidad.setDelegacion(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DELEGACION));
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
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APLICAR_RETENCION));
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
			entidad.setClaveIrpf(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SUBCLAVE_IRPF:
			entidad.setSubClaveIrpf(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SUBCLAVE_IRPF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CEUTA:
			entidad.setCeuta(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CEUTA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_IVAD:
			entidad.setCtaIvad(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_IVAD));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_IVAD:
			entidad.setSctaIvad(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_IVAD));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONDICIONES:
			entidad.setCondiciones(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONDICIONES));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_BANCO:
			entidad.setCtaBanco(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_BANCO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_BANCO:
			entidad.setSctaBanco(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_BANCO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_EFECTOS:
			entidad.setCtaEfectos(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_EFECTOS));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_EFECTOS:
			entidad.setSctaEfectos(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_EFECTOS));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APUNTE:
			entidad.setApunte(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APUNTE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CENTRODESTINO:
			entidad.setCentroDestino(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CENTRODESTINO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_FRA_SII:
			entidad.setTipoFraSii(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_FRA_SII));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE:
			entidad.setClaveRe(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD1:
			entidad.setClaveReAd1(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD1));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD2:
			entidad.setClaveReAd2(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CLAVE_RE_AD2));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_OP_INTRA:
			entidad.setTipoOpIntra(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_OP_INTRA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESC_BIENES:
			entidad.setDescBienes(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESC_BIENES));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESCRIPCION_OP:
			entidad.setDescripcionOp(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DESCRIPCION_OP));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SIMPLIFICADA:
			entidad.setSimplificada(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SIMPLIFICADA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FRA_SIMPLI_IDEN:
			entidad.setFraSimpliIden(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FRA_SIMPLI_IDEN));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1:
			entidad.setDiario1(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2:
			entidad.setDiario2(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_PARTIDA:
			entidad.setTipoPartida(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_TIPO_PARTIDA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APARTADO:
			entidad.setApartado(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_APARTADO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CAPITULO:
			entidad.setCapitulo(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CAPITULO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PARTIDA:
			entidad.setPartida(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PARTIDA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_GASTO:
			entidad.setCtaGasto(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CTA_GASTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_GASTO:
			entidad.setSctaGasto(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_SCTA_GASTO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_REPERCUTIR:
			entidad.setRepercutir(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_REPERCUTIR));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONCEPTO_FAC:
			entidad.setConceptoFac(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CONCEPTO_FAC));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_FAC:
			entidad.setFechaFac(dameFecha(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_FECHA_FAC));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_COD_COEF:
			entidad.setCodCoef(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_COD_COEF));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CODI_DIAR_IVA_V:
			entidad.setCodiDiarIvaV(
					dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CODI_DIAR_IVA_V));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PCTJE_IVA_V:
			entidad.setPctjeIvaV(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_PCTJE_IVA_V));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_NOMBRE:
			entidad.setNombre(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_NOMBRE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CARACTERISTICA:
			entidad.setCaracteristica(dameString(exc,fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_CARACTERISTICA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_BASE:
			entidad.setDiario1Base(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_BASE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_CUOTA:
			entidad.setDiario1Cuota(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_CUOTA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_TIPO:
			entidad.setDiario1Tipo(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO1_TIPO));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_BASE:
			entidad.setDiario2Base(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_BASE));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_CUOTA:
			entidad.setDiario2Cuota(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_CUOTA));
			break;
		case MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_TIPO:
			entidad.setDiario2Tipo(dameNumero(exc, fila, MSVInfoDetallePrinexLbkExcelValidator.COL_NUM.GPL_DIARIO2_TIPO));
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
		if(exc.dameCelda(fila, columna) != null && !exc.dameCelda(fila, columna).isEmpty())
			resultado = Double.valueOf(exc.dameCelda(fila, columna));
		return resultado;
	}
	
	private Long dameLong(MSVHojaExcel exc, int fila, Integer columna)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		Long resultado = null;
		if(exc.dameCelda(fila, columna) != null && !exc.dameCelda(fila, columna).isEmpty())
			resultado = Long.valueOf(exc.dameCelda(fila, columna));
		return resultado;
	}
	
	private String dameString(MSVHojaExcel exc, int fila, Integer columna)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		String resultado = null;
		if(exc.dameCelda(fila, columna) != null && !exc.dameCelda(fila, columna).isEmpty())
			resultado = exc.dameCelda(fila, columna);
		return resultado;
	}
	

}
