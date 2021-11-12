package es.pfsgroup.plugin.rem.model;
import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_DESCUENTO_COLECTIVOS", schema = "${entity.schema}")
public class VGridDescuentoColectivos implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ID_DESCUENTO")
	private Long id;
	
	@Column(name= "ID_ACTIVO")
	private Long activoId;

	@Column(name = "NUM_ACTIVO")
	private Long numActivo;		

	@Column(name = "CODIGO_DESCUENTOS")
	private String descuentosCod;
	
	@Column(name = "DESCRIPCION_DESCUENTOS")
	private String descuentosDesc;
	
	@Column(name = "CODIGO_PRECIOS")
	private String preciosCod;
	
	@Column(name = "DESCRIPCION_PRECIOS")
	private String preciosDesc;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getDescuentosCod() {
		return descuentosCod;
	}

	public void setDescuentosCod(String descuentosCod) {
		this.descuentosCod = descuentosCod;
	}

	public String getDescuentosDesc() {
		return descuentosDesc;
	}

	public void setDescuentosDesc(String descuentosDesc) {
		this.descuentosDesc = descuentosDesc;
	}

	public String getPreciosCod() {
		return preciosCod;
	}

	public void setPreciosCod(String preciosCod) {
		this.preciosCod = preciosCod;
	}

	public String getPreciosDesc() {
		return preciosDesc;
	}

	public void setPreciosDesc(String preciosDesc) {
		this.preciosDesc = preciosDesc;
	}

}

