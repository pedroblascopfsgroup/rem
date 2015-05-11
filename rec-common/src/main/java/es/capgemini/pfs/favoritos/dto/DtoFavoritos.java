package es.capgemini.pfs.favoritos.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * dto de favoritos.
 * @author jbosnjak
 *
 */
public class DtoFavoritos  extends WebDto {

	 private static final long serialVersionUID = 1L;

	 private Long idUsuario;

	 private String entidadInformacion;

	 private Long idInformacion;

	/**
	 * @return the entidadInformacion
	 */
	public String getEntidadInformacion() {
		return entidadInformacion;
	}
	/**
	 * @param entidadInformacion the entidadInformacion to set
	 */
	public void setEntidadInformacion(String entidadInformacion) {
		this.entidadInformacion = entidadInformacion;
	}
	/**
	 * @return the idInformación
	 */
	public Long getIdInformacion() {
		return idInformacion;
	}
	/**
	 * @param idInformacion the idInformación to set
	 */
	public void setIdInformacion(Long idInformacion) {
		this.idInformacion = idInformacion;
	}
	/**
	 * @return the idUsuario
	 */
	public Long getIdUsuario() {
		return idUsuario;
	}
	/**
	 * @param idUsuario the idUsuario to set
	 */
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
}
