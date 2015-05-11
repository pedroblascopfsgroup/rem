package es.pfsgroup.recovery.panelcontrol.letrados.vistas.nivel.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "V_PC_CONT_NIV_NIVELES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PCNivel  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9045150718218787184L;
	
	@Column(name="NIV_ID")
	@Id
	private Long codigo;
	
	@Column(name="NIV_DESCRIPCION")
	private String descripcion;



	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}

	public Long getCodigo() {
		return codigo;
	}

}
