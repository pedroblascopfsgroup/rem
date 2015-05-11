package es.pfsgroup.recovery.panelcontrol.letrados.vistas.zona.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "V_PC_CONT_ZON_ZONIFICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PCZona  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2759256585743456182L;

	
	@Column(name="NIV_ID")
	private Long id;
	
	@Id
	@Column(name="ZON_COD")
	private String codigo;
	
	@Column(name="ZON_DESCRIPCION")
	private String descripcion;

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
}
