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
@Table(name = "SIDHI_CFG_DD_TJU_TIPO_JUI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIDDTipoJuicio implements Serializable, Auditable, SIDHIDDTipoJuicioInfo{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1406549998868734388L;

	@Id
	@Column(name = "DD_TJU_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHITipoJuicioGenerator")
	@SequenceGenerator(name = "SIDHITipoJuicioGenerator", sequenceName = "S_SIDHI_CFG_DD_TJU_TIPO_JUICIO")
	private Long id;

	@Column(name = "DD_TJU_CODIGO")
	private String codigo;
	
	@Column(name = "DD_TJU_TPO")
	private String codigoTipoProcedimiento;
	
	@Column(name = "DD_TJU_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TJU_CODIGO_INTERFAZ")
	private String codigoInterfaz;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

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

	public String getCodigoTipoProcedimiento() {
		return codigoTipoProcedimiento;
	}

	public void setCodigoTipoProcedimiento(String codigoTipoProcedimiento) {
		this.codigoTipoProcedimiento = codigoTipoProcedimiento;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getCodigoInterfaz() {
		return codigoInterfaz;
	}

	public void setCodigoInterfaz(String codigoInterfaz) {
		this.codigoInterfaz = codigoInterfaz;
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
