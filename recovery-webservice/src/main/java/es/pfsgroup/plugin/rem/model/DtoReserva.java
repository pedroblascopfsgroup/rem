package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import javax.persistence.Column;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de una reserva.
 *  
 * @author Jose Villel
 */
public class DtoReserva extends WebDto {

	private static final long serialVersionUID = 3574353502838449106L;


	private Long idReserva;
	
	private Long numReserva;
	
	private String tipoArrasCodigo;
	
	private Date fechaEnvio;
	
	private Double importe;
	
	private String estadoReservaDescripcion;
	
	private Date fechaFirma;
	
	private Integer conImpuesto;
	
	private Date fechaVencimiento;
	
	private Date fechaCobro;
	
	private String comprador;
	
	private String Observaciones;

	private String estadoReserva;
	
	private String codigoSucursal;
	
	private String cartera;
	
	private String sucursal;
	
	private String estadoReservaCodigo;
	
	private Double depositoReserva;
	
	private String motivoAmpliacionArrasCodigo;
	
	private String solicitudAmpliacionArras;
	
	private Date fechaVigenciaArras;
	
	private Date fechaAmpliacionArras;
	
	private Date fechaPropuestaProrrogaArras;
	
	private Date fechaComunicacionCliente;
	
	private Date fechaComunicacionClienteRescision;
	
	private Date fechaFirmaRescision;
	
    private Boolean inscripcionTitulo;
    
    private Boolean tanteoDL;
    
    private Boolean cargas;
    
    private Boolean temasTecnicos;
    
    private Boolean posesion;
    
    private Boolean temasCatastrales;
    
    private Boolean autorizacionVpo;
	

	public Double getDepositoReserva() {
		return depositoReserva;
	}

	public void setDepositoReserva(Double depositoReserva) {
		this.depositoReserva = depositoReserva;
	}

	public Long getIdReserva() {
		return idReserva;
	}

	public void setIdReserva(Long idReserva) {
		this.idReserva = idReserva;
	}

	public Long getNumReserva() {
		return numReserva;
	}

	public void setNumReserva(Long numReserva) {
		this.numReserva = numReserva;
	}

	public String getTipoArrasCodigo() {
		return tipoArrasCodigo;
	}

	public void setTipoArrasCodigo(String tipoArrasCodigo) {
		this.tipoArrasCodigo = tipoArrasCodigo;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getEstadoReservaDescripcion() {
		return estadoReservaDescripcion;
	}

	public void setEstadoReservaDescripcion(String estadoReservaDescripcion) {
		this.estadoReservaDescripcion = estadoReservaDescripcion;
	}

	public Date getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}

	public Integer getConImpuesto() {
		return conImpuesto;
	}

	public void setConImpuesto(Integer conImpuesto) {
		this.conImpuesto = conImpuesto;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public Date getFechaCobro() {
		return fechaCobro;
	}

	public void setFechaCobro(Date fechaCobro) {
		this.fechaCobro = fechaCobro;
	}

	public String getComprador() {
		return comprador;
	}

	public void setComprador(String comprador) {
		this.comprador = comprador;
	}

	public String getObservaciones() {
		return Observaciones;
	}

	public void setObservaciones(String observaciones) {
		Observaciones = observaciones;
	}

	public String getEstadoReserva() {
		return estadoReserva;
	}

	public void setEstadoReserva(String estadoReserva) {
		this.estadoReserva = estadoReserva;
	}

	public String getCodigoSucursal() {
		return codigoSucursal;
	}

	public void setCodigoSucursal(String codigoSucursal) {
		this.codigoSucursal = codigoSucursal;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public String getEstadoReservaCodigo() {
		return estadoReservaCodigo;
	}

	public void setEstadoReservaCodigo(String estadoReservaCodigo) {
		this.estadoReservaCodigo = estadoReservaCodigo;
	}

	public String getMotivoAmpliacionArrasCodigo() {
		return motivoAmpliacionArrasCodigo;
	}

	public void setMotivoAmpliacionArrasCodigo(String motivoAmpliacionArrasCodigo) {
		this.motivoAmpliacionArrasCodigo = motivoAmpliacionArrasCodigo;
	}

	public String getSolicitudAmpliacionArras() {
		return solicitudAmpliacionArras;
	}

	public void setSolicitudAmpliacionArras(String solicitudAmpliacionArras) {
		this.solicitudAmpliacionArras = solicitudAmpliacionArras;
	}

	public Date getFechaVigenciaArras() {
		return fechaVigenciaArras;
	}

	public void setFechaVigenciaArras(Date fechaVigenciaArras) {
		this.fechaVigenciaArras = fechaVigenciaArras;
	}

	public Date getFechaAmpliacionArras() {
		return fechaAmpliacionArras;
	}

	public void setFechaAmpliacionArras(Date fechaAmpliacionArras) {
		this.fechaAmpliacionArras = fechaAmpliacionArras;
	}

	public Date getFechaPropuestaProrrogaArras() {
		return fechaPropuestaProrrogaArras;
	}

	public void setFechaPropuestaProrrogaArras(Date fechaPropuestaProrrogaArras) {
		this.fechaPropuestaProrrogaArras = fechaPropuestaProrrogaArras;
	}

	public Date getFechaComunicacionCliente() {
		return fechaComunicacionCliente;
	}

	public void setFechaComunicacionCliente(Date fechaComunicacionCliente) {
		this.fechaComunicacionCliente = fechaComunicacionCliente;
	}

	public Date getFechaComunicacionClienteRescision() {
		return fechaComunicacionClienteRescision;
	}

	public void setFechaComunicacionClienteRescision(Date fechaComunicacionClienteRescision) {
		this.fechaComunicacionClienteRescision = fechaComunicacionClienteRescision;
	}

	public Date getFechaFirmaRescision() {
		return fechaFirmaRescision;
	}

	public void setFechaFirmaRescision(Date fechaFirmaRescision) {
		this.fechaFirmaRescision = fechaFirmaRescision;
	}

	public Boolean getInscripcionTitulo() {
		return inscripcionTitulo;
	}

	public void setInscripcionTitulo(Boolean inscripcionTitulo) {
		this.inscripcionTitulo = inscripcionTitulo;
	}

	public Boolean getTanteoDL() {
		return tanteoDL;
	}

	public void setTanteoDL(Boolean tanteoDL) {
		this.tanteoDL = tanteoDL;
	}

	public Boolean getCargas() {
		return cargas;
	}

	public void setCargas(Boolean cargas) {
		this.cargas = cargas;
	}

	public Boolean getTemasTecnicos() {
		return temasTecnicos;
	}

	public void setTemasTecnicos(Boolean temasTecnicos) {
		this.temasTecnicos = temasTecnicos;
	}

	public Boolean getPosesion() {
		return posesion;
	}

	public void setPosesion(Boolean posesion) {
		this.posesion = posesion;
	}

	public Boolean getTemasCatastrales() {
		return temasCatastrales;
	}

	public void setTemasCatastrales(Boolean temasCatastrales) {
		this.temasCatastrales = temasCatastrales;
	}

	public Boolean getAutorizacionVpo() {
		return autorizacionVpo;
	}

	public void setAutorizacionVpo(Boolean autorizacionVpo) {
		this.autorizacionVpo = autorizacionVpo;
	}
}
