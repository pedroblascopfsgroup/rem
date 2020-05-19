package es.pfsgroup.plugin.rem.model;

/**
 * Dto para el
 * @author Joaquin Bahamonde
 */
public class DtoVariablesCalculoComiteLBK {

    //Importe tasación
	private Double vta;
    
    //Importe oferta
    private Double pvb;
    
    //Valor neto contable
    private Double vnc;
    
    //Valor razonable
    private Double vr;
    
    //pvb - cco
    private Double pvn;
    
    //Suma honorarios
    private Double cco;
    
    //Importe mínimo autorizado
    private Double pmin;

    //Contiene algún importe 0 o nullo
	private Boolean importeCero;

	//Es una oferta individual
	private Boolean esIndividual;

    public Double getVta() {
		return vta;
	}
	public void setVta(Double vta) {
		this.vta = vta;
	}
	public Double getPvb() {
		return pvb;
	}
	public void setPvb(Double pvb) {
		this.pvb = pvb;
	}
	public Double getVnc() {
		return vnc;
	}
	public void setVnc(Double vnc) {
		this.vnc = vnc;
	}
	public Double getVr() {
		return vr;
	}
	public void setVr(Double vr) {
		this.vr = vr;
	}
	public Double getPvn() {
		return pvn;
	}
	public void setPvn(Double pvn) {
		this.pvn = pvn;
	}
	public Double getCco() {
		return cco;
	}
	public void setCco(Double cco) {
		this.cco = cco;
	}
	public Double getPmin() {
		return pmin;
	}
	public void setPmin(Double pmin) {
		this.pmin = pmin;
	}
	public Boolean getImporteCero() {
		return importeCero;
	}
	public void setImporteCero(Boolean importeCero) {
		this.importeCero = importeCero;
	}
	public Boolean getEsIndividual() {
		return esIndividual;
	}
	public void setEsIndividual(Boolean esIndividual) {
		this.esIndividual = esIndividual;
	}
	
      	
}