package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name = "V_BUSQUEDA_TRABAJOS_GASTOS", schema = "${entity.schema}")
public class VBusquedaTrabajosGastos implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "TBJ_ID")
	private Long id;
		
    @Column(name = "TBJ_NUM_TRABAJO")
    private String numTrabajo;
    
    @Column(name = "TBJ_WEBCOM_ID")
    private Long idTrabajoWebcom;

    @Column(name = "DD_TTR_CODIGO")
	private String codigoTipo;
    
    @Column(name = "DD_STR_CODIGO")
	private String codigoSubtipo;

    @Column(name = "DD_EST_CODIGO")
	private String codigoEstado;
    
    @Column(name = "DD_TTR_DESCRIPCION")
	private String descripcionTipo;
    
    @Column(name = "DD_STR_DESCRIPCION")
	private String descripcionSubtipo;

    @Column(name = "DD_EST_DESCRIPCION")
	private String descripcionEstado;  
    	
	@Column(name = "PROVEEDOR")
	private String proveedor;
	
	@Column(name="PVE_ID")
	private Long idProveedor;
	
	@Column(name= "TBJ_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name="TBJ_CUBRE_SEGURO")
	private Integer cubreSeguro;
	
	@Column(name="CON_CIERRE_ECONOMICO")
	private Integer conCierreEconomico;
	
	@Column(name="FACTURADO")
	private Integer facturado;
	
	@Column(name="TBJ_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name="TBJ_FECHA_CIERRE_ECONOMICO")
	private Date fechaCierreEconomico;
	
	@Column(name="DD_TTR_FILTRAR")
	private Integer filtrar;
	
	@Column(name="PROPIETARIO")
	private Long propietario;
	
	@Column(name="TBJ_IMPORTE_PRESUPUESTO")
	private Double importePresupuesto;
	
	@Column(name="TBJ_FECHA_EJECUTADO")
	private Date fechaEjecutado;
	
	public Integer getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Integer cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	
	public Long getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}

	public void setIdTrabajoWebcom(Long idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getCodigoSubtipo() {
		return codigoSubtipo;
	}

	public void setCodigoSubtipo(String codigoSubtipo) {
		this.codigoSubtipo = codigoSubtipo;
	}

	public String getCodigoEstado() {
		return codigoEstado;
	}

	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}

	public String getDescripcionTipo() {
		return descripcionTipo;
	}

	public void setDescripcionTipo(String descripcionTipo) {
		this.descripcionTipo = descripcionTipo;
	}

	public String getDescripcionSubtipo() {
		return descripcionSubtipo;
	}

	public void setDescripcionSubtipo(String descripcionSubtipo) {
		this.descripcionSubtipo = descripcionSubtipo;
	}

	public String getDescripcionEstado() {
		return descripcionEstado;
	}

	public void setDescripcionEstado(String descripcionEstado) {
		this.descripcionEstado = descripcionEstado;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}


	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public Integer getConCierreEconomico() {
		return conCierreEconomico;
	}

	public void setConCierreEconomico(Integer conCierreEconomico) {
		this.conCierreEconomico = conCierreEconomico;
	}

	public Date getFechaCierreEconomico() {
		return fechaCierreEconomico;
	}

	public void setFechaCierreEconomico(Date fechaCierreEconomico) {
		this.fechaCierreEconomico = fechaCierreEconomico;
	}

	public Integer getFiltrar() {
		return filtrar;
	}

	public void setFiltrar(Integer filtrar) {
		this.filtrar = filtrar;
	}

	public Long getPropietario() {
		return propietario;
	}

	public void setPropietario(Long propietario) {
		this.propietario = propietario;
	}
	

	public Double getImportePresupuesto() {
		return importePresupuesto;
	}

	public void setImportePresupuesto(Double importePresupuesto) {
		this.importePresupuesto = importePresupuesto;
	}

	public Date getFechaEjecutado() {
		return fechaEjecutado;
	}

	public void setFechaEjecutado(Date fechaEjecutado) {
		this.fechaEjecutado = fechaEjecutado;
	}
	
}