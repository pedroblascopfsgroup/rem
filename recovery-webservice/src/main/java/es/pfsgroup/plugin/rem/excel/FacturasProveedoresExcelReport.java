package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VFacturasProveedores;

public class FacturasProveedoresExcelReport extends AbstractExcelReport implements ExcelReport{
	private List<VFacturasProveedores> listaFacturas;
	
	public FacturasProveedoresExcelReport(List<VFacturasProveedores> listaFacturas){
		this.listaFacturas = listaFacturas;
	}
	
	public List<String> getCabeceras(){
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("SOCIEDAD");
		listaCabeceras.add("VISTA");
		listaCabeceras.add("ORDEN");
		listaCabeceras.add("CIF");
		listaCabeceras.add("CODIGO");
		listaCabeceras.add("NUM_FRA");
		listaCabeceras.add("FECHA_FRA");
		listaCabeceras.add("FECHA_CONTABLE");
		listaCabeceras.add("DIARIO_CONTB");
		listaCabeceras.add("IMP_BRUTO");
		listaCabeceras.add("TOTAL");
		listaCabeceras.add("OP_ALQ");
		listaCabeceras.add("D347");
		listaCabeceras.add("TIPO_FRA");
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
		listaCabeceras.add("PROYECTO");
		listaCabeceras.add("TIPO_INMUEBLE");
		listaCabeceras.add("CLAVE1");
		listaCabeceras.add("CLAVE2");
		listaCabeceras.add("CLAVE3");
		listaCabeceras.add("CLAVE4");
		listaCabeceras.add("ID_ACTIVO");
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
		listaCabeceras.add("CODI_DIAR_IVA_V");
		listaCabeceras.add("PCTJE_IVA_V");
		listaCabeceras.add("NOMBRE");
		listaCabeceras.add("CARACTERISTICA");
		listaCabeceras.add("RUTA");
		listaCabeceras.add("ETAPA");
		listaCabeceras.add("TIPO_GASTO");
		listaCabeceras.add("SUBTIPO_GASTO");
		
		return listaCabeceras;
	}
	
	public List<List<String>> getData(){
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(VFacturasProveedores factura:listaFacturas){
			if(!Checks.esNulo(factura)){
			List<String> fila = new ArrayList<String>();
			
			if(!Checks.esNulo(factura.getSociedad())) {
				fila.add(factura.getSociedad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getVista())) {
				fila.add(factura.getVista().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getOrden())) {
				fila.add(factura.getOrden().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCif())) {
				fila.add(factura.getCif());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCodigo())) {
				fila.add(factura.getCodigo());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getNumFra())) {
				fila.add(factura.getNumFra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getFechaFra())) {
				fila.add(factura.getFechaFra().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getFechaContable())) {
				fila.add(factura.getFechaContable().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDiarioContb())) {
				fila.add(factura.getDiarioContb());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getImporteBruto())) {
				fila.add(factura.getImporteBruto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTotal())) {
				fila.add(factura.getTotal().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getOpAlq())) {
				fila.add(factura.getOpAlq());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getD347())) {
				fila.add(factura.getD347());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoFra())) {
				fila.add(factura.getTipoFra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSujRecc())) {
				fila.add(factura.getSujRecc());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDelegacion())) {
				fila.add(factura.getDelegacion());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getBaseRetencion())) {
				fila.add(factura.getBaseRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getPorcentajeRetencion())) {
				fila.add(factura.getPorcentajeRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getImporteRetencion())) {
				fila.add(factura.getImporteRetencion().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getAplicarRetencion())) {
				fila.add(factura.getAplicarRetencion());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getBaseIrpf())) {
				fila.add(factura.getBaseIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getPorcentajeIrpf())) {
				fila.add(factura.getPorcentajeIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getImporteIrpf())) {
				fila.add(factura.getImporteIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClaveIrpf())) {
				fila.add(factura.getClaveIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSubClaveIrpf())) {
				fila.add(factura.getSubClaveIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCeuta())) {
				fila.add(factura.getCeuta());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getConcepto())) {
				fila.add(factura.getConcepto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaAcreedora())) {
				fila.add(factura.getCtaAcreedora().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaAcreedora())) {
				fila.add(factura.getSctaAcreedora());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaGarantia())) {
				fila.add(factura.getCtaGarantia().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaGarantia())) {
				fila.add(factura.getSctaGarantia());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaIrpf())) {
				fila.add(factura.getCtaIrpf().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaIrpf())) {
				fila.add(factura.getSctaIrpf());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaIvad())) {
				fila.add(factura.getCtaIvad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaIvad())) {
				fila.add(factura.getSctaIvad());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCondiciones())) {
				fila.add(factura.getCondiciones());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getPagada())) {
				fila.add(factura.getPagada());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaBanco())) {
				fila.add(factura.getCtaBanco());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaBanco())) {
				fila.add(factura.getSctaBanco());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaEfectos())) {
				fila.add(factura.getCtaEfectos());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaEfectos())) {
				fila.add(factura.getSctaEfectos());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getApunte())) {
				fila.add(factura.getApunte());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCentrodestino())) {
				fila.add(factura.getCentrodestino());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoFraSii())) {
				fila.add(factura.getTipoFraSii());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClaveRe())) {
				fila.add(factura.getClaveRe());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClaveReAd1())) {
				fila.add(factura.getClaveReAd1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClaveReAd2())) {
				fila.add(factura.getClaveReAd2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoOpIntra())) {
				fila.add(factura.getTipoOpIntra());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDescBienes())) {
				fila.add(factura.getDescBienes());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDescripcionOp())) {
				fila.add(factura.getDescripcionOp());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSimplificada())) {
				fila.add(factura.getSimplificada());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getFraSImpliIden())) {
				fila.add(factura.getFraSImpliIden());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDiario1())) {
				fila.add(factura.getDiario1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getBase1())) {
				fila.add(factura.getBase1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getIva1())) {
				fila.add(factura.getIva1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCuota1())) {
				fila.add(factura.getCuota1().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getDiario2())) {
				fila.add(factura.getDiario2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getBase2())) {
				fila.add(factura.getBase2().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getIva2())) {
				fila.add(factura.getIva2().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCuota2())) {
				fila.add(factura.getCuota2().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getProyecto())) {
				fila.add(factura.getProyecto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoInmueble())) {
				fila.add(factura.getTipoInmueble());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClave1())) {
				fila.add(factura.getClave1());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClave2())) {
				fila.add(factura.getClave2());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClave3())) {
				fila.add(factura.getClave3());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getClave4())) {
				fila.add(factura.getClave4());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getIdActivo())) {
				fila.add(factura.getIdActivo().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getImporteGasto())) {
				fila.add(factura.getImporteGasto().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoPartida())) {
				fila.add(factura.getTipoPartida());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getApartado())) {
				fila.add(factura.getApartado());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCapitulo())) {
				fila.add(factura.getCapitulo());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getPartida())) {
				fila.add(factura.getPartida());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCtaGasto())) {
				fila.add(factura.getCtaGasto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSctaGasto())) {
				fila.add(factura.getSctaGasto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getRepercutir())) {
				fila.add(factura.getRepercutir());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getConceptoFac())) {
				fila.add(factura.getConceptoFac());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getFechaFac())) {
				fila.add(factura.getFechaFac().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCodCoef())) {
				fila.add(factura.getCodCoef());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCodiDiarIvaV())) {
				fila.add(factura.getCodiDiarIvaV());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getPctjeIvaV())) {
				fila.add(factura.getPctjeIvaV().toString());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getNombre())) {
				fila.add(factura.getNombre());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getCaracteristica())) {
				fila.add(factura.getCaracteristica());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getRuta())) {
				fila.add(factura.getRuta());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getEtapa())) {
				fila.add(factura.getEtapa());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getTipoGasto())) {
				fila.add(factura.getTipoGasto());
			}else {
				fila.add("");
			}
			
			if(!Checks.esNulo(factura.getSubTipoGasto())) {
				fila.add(factura.getSubTipoGasto());
			}else {
				fila.add("");
			}
			
			valores.add(fila);
		}}
		
		return valores;
	}
	
	public String getReportName() {
		return LISTA_FACTURAS_PROVEEDORES_XLS;
	}
	
}
