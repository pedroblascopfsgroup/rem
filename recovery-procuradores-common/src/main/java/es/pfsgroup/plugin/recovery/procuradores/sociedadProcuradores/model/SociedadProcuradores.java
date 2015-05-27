package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "SCP_SOCIEDAD_PROCURADORES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SociedadProcuradores implements Serializable{

	private static final long serialVersionUID = 2981071737733535390L;
	
	@Id
	@Column(name = "SOC_PRO_ID")
	private Long id;
	
	@Column(name = "NOMBRE")
	private String nombre;
	
	
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

	
}