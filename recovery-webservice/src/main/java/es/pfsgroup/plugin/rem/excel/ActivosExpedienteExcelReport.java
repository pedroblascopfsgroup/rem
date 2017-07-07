package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;

public class ActivosExpedienteExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<DtoActivosExpediente> listaActivos;
	private Long numExpediente;
	private static String OK= "OK";
	private static String KO= "KO";
	private static String PENDIENTE= "PTE";
	private static String NA= "N/A";
	private static String EJERCIDO= "EJERCIDO";
	private static String VACIO="";

	public ActivosExpedienteExcelReport(List<DtoActivosExpediente> listaActivos2, Long numExpediente) {
		this.listaActivos = listaActivos2;
		this.numExpediente= numExpediente;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getCabeceras()
	 */
	@Override
	public List<String> getCabeceras() {
		
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº de expediente");
		listaCabeceras.add("Nº de activo");
		listaCabeceras.add("Condiciones jurídicas");
		listaCabeceras.add("Bloqueos");
		listaCabeceras.add("Condiciones tanteo");
		
		return listaCabeceras;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getData()
	 */
	@Override
	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		for(DtoActivosExpediente dtoActivo: listaActivos){
			List<String> fila = new ArrayList<String>();
			
			fila.add(numExpediente.toString());
			fila.add(dtoActivo.getNumActivo().toString());
			if(!Checks.esNulo(dtoActivo.getCondiciones())){
				if(dtoActivo.getCondiciones()==1){
					fila.add(OK);
				}
				else if(dtoActivo.getCondiciones()==0){
					fila.add(KO);
				}
				else{
					fila.add(PENDIENTE);
				}
			}
			else{
				fila.add(VACIO);
			}
			if(!Checks.esNulo(dtoActivo.getBloqueos())){
				if(dtoActivo.getBloqueos()==1){
					fila.add(OK);
				}
				else if(dtoActivo.getBloqueos()==0){
					fila.add(KO);
				}
				else if(dtoActivo.getBloqueos()==2){
					fila.add(PENDIENTE);
				}
			}
			else{
				fila.add(NA);
			}
			if(!Checks.esNulo(dtoActivo.getTanteos())){
				if(dtoActivo.getTanteos()==1){
					fila.add(OK);
				}
				else if(dtoActivo.getTanteos()==0){
					fila.add(KO);
				}
				else if(dtoActivo.getTanteos()==2){
					fila.add(EJERCIDO);
				}
				else if(dtoActivo.getTanteos()==3){
					fila.add(NA);
				}
			}
			else{
				fila.add(VACIO);
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.excel.ExcelReport#getReportName()
	 */
	@Override
	public String getReportName() {
		return LISTA_ACTIVOS_EXPEDIENTE_XLS;
	}
	
	

}
