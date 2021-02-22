package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Perfil;

@Entity
@Table(name = "CVD_CONF_DOC_OCULTAR_PERFIL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionOcultarPerfilDocumento implements Auditable,Serializable {
	private static final long serialVersionUID = 1L;
	@Id
	@Column(name = "CVD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionOcultarPerfilDocumentoGenerator")
	@SequenceGenerator(name = "ConfiguracionOcultarPerfilDocumentoGenerator", sequenceName = "S_CVD_CONF_DOC_OCULTAR_PERFIL")
	private Long id;
	    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PEF_ID")
   	private Perfil perfil;
	 
	@ManyToOne
	@JoinColumn(name = "DD_TDO_ID")
	private DDTipoDocumentoEntidad tipoDocumentoEntidad; 
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Perfil getPerfil() {
		return perfil;
	}

	public void setPerfil(Perfil perfil) {
		this.perfil = perfil;
	}

	public DDTipoDocumentoEntidad getTipoDocumentoEntidad() {
		return tipoDocumentoEntidad;
	}

	public void setTipoDocumentoEntidad(DDTipoDocumentoEntidad tipoDocumentoEntidad) {
		this.tipoDocumentoEntidad = tipoDocumentoEntidad;
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
	
	
	
}
