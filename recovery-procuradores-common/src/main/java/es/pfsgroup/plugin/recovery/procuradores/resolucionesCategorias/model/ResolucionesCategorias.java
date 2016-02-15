package es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "VTAR_RESOLUCIONES_CATEGORIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class ResolucionesCategorias implements Serializable{

	private static final long serialVersionUID = 2981071737733535390L;
	
	@Id
	@Column(name = "CAT_ID")
	private Long id;
	
	@Column(name = "COUNT")
	private String count;

	@Column(name = "USU_PENDIENTES")
	private Long usuario;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}
	
	public Long getUsuario() {
		return usuario;
	}

	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}
	
}