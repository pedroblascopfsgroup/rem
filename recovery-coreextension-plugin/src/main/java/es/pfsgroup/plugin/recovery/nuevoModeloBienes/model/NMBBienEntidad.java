package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.Max;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;

@Entity
@Table(name = "BIE_BIEN_ENTIDAD", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class NMBBienEntidad implements Serializable, Auditable{

	private static final long serialVersionUID = -4497097910086775262L;
	
	@Id
    @Column(name = "BIE_ID")
    private Long id;
	
    @OneToOne
    @JoinColumn(name = "DD_TBI_ID")
    private DDTipoBien tipoBien;

    @Max(value = 100, message = "bienes.validacion.participacionMenor100")
    @NotNull(message = "bienes.validacion.participacionNoNulo")
    @Column(name = "BIE_PARTICIPACION")
    private Integer participacion;

    @Column(name = "BIE_VALOR_ACTUAL")
    private Float valorActual;

    @Column(name = "BIE_IMPORTE_CARGAS")
    private Float importeCargas;

    @Column(name = "BIE_SUPERFICIE")
    private Float superficie;

    @Column(name = "BIE_POBLACION")
    private String poblacion;

    @Column(name = "BIE_DATOS_REGISTRALES")
    private String datosRegistrales;

    @Column(name = "BIE_REFERENCIA_CATASTRAL")
    private String referenciaCatastral;

    @Column(name = "BIE_DESCRIPCION")
    private String descripcionBien;

    @Column(name = "BIE_FECHA_VERIFICACION")
    private Date fechaVerificacion;
	
	@Column(name = "BIE_DREG_REFERENCIA_CATASTRAL")
    private String referenciaCatastralBien;   
	
	@Column(name = "BIE_DREG_SUPERFICIE_CONSTRUIDA")
    private Float superficieConstruida;
	
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
	
	@Column(name = "BIE_FECHA_VALOR_SUBJETIVO")
    private Date fechaValorSubjetivo;
	
	@Column(name = "BIE_IMPORTE_VALOR_SUBJETIVO")
    private Float importeValorSubjetivo;
	
	@Column(name = "BIE_FECHA_VALOR_APRECIACION")
    private Date fechaValorApreciacion;
	
	@Column(name = "BIE_IMPORTE_VALOR_APRECIACION")
    private Float importeValorApreciacion;
	
	@Column(name = "BIE_FECHA_VALOR_TASACION")
    private Date fechaValorTasacion;
	
	@Column(name = "BIE_IMPORTE_VALOR_TASACION")
    private Float importeValorTasacion;
	
	@Column(name = "BIE_LOC_POBLACION")
    private String poblacionLoc;
	
	@Column(name = "BIE_LOC_DIRECCION")
    private String direccion;
	
	@Column(name = "BIE_LOC_COD_POST")
    private String codPostal;
	
	@OneToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
	@ManyToOne
    @JoinColumn(name = "DD_ORIGEN_ID")
	private NMBDDOrigenBien origen;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPO_CARGA_ID")
	private NMBDDTipoCargaBien tipoCarga;   
	
	@Column(name = "BIE_MARCA_EXTERNOS")
    private Integer marcaExternos;
	
	@Column(name = "BIE_CODIGO_INTERNO")
    private String codigoInterno;

	@Column(name= "BIE_SOLVENCIA_NO_ENCONTRADA")
	private boolean solvenciaNoEncontrada;
	
	@Column(name= "BIE_OBSERVACIONES")
	private String observaciones;
	
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
    private Float valoracion;
	
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
	
    @Embedded
    private Auditoria auditoria;
    
  
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public NMBDDOrigenBien getOrigen() {
		return origen;
	}

	public void setOrigen(NMBDDOrigenBien origen) {
		this.origen = origen;
	}

	public String getDescripcion() {
		return getDescripcion();
	}

	public void setDescripcion(String descripcion) {
		this.setDescripcion(descripcion);
	}

	public NMBDDTipoCargaBien getTipoCarga() {
		return tipoCarga;
	}

	public void setTipoCarga(NMBDDTipoCargaBien tipoCarga) {
		this.tipoCarga = tipoCarga;
	}

	public String getCodigoInterno() {
		return codigoInterno;
	}

	public void setCodigoInterno(String codigoInterno) {
		this.codigoInterno = codigoInterno;
	}

	/**
	 * @param marcaExternos the marcaExternos to set
	 */
	public void setMarcaExternos(Integer marcaExternos) {
		this.marcaExternos = marcaExternos;
	}

	/**
	 * @return the marcaExternos
	 */
	public Integer getMarcaExternos() {
		return marcaExternos;
	}


	public void setSolvenciaNoEncontrada(boolean solvenciaNoEncontrada) {
		this.solvenciaNoEncontrada = solvenciaNoEncontrada;
	}

	public boolean isSolvenciaNoEncontrada() {
		return solvenciaNoEncontrada;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoBien getTipoBien() {
		return tipoBien;
	}

	public void setTipoBien(DDTipoBien tipoBien) {
		this.tipoBien = tipoBien;
	}

	public Integer getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Integer participacion) {
		this.participacion = participacion;
	}

	public Float getValorActual() {
		return valorActual;
	}

	public void setValorActual(Float valorActual) {
		this.valorActual = valorActual;
	}

	public Float getImporteCargas() {
		return importeCargas;
	}

	public void setImporteCargas(Float importeCargas) {
		this.importeCargas = importeCargas;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public String getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public String getDatosRegistrales() {
		return datosRegistrales;
	}

	public void setDatosRegistrales(String datosRegistrales) {
		this.datosRegistrales = datosRegistrales;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public String getDescripcionBien() {
		return descripcionBien;
	}

	public void setDescripcionBien(String descripcionBien) {
		this.descripcionBien = descripcionBien;
	}

	public Date getFechaVerificacion() {
		return fechaVerificacion;
	}

	public void setFechaVerificacion(Date fechaVerificacion) {
		this.fechaVerificacion = fechaVerificacion;
	}

	public String getReferenciaCatastralBien() {
		return referenciaCatastralBien;
	}

	public void setReferenciaCatastralBien(String referenciaCatastralBien) {
		this.referenciaCatastralBien = referenciaCatastralBien;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
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

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public Date getFechaValorSubjetivo() {
		return fechaValorSubjetivo;
	}

	public void setFechaValorSubjetivo(Date fechaValorSubjetivo) {
		this.fechaValorSubjetivo = fechaValorSubjetivo;
	}

	public Float getImporteValorSubjetivo() {
		return importeValorSubjetivo;
	}

	public void setImporteValorSubjetivo(Float importeValorSubjetivo) {
		this.importeValorSubjetivo = importeValorSubjetivo;
	}

	public Date getFechaValorApreciacion() {
		return fechaValorApreciacion;
	}

	public void setFechaValorApreciacion(Date fechaValorApreciacion) {
		this.fechaValorApreciacion = fechaValorApreciacion;
	}

	public Float getImporteValorApreciacion() {
		return importeValorApreciacion;
	}

	public void setImporteValorApreciacion(Float importeValorApreciacion) {
		this.importeValorApreciacion = importeValorApreciacion;
	}

	public Date getFechaValorTasacion() {
		return fechaValorTasacion;
	}

	public void setFechaValorTasacion(Date fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}

	public Float getImporteValorTasacion() {
		return importeValorTasacion;
	}

	public void setImporteValorTasacion(Float importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}

	public String getPoblacionLoc() {
		return poblacionLoc;
	}

	public void setPoblacionLoc(String poblacionLoc) {
		this.poblacionLoc = poblacionLoc;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
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

	public Float getValoracion() {
		return valoracion;
	}

	public void setValoracion(Float valoracion) {
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
	

}
