package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_OFERTAS_ACTIVOS_AGRUPACION", schema = "${entity.schema}")
public class VOfertasActivosAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "ID")
	private String id;
	
	@Column(name = "OFR_ID")
	private String idOferta;
	
	@Column(name = "OFR_NUM_OFERTA")  
	private String numOferta;

	@Column(name = "ACT_ID")
	private String idActivo;
	
	@Column(name = "AGR_ID")
	private String idAgrupacion;
	
	@Column(name = "OFR_FECHA_ALTA")
	private Date fechaCreacion;
	
	@Column(name = "DD_TOF_DESCRIPCION")  
	private String descripcionTipoOferta;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private String numActivo; 
	
	@Column(name = "AGR_NUM_AGRUP_REM")
	private String numAgrupacionRem; 
	
	@Column(name = "OFERTANTE")
	private String ofertante;
	
	@Column(name = "VAL_IMPORTE")
	private String precioPublicado;
	
	@Column(name = "OFR_IMPORTE")
	private String importeOferta;

	@Column(name = "DD_EOF_DESCRIPCION")
	private String estadoOferta;
	
	@Column(name = "DD_EOF_CODIGO")
	private String codigoEstadoOferta;
	
	@Column(name = "ECO_ID")
	private String idExpediente;
	
	@Column(name = "ECO_NUM_EXPEDIENTE")
	private String numExpediente;
	
	@Column(name = "DD_EEC_DESCRIPCION")
	private String descripcionEstadoExpediente;
	
	@Column(name = "DD_SAC_DESCRIPCION")
	private String subtipoActivo;
	
	@Column(name = "DD_TOF_CODIGO")  
	private String codigoTipoOferta;
	
	
	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(String idOferta) {
		this.idOferta = idOferta;
	}

	public String getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(String idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public String getDescripcionTipoOferta() {
		return descripcionTipoOferta;
	}

	public void setDescripcionTipoOferta(String descripcionTipoOferta) {
		this.descripcionTipoOferta = descripcionTipoOferta;
	}

	public String getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(String numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public String getOfertante() {
		return ofertante;
	}

	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}

	public String getPrecioPublicado() {
		return precioPublicado;
	}

	public void setPrecioPublicado(String precioPublicado) {
		this.precioPublicado = precioPublicado;
	}

	public String getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(String importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}
	
	public String getCodigoEstadoOferta() {
		return codigoEstadoOferta;
	}

	public void setCodigoEstadoOferta(String codigoEstadoOferta) {
		this.codigoEstadoOferta = codigoEstadoOferta;
	}

	public String getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}

	public String getDescripcionEstadoExpediente() {
		return descripcionEstadoExpediente;
	}

	public void setDescripcionEstadoExpediente(String descripcionEstadoExpediente) {
		this.descripcionEstadoExpediente = descripcionEstadoExpediente;
	}

	public String getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}

	public String getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getDescripcionCodigoOferta() {
		return codigoTipoOferta;
	}

	public void setDescripcionCodigoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}
	
	 
}