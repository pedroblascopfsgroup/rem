package es.capgemini.pfs.termino.dto;

import es.capgemini.devon.dto.WebDto;

public class TerminoAcuerdoDto extends WebDto{
	

	private static final long serialVersionUID = -3746399692512887715L;

	private Long idAcuerdo;
	
	private Long idTipoAcuerdo;
	
	private Long idSubTipoAcuerdo;

	private Long idTipoProducto;
	
	private String modoDesembolso;
	
	private String formalizacion;
	
	private Float importe;
	
	private Float comisiones;
	
	private String periodoCarencia;
	
	private String periodicidad;
	
	private String periodoFijo;
	
	private String sistemaAmortizacion;
	
	private Float interes;
	
	private String periodoVariable;
	
	private String informeLetrado;

	public Long getIdAcuerdo() {
		return idAcuerdo;
	}

	public void setIdAcuerdo(Long idAcuerdo) {
		this.idAcuerdo = idAcuerdo;
	}

	public Long getIdTipoAcuerdo() {
		return idTipoAcuerdo;
	}
	
	public Long getIdSubTipoAcuerdo() {
		return idSubTipoAcuerdo;
	}

	public void setIdSubTipoAcuerdo(Long idSubTipoAcuerdo) {
		this.idSubTipoAcuerdo = idSubTipoAcuerdo;
	}

	public void setIdTipoAcuerdo(Long idTipoAcuerdo) {
		this.idTipoAcuerdo = idTipoAcuerdo;
	}

	public Long getIdTipoProducto() {
		return idTipoProducto;
	}

	public void setIdTipoProducto(Long idTipoProducto) {
		this.idTipoProducto = idTipoProducto;
	}

	public String getModoDesembolso() {
		return modoDesembolso;
	}

	public void setModoDesembolso(String modoDesembolso) {
		this.modoDesembolso = modoDesembolso;
	}

	public String getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(String formalizacion) {
		this.formalizacion = formalizacion;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public String getPeriodoCarencia() {
		return periodoCarencia;
	}

	public void setPeriodoCarencia(String periodoCarencia) {
		this.periodoCarencia = periodoCarencia;
	}

	public String getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	public String getPeriodoFijo() {
		return periodoFijo;
	}

	public void setPeriodoFijo(String periodoFijo) {
		this.periodoFijo = periodoFijo;
	}

	public String getSistemaAmortizacion() {
		return sistemaAmortizacion;
	}

	public void setSistemaAmortizacion(String sistemaAmortizacion) {
		this.sistemaAmortizacion = sistemaAmortizacion;
	}

	public Float getInteres() {
		return interes;
	}

	public void setInteres(Float interes) {
		this.interes = interes;
	}

	public String getPeriodoVariable() {
		return periodoVariable;
	}

	public void setPeriodoVariable(String periodoVariable) {
		this.periodoVariable = periodoVariable;
	}

	public String getInformeLetrado() {
		return informeLetrado;
	}

	public void setInformeLetrado(String informeLetrado) {
		this.informeLetrado = informeLetrado;
	}


}
