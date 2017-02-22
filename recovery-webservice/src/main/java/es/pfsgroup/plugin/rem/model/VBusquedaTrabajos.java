package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name = "V_BUSQUEDA_TRABAJOS", schema = "${entity.schema}")
public class VBusquedaTrabajos implements Serializable {

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
    
    @Column(name="NUM_ACTIVO_AGRUPACION")
    private Long numActivoAgrupacion;

    @Column(name="NUMACTIVO")
    private Long numActivo;
    
    @Column(name="IDACTIVO")
    private Long idActivo;
    
    @Column(name="NUMAGRUPACION")
    private Long numAgrupacionRem;
    
    @Column(name="TIPO_ENTIDAD")
    private String tipoEntidad;

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
	
	@Column(name = "SOLICITANTE")
	private String solicitante;
	
	@Column(name= "TBJ_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name="POBLACION")
	private String descripcionPoblacion;	

	@Column(name="PROVINCIA")
	private String descripcionProvincia;
	
	@Column(name="DD_PRV_CODIGO")
	private String codigoProvincia;

	@Column(name="CODPOSTAL")
	private String codPostal;
	
	@Column(name="CARTERA")
	private String cartera;
	
	@Column(name="GESTOR_ACTIVO")
	private String gestorActivo;
	
	@Column(name="TBJ_CUBRE_SEGURO")
	private Integer cubreSeguro;
	
	@Column(name="CON_CIERRE_ECONOMICO")
	private Integer conCierreEconomico;
	
	@Column(name="FACTURADO")
	private Integer facturado;
	
	@Column(name="TBJ_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name="TBJ_FECHA_EJECUTADO")
	private Date fechaEjecutado;
	
	@Column(name="TBJ_FECHA_CIERRE_ECONOMICO")
	private Date fechaCierreEconomico;
	
	@Column(name="RANGO")
	private Integer rango;
	
	@Column(name="DD_TTR_FILTRAR")
	private Integer filtrar;
	

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

	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}

	public String getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
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

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public String getDescripcionPoblacion() {
		return descripcionPoblacion;
	}

	public void setDescripcionPoblacion(String descripcionPoblacion) {
		this.descripcionPoblacion = descripcionPoblacion;
	}

	public String getDescripcionProvincia() {
		return descripcionProvincia;
	}

	public void setDescripcionProvincia(String descripcionProvincia) {
		this.descripcionProvincia = descripcionProvincia;
	}

	public String getCodigoProvincia() {
		return codigoProvincia;
	}

	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getGestorActivo() {
		return gestorActivo;
	}

	public void setGestorActivo(String gestorActivo) {
		this.gestorActivo = gestorActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(Long numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}	

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Date getFechaEjecutado() {
		return fechaEjecutado;
	}

	public void setFechaEjecutado(Date fechaEjecutado) {
		this.fechaEjecutado = fechaEjecutado;
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

	public Integer getRango() {
		return rango;
	}

	public void setRango(Integer rango) {
		this.rango = rango;
	}

	public Integer getFiltrar() {
		return filtrar;
	}

	public void setFiltrar(Integer filtrar) {
		this.filtrar = filtrar;
	}

}