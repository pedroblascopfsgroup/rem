package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_SUBDIVISIONES_AGRUPACION", schema = "${entity.schema}")
public class VSubdivisionesAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "AGR_ID")
	private Long agrupacionId;	
	
    @Column(name = "DESCRIPCION")
    private String descripcion;
    
    @Column(name = "NUM_ACTIVOS")
   	private Integer numActivos;
    
    @Column(name = "DORMITORIOS")
   	private Integer dormitorios;
    
    @Column(name = "PLANTAS")
   	private Integer plantas;

  

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getAgrupacionId() {
		return agrupacionId;
	}

	public void setAgrupacionId(Long agrupacionId) {
		this.agrupacionId = agrupacionId;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getNumActivos() {
		return numActivos;
	}

	public void setNumActivos(Integer numActivos) {
		this.numActivos = numActivos;
	}

	public Integer getDormitorios() {
		return dormitorios;
	}

	public void setDormitorios(Integer dormitorios) {
		this.dormitorios = dormitorios;
	}

	public Integer getPlantas() {
		return plantas;
	}

	public void setPlantas(Integer plantas) {
		this.plantas = plantas;
	}


	


}