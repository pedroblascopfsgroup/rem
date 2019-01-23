package es.pfsgroup.plugin.rem.model;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de propuesta alquiler bankia
 * @author Lara Pablo
 *
 */
public class DtoPropuestaAlqBankia extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long ecoId;
	private Long numActivoUvem;	
	private Integer carenciaALquiler; 
	private String textoOferta;
   	private Date fechaAltaExpedienteComercial;
   	private Date fechaPublicacionWeb;
	private BigDecimal importeFianza;
	private Integer mesesFianza;
	private BigDecimal importeOferta;
	private Date fechaAltaOferta;
	private String  descripcionEstadoPatrimonio;
	private String nombrePropietario;
	private Date fechaUltimaTasacion;
	private BigDecimal importeTasacionFinal;
   	private String municipio;
	private String calle;
	private Integer codPostal;
	private String provincia;
	private String escalera;
	private String piso;
	private String puerta;
	private String numDomicilio;
	private String tipoVia;
	private String compradorNombre;
	private String compradorApellidos;
	private String compradorDocumento;
	private String tipoActivo;
	private String cartera;
	private Long numeroAgrupacion;
	
	private String nombreCompleto;
	private String codPostMunicipio;
	private String direccionCompleta;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getEcoId() {
		return ecoId;
	}
	public void setEcoId(Long ecoId) {
		this.ecoId = ecoId;
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
	public String getNumDomicilio() {
		return numDomicilio;
	}
	public void setNumDomicilio(String numDomicilio) {
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
	
	
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getCodPostMunicipio() {
		return codPostMunicipio;
	}
	public void setCodPostMunicipio(String codPostMunicipio) {
		this.codPostMunicipio = codPostMunicipio;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public Date getFechaAltaOferta() {
		return fechaAltaOferta;
	}
	public void setFechaAltaOferta(Date fechaAltaOferta) {
		this.fechaAltaOferta = fechaAltaOferta;
	}
	public Long getNumeroAgrupacion() {
		return numeroAgrupacion;
	}
	public void setNumeroAgrupacion(Long numeroAgrupacion) {
		this.numeroAgrupacion = numeroAgrupacion;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
		
}