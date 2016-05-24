package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBAdicionalBienInfo;

@Entity
@Table(name = "BIE_ADICIONAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class NMBAdicionalBien implements Serializable, Auditable, NMBAdicionalBienInfo{

	private static final long serialVersionUID = -3290771629640906608L;

	@Id
    @Column(name = "BIE_ADI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBAdicionalBienGenerator")
    @SequenceGenerator(name = "NMBAdicionalBienGenerator", sequenceName = "S_BIE_ADICIONAL")
    private Long id;
	
//	@ManyToOne
//    @JoinColumn(name = "BIE_ID")
//	private NMBBien bien;
	
	@OneToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "BIE_ID")
    private NMBBien bien;
	
	@Column(name = "BIE_ADI_NOM_EMPRESA")
    private String nomEmpresa;
	
	@Column(name = "BIE_ADI_CIF_EMPRESA")
    private String cifEmpresa;
	
	@Column(name = "BIE_ADI_COD_IAE")
    private String codIAE;
	
	@Column(name = "BIE_ADI_DES_IAE")
    private String desIAE;
	
	@OneToOne
    @JoinColumn(name = "DD_TPB_ID")
    private DDTipoProdBancario tipoProdBancario;
	
	@OneToOne
    @JoinColumn(name = "DD_TPN_ID")
    private DDTipoInmueble tipoInmueble;
	
	@Column(name = "BIE_ADI_VALORACION")
    private BigDecimal valoracion;
	
	@Column(name = "BIE_ADI_ENTIDAD")
    private String entidad;
	
	@Column(name = "BIE_ADI_NUM_CUENTA")
    private String numCuenta;
	
	@Column(name = "BIE_ADI_MATRICULA")
    private String matricula;
	
	@Column(name = "BIE_ADI_BASTIDOR")
    private String bastidor;

	@Column(name = "BIE_ADI_MODELO")
    private String modelo;
	
	@Column(name = "BIE_ADI_MARCA")
    private String marca;
	
	@Column(name = "BIE_ADI_FECHAMATRICULA")
    private Date fechaMatricula;
	
	@Column(name = "BIE_ADI_FFIN_REV_CARGA")			
	private Date fechaRevision;
	
	@Column(name = "BIE_ADI_SIN_CARGA")
	private Boolean sinCargas;
	
	@Column(name = "BIE_ADI_OBS_CARGA")
	private String observaciones;
	
	@Column(name = "BIE_ADI_DEUDA_SEGUN_JUZ")
	private Float deudaSegunJuzgado;
	
	@Column(name = "BIE_ADI_CAN_CARGAS_RESUMEN")
	private String cancelacionResumen;

	@Column(name = "BIE_ADI_CAN_CARGAS_PROPUESTA")
	private String cancelacionPropuesta;
	
	@Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public String getBastidor() {
		return bastidor;
	}

	public void setBastidor(String bastidor) {
		this.bastidor = bastidor;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getNomEmpresa() {
		return nomEmpresa;
	}

	public void setNomEmpresa(String nomEmpresa) {
		this.nomEmpresa = nomEmpresa;
	}

	public String getCifEmpresa() {
		return cifEmpresa;
	}

	public void setCifEmpresa(String cifEmpresa) {
		this.cifEmpresa = cifEmpresa;
	}

	public String getCodIAE() {
		return codIAE;
	}

	public void setCodIAE(String codIAE) {
		this.codIAE = codIAE;
	}

	public String getDesIAE() {
		return desIAE;
	}

	public void setDesIAE(String desIAE) {
		this.desIAE = desIAE;
	}

	public DDTipoProdBancario getTipoProdBancario() {
		return tipoProdBancario;
	}

	public void setTipoProdBancario(DDTipoProdBancario tipoProdBancario) {
		this.tipoProdBancario = tipoProdBancario;
	}

	public DDTipoInmueble getTipoInmueble() {
		return tipoInmueble;
	}

	public void setTipoInmueble(DDTipoInmueble tipoInmueble) {
		this.tipoInmueble = tipoInmueble;
	}

	public BigDecimal getValoracion() {
		return valoracion;
	}

	public void setValoracion(BigDecimal valoracion) {
		this.valoracion = valoracion;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}

	public String getModelo() {
		return modelo;
	}

	public void setModelo(String modelo) {
		this.modelo = modelo;
	}

	public String getMarca() {
		return marca;
	}

	public void setMarca(String marca) {
		this.marca = marca;
	}

	public Date getFechaMatricula() {
		return fechaMatricula;
	}

	public void setFechaMatricula(Date fechaMatricula) {
		this.fechaMatricula = fechaMatricula;
	}

	public Date getFechaRevision() {
		return fechaRevision;
	}

	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
	}

	public Boolean getSinCargas() {
		return sinCargas;
	}

	public void setSinCargas(Boolean sinCargas) {
		this.sinCargas = sinCargas;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Float getDeudaSegunJuzgado() {
		return deudaSegunJuzgado;
	}

	public void setDeudaSegunJuzgado(Float deudaSegunJuzgado) {
		this.deudaSegunJuzgado = deudaSegunJuzgado;
	}

	public String getCancelacionResumen() {
		return cancelacionResumen;
	}

	public void setCancelacionResumen(String cancelacionResumen) {
		this.cancelacionResumen = cancelacionResumen;
	}

	public String getCancelacionPropuesta() {
		return cancelacionPropuesta;
	}

	public void setCancelacionPropuesta(String cancelacionPropuesta) {
		this.cancelacionPropuesta = cancelacionPropuesta;
	}
}