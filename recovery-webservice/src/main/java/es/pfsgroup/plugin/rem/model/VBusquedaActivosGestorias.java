package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Immutable;


@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_GESTORIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Immutable
public class VBusquedaActivosGestorias implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;

    @Column(name = "DD_IGE_ID")
    private Long gestoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGestoria() {
		return gestoria;
	}

	public void setGestoria(Long gestoria) {
		this.gestoria = gestoria;
	}


}