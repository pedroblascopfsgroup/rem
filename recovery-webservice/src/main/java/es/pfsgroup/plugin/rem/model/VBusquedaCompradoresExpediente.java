package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_COMPRADORES_EXP", schema = "${entity.schema}")
public class VBusquedaCompradoresExpediente implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "COM_ID")
	private String id;
	
	@Column(name="ECO_ID")
	private String idExpediente;
	
	@Column(name="NOMBRE_COMPRADOR")
	private String nombreComprador;
	
	@Column(name="DOC_COMPRADOR")
	private String numDocumentoComprador;
	
	@Column(name="NOMBRE_REPRESENTANTE")
	private String nombreRepresentante;
	
	@Column(name="DOC_REPRESENTANTE")
	private String numDocumentoRepresentante;
	
	@Column(name="PORCENTAJE_COMPRA")
	private String porcentajeCompra;
	
	@Column(name="TELEFONO")
	private String telefono;
	
	@Column(name="COM_EMAIL")
	private String email;
	
    @Column(name = "COD_ESTADO_PBC")
    private String codigoEstadoPbc;
    
    @Column(name = "DESC_ESTADO_PBC")
    private String descripcionEstadoPbc;
    
    @Column(name="CEX_RELACION_HRE")
    private String relacionHre;
    
    @Column(name="CEX_TITULAR_CONTRATACION")
    private Integer titularContratacion;
    
    @Column(name = "CEX_NUM_FACTURA")
    private String numFactura;
    
    @Column(name = "CEX_FECHA_FACTURA")
    private Date fechaFactura;
    
    @Column(name = "BORRADO")
    private Boolean borrado;
    
    @Column(name = "CEX_FECHA_BAJA")
    private Date fechaBaja;
    
    @Column(name = "COD_GRADO_PROPIEDAD")
    private String codigoGradoPropiedad;
    
    @Column(name = "DESC_GRADO_PROPIEDAD")
    private String descripcionGradoPropiedad;
    
    @Column(name = "ADC_NAME")
    private String nombreAdjunto;
    
    @Column(name = "CEX_ID_PERSONA_HAYA")
    private String idPersonaHaya;
    
    @Column(name = "ADCOM_ID")
    private Long idDocAdjunto;
    
    @Column(name = "ADC_ID_DOCUMENTO_REST")
    private Long idDocRestClient;
    
    
    
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getNombreComprador() {
		return nombreComprador;
	}

	public void setNombreComprador(String nombreComprador) {
		this.nombreComprador = nombreComprador;
	}

	public String getNumDocumentoComprador() {
		return numDocumentoComprador;
	}

	public void setNumDocumentoComprador(String numDocumentoComprador) {
		this.numDocumentoComprador = numDocumentoComprador;
	}

	public String getNombreRepresentante() {
		return nombreRepresentante;
	}

	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}

	public String getNumDocumentoRepresentante() {
		return numDocumentoRepresentante;
	}

	public void setNumDocumentoRepresentante(String numDocumentoRepresentante) {
		this.numDocumentoRepresentante = numDocumentoRepresentante;
	}

	public String getPorcentajeCompra() {
		return porcentajeCompra;
	}

	public void setPorcentajeCompra(String porcentajeCompra) {
		this.porcentajeCompra = porcentajeCompra;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCodigoEstadoPbc() {
		return codigoEstadoPbc;
	}

	public void setCodigoEstadoPbc(String codigoEstadoPbc) {
		this.codigoEstadoPbc = codigoEstadoPbc;
	}

	public String getDescripcionEstadoPbc() {
		return descripcionEstadoPbc;
	}

	public void setDescripcionEstadoPbc(String descripcionEstadoPbc) {
		this.descripcionEstadoPbc = descripcionEstadoPbc;
	}

	public String getRelacionHre() {
		return relacionHre;
	}

	public void setRelacionHre(String relacionHre) {
		this.relacionHre = relacionHre;
	}

	public Integer getTitularContratacion() {
		return titularContratacion;
	}

	public void setTitularContratacion(Integer titularContratacion) {
		this.titularContratacion = titularContratacion;
	}

	public String getNumFactura() {
		return numFactura;
	}

	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}

	public Date getFechaFactura() {
		return fechaFactura;
	}

	public void setFechaFactura(Date fechaFactura) {
		this.fechaFactura = fechaFactura;
	}

	public Boolean getBorrado() {
		return borrado;
	}

	public void setBorrado(Boolean borrado) {
		this.borrado = borrado;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getCodigoGradoPropiedad() {
		return codigoGradoPropiedad;
	}

	public void setCodigoGradoPropiedad(String codigoGradoPropiedad) {
		this.codigoGradoPropiedad = codigoGradoPropiedad;
	}

	public String getDescripcionGradoPropiedad() {
		return descripcionGradoPropiedad;
	}

	public void setDescripcionGradoPropiedad(String descripcionGradoPropiedad) {
		this.descripcionGradoPropiedad = descripcionGradoPropiedad;
	}
	
	
	public String getNombreAdjunto() {
		return nombreAdjunto;
	}

	public void setNombreAdjunto(String nombreAdjunto) {
		this.nombreAdjunto = nombreAdjunto;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}
	public Long getIdDocAdjunto() {
		return idDocAdjunto;
	}

	public Long getIdDocRestClient() {
		return idDocRestClient;
	}

	public void setIdDocRestClient(Long idDocRestClient) {
		this.idDocRestClient = idDocRestClient;
	}

	public void setIdDocAdjunto(Long idDocAdjunto) {
		this.idDocAdjunto = idDocAdjunto;
	}
	
}
