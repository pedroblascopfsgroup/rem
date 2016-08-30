package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la disponibilidad de la publicación de un activo.
 *
 */
public class DtoCondicionantesDisponibilidad extends WebDto {
	private static final long serialVersionUID = 1L;
	
	private String idActivo;
	private Boolean ruina;
	private Boolean pendienteInscripcion;
	private Boolean obraNuevaSinDeclarar;
	private Boolean sinTomaPosesionInicial;
	private Boolean proindiviso;
	private Boolean obraNuevaEnConstruccion;
	private Boolean ocupadoConTitulo;
	private Boolean tapiado;
	private String otro;
	private Boolean ocupadoSinTitulo;
	private Boolean divHorizontalNoInscrita;
	

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public Boolean getRuina() {
		return ruina;
	}

	public void setRuina(Boolean ruina) {
		this.ruina = ruina;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getObraNuevaSinDeclarar() {
		return obraNuevaSinDeclarar;
	}

	public void setObraNuevaSinDeclarar(Boolean obraNuevaSinDeclarar) {
		this.obraNuevaSinDeclarar = obraNuevaSinDeclarar;
	}

	public Boolean getSinTomaPosesionInicial() {
		return sinTomaPosesionInicial;
	}

	public void setSinTomaPosesionInicial(Boolean sinTomaPosesionInicial) {
		this.sinTomaPosesionInicial = sinTomaPosesionInicial;
	}

	public Boolean getProindiviso() {
		return proindiviso;
	}

	public void setProindiviso(Boolean proindiviso) {
		this.proindiviso = proindiviso;
	}

	public Boolean getObraNuevaEnConstruccion() {
		return obraNuevaEnConstruccion;
	}

	public void setObraNuevaEnConstruccion(Boolean obraNuevaEnConstruccion) {
		this.obraNuevaEnConstruccion = obraNuevaEnConstruccion;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
	}

	public Boolean getTapiado() {
		return tapiado;
	}

	public void setTapiado(Boolean tapiado) {
		this.tapiado = tapiado;
	}

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getDivHorizontalNoInscrita() {
		return divHorizontalNoInscrita;
	}

	public void setDivHorizontalNoInscrita(Boolean divHorizontalNoInscrita) {
		this.divHorizontalNoInscrita = divHorizontalNoInscrita;
	}
	
	
}
