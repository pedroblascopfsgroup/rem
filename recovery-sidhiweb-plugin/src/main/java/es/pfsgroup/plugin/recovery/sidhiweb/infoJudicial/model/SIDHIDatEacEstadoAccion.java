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

import es.capgemini.pfs.auditoria.model.Auditoria;


@Entity
@Table(name = "SIDHI_DAT_EAC_ESTADO_ACCION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIDatEacEstadoAccion implements Serializable {

	private static final long serialVersionUID = -4509736685254119715L;

	@Id
	@Column(name = "DD_EAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIEstadoAccionGenerator")
	@SequenceGenerator(name = "SIDHIEstadoAccionGenerator", sequenceName = "S_SIDHI_DAT_EAC_ESTADO_ACCION")
	private Long id;

	@Column(name = "DD_EAC_CODIGO")
	private String codigo;
	
	@Column(name = "DD_EAC_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_EAC_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	//Getters and Setters
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

}
