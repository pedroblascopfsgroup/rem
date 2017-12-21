package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "ACT_ACTIVO_BNK", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBNK implements Serializable, Auditable{
	
	private static final long serialVersionUID = 4477763412715784465L;
	//terminaar de mapear todos los campos
	@Id
	@Column(name="ACT_ID")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@Column(name = "ACB_COTSIN")
	private String acbCotsin;
	
	@Version
	private Long version;	
	
	@Embedded
	private Auditoria auditoria;
	
	@Column(name="ACB_COREAE")
	private int acbCoreae;
	
	@Column(name="ACB_COREAE_TEXTO")
	private String acbCoreaeTexto;
	

	public Activo getActivo() {
		return activo;
	}


	public void setActivo(Activo activo) {
		this.activo = activo;
	}


	public String getAcbCotsin() {
		return acbCotsin;
	}


	public void setAcbCotsin(String acbCotsin) {
		this.acbCotsin = acbCotsin;
	}


	public Long getVersion() {
		return version;
	}


	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


	public int getAcbCoreae() {
		return acbCoreae;
	}


	public void setAcbCoreae(int acbCoreae) {
		this.acbCoreae = acbCoreae;
	}


	public String getAcbCoreaeTexto() {
		return acbCoreaeTexto;
	}


	public void setAcbCoreaeTexto(String acbCoreaeTexto) {
		this.acbCoreaeTexto = acbCoreaeTexto;
	}


	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}


	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}
	
	
	
	
}
