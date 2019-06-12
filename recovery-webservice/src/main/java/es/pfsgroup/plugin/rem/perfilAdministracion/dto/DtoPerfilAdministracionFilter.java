package es.pfsgroup.plugin.rem.perfilAdministracion.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoPerfilAdministracionFilter extends WebDto {

	private static final long serialVersionUID = -9181014525642347186L;
	
	private Long id;
	private Long pefId;
	private String perfilDescripcion;
	private String perfilDescripcionLarga;
	private String perfilCodigo;
	private String funcionDescripcion;
	private String funcionDescripcionLarga;
	private int totalCount;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getPefId() {
		return pefId;
	}
	
	public void setPefId(Long pefId) {
		this.pefId = pefId;
	}

	public String getPerfilDescripcion() {
		return perfilDescripcion;
	}
	
	public void setPerfilDescripcion(String perfilDescripcion) {
		this.perfilDescripcion = perfilDescripcion;
	}

	public String getPerfilDescripcionLarga() {
		return perfilDescripcionLarga;
	}

	public void setPerfilDescripcionLarga(String perfilDescripcionLarga) {
		this.perfilDescripcionLarga = perfilDescripcionLarga;
	}

	public String getPerfilCodigo() {
		return perfilCodigo;
	}

	public void setPerfilCodigo(String perfilCodigo) {
		this.perfilCodigo = perfilCodigo;
	}

	public String getFuncionDescripcion() {
		return funcionDescripcion;
	}

	public void setFuncionDescripcion(String funcionDescripcion) {
		this.funcionDescripcion = funcionDescripcion;
	}

	public String getFuncionDescripcionLarga() {
		return funcionDescripcionLarga;
	}

	public void setFuncionDescripcionLarga(String funcionDescripcionLarga) {
		this.funcionDescripcionLarga = funcionDescripcionLarga;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}