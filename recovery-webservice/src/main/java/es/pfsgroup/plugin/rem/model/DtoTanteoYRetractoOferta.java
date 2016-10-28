package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de tanteo y retracto de una oferta.
 *  
 * @author Bender
 *
 */
public class DtoTanteoYRetractoOferta extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353241838449107L;
	
	private Long idOferta;
	private Long numOferta;
	private String condicionesTransmision;
	private Date fechaComunicacionReg;
	private Date fechaContestacion;
	private Date fechaSolicitudVisita;
	private Date fechaRealizacionVisita;
	private Date fechaFinTanteo;
	private String resultadoTanteoCodigo;
	private String resultadoTanteoDescripcion;
	private Date plazoMaxFormalizacion;
	
	
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public String getCondicionesTransmision() {
		return condicionesTransmision;
	}
	public void setCondicionesTransmision(String condicionesTransmision) {
		this.condicionesTransmision = condicionesTransmision;
	}
	public Date getFechaComunicacionReg() {
		return fechaComunicacionReg;
	}
	public void setFechaComunicacionReg(Date fechaComunicacionReg) {
		this.fechaComunicacionReg = fechaComunicacionReg;
	}
	public Date getFechaContestacion() {
		return fechaContestacion;
	}
	public void setFechaContestacion(Date fechaContestacion) {
		this.fechaContestacion = fechaContestacion;
	}
	public Date getFechaSolicitudVisita() {
		return fechaSolicitudVisita;
	}
	public void setFechaSolicitudVisita(Date fechaSolicitudVisita) {
		this.fechaSolicitudVisita = fechaSolicitudVisita;
	}
	public Date getFechaRealizacionVisita() {
		return fechaRealizacionVisita;
	}
	public void setFechaRealizacionVisita(Date fechaRealizacionVisita) {
		this.fechaRealizacionVisita = fechaRealizacionVisita;
	}
	public Date getFechaFinTanteo() {
		return fechaFinTanteo;
	}
	public void setFechaFinTanteo(Date fechaFinTanteo) {
		this.fechaFinTanteo = fechaFinTanteo;
	}
	public String getResultadoTanteoCodigo() {
		return resultadoTanteoCodigo;
	}
	public void setResultadoTanteoCodigo(String resultadoTanteoCodigo) {
		this.resultadoTanteoCodigo = resultadoTanteoCodigo;
	}
	public String getResultadoTanteoDescripcion() {
		return resultadoTanteoDescripcion;
	}
	public void setResultadoTanteoDescripcion(String resultadoTanteoDescripcion) {
		this.resultadoTanteoDescripcion = resultadoTanteoDescripcion;
	}
	public Date getPlazoMaxFormalizacion() {
		return plazoMaxFormalizacion;
	}
	public void setPlazoMaxFormalizacion(Date plazoMaxFormalizacion) {
		this.plazoMaxFormalizacion = plazoMaxFormalizacion;
	}
	
	
   	
}
