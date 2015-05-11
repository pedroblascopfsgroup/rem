package es.pfsgroup.recovery.recobroWeb.expediente.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class BusquedaExpRecobroDto extends PaginationParamsImpl{

	private static final long serialVersionUID = -3963607084877125848L;

	private String esquema;
	
	private String cartera;
	
	private String subcartera;
	
	private String motivoBaja;
	
	private String agencia;
	
	private String supervisor;
	

	public String getEsquema() {
		return esquema;
	}

	public void setEsquema(String esquema) {
		this.esquema = esquema;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(String subcartera) {
		this.subcartera = subcartera;
	}

	public String getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(String motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public String getAgencia() {
		return agencia;
	}

	public void setAgencia(String agencia) {
		this.agencia = agencia;
	}

	public String getSupervisor() {
		return supervisor;
	}

	public void setSupervisor(String supervisor) {
		this.supervisor = supervisor;
	}
	
	

}
