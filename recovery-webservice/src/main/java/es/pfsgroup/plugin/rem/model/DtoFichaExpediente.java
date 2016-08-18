package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un expediente.
 *  
 * @author Jose Villel
 *
 */
public class DtoFichaExpediente extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idExpediente;
	
    private Long idOferta;
    
    private Long idAgrupacion;
    
    private Long numAgrupacion;
    
    private Long idActivo;
    
    private Long numActivo;
    
    private Long numExpediente;
    
    private Long numEntidad;
    
    private String tipoExpedienteCodigo;
    
    private String tipoExpedienteDescripcion;

	private String mediador;
    
    private String propietario;
    
    private String comprador;
    
    private String estado;
    
    private Double importe;
    
  	private String entidadPropietariaDescripcion;
    
    private Date fechaAlta;

   	private Date fechaSancion;
   	
    private Date fechaReserva;
       
   	private Date fechaFin;
   	

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public String getMediador() {
		return mediador;
	}

	public void setMediador(String mediador) {
		this.mediador = mediador;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getComprador() {
		return comprador;
	}

	public void setComprador(String comprador) {
		this.comprador = comprador;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public Date getFechaReserva() {
		return fechaReserva;
	}

	public void setFechaReserva(Date fechaReserva) {
		this.fechaReserva = fechaReserva;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	
    public String getTipoExpedienteCodigo() {
		return tipoExpedienteCodigo;
	}

	public void setTipoExpedienteCodigo(String tipoExpedienteCodigo) {
		this.tipoExpedienteCodigo = tipoExpedienteCodigo;
	}

	public String getTipoExpedienteDescripcion() {
		return tipoExpedienteDescripcion;
	}

	public void setTipoExpedienteDescripcion(String tipoExpedienteDescripcion) {
		this.tipoExpedienteDescripcion = tipoExpedienteDescripcion;
	}

	public Long getNumEntidad() {
		return numEntidad;
	}

	public void setNumEntidad(Long numEntidad) {
		this.numEntidad = numEntidad;
	}

   	
   	
   	
   	
}
