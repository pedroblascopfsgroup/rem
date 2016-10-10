package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_VISITAS_DETALLE", schema = "${entity.schema}")
public class VBusquedaVisitasDetalle implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "VIS_ID")
	private String id;
	
	@Column(name="VIS_NUM_VISITA")
	private String numVisita;
	
	@Column(name="ACT_ID")
	private String idActivo;
	
	@Column(name="ACT_NUM_ACTIVO")
	private String numActivo;
	
	@Column(name="VIS_FECHA_VISITA")
	private Date fechaVisita;
	
	@Column(name = "VIS_FECHA_SOLICTUD")
	private Date fechaSolicitud;
	
	@Column(name="VIS_FECHA_CONCERTACION")
	private Date fechaConcertacion;
	
	@Column(name="VIS_FECHA_CONTACTO")
	private Date fechaContacto;
	
	@Column(name="VIS_OBSERVACIONES")
	private String observacionesVisita;
	
	@Column(name="DD_SVI_CODIGO")
	private String subEstadoVisitaCodigo;
	
	@Column(name = "DD_SVI_DESCRIPCION")
	private String subEstadoVisitaDescripcion;
	
	@Column(name="DD_EVI_CODIGO")
	private String estadoVisitaCodigo;
	
	@Column(name="DD_EVI_DESCRIPCION")
	private String estadoVisitaDescripcion;
	
	@Column(name="CLC_ID")
	private String idCliente;
	
	@Column(name="OFERTANTE")
	private String nombreCompleroCliente;
	
	@Column(name = "CLC_DOCUMENTO")
	private String documentoCliente;
	
	@Column(name="CLC_DOCUMENTO_REPRESENTANTE")
	private String documentoRepresentanteCliente;
	
	@Column(name="CLC_TELEFONO1")
	private String telefono1Cliente;
	
	@Column(name="CLC_TELEFONO2")
	private String telefono2Cliente;
	
	@Column(name="CLC_EMAIL")
	private String emailCliente;
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNumVisita() {
		return numVisita;
	}

	public void setNumVisita(String numVisita) {
		this.numVisita = numVisita;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public Date getFechaVisita() {
		return fechaVisita;
	}

	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaConcertacion() {
		return fechaConcertacion;
	}

	public void setFechaConcertacion(Date fechaConcertacion) {
		this.fechaConcertacion = fechaConcertacion;
	}

	public Date getFechaContacto() {
		return fechaContacto;
	}

	public void setFechaContacto(Date fechaContacto) {
		this.fechaContacto = fechaContacto;
	}

	public String getObservacionesVisita() {
		return observacionesVisita;
	}

	public void setObservacionesVisita(String observacionesVisita) {
		this.observacionesVisita = observacionesVisita;
	}

	public String getSubEstadoVisitaCodigo() {
		return subEstadoVisitaCodigo;
	}

	public void setSubEstadoVisitaCodigo(String subEstadoVisitaCodigo) {
		this.subEstadoVisitaCodigo = subEstadoVisitaCodigo;
	}

	public String getSubEstadoVisitaDescripcion() {
		return subEstadoVisitaDescripcion;
	}

	public void setSubEstadoVisitaDescripcion(String subEstadoVisitaDescripcion) {
		this.subEstadoVisitaDescripcion = subEstadoVisitaDescripcion;
	}

	public String getEstadoVisitaCodigo() {
		return estadoVisitaCodigo;
	}

	public void setEstadoVisitaCodigo(String estadoVisitaCodigo) {
		this.estadoVisitaCodigo = estadoVisitaCodigo;
	}

	public String getEstadoVisitaDescripcion() {
		return estadoVisitaDescripcion;
	}

	public void setEstadoVisitaDescripcion(String estadoVisitaDescripcion) {
		this.estadoVisitaDescripcion = estadoVisitaDescripcion;
	}

	public String getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(String idCliente) {
		this.idCliente = idCliente;
	}

	public String getNombreCompleroCliente() {
		return nombreCompleroCliente;
	}

	public void setNombreCompleroCliente(String nombreCompleroCliente) {
		this.nombreCompleroCliente = nombreCompleroCliente;
	}

	public String getDocumentoCliente() {
		return documentoCliente;
	}

	public void setDocumentoCliente(String documentoCliente) {
		this.documentoCliente = documentoCliente;
	}

	public String getDocumentoRepresentanteCliente() {
		return documentoRepresentanteCliente;
	}

	public void setDocumentoRepresentanteCliente(
			String documentoRepresentanteCliente) {
		this.documentoRepresentanteCliente = documentoRepresentanteCliente;
	}

	public String getTelefono1Cliente() {
		return telefono1Cliente;
	}

	public void setTelefono1Cliente(String telefono1Cliente) {
		this.telefono1Cliente = telefono1Cliente;
	}

	public String getTelefono2Cliente() {
		return telefono2Cliente;
	}

	public void setTelefono2Cliente(String telefono2Cliente) {
		this.telefono2Cliente = telefono2Cliente;
	}

	public String getEmailCliente() {
		return emailCliente;
	}

	public void setEmailCliente(String emailCliente) {
		this.emailCliente = emailCliente;
	}
	

}
