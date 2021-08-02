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
 * Gestiona la vista de V_SIN_INFORME_APROBADO_REM
 */
@Entity
@Table(name = "V_SIN_INFORME_APROBADO_REM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class VSinInformeAprobadoRem  implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_ID")
    private Long idActivo;
	
	@Column(name = "SIN_INFORME_APROBADO_REM")
	private Boolean sinInformeAprobadoREM;

	
	
	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Boolean getSinInformeAprobadoREM() {
		return sinInformeAprobadoREM;
	}

	public void setSinInformeAprobadoREM(Boolean sinInformeAprobadoREM) {
		this.sinInformeAprobadoREM = sinInformeAprobadoREM;
	}

	
	

	

	
	

}