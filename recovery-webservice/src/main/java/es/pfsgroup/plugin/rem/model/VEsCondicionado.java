package es.pfsgroup.plugin.rem.model;



import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Gestiona la vista de V_ES_CONDICIONADO
 */
@Entity
@Table(name = "V_ES_CONDICIONADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)

public class VEsCondicionado  implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_ID")
    private Long idActivo;
	
	@Column(name = "ES_CONDICIONADO")
	private Boolean isCondicionado;

	
	
	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Boolean getIsCondicionado() {
		return isCondicionado;
	}

	public void setIsCondicionado(Boolean isCondicionado) {
		this.isCondicionado = isCondicionado;
	}

	



	
	

}
