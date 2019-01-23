package es.pfsgroup.plugin.rem.model;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

public class DtoCondicionesActivoExpediente extends WebDto {

	
	private static final long serialVersionUID = 1L;

	private String situacionPosesoriaCodigoInformada;

	private Integer posesionInicialInformada;

	private String estadoTituloInformada;

	private String situacionPosesoriaCodigo;

	private Integer posesionInicial;

	private String estadoTitulo;
	
	private Integer eviccion;
	
	private Integer viciosOcultos;
	
	private Long ecoId;
	
	private Long idActivo;
	
	private String activos;

	public String getSituacionPosesoriaCodigoInformada() {
		return situacionPosesoriaCodigoInformada;
	}

	public void setSituacionPosesoriaCodigoInformada(String situacionPosesoriaCodigoInformada) {
		this.situacionPosesoriaCodigoInformada = situacionPosesoriaCodigoInformada;
	}

	public Integer getPosesionInicialInformada() {
		return posesionInicialInformada;
	}

	public void setPosesionInicialInformada(Integer posesionInicialInformada) {
		this.posesionInicialInformada = posesionInicialInformada;
	}

	public String getEstadoTituloInformada() {
		return estadoTituloInformada;
	}

	public void setEstadoTituloInformada(String estadoTituloInformada) {
		this.estadoTituloInformada = estadoTituloInformada;
	}

	public String getSituacionPosesoriaCodigo() {
		return situacionPosesoriaCodigo;
	}

	public void setSituacionPosesoriaCodigo(String situacionPosesoriaCodigo) {
		this.situacionPosesoriaCodigo = situacionPosesoriaCodigo;
	}

	public Integer getPosesionInicial() {
		return posesionInicial;
	}

	public void setPosesionInicial(Integer posesionInicial) {
		this.posesionInicial = posesionInicial;
	}

	public String getEstadoTitulo() {
		return estadoTitulo;
	}

	public void setEstadoTitulo(String estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}

	public Integer getEviccion() {
		return eviccion;
	}

	public void setEviccion(Integer eviccion) {
		this.eviccion = eviccion;
	}

	public Integer getViciosOcultos() {
		return viciosOcultos;
	}

	public void setViciosOcultos(Integer viciosOcultos) {
		this.viciosOcultos = viciosOcultos;
	}

	public Long getEcoId() {
		return ecoId;
	}

	public void setEcoId(Long ecoID) {
		this.ecoId = ecoID;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getActivos() {
		return activos;
	}

	public void setActivos(String activos) {
		this.activos = activos;
	}
	

}
