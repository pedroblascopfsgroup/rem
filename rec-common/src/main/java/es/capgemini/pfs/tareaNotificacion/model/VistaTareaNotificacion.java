package es.capgemini.pfs.tareaNotificacion.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * VistaTareaNotificacion.
 * @author jbosnjak
 *
 */
public class VistaTareaNotificacion implements Serializable{

	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	private Long usuario;
	private Long idTarea;
	private String codigoTarea;
	private String codigoTipoTarea;
	private String tipoTarea;
	private String subtipoTarea;
	private String descripcionTarea;
	private String codigoEntidad;
	private String entidad;
	private Long idEntidad;
	private Integer alerta;
	private String codigoSubtipoTarea;
	private Date fechaCreacion;
	private Long plazo;
	private Date fechaCreacionEntidad;
	private String codigoSituacion;
	/**
	 * @return the usuario
	 */
	public Long getUsuario() {
		return usuario;
	}
	/**
	 * @param usuario the usuario to set
	 */
	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}
	/**
	 * @return the idTarea
	 */
	public Long getIdTarea() {
		return idTarea;
	}
	/**
	 * @param idTarea the idTarea to set
	 */
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	/**
	 * @return the codigoTarea
	 */
	public String getCodigoTarea() {
		return codigoTarea;
	}
	/**
	 * @param codigoTarea the codigoTarea to set
	 */
	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}
	/**
	 * @return the codigoTipoTarea
	 */
	public String getCodigoTipoTarea() {
		return codigoTipoTarea;
	}
	/**
	 * @param codigoTipoTarea the codigoTipoTarea to set
	 */
	public void setCodigoTipoTarea(String codigoTipoTarea) {
		this.codigoTipoTarea = codigoTipoTarea;
	}
	/**
	 * @return the tipoTarea
	 */
	public String getTipoTarea() {
		return tipoTarea;
	}
	/**
	 * @param tipoTarea the tipoTarea to set
	 */
	public void setTipoTarea(String tipoTarea) {
		this.tipoTarea = tipoTarea;
	}
	/**
	 * @return the subtipoTarea
	 */
	public String getSubtipoTarea() {
		return subtipoTarea;
	}
	/**
	 * @param subtipoTarea the subtipoTarea to set
	 */
	public void setSubtipoTarea(String subtipoTarea) {
		this.subtipoTarea = subtipoTarea;
	}
	/**
	 * @return the descripcionTarea
	 */
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
	/**
	 * @param descripcionTarea the descripcionTarea to set
	 */
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
	/**
	 * @return the codigoEntidad
	 */
	public String getCodigoEntidad() {
		return codigoEntidad;
	}
	/**
	 * @param codigoEntidad the codigoEntidad to set
	 */
	public void setCodigoEntidad(String codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}
	/**
	 * @return the entidad
	 */
	public String getEntidad() {
		return entidad;
	}
	/**
	 * @param entidad the entidad to set
	 */
	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}
	/**
	 * @return the idEntidad
	 */
	public Long getIdEntidad() {
		return idEntidad;
	}
	/**
	 * @param idEntidad the idEntidad to set
	 */
	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}
	/**
	 * @return the alerta
	 */
	public Integer getAlerta() {
		return alerta;
	}
	/**
	 * @param alerta the alerta to set
	 */
	public void setAlerta(Integer alerta) {
		this.alerta = alerta;
	}
	/**
	 * @return the codigoSubtipoTarea
	 */
	public String getCodigoSubtipoTarea() {
		return codigoSubtipoTarea;
	}
	/**
	 * @param codigoSubtipoTarea the codigoSubtipoTarea to set
	 */
	public void setCodigoSubtipoTarea(String codigoSubtipoTarea) {
		this.codigoSubtipoTarea = codigoSubtipoTarea;
	}
	/**
	 * @return the fechaCreacion
	 */
	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	/**
	 *
	 * @return the fecha creacion formateada
	 */
	public String getFechaCreacionFormateada(){
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		if (getFechaCreacion()!=null){
			return df.format(getFechaCreacion());
		}
		return "";
	}

	/**
	 *
	 * @return the fecha creacion entidad formateada
	 */
	public String getFechaCreacionEntidadFormateada(){
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		if (getFechaCreacionEntidad()!=null){
			return df.format(getFechaCreacionEntidad());
		}
		return "";
	}

	/**
	 * @param fechaCreacion the fechaCreacion to set
	 */
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	/**
	 * @return the plazo
	 */
	public Long getPlazo() {
		return plazo;
	}
	/**
	 * @param plazo the plazo to set
	 */
	public void setPlazo(Long plazo) {
		this.plazo = plazo;
	}
	/**
	 * @return the fechaCreacionEntidad
	 */
	public Date getFechaCreacionEntidad() {
		return fechaCreacionEntidad;
	}
	/**
	 * @param fechaCreacionEntidad the fechaCreacionEntidad to set
	 */
	public void setFechaCreacionEntidad(Date fechaCreacionEntidad) {
		this.fechaCreacionEntidad = fechaCreacionEntidad;
	}
	/**
	 * @return the codigoSituacion
	 */
	public String getCodigoSituacion() {
		return codigoSituacion;
	}
	/**
	 * @param codigoSituacion the codigoSituacion to set
	 */
	public void setCodigoSituacion(String codigoSituacion) {
		this.codigoSituacion = codigoSituacion;
	}

}
