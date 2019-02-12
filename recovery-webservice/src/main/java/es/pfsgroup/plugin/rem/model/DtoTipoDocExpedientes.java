package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

public class DtoTipoDocExpedientes extends WebDto implements Comparable<DtoTipoDocExpedientes>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private String codigo;
	private String descripcion;
	private String descripcionLarga;
	private Integer vinculable;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	public Integer getVinculable() {
		return vinculable;
	}
	public void setVinculable(Integer vinculable) {
		this.vinculable = vinculable;
	}
	
	@Override
	public int compareTo(DtoTipoDocExpedientes o) {
		
		if(!Checks.esNulo(this.getCodigo()) || !Checks.esNulo(o.getCodigo())){
			if(Checks.esNulo(this.getCodigo())){
				return -1;
			}
			else if(Checks.esNulo(o.getCodigo())){
				return 1;
			}
			return o.getCodigo().compareTo(this.getCodigo());
		}
		else{
			return o.getId().compareTo(this.getId());
		}
	}
	
}
