package es.capgemini.pfs.asunto.dto;


public class DtoReportFaseComun {

	private String saldoIrregular;
	private String estado;
	
	private Double insinuacionLetrado = new Double(0);
	private Double contraLetrado = new Double(0);
	private Double generalLetrado = new Double(0);
	private Double especialLetrado = new Double(0);
	private Double ordinarioLetrado = new Double(0);
	private Double subordinarioLetrado = new Double(0);
	private Double noAdmLetrado = new Double(0);
	private Double contingenteLetrado = new Double(0);
	
	private Double insinuacionFinal = new Double(0);
	private Double contraFinal = new Double(0);
	private Double generalFinal = new Double(0);
	private Double especialFinal = new Double(0);
	private Double ordinarioFinal = new Double(0);
	private Double subordinarioFinal = new Double(0);
	private Double noAdmFinal = new Double(0);
	private Double contingenteFinal = new Double(0);
	
	
	public String getSaldoIrregular() {
		return saldoIrregular;
	}
	public void setSaldoIrregular(String saldoIrregular) {
		this.saldoIrregular = saldoIrregular;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public Double getInsinuacionLetrado() {
		insinuacionLetrado = contraLetrado + generalLetrado + especialLetrado + ordinarioLetrado + subordinarioLetrado + noAdmLetrado + contingenteLetrado;
		return insinuacionLetrado;
	}
	public void setInsinuacionLetrado(Double insinuacionLetrado) {
		this.insinuacionLetrado = insinuacionLetrado;
	}
	public Double getContraLetrado() {
		return contraLetrado;
	}
	public void setContraLetrado(Double contraLetrado) {
		this.contraLetrado = contraLetrado;
	}
	public Double getGeneralLetrado() {
		return generalLetrado;
	}
	public void setGeneralLetrado(Double generalLetrado) {
		this.generalLetrado = generalLetrado;
	}
	public Double getEspecialLetrado() {
		return especialLetrado;
	}
	public void setEspecialLetrado(Double especialLetrado) {
		this.especialLetrado = especialLetrado;
	}
	public Double getOrdinarioLetrado() {
		return ordinarioLetrado;
	}
	public void setOrdinarioLetrado(Double ordinarioLetrado) {
		this.ordinarioLetrado = ordinarioLetrado;
	}
	public Double getSubordinarioLetrado() {
		return subordinarioLetrado;
	}
	public void setSubordinarioLetrado(Double subordianrioLetrado) {
		this.subordinarioLetrado = subordianrioLetrado;
	}
	public Double getNoAdmLetrado() {
		return noAdmLetrado;
	}
	public void setNoAdmLetrado(Double noAdmLetrado) {
		this.noAdmLetrado = noAdmLetrado;
	}
	public Double getContingenteLetrado() {
		return contingenteLetrado;
	}
	public void setContingenteLetrado(Double contingenteLetrado) {
		this.contingenteLetrado = contingenteLetrado;
	}
	public Double getInsinuacionFinal() {
		insinuacionFinal = contraFinal + generalFinal + especialFinal + ordinarioFinal + subordinarioFinal + noAdmFinal + contingenteFinal;
		return insinuacionFinal;
	}
	public void setInsinuacionFinal(Double insinuacionFinal) {
		this.insinuacionFinal = insinuacionFinal;
	}
	public Double getContraFinal() {
		return contraFinal;
	}
	public void setContraFinal(Double contraFinal) {
		this.contraFinal = contraFinal;
	}
	public Double getGeneralFinal() {
		return generalFinal;
	}
	public void setGeneralFinal(Double generalFinal) {
		this.generalFinal = generalFinal;
	}
	public Double getEspecialFinal() {
		return especialFinal;
	}
	public void setEspecialFinal(Double especialFinal) {
		this.especialFinal = especialFinal;
	}
	public Double getOrdinarioFinal() {
		return ordinarioFinal;
	}
	public void setOrdinarioFinal(Double ordinarioFinal) {
		this.ordinarioFinal = ordinarioFinal;
	}
	public Double getSubordinarioFinal() {
		return subordinarioFinal;
	}
	public void setSubordinarioFinal(Double subordianrioFinal) {
		this.subordinarioFinal = subordianrioFinal;
	}
	public Double getNoAdmFinal() {
		return noAdmFinal;
	}
	public void setNoAdmFinal(Double noAdmFinal) {
		this.noAdmFinal = noAdmFinal;
	}
	public Double getContingenteFinal() {
		return contingenteFinal;
	}
	public void setContingenteFinal(Double contingenteFinal) {
		this.contingenteFinal = contingenteFinal;
	}
	
	
	
	
	
}
