package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;


@Entity
@Table(name = "V_PROPUESTA_ALQ_BANKIA", schema = "${entity.schema}")
public class VPropuestaAlqBankia implements Serializable {

	/**
	 *  @author Lara Pablo
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ECO_ID")
	private Long id;
	
	@Column(name = "ACT_NUM_ACTIVO_UVEM")
	private Long numActivoUvem;	
	
	@Column(name = "ALQ_CARENCIA")
	private Integer carenciaALquiler; 
		
	@Column(name = "TXO_TEXTO")
	private String textoOferta;  
	
    @Column(name = "DD_TPA_DESCRIPCION")
    private String tipoActivoDescripcion;
    
    @Column(name = "ECO_FECHA_ALTA")
   	private Date fechaAltaExpedienteComercial;

    @Column(name = "APU_FECHA_INI_ALQUILER")
   	private Date fechaPublicacionWeb;
	
	@Column(name = "ALQ_FIANZA_IMPORTE")
	private BigDecimal importeFianza;
	
	@Column(name="ALQ_FIANZA_MESES")
	private Integer mesesFianza;
	
	@Column(name = "OFR_IMPORTE")
	private BigDecimal importeOferta;
	
	@Column(name = "DD_EAL_DESCRIPCION")
	private String  descripcionEstadoPatrimonio;
	
	@Column(name = "PRO_NOMBRE")
	private String nombrePropietario;	
	
	@Column(name = "TAS_FECHA_RECEPCION_TASACION")
	private Date fechaUltimaTasacion;
    
	@Column(name = "TAS_IMPORTE_TAS_FIN")
	private BigDecimal importeTasacionFinal;
	
	@Column(name = "BIE_LOC_POBLACION")
   	private String municipio;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String calle;
	
	@Column(name = "BIE_LOC_COD_POST")
	private Integer codPostal;
	
	@Column(name = "DD_PRV_DESCRIPCION")
	private String provincia;
	
	@Column(name = "BIE_LOC_ESCALERA")
	private String escalera;
	
	@Column(name="BIE_LOC_PISO")
	private String piso;
	
	@Column(name="BIE_LOC_PUERTA")
	private String puerta;
	
	@Column(name="BIE_LOC_NUMERO_DOMICILIO")
	private Integer numDomicilio;

	@Column(name="DD_TVI_DESCRIPCION")
	private String tipoVia;
	
	@Column(name="COM_NOMBRE")
	private String compradorNombre;
	
	@Column(name="COM_APELLIDOS")
	private String compradorApellidos;
	
	@Column(name="COM_DOCUMENTO")
	private String compradorDocumento;
	
	@Column(name="DD_TPA_DESCRIPCION")
	private String tipoActivo;
	
	@Column(name="DD_CRA_DESCRIPCION")
	private String cartera;
	
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public Integer getCarenciaALquiler() {
		return carenciaALquiler;
	}

	public void setCarenciaALquiler(Integer carenciaALquiler) {
		this.carenciaALquiler = carenciaALquiler;
	}

	public String getTextoOferta() {
		return textoOferta;
	}

	public void setTextoOferta(String textoOferta) {
		this.textoOferta = textoOferta;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public Date getFechaAltaExpedienteComercial() {
		return fechaAltaExpedienteComercial;
	}

	public void setFechaAltaExpedienteComercial(Date fechaAltaExpedienteComercial) {
		this.fechaAltaExpedienteComercial = fechaAltaExpedienteComercial;
	}

	public Date getFechaPublicacionWeb() {
		return fechaPublicacionWeb;
	}

	public void setFechaPublicacionWeb(Date fechaPublicacionWeb) {
		this.fechaPublicacionWeb = fechaPublicacionWeb;
	}

	public BigDecimal getImporteFianza() {
		return importeFianza;
	}

	public void setImporteFianza(BigDecimal importeFianza) {
		this.importeFianza = importeFianza;
	}

	public Integer getMesesFianza() {
		return mesesFianza;
	}

	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}

	public BigDecimal getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(BigDecimal importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getDescripcionEstadoPatrimonio() {
		return descripcionEstadoPatrimonio;
	}

	public void setDescripcionEstadoPatrimonio(String descripcionEstadoPatrimonio) {
		this.descripcionEstadoPatrimonio = descripcionEstadoPatrimonio;
	}

	public String getNombrePropietario() {
		return nombrePropietario;
	}

	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}

	public Date getFechaUltimaTasacion() {
		return fechaUltimaTasacion;
	}

	public void setFechaUltimaTasacion(Date fechaUltimaTasacion) {
		this.fechaUltimaTasacion = fechaUltimaTasacion;
	}

	public BigDecimal getImporteTasacionFinal() {
		return importeTasacionFinal;
	}

	public void setImporteTasacionFinal(BigDecimal importeTasacionFinal) {
		this.importeTasacionFinal = importeTasacionFinal;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getCalle() {
		return calle;
	}

	public void setCalle(String calle) {
		this.calle = calle;
	}

	public Integer getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(Integer codPostal) {
		this.codPostal = codPostal;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public Integer getNumDomicilio() {
		return numDomicilio;
	}

	public void setNumDomicilio(Integer numDomicilio) {
		this.numDomicilio = numDomicilio;
	}

	public String getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(String tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getCompradorNombre() {
		return compradorNombre;
	}

	public void setCompradorNombre(String compradorNombre) {
		this.compradorNombre = compradorNombre;
	}

	public String getCompradorApellidos() {
		return compradorApellidos;
	}

	public void setCompradorApellidos(String compradorApellidos) {
		this.compradorApellidos = compradorApellidos;
	}

	public String getCompradorDocumento() {
		return compradorDocumento;
	}

	public void setCompradorDocumento(String compradorDocumento) {
		this.compradorDocumento = compradorDocumento;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}