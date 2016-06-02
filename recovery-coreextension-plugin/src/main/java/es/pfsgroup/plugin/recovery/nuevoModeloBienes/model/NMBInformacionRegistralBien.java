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
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;

@Entity
@Table(name = "BIE_DATOS_REGISTRALES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBInformacionRegistralBien implements  Serializable, Auditable, NMBInformacionRegistralBienInfo{

	private static final long serialVersionUID = -5541290889342928574L;

	@Id
    @Column(name = "BIE_DREG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBDatosRegistralesBienGenerator")
    @SequenceGenerator(name = "NMBDatosRegistralesBienGenerator", sequenceName = "S_BIE_DATOS_REGISTRALES")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@Column(name = "BIE_DREG_REFERENCIA_CATASTRAL")
    private String referenciaCatastralBien;   
	
	@Column(name = "BIE_DREG_SUPERFICIE")
    private BigDecimal superficie;
	
	@Column(name = "BIE_DREG_SUPERFICIE_CONSTRUIDA")
    private BigDecimal superficieConstruida;
	
	@Column(name = "BIE_DREG_TOMO")
	private String tomo;
	
	@Column(name = "BIE_DREG_LIBRO")
	private String libro;
	
	@Column(name = "BIE_DREG_FOLIO")
	private String folio;

	@Column(name = "BIE_DREG_INSCRIPCION")
	private String inscripcion;
	
	@Column(name = "BIE_DREG_FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	
	@Column(name = "BIE_DREG_NUM_REGISTRO")
	private String numRegistro;
	
	@Column(name = "BIE_DREG_MUNICIPIO_LIBRO")
	private String municipoLibro;
	
	@Column(name = "BIE_DREG_CODIGO_REGISTRO")
	private String codigoRegistro;
	
	@Column(name = "BIE_DREG_NUM_FINCA")
    private String numFinca;
	
	@OneToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
	@OneToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;	
	
	
	@Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien nmbbien) {
		this.bien = nmbbien;
	}

	public String getReferenciaCatastralBien() {
		return referenciaCatastralBien;
	}

	public void setReferenciaCatastralBien(String referenciaCatastral) {
		this.referenciaCatastralBien = referenciaCatastral;
	}

	public BigDecimal getSuperficie() {
		return superficie;
	}

	public void setSuperficie(BigDecimal superficie) {
		this.superficie = superficie;
	}

	public BigDecimal getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(BigDecimal superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public String getTomo() {
		return tomo;
	}

	public void setTomo(String tomo) {
		this.tomo = tomo;
	}

	public String getLibro() {
		return libro;
	}

	public void setLibro(String libro) {
		this.libro = libro;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getInscripcion() {
		return inscripcion;
	}

	public void setInscripcion(String inscripcion) {
		this.inscripcion = inscripcion;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getMunicipoLibro() {
		return municipoLibro;
	}

	public void setMunicipoLibro(String municipoLibro) {
		this.municipoLibro = municipoLibro;
	}

	public String getCodigoRegistro() {
		return codigoRegistro;
	}

	public void setCodigoRegistro(String codigoRegistro) {
		this.codigoRegistro = codigoRegistro;
	}

	/**
	 * @param auditoria the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	
	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}
	
	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}
}
