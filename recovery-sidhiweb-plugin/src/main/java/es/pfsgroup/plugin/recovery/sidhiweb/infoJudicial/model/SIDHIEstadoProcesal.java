package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "SIDHI_DAT_EPC_ESTADO_PROCES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIEstadoProcesal implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -9145518131553496402L;

	@Id
	@Column(name = "EPC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIEstadoProcesalGenerator")
	@SequenceGenerator(name = "SIDHIEstadoProcesalGenerator", sequenceName = "S_SIDHI_DAT_EPC_ESTADO_PROCES")
	private Long id;
	
	@Column(name = "EPC_CODIGO")
	private String codigo;
	
	@Column(name = "EPC_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "EPC_CODIGO_INTERFAZ")
	private String codigoInterfaz;
	
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigoInterfaz(String codigoInterfaz) {
		this.codigoInterfaz = codigoInterfaz;
	}

	public String getCodigoInterfaz() {
		return codigoInterfaz;
	}

	@Override
	public String toString() {
		return "SIDHIEstadoProcesal [codigo=" + codigo + ", codigoInterfaz="
				+ codigoInterfaz + ", id=" + id + "]";
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}


}
