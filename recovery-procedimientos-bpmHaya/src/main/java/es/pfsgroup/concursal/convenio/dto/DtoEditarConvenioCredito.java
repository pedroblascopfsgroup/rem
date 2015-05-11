package es.pfsgroup.concursal.convenio.dto;

import javax.validation.constraints.NotNull;
import es.capgemini.devon.dto.WebDto;

public class DtoEditarConvenioCredito extends WebDto{
	
	private static final long serialVersionUID = 4134246258943431546L;

	@NotNull
	private Long idConvenioCredito;
	
	private Float quita;
	
	private Float espera;
	
	private Float carencia;
	
	private String comentario;

	public void setIdConvenioCredito(Long idConvenioCredito) {
		this.idConvenioCredito = idConvenioCredito;
	}

	public Long getIdConvenioCredito() {
		return idConvenioCredito;
	}

	public void setQuita(Float quita) {
		this.quita = quita;
	}

	public Float getQuita() {
		return quita;
	}

	public void setEspera(Float espera) {
		this.espera = espera;
	}

	public Float getEspera() {
		return espera;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public String getComentario() {
		return comentario;
	}

	public void setCarencia(Float carencia) {
		this.carencia = carencia;
	}

	public Float getCarencia() {
		return carencia;
	}


}
