package es.pfsgroup.plugin.recovery.masivo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO que servirá para realizar las búsquedas que contendrá estos atributos
 * y otras transferencias de información
 * 
 * @author pedro
 *
 */
public class MSVConfImpulsoAutomaticoDto extends WebDto {

	private static final long serialVersionUID = 380799789703771409L;
	
	private Long id;
	private Long idTipoJuicio;
	private Long idTarea;
	private String conProcurador;
	private Long idDespachoExterno;
	private String cartera;
	
	private String operUltimaResol;
	private Integer numDiasUltimaResol;
	private String operUltimoImpulso;
	private Integer numDiasUltimoImpulso;

	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdTipoJuicio() {
		return idTipoJuicio;
	}
	public void setIdTipoJuicio(Long idTipoJuicio) {
		this.idTipoJuicio = idTipoJuicio;
	}
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	public String getConProcurador() {
		return conProcurador;
	}
	public void setConProcurador(String conProcurador) {
		this.conProcurador = conProcurador;
	}
	public Long getIdDespachoExterno() {
		return idDespachoExterno;
	}
	public void setIdDespachoExterno(Long idDespachoExterno) {
		this.idDespachoExterno = idDespachoExterno;
	}
	
	public String getOperUltimaResol() {
		return operUltimaResol;
	}

	public void setOperUltimaResol(String operUltimaResol) {
		this.operUltimaResol = operUltimaResol;
	}

	public Integer getNumDiasUltimaResol() {
		return numDiasUltimaResol;
	}

	public void setNumDiasUltimaResol(Integer numDiasUltimaResol) {
		this.numDiasUltimaResol = numDiasUltimaResol;
	}

	public String getOperUltimoImpulso() {
		return operUltimoImpulso;
	}

	public void setOperUltimoImpulso(String operUltimoImpulso) {
		this.operUltimoImpulso = operUltimoImpulso;
	}

	public Integer getNumDiasUltimoImpulso() {
		return numDiasUltimoImpulso;
	}

	public void setNumDiasUltimoImpulso(Integer numDiasUltimoImpulso) {
		this.numDiasUltimoImpulso = numDiasUltimoImpulso;
	}
	
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
}
