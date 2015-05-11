package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class NMBDtoProcedimientoOrigen extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7543825764046266602L;
	
	private String procedimientoOrigen;
	
	private String letrado;
	
	private String plaza;
	
	private String juzgado;
	
	private String procurador;
	
	private String numeroAutos;
	
	private String faseActual;
	
	private String hitoActual;
	
	private Date fechaEntrega;
	
	private Date fechaAuto;
	
	private String demandado;
	
	private Long codigo;
	
	
	public void setProcedimientoOrigen(String procedimientoOrigen) {
		this.procedimientoOrigen = procedimientoOrigen;
	}

	public String getProcedimientoOrigen() {
		return procedimientoOrigen;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public String getNumeroAutos() {
		return numeroAutos;
	}

	public void setNumeroAutos(String numeroAutos) {
		this.numeroAutos = numeroAutos;
	}

	public String getFaseActual() {
		return faseActual;
	}

	public void setFaseActual(String faseActual) {
		this.faseActual = faseActual;
	}

	public String getHitoActual() {
		return hitoActual;
	}

	public void setHitoActual(String hitoActual) {
		this.hitoActual = hitoActual;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public Date getFechaAuto() {
		return fechaAuto;
	}

	public void setFechaAuto(Date fechaAuto) {
		this.fechaAuto = fechaAuto;
	}

	public String getDemandado() {
		return demandado;
	}

	public void setDemandado(String demandado) {
		this.demandado = demandado;
	}

	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}

	public Long getCodigo() {
		return codigo;
	}
	
	

}
