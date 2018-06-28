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

	@Column(name="ID_CUSTODIO_REM")
	private String idCustodioREM;

	@Column(name="CODIGO_CUSTODIO_REM")
	private String codigoCustodioREM;

	@Column(name="SUBTIPO_CUSTODIO_DESC")
	private String subtipoCustodioDescripcion;

	@Column(name="SUBTIPO_CUSTODIO_COD")
	private String subtipoCustodioCodigo;

	@Column(name="ID_PRESCRIPTOR_REM")
	private String idPrescriptorREM;

	@Column(name="CODIGO_PRESCRIPTOR_REM")
	private String codigoPrescriptorREM;

	@Column(name="SUBTIPO_PRESCRIPTOR_DESC")
	private String subtipoPrescriptorDescripcion;

	@Column(name="SUBTIPO_PRESCRIPTOR_COD")
	private String subtipoPrescriptorCodigo;
	
	@Column(name="CODIGO_CARTERA")
	private String carteraCodigo;

	@Column(name="DD_CRA_ID")
	private String idCartera;
	
	
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

	public String getCodigoCustodioREM() {
		return codigoCustodioREM;
	}

	public void setCodigoCustodioREM(String codigoCustodioREM) {
		this.codigoCustodioREM = codigoCustodioREM;
	}

	public String getSubtipoCustodioDescripcion() {
		return subtipoCustodioDescripcion;
	}

	public void setSubtipoCustodioDescripcion(String subtipoCustodioDescripcion) {
		this.subtipoCustodioDescripcion = subtipoCustodioDescripcion;
	}

	public String getCodigoPrescriptorREM() {
		return codigoPrescriptorREM;
	}

	public void setCodigoPrescriptorREM(String codigoPrescriptorREM) {
		this.codigoPrescriptorREM = codigoPrescriptorREM;
	}

	public String getSubtipoPrescriptorDescripcion() {
		return subtipoPrescriptorDescripcion;
	}

	public void setSubtipoPrescriptorDescripcion(String subtipoPrescriptorDescripcion) {
		this.subtipoPrescriptorDescripcion = subtipoPrescriptorDescripcion;
	}

	public String getSubtipoCustodioCodigo() {
		return subtipoCustodioCodigo;
	}

	public void setSubtipoCustodioCodigo(String subtipoCustodioCodigo) {
		this.subtipoCustodioCodigo = subtipoCustodioCodigo;
	}

	public String getSubtipoPrescriptorCodigo() {
		return subtipoPrescriptorCodigo;
	}

	public void setSubtipoPrescriptorCodigo(String subtipoPrescriptorCodigo) {
		this.subtipoPrescriptorCodigo = subtipoPrescriptorCodigo;
	}

	public String getIdCustodioREM() {
		return idCustodioREM;
	}

	public void setIdCustodioREM(String idCustodioREM) {
		this.idCustodioREM = idCustodioREM;
	}

	public String getIdPrescriptorREM() {
		return idPrescriptorREM;
	}

	public void setIdPrescriptorREM(String idPrescriptorREM) {
		this.idPrescriptorREM = idPrescriptorREM;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	
	
	public String getIdCartera() {
		return idCartera;
	}

	public void setIdCartera(String idCartera) {
		this.idCartera = idCartera;
	}
	

}
