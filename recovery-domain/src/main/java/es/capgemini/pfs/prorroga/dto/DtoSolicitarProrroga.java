package es.capgemini.pfs.prorroga.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * Dto solictud prorroga.
 * @author jbosnjak
 *
 */
public class DtoSolicitarProrroga implements Serializable {

	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = -2534637203546559413L;

	private String codigoCausa;

	private String codigoRespuesta;

	private Date fechaPropuesta;

	private String idTipoEntidadInformacion;

	private Long idEntidadInformacion;

	private String descripcionCausa;

	private Boolean solicitud;

	private Long idTareaOriginal;

	private Long idTareaAsociada;

	private Long idProrroga;

	private String aceptada;

	/**
	 * @return the codigoCausa
	 */
	public String getCodigoCausa() {
		return codigoCausa;
	}

	/**
	 * @param codigoCausa the codigoCausa to set
	 */
	public void setCodigoCausa(String codigoCausa) {
		this.codigoCausa = codigoCausa;
	}

	/**
	 * @return the codigoRespuesta
	 */
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	/**
	 * @param codigoRespuesta the codigoRespuesta to set
	 */
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	/**
	 * @return the fechaPropuesta
	 */
	public Date getFechaPropuesta() {
		return fechaPropuesta;
	}

	/**
	 * @param fechaPropuesta the fechaPropuesta to set
	 */
	public void setFechaPropuesta(Date fechaPropuesta) {
		this.fechaPropuesta = fechaPropuesta;
	}

	/**
	 * @return the idTipoEntidadInformacion
	 */
	public String getIdTipoEntidadInformacion() {
		return idTipoEntidadInformacion;
	}

	/**
	 * @param idTipoEntidadInformacion the idTipoEntidadInformacion to set
	 */
	public void setIdTipoEntidadInformacion(String idTipoEntidadInformacion) {
		this.idTipoEntidadInformacion = idTipoEntidadInformacion;
	}

	/**
	 * @return the idEntidadInformacion
	 */
	public Long getIdEntidadInformacion() {
		return idEntidadInformacion;
	}

	/**
	 * @param idEntidadInformacion the idEntidadInformacion to set
	 */
	public void setIdEntidadInformacion(Long idEntidadInformacion) {
		this.idEntidadInformacion = idEntidadInformacion;
	}

	/**
	 * @return the descripcionCausa
	 */
	public String getDescripcionCausa() {
		return descripcionCausa;
	}

	/**
	 * @param descripcionCausa the descripcionCausa to set
	 */
	public void setDescripcionCausa(String descripcionCausa) {
		this.descripcionCausa = descripcionCausa;
	}

	/**
	 * @return the solicitud
	 */
	public Boolean getSolicitud() {
		return solicitud;
	}

	/**
	 * @param solicitud the solicitud to set
	 */
	public void setSolicitud(Boolean solicitud) {
		this.solicitud = solicitud;
	}

	/**
	 * @return the idTareaOriginal
	 */
	public Long getIdTareaOriginal() {
		return idTareaOriginal;
	}

	/**
	 * @param idTareaOriginal the idTareaOriginal to set
	 */
	public void setIdTareaOriginal(Long idTareaOriginal) {
		this.idTareaOriginal = idTareaOriginal;
	}

	/**
	 * @return the aceptada
	 */
	public String getAceptada() {
		return aceptada;
	}

	/**
	 * @param aceptada the aceptada to set
	 */
	public void setAceptada(String aceptada) {
		this.aceptada = aceptada;
	}

	/**
	 * @return the idProrroga
	 */
	public Long getIdProrroga() {
		return idProrroga;
	}

	/**
	 * @param idProrroga the idProrroga to set
	 */
	public void setIdProrroga(Long idProrroga) {
		this.idProrroga = idProrroga;
	}

	/**
	 * @return the idTareaAsociada
	 */
	public Long getIdTareaAsociada() {
		return idTareaAsociada;
	}

	/**
	 * @param idTareaAsociada the idTareaAsociada to set
	 */
	public void setIdTareaAsociada(Long idTareaAsociada) {
		this.idTareaAsociada = idTareaAsociada;
	}
}
