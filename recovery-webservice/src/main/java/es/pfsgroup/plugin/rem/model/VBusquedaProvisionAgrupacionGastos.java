package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_BUSQUEDA_PROVISION_GASTOS", schema = "${entity.schema}")
public class VBusquedaProvisionAgrupacionGastos implements Serializable {

	private static final long serialVersionUID = 1L;


	@Id
	@Column(name= "PRG_ID")
	private Long id;
	
	@Column(name = "PRG_NUM_PROVISION")
	private String numProvision;
	
	@Column(name = "DD_EPR_CODIGO")
	private String codEstadoProvision;
	
	@Column(name = "DD_EPR_DESCRIPCION")
	private String descEstadoProvision;
	
	@Column(name = "PRG_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "PVE_ID")
	private Long idProveedor;
	
	@Column(name = "PVE_COD_REM")
	private String codREMProveedor;
	
	@Column(name = "PVE_NOMBRE")
	private String nombreProveedor;
	
	@Column(name = "PRG_FECHA_ENVIO")
	private Date fechaEnvio;
	
	@Column(name = "PRG_FECHA_RESPUESTA")
	private Date fechaRespuesta;
	
	@Column(name = "PRG_FECHA_ANULACION")
	private Date fechaAnulacion;
	
	@Column(name = "PRO_NOMBRE")
	private String nomPropietario;
	
	@Column(name = "PRO_DOCIDENTIF")
	private String nifPropietario;
	
	@Column(name = "DD_CRA_CODIGO")
	private String codCartera;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String descCartera;
	
	@Column(name = "DD_SCR_CODIGO")
	private String codSubCartera;
	
	@Column(name = "DD_SCR_DESCRIPCION")
	private String descSubCartera;
	
	@Column(name = "IMPORTE_TOTAL")
	private Double importeTotal;

	
	
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumProvision() {
		return numProvision;
	}

	public void setNumProvision(String numProvision) {
		this.numProvision = numProvision;
	}

	public String getCodEstadoProvision() {
		return codEstadoProvision;
	}

	public void setCodEstadoProvision(String codEstadoProvision) {
		this.codEstadoProvision = codEstadoProvision;
	}

	public String getDescEstadoProvision() {
		return descEstadoProvision;
	}

	public void setDescEstadoProvision(String descEstadoProvision) {
		this.descEstadoProvision = descEstadoProvision;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getCodREMProveedor() {
		return codREMProveedor;
	}

	public void setCodREMProveedor(String codREMProveedor) {
		this.codREMProveedor = codREMProveedor;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}

	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public String getNomPropietario() {
		return nomPropietario;
	}

	public void setNomPropietario(String nomPropietario) {
		this.nomPropietario = nomPropietario;
	}

	public String getNifPropietario() {
		return nifPropietario;
	}

	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}

	public String getCodCartera() {
		return codCartera;
	}

	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}

	public String getDescCartera() {
		return descCartera;
	}

	public void setDescCartera(String descCartera) {
		this.descCartera = descCartera;
	}

	public String getCodSubCartera() {
		return codSubCartera;
	}

	public void setCodSubCartera(String codSubCartera) {
		this.codSubCartera = codSubCartera;
	}

	public String getDescSubCartera() {
		return descSubCartera;
	}

	public void setDescSubCartera(String descSubCartera) {
		this.descSubCartera = descSubCartera;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	
}