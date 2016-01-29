//package es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.model;
//
//import java.io.Serializable;
//
//import javax.persistence.Column;
//import javax.persistence.Embedded;
//import javax.persistence.Entity;
//import javax.persistence.FetchType;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.JoinColumn;
//import javax.persistence.ManyToOne;
//import javax.persistence.SequenceGenerator;
//import javax.persistence.Table;
//import javax.persistence.Version;
//
//import org.hibernate.annotations.Cache;
//import org.hibernate.annotations.CacheConcurrencyStrategy;
//
//import es.capgemini.pfs.auditoria.Auditable;
//import es.capgemini.pfs.auditoria.model.Auditoria;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDSubTipoResultadoInfo;
//
//@Entity
//@Table(name = "SIDHI_DAT_SRD_SUBT_RDO", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//public class SIDHIDDSubTipoResultado implements SIDHIDDSubTipoResultadoInfo, Serializable, Auditable{
//	
//	/**
//	 * 
//	 */
//	private static final long serialVersionUID = -5474501193740174247L;
//
//	@Id
//	@Column(name = "DD_SRD_ID")
//	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHISubTiopResultadoGenerator")
//	@SequenceGenerator(name = "SIDHISubTiopResultadoGenerator", sequenceName = "S_SIDHI_DAT_SRD_SUBT_RDO")
//	private Long id;
//	
//	@Column(name="DD_SRD_CODIGO")
//	private String codigo;
//	
//	@Column(name="DD_SRD_DESCRIPCION")
//	private String descripcion;
//	
//	@Column(name="DD_SRD_DESCRIPCION_LARGA")
//	private String descripcionLarga;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TRD_ID")
//	private SIDHIDDTipoResultado tipoResultado;
//	
//	@Column(name="DD_SRD_CODIGO_INTERFAZ")
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
//	public SIDHIDDTipoResultado getTipoResultado() {
//		return tipoResultado;
//	}
//
//	public void setTipoResultado(SIDHIDDTipoResultado tipoResultado) {
//		this.tipoResultado = tipoResultado;
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
//}
