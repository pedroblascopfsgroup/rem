package es.capgemini.pfs.persona.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.persona.model.EXTPersona;

public class EXTDtoClienteResultado extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private EXTPersona persona;
	
	private Integer diasVencidos;
	
	private Float riesgoTotal;
	
	private String situacion;
	
	private String situacionFinanciera;

	public void setPersona(EXTPersona persona) {
		this.persona = persona;
	}

	public EXTPersona getPersona() {
		return persona;
	}

	public void setDiasVencidos(Integer diasVencidos) {
		this.diasVencidos = diasVencidos;
	}

	public Integer getDiasVencidos() {
		return diasVencidos;
	}

	public void setRiesgoTotal(Float riesgoTotal) {
		this.riesgoTotal = riesgoTotal;
	}

	public Float getRiesgoTotal() {
		return riesgoTotal;
	}

	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}

	public String getSituacion() {
		return situacion;
	}

	public void setSituacionFinanciera(String situacionFinanciera) {
		this.situacionFinanciera = situacionFinanciera;
	}

	public String getSituacionFinanciera() {
		return situacionFinanciera;
	}

}
