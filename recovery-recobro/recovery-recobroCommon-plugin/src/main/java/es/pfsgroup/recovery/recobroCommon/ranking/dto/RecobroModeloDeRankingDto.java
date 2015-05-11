package es.pfsgroup.recovery.recobroCommon.ranking.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroModeloDeRankingDto extends WebDto{
	
	private static final long serialVersionUID = -2834373854024793226L;
	
	private Long id;
	private String nombre;
	private String estado;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}

}
