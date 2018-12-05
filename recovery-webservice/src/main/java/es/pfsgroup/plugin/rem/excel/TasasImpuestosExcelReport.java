package es.pfsgroup.plugin.rem.excel;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VTasasImpuestos;

public class TasasImpuestosExcelReport extends AbstractExcelReport implements ExcelReport{
	private List<VTasasImpuestos> listaTasasImpuestos;
	
	public TasasImpuestosExcelReport(List<VTasasImpuestos> listaTasasImpuestos){
		this.listaTasasImpuestos = listaTasasImpuestos;
	}
	
	public List<String> getCabeceras(){
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("SOCIEDAD");
		listaCabeceras.add("VISTA");
		listaCabeceras.add("ORDEN");
		listaCabeceras.add("CIF");
		listaCabeceras.add("CODIGO");
		listaCabeceras.add("NUM.FRA");
		listaCabeceras.add("FECHA.FRA");
		listaCabeceras.add("FECHA.CONTABLE");
		listaCabeceras.add("DIARIO_CONTB");
		listaCabeceras.add("IMP.BRUTO");
		listaCabeceras.add("TOTAL");
		listaCabeceras.add("OP.ALQ");
		listaCabeceras.add("D347");
		listaCabeceras.add("TIPO.FRA");
		listaCabeceras.add("SUJ_RECC");
		listaCabeceras.add("DELEGACION");
		listaCabeceras.add("BASE_RETENCION");
		listaCabeceras.add("PORCENTAJE_RETENCION");
		listaCabeceras.add("IMPORTE_RETENCION");
		listaCabeceras.add("APLICAR_RETENCION");
		listaCabeceras.add("BASE_IRPF");
		listaCabeceras.add("PORCENTAJE_IRPF");
		listaCabeceras.add("IMPORTE_IRPF");
		listaCabeceras.add("CLAVE_IRPF");
		listaCabeceras.add("SUBCLAVE_IRPF");
		listaCabeceras.add("CEUTA");
		listaCabeceras.add("CONCEPTO");
		listaCabeceras.add("CTA_ACREEDORA");
		listaCabeceras.add("SCTA_ACREEDORA");
		listaCabeceras.add("CTA_GARANTIA");
		listaCabeceras.add("SCTA_GARANTIA");
		listaCabeceras.add("CTA_IRPF");
		listaCabeceras.add("SCTA_IRPF");
		listaCabeceras.add("CTA_IVAD");
		listaCabeceras.add("SCTA_IVAD");
		listaCabeceras.add("CONDICIONES");
		listaCabeceras.add("PAGADA");
		listaCabeceras.add("CTA_BANCO");
		listaCabeceras.add("SCTA_BANCO");
		listaCabeceras.add("CTA_EFECTOS");
		listaCabeceras.add("SCTA_EFECTOS");
		listaCabeceras.add("APUNTE");
		listaCabeceras.add("CENTRODESTINO");
		listaCabeceras.add("AUTOREPE_INVE_SUJE_PASI");
		listaCabeceras.add("SERIE_AUTOREPE");
		listaCabeceras.add("DIARIO_AUTOREPE");
		listaCabeceras.add("TIPO_FRA_SII");
		listaCabeceras.add("CLAVE_RE");
		listaCabeceras.add("CLAVE_RE_AD1");
		listaCabeceras.add("CLAVE_RE_AD2");
		listaCabeceras.add("TIPO_OP_INTRA");
		listaCabeceras.add("DESC_BIENES");
		listaCabeceras.add("DESCRIPCION_OP");
		listaCabeceras.add("SIMPLIFICADA");
		listaCabeceras.add("FRA_SIMPLI_IDEN");
		listaCabeceras.add("DIARIO1");
		listaCabeceras.add("BASE1");
		listaCabeceras.add("IVA1");
		listaCabeceras.add("CUOTA1");
		listaCabeceras.add("DIARIO2");
		listaCabeceras.add("BASE2");
		listaCabeceras.add("IVA2");
		listaCabeceras.add("CUOTA2");
		listaCabeceras.add("DIARIO3");
		listaCabeceras.add("BASE3");
		listaCabeceras.add("IVA3");
		listaCabeceras.add("CUOTA3");
		listaCabeceras.add("DIARIO4");
		listaCabeceras.add("BASE4");
		listaCabeceras.add("IVA4");
		listaCabeceras.add("CUOTA4");
		listaCabeceras.add("DIARIO5");
		listaCabeceras.add("BASE5");
		listaCabeceras.add("IVA5");
		listaCabeceras.add("CUOTA5");
		listaCabeceras.add("PROYECTO");
		listaCabeceras.add("TIPO_INMUEBLE");
		listaCabeceras.add("CLAVE1");
		listaCabeceras.add("CLAVE2");
		listaCabeceras.add("CLAVE3");
		listaCabeceras.add("CLAVE4");
		listaCabeceras.add("ID_ACTIVO");
		listaCabeceras.add("CONCEPTO_GTO_CTE");
		listaCabeceras.add("IMPORTE_GASTO");
		listaCabeceras.add("TIPO_PARTIDA");
		listaCabeceras.add("APARTADO");
		listaCabeceras.add("CAPITULO");
		listaCabeceras.add("PARTIDA");
		listaCabeceras.add("CTA_GASTO");
		listaCabeceras.add("SCTA_GASTO");
		listaCabeceras.add("REPERCUTIR");
		listaCabeceras.add("CONCEPTO_FAC");
		listaCabeceras.add("FECHA_FAC");
		listaCabeceras.add("COD_COEF");
		listaCabeceras.add("NOMBRE");
		listaCabeceras.add("CARACTERÍSTICA");
		listaCabeceras.add("CODI_DIAR_IVA_V");
		listaCabeceras.add("PCTJE_IVA_V");
		
		return listaCabeceras;
	}
	
	public List<List<String>> getData(){
		List<List<String>> valores = new ArrayList<List<String>>();
		String pattern = "dd/MM/yyyy";
		SimpleDateFormat SimpleDateFormat = new SimpleDateFormat(pattern);
		
		for(VTasasImpuestos tasaImpuesto:listaTasasImpuestos){
			if (!Checks.esNulo(tasaImpuesto)){
			List<String> fila = new ArrayList<String>();
			
			if(!Checks.esNulo(tasaImpuesto.getSociedad())) {
				fila.add(tasaImpuesto.getSociedad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getVista())) {
				fila.add(tasaImpuesto.getVista().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getOrden())) {
				fila.add(tasaImpuesto.getOrden().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCif())) {
				fila.add(tasaImpuesto.getCif());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCodigo())) {
				fila.add(tasaImpuesto.getCodigo());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getNumFra())) {
				fila.add(tasaImpuesto.getNumFra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getFechaFra())) {
				fila.add(SimpleDateFormat.format(tasaImpuesto.getFechaFra()));
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getFechaContable())) {
				fila.add(SimpleDateFormat.format(tasaImpuesto.getFechaContable()));
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDiarioContb())) {
				fila.add(tasaImpuesto.getDiarioContb());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getImporteBruto())) {
				fila.add(tasaImpuesto.getImporteBruto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getTotal())) {
				fila.add(tasaImpuesto.getTotal().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getOpAlq())) {
				fila.add(tasaImpuesto.getOpAlq());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getD347())) {
				fila.add(tasaImpuesto.getD347());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getTipoFra())) {
				fila.add(tasaImpuesto.getTipoFra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSujRecc())) {
				fila.add(tasaImpuesto.getSujRecc());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDelegacion())) {
				fila.add(tasaImpuesto.getDelegacion());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getBaseRetencion())) {
				fila.add(tasaImpuesto.getBaseRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getPorcentajeRetencion())) {
				fila.add(tasaImpuesto.getPorcentajeRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getImporteRetencion())) {
				fila.add(tasaImpuesto.getImporteRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getAplicarRetencion())) {
				fila.add(tasaImpuesto.getAplicarRetencion());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getBaseIrpf())) {
				fila.add(tasaImpuesto.getBaseIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getPorcentajeIrpf())) {
				fila.add(tasaImpuesto.getPorcentajeIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getImporteIrpf())) {
				fila.add(tasaImpuesto.getImporteIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClaveIrpf())) {
				fila.add(tasaImpuesto.getClaveIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSubClaveIrpf())) {
				fila.add(tasaImpuesto.getSubClaveIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCeuta())) {
				fila.add(tasaImpuesto.getCeuta());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getConcepto())) {
				fila.add(tasaImpuesto.getConcepto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaAcreedora())) {
				fila.add(tasaImpuesto.getCtaAcreedora().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaAcreedora())) {
				fila.add(tasaImpuesto.getSctaAcreedora());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaGarantia())) {
				fila.add(tasaImpuesto.getCtaGarantia().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaGarantia())) {
				fila.add(tasaImpuesto.getSctaGarantia());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaIrpf())) {
				fila.add(tasaImpuesto.getCtaIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaIrpf())) {
				fila.add(tasaImpuesto.getSctaIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaIvad())) {
				fila.add(tasaImpuesto.getCtaIvad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaIvad())) {
				fila.add(tasaImpuesto.getSctaIvad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCondiciones())) {
				fila.add(tasaImpuesto.getCondiciones());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getPagada())) {
				fila.add(tasaImpuesto.getPagada());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaBanco())) {
				fila.add(tasaImpuesto.getCtaBanco());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaBanco())) {
				fila.add(tasaImpuesto.getSctaBanco());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaEfectos())) {
				fila.add(tasaImpuesto.getCtaEfectos());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaEfectos())) {
				fila.add(tasaImpuesto.getSctaEfectos());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getApunte())) {
				fila.add(tasaImpuesto.getApunte());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCentrodestino())) {
				fila.add(tasaImpuesto.getCentrodestino());
			}else {
				fila.add("");
			}
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			if(!Checks.esNulo(tasaImpuesto.getTipoFraSii())) {
				fila.add(tasaImpuesto.getTipoFraSii());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClaveRe())) {
				fila.add(tasaImpuesto.getClaveRe());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClaveReAd1())) {
				fila.add(tasaImpuesto.getClaveReAd1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClaveReAd2())) {
				fila.add(tasaImpuesto.getClaveReAd2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getTipoOpIntra())) {
				fila.add(tasaImpuesto.getTipoOpIntra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDescBienes())) {
				fila.add(tasaImpuesto.getDescBienes());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDescripcionOp())) {
				fila.add(tasaImpuesto.getDescripcionOp());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSimplificada())) {
				fila.add(tasaImpuesto.getSimplificada());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getFraSImpliIden())) {
				fila.add(tasaImpuesto.getFraSImpliIden());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDiario1())) {
				fila.add(tasaImpuesto.getDiario1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getBase1())) {
				fila.add(tasaImpuesto.getBase1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getIva1())) {
				fila.add(tasaImpuesto.getIva1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCuota1())) {
				fila.add(tasaImpuesto.getCuota1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getDiario2())) {
				fila.add(tasaImpuesto.getDiario2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getBase2())) {
				fila.add(tasaImpuesto.getBase2().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getIva2())) {
				fila.add(tasaImpuesto.getIva2().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCuota2())) {
				fila.add(tasaImpuesto.getCuota2().toString());
			}else {
				fila.add("");
			}
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			fila.add("");
			
			if(!Checks.esNulo(tasaImpuesto.getProyecto())) {
				fila.add(tasaImpuesto.getProyecto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getTipoInmueble())) {
				fila.add(tasaImpuesto.getTipoInmueble());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClave1())) {
				fila.add(tasaImpuesto.getClave1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClave2())) {
				fila.add(tasaImpuesto.getClave2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClave3())) {
				fila.add(tasaImpuesto.getClave3());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getClave4())) {
				fila.add(tasaImpuesto.getClave4());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getIdActivo())) {
				fila.add(tasaImpuesto.getIdActivo().toString());
			}else {
				fila.add("");
			}
			
			fila.add("");
			
			if(!Checks.esNulo(tasaImpuesto.getImporteGasto())) {
				fila.add(tasaImpuesto.getImporteGasto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getTipoPartida())) {
				fila.add(tasaImpuesto.getTipoPartida());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getApartado())) {
				fila.add(tasaImpuesto.getApartado());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCapitulo())) {
				fila.add(tasaImpuesto.getCapitulo());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getPartida())) {
				fila.add(tasaImpuesto.getPartida());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCtaGasto())) {
				fila.add(tasaImpuesto.getCtaGasto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getSctaGasto())) {
				fila.add(tasaImpuesto.getSctaGasto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getRepercutir())) {
				fila.add(tasaImpuesto.getRepercutir());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getConceptoFac())) {
				fila.add(tasaImpuesto.getConceptoFac());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getFechaFac())) {
				fila.add(SimpleDateFormat.format(tasaImpuesto.getFechaFac()));
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCodCoef())) {
				fila.add(tasaImpuesto.getCodCoef());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getNombre())) {
				fila.add(tasaImpuesto.getNombre());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCaracteristica())) {
				fila.add(tasaImpuesto.getCaracteristica());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getCodiDiarIvaV())) {
				fila.add(tasaImpuesto.getCodiDiarIvaV());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(tasaImpuesto.getPctjeIvaV())) {
				fila.add(tasaImpuesto.getPctjeIvaV().toString());
			}else {
				fila.add("");
			}
			
			valores.add(fila);
		}}
		
		return valores;
	}
	
	public String getReportName() {
		return LISTA_TASAS_IMPUESTOS_XLS;
	}
	
}