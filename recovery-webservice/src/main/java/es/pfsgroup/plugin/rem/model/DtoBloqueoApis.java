package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Proveedores.
 * 
 * @author Lara Pablo
 */
public class DtoBloqueoApis extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long idBloqueo;
	private String carteraCodigo;
	private String lineaNegocioCodigo;
	private String especialidadCodigo;
	private String provinciaCodigo;
	private String motivo;
	private String motivoAnterior;

	
	
	public Long getIdBloqueo() {
		return idBloqueo;
	}
	public void setIdBloqueo(Long idBloqueo) {
		this.idBloqueo = idBloqueo;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public String getLineaNegocioCodigo() {
		return lineaNegocioCodigo;
	}
	public void setLineaNegocioCodigo(String lineaNegocioCodigo) {
		this.lineaNegocioCodigo = lineaNegocioCodigo;
	}
	public String getEspecialidadCodigo() {
		return especialidadCodigo;
	}
	public void setEspecialidadCodigo(String especialidadCodigo) {
		this.especialidadCodigo = especialidadCodigo;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getMotivoAnterior() {
		return motivoAnterior;
	}

	public void setMotivoAnterior(String motivoAnterior) {
		this.motivoAnterior = motivoAnterior;
	}
}