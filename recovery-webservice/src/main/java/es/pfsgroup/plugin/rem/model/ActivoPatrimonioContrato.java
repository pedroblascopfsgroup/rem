package es.pfsgroup.plugin.rem.model;

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

/**
 * Modelo que gestiona el patrimonio de un activo.
 * 
 * @author Luis Adelantado
 */
@Entity
@Table(name = "ACT_DCA_DATOS_CONTRATO_ALQ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPatrimonioContrato implements Serializable, Auditable {

	public static final String DCA_EST_CONTRATO_ALQ = "Alquilada";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DCA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPatrimonioContratoGenerator")
	@SequenceGenerator(name = "ActivoPatrimonioContratoGenerator", sequenceName = "S_ACT_DCA_DATOS_CONTRATO_ALQ")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@Column(name = "DCA_FECHA_CREACION")
	private Date fechaCreacion;
	
	@Column(name = "DCA_CUOTA")
	private Double cuota;

	@Column(name = "DCA_NOM_PRINEX")
	private String nomPrinex;
	
	@Column(name = "DCA_UHEDIT")
	private String uhedit;
	
	@Column(name = "DCA_ID_CONTRATO")
	private String idContrato;

	@Column(name = "DCA_EST_CONTRATO")
	private String estadoContrato;
	
	@Column(name = "DCA_FECHA_FIRMA")
	private Date fechaFirma;
	
	@Column(name = "DCA_FECHA_FIN_CONTRATO")
	private Date fechaFinContrato;
	
	@Column(name = "DCA_NOMBRE_CLIENTE")
	private String inquilino;
	
	@Column(name = "DCA_DEUDA_PENDIENTE")
	private Double deudaPendiente;
	
	@Column(name = "DCA_RECIBOS_PENDIENTES")
	private Long recibosPendientes;
	
	@Column(name = "DCA_F_ULTIMO_PAGADO")
	private Date ultimoReciboPagado;
	
	@Column(name = "DCA_F_ULTIMO_ADEUDADO")
	private Date ultimoReciboAdeudado;
	
	@Column(name = "DCA_ID_CONTRATO_ANTIGUO")
	private String idContratoAntiguo;

    @Column(name = "DCA_PAZ_SOCIAL")
    private Boolean pazSocial;
    
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public Double getCuota() {
		return cuota;
	}

	public void setCuota(Double cuota) {
		this.cuota = cuota;
	}

	public String getNomPrinex() {
		return nomPrinex;
	}

	public void setNomPrinex(String nomPrinex) {
		this.nomPrinex = nomPrinex;
	}

	public String getUhedit() {
		return uhedit;
	}

	public void setUhedit(String uhedit) {
		this.uhedit = uhedit;
	}

	public String getIdContrato() {
		return idContrato;
	}

	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}

	public String getEstadoContrato() {
		return estadoContrato;
	}

	public void setEstadoContrato(String estadoContrato) {
		this.estadoContrato = estadoContrato;
	}

	public Date getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}

	public Date getFechaFinContrato() {
		return fechaFinContrato;
	}

	public void setFechaFinContrato(Date fechaFinContrato) {
		this.fechaFinContrato = fechaFinContrato;
	}

	public String getInquilino() {
		return inquilino;
	}

	public void setInquilino(String inquilino) {
		this.inquilino = inquilino;
	}

	public Double getDeudaPendiente() {
		return deudaPendiente;
	}

	public void setDeudaPendiente(Double deudaPendiente) {
		this.deudaPendiente = deudaPendiente;
	}

	public Long getRecibosPendientes() {
		return recibosPendientes;
	}

	public void setRecibosPendientes(Long recibosPendientes) {
		this.recibosPendientes = recibosPendientes;
	}

	public Date getUltimoReciboPagado() {
		return ultimoReciboPagado;
	}

	public void setUltimoReciboPagado(Date ultimoReciboPagado) {
		this.ultimoReciboPagado = ultimoReciboPagado;
	}

	public Date getUltimoReciboAdeudado() {
		return ultimoReciboAdeudado;
	}

	public void setUltimoReciboAdeudado(Date ultimoReciboAdeudado) {
		this.ultimoReciboAdeudado = ultimoReciboAdeudado;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String getIdContratoAntiguo() {
		return idContratoAntiguo;
	}

	public void setIdContratoAntiguo(String idContratoAntiguo) {
		this.idContratoAntiguo = idContratoAntiguo;
	}

	public Boolean getPazSocial() {
		return pazSocial;
	}

	public void setPazSocial(Boolean pazSocial) {
		this.pazSocial = pazSocial;
	}
}
	