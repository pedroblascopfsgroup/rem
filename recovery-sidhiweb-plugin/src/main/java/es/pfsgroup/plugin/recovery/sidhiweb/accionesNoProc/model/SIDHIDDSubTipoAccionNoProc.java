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
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDSubTipoAccionNoProcInfo;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.model.SIDHIDDTipoAccionNoProcInfo;
//
//@Entity
//@Table(name = "SIDHI_DAT_SIE_SUBT_IEJUD", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//public class SIDHIDDSubTipoAccionNoProc implements SIDHIDDSubTipoAccionNoProcInfo, Serializable, Auditable{
//	
//	private static final long serialVersionUID = -3659518398486542544L;
//	
//	@Id
//	@Column(name = "DD_SIE_ID")
//	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHISubTiopAccionNoProcGenerator")
//	@SequenceGenerator(name = "SIDHISubTiopAccionNoProcGenerator", sequenceName = "S_SIDHI_DAT_SIE_SUBT_IEJUD")
//	private Long id;
//	
//	@Column(name="DD_SIE_CODIGO")
//	private String codigo;
//	
//	@Column(name="DD_SIE_DESCRIPCION")
//	private String descripcion;
//	
//	@Column(name="DD_SIE_DESCRIPCION_LARGA")
//	private String descripcionLarga;
//	
//	@ManyToOne(fetch = FetchType.EAGER)
//	@JoinColumn(name = "DD_TIE_ID")
//	private SIDHIDDTipoAccionNoProc tipoAccionNoProc;
//	
//	@Column(name="DD_SIE_CODIGO_INTERFAZ")
//	private String codigoInterfaz;
//
//	@Embedded
//	private Auditoria auditoria;
//
//	@Version
//	private Integer version;
//
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public Long getId() {
//		return id;
//	}
//
//	@Override
//	public String getCodigo() {
//		return codigo;
//	}
//
//	@Override
//	public String getCodigoInterfaz() {
//		return codigoInterfaz;
//	}
//
//	@Override
//	public String getDescripcion() {
//		return descripcion;
//	}
//
//	@Override
//	public String getDescripcionLarga() {
//		return descripcionLarga;
//	}
//
//	@Override
//	public SIDHIDDTipoAccionNoProcInfo getTipoAccionNoProc() {
//		return tipoAccionNoProc;
//	}
//
//	@Override
//	public Auditoria getAuditoria() {
//		return auditoria;
//	}
//
//	@Override
//	public void setAuditoria(Auditoria auditoria) {
//		this.auditoria=auditoria;
//	}
//
//	public void setVersion(Integer version) {
//		this.version = version;
//	}
//
//	public Integer getVersion() {
//		return version;
//	}
//
//}
