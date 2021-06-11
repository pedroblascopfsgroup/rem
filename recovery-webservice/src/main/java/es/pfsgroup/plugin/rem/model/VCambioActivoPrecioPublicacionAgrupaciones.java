package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES", schema = "${entity.schema}")
public class VCambioActivoPrecioPublicacionAgrupaciones implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "AGR_ID")
	private Long id;
		
	@Column(name = "CAMBIO_ESTADO_ACTIVO")
	private Boolean cambioEstadoActivo;
	
	@Column(name = "CAMBIO_ESTADO_PRECIO")
	private Boolean cambioEstadoPrecio;
	
	@Column(name = "CAMBIO_ESTADO_PUBLICACION")
	private Boolean cambioEstadoPublicacion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Boolean getCambioEstadoActivo() {
		return cambioEstadoActivo;
	}

	public void setCambioEstadoActivo(Boolean cambioEstadoActivo) {
		this.cambioEstadoActivo = cambioEstadoActivo;
	}

	public Boolean getCambioEstadoPrecio() {
		return cambioEstadoPrecio;
	}

	public void setCambioEstadoPrecio(Boolean cambioEstadoPrecio) {
		this.cambioEstadoPrecio = cambioEstadoPrecio;
	}

	public Boolean getCambioEstadoPublicacion() {
		return cambioEstadoPublicacion;
	}

	public void setCambioEstadoPublicacion(Boolean cambioEstadoPublicacion) {
		this.cambioEstadoPublicacion = cambioEstadoPublicacion;
	}

	
}
