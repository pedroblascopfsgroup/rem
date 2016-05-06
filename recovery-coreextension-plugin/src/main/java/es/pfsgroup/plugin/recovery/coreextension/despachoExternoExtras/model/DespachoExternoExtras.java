package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * PRODUCTO-1272 - Clase que representa campos adicionales a DES_DESPACHO_EXTERNO
 * @author jros
 *
 */
@Entity
@Table(name = "DEE_DESPACHO_EXTRAS", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DespachoExternoExtras implements Serializable, Auditable  {

	private static final long serialVersionUID = -7347415357949976482L;
	
	@Id
    @Column(name = "DES_ID")
	private Long id;
	
	@Column(name = "DEE_FAX")
	private String fax;
	
	/**
	 * Estado del letrado/procurador a nivel operativo. 
	 * Valores posibles:[0/1] --> [Alta/Baja] - MAPEADOS en recovery (Si esta de Alta en recovery o se le ha dado de Baja)
	 */
	@Column(name = "DEE_COD_EST_ASE")
	private String codEstAse;
	
	@Column(name = "DEE_CONTRATO_VIGOR")
	private Integer contratoVigor;
	
	@Column(name = "DEE_SERVICIO_INTEGRAL")
	private boolean servicioIntegral;
	
	@Column(name = "DEE_FECHA_SERVICIO_INTEGRAL")
	private Date fechaServicioIntegral;
	
	@Column(name = "DEE_CLASIF_CONCURSOS")
	private boolean clasifConcursos;
	
	@Column(name = "DEE_CLASIF_PERFIL")
    private Integer clasifPerfil;
	
	@Column(name = "DEE_REL_BANKIA")
    private Integer relacionBankia;
	
	@Column(name = "DEE_OFICINA_CONTACTO")
	private String	oficinaContacto;
	
	@Column(name = "DEE_ENTIDAD_CONTACTO")
	private String entidadContacto;
	
	@Column(name = "DEE_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "DEE_ENTIDAD_LIQUIDACION")
	private String entidadLiquidacion;
	
	@Column(name = "DEE_OFICINA_LIQUIDACION")
	private String oficinaLiquidacion;
	
	@Column(name = "DEE_DIGCON_LIQUIDACION")
	private String digconLiquidacion;
	
	@Column(name = "DEE_CUENTA_LIQUIDACION")
	private String cuentaLiquidacion;
	
	@Column(name = "DEE_ENTIDAD_PROVISIONES")
	private String entidadProvisiones;
	
	@Column(name = "DEE_OFICINA_PROVISIONES")
	private String oficinaProvisiones;
	
	@Column(name = "DEE_DIGCON_PROVISIONES")
	private String digconProvisiones;
	
	@Column(name = "DEE_CUENTA_PROVISIONES")
	private String cuentaProvisiones;
	
	@Column(name = "DEE_ENTIDAD_ENTREGAS")
	private String entidadEntregas;
	
	@Column(name = "DEE_OFICINA_ENTREGAS")
	private String oficinaEntregas;
	
	@Column(name = "DEE_DIGCON_ENTREGAS")
	private String digconEntregas;
	
	@Column(name = "DEE_CUENTA_ENTREGAS")
	private String cuentaEntregas;
	
	@Column(name = "DEE_CENTRO_RECUP")
	private String centroRecuperacion;
	
	@Column(name = "DEE_CORREO_ELECTRONICO")
	private String correoElectronico;
	
	@Column(name = "DEE_TIPO_DOC")
	private String tipoDocumento;
	
	@Column(name = "DEE_DOCUMENTO")
	private String documentoCif;
	
	@Column(name = "DEE_ASESORIA")
	private boolean asesoria;
	
	@Column(name = "DEE_IVA_APL")
	private Float iva;
	
	@Column(name = "DEE_IVA_DES")
	private String descripcionIVA;
	
	@Column(name = "DEE_IRPF_APL")
	private Float irpf;
	
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

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getCodEstAse() {
		return codEstAse;
	}

	public void setCodEstAse(String codEstAse) {
		this.codEstAse = codEstAse;
	}

	public Integer getContratoVigor() {
		return contratoVigor;
	}

	public void setContratoVigor(Integer contratoVigor) {
		this.contratoVigor = contratoVigor;
	}

	public boolean isServicioIntegral() {
		return servicioIntegral;
	}

	public void setServicioIntegral(boolean servicioIntegral) {
		this.servicioIntegral = servicioIntegral;
	}

	public Date getFechaServicioIntegral() {
		return fechaServicioIntegral;
	}

	public void setFechaServicioIntegral(Date fechaServicioIntegral) {
		this.fechaServicioIntegral = fechaServicioIntegral;
	}

	public boolean isClasifConcursos() {
		return clasifConcursos;
	}

	public void setClasifConcursos(boolean clasifConcursos) {
		this.clasifConcursos = clasifConcursos;
	}

	public Integer getClasifPerfil() {
		return clasifPerfil;
	}

	public void setClasifPerfil(Integer tipoPerfil) {
		this.clasifPerfil = tipoPerfil;
	}

	public Integer getRelacionBankia() {
		return relacionBankia;
	}

	public void setRelacionBankia(Integer relacionBankia) {
		this.relacionBankia = relacionBankia;
	}

	public String getOficinaContacto() {
		return oficinaContacto;
	}

	public void setOficinaContacto(String oficinaContacto) {
		this.oficinaContacto = oficinaContacto;
	}

	public String getEntidadContacto() {
		return entidadContacto;
	}

	public void setEntidadContacto(String entidadContacto) {
		this.entidadContacto = entidadContacto;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getEntidadLiquidacion() {
		return entidadLiquidacion;
	}

	public void setEntidadLiquidacion(String entidadLiquidacion) {
		this.entidadLiquidacion = entidadLiquidacion;
	}

	public String getOficinaLiquidacion() {
		return oficinaLiquidacion;
	}

	public void setOficinaLiquidacion(String oficinaLiquidacion) {
		this.oficinaLiquidacion = oficinaLiquidacion;
	}

	public String getDigconLiquidacion() {
		return digconLiquidacion;
	}

	public void setDigconLiquidacion(String digconLiquidacion) {
		this.digconLiquidacion = digconLiquidacion;
	}

	public String getCuentaLiquidacion() {
		return cuentaLiquidacion;
	}

	public void setCuentaLiquidacion(String cuentaLiquidacion) {
		this.cuentaLiquidacion = cuentaLiquidacion;
	}

	public String getEntidadProvisiones() {
		return entidadProvisiones;
	}

	public void setEntidadProvisiones(String entidadProvisiones) {
		this.entidadProvisiones = entidadProvisiones;
	}

	public String getOficinaProvisiones() {
		return oficinaProvisiones;
	}

	public void setOficinaProvisiones(String oficinaProvisiones) {
		this.oficinaProvisiones = oficinaProvisiones;
	}

	public String getDigconProvisiones() {
		return digconProvisiones;
	}

	public void setDigconProvisiones(String digconProvisiones) {
		this.digconProvisiones = digconProvisiones;
	}

	public String getCuentaProvisiones() {
		return cuentaProvisiones;
	}

	public void setCuentaProvisiones(String cuentaProvisiones) {
		this.cuentaProvisiones = cuentaProvisiones;
	}

	public String getEntidadEntregas() {
		return entidadEntregas;
	}

	public void setEntidadEntregas(String entidadEntregas) {
		this.entidadEntregas = entidadEntregas;
	}

	public String getOficinaEntregas() {
		return oficinaEntregas;
	}

	public void setOficinaEntregas(String oficinaEntregas) {
		this.oficinaEntregas = oficinaEntregas;
	}

	public String getDigconEntregas() {
		return digconEntregas;
	}

	public void setDigconEntregas(String digconEntregas) {
		this.digconEntregas = digconEntregas;
	}

	public String getCuentaEntregas() {
		return cuentaEntregas;
	}

	public void setCuentaEntregas(String cuentaEntregas) {
		this.cuentaEntregas = cuentaEntregas;
	}

	public String getCentroRecuperacion() {
		return centroRecuperacion;
	}

	public void setCentroRecuperacion(String centroRecuperacion) {
		this.centroRecuperacion = centroRecuperacion;
	}

	public String getCorreoElectronico() {
		return correoElectronico;
	}

	public void setCorreoElectronico(String correoElectronico) {
		this.correoElectronico = correoElectronico;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getDocumentoCif() {
		return documentoCif;
	}

	public void setDocumentoCif(String documentoCif) {
		this.documentoCif = documentoCif;
	}

	public boolean isAsesoria() {
		return asesoria;
	}

	public void setAsesoria(boolean asesoria) {
		this.asesoria = asesoria;
	}

	public Float getIva() {
		return iva;
	}

	public void setIva(Float iva) {
		this.iva = iva;
	}

	public String getDescripcionIVA() {
		return descripcionIVA;
	}

	public void setDescripcionIVA(String descripcionIVA) {
		this.descripcionIVA = descripcionIVA;
	}

	public Float getIrpf() {
		return irpf;
	}

	public void setIrpf(Float irpf) {
		this.irpf = irpf;
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
