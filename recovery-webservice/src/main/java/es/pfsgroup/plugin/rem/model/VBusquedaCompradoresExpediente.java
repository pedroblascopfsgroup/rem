package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
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
	

}
