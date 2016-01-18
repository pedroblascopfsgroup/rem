//package es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.model;
//
//import java.io.Serializable;
//
//import javax.persistence.Column;
//import javax.persistence.Embedded;
//import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.SequenceGenerator;
//import javax.persistence.Table;
//import javax.persistence.Version;
//
//import org.hibernate.annotations.Cache;
//import org.hibernate.annotations.CacheConcurrencyStrategy;
//
//import es.capgemini.pfs.auditoria.Auditable;
//import es.capgemini.pfs.auditoria.model.Auditoria;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter.model.SIDHIDDTipoHitoIterInfo;
//
//@Entity
//@Table(name = "SIDHI_DAT_DD_THE_TIPO_HITO", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//public class SIDHIDDTipoHitoIter implements SIDHIDDTipoHitoIterInfo, Auditable, Serializable{
//	
//	/**
//	 * 
//	 */
//	private static final long serialVersionUID = -2425519108942977725L;
//
//	@Id
//	@Column(name = "DD_THE_ID")
//	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHITipoHitoIterGenerator")
//	@SequenceGenerator(name = "SIDHITipoHitoIterGenerator", sequenceName = "S_SIDHI_DAT_DD_THE_TIPO_HITO")
//	private Long id;
//	
//	@Column(name="DD_THE_CODIGO")
//	private String codigo;
//	
//	@Column(name="DD_THE_DESCRIPCION")
//	private String descripcion;
//	
//	@Column(name="DD_THE_DESCRIPCION_LARGA")
//	private String descripcionLarga;
//	
//	
//	@Column(name="DD_THE_CODIGO_INTERFAZ")
//	private String codigoInterfaz;
//
//	@Embedded
//	private Auditoria auditoria;
//
//	@Version
//	private Integer version;
//
//	public Long getId() {
//		return id;
//	}
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public String getCodigo() {
//		return codigo;
//	}
//
//	public void setCodigo(String codigo) {
//		this.codigo = codigo;
//	}
//
//	public String getDescripcion() {
//		return descripcion;
//	}
//
//	public void setDescripcion(String descripcion) {
//		this.descripcion = descripcion;
//	}
//
//	public String getDescripcionLarga() {
//		return descripcionLarga;
//	}
//
//	public void setDescripcionLarga(String descripcionLarga) {
//		this.descripcionLarga = descripcionLarga;
//	}
//
//	public String getCodigoInterfaz() {
//		return codigoInterfaz;
//	}
//
//	public void setCodigoInterfaz(String codigoInterfaz) {
//		this.codigoInterfaz = codigoInterfaz;
//	}
//
//	public Auditoria getAuditoria() {
//		return auditoria;
//	}
//
//	public void setAuditoria(Auditoria auditoria) {
//		this.auditoria = auditoria;
//	}
//
//	public Integer getVersion() {
//		return version;
//	}
//
//	public void setVersion(Integer version) {
//		this.version = version;
//	}
//
//	
//}
