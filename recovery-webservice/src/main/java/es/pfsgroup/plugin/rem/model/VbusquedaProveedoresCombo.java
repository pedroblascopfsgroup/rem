package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_PROVEEDORES_COMBO", schema = "${entity.schema}")
public class VbusquedaProveedoresCombo implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "PVE_ID")
	private Long id;
	
	@Column(name = "PVE_NOMBRE")
	private String descripcion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	

}
