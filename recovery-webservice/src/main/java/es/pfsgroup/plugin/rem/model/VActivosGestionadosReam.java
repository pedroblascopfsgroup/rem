package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name = "V_ACTIVOS_GESTIONADOS_REAM", schema = "${entity.schema}")
public class VActivosGestionadosReam implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ACT_ID")
	private Long idActivo;


	public Long getIdActivo() {
		return idActivo;
	}


	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
		
    
	
}