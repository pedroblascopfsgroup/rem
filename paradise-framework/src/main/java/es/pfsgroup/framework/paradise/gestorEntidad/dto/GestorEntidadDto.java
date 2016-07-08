package es.pfsgroup.framework.paradise.gestorEntidad.dto;

import es.capgemini.devon.dto.WebDto;

public class GestorEntidadDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5292448099664668994L;
	
	public static final String TIPO_ENTIDAD_EXPEDIENTE = "1";
	public static final String TIPO_ENTIDAD_ASUNTO = "2";
	public static final String TIPO_ENTIDAD_ACTIVO = "3";

	private Long idEntidad;
	private String tipoEntidad;
	private Long idTipoGestor;
	private Long idUsuario;
	private Long idTipoDespacho;

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public String getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public Long getIdTipoGestor() {
		return idTipoGestor;
	}

	public void setIdTipoGestor(Long idTipoGestor) {
		this.idTipoGestor = idTipoGestor;
	}

	public Long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}

	public Long getIdTipoDespacho() {
		return idTipoDespacho;
	}

	public void setIdTipoDespacho(Long idTipoDespacho) {
		this.idTipoDespacho = idTipoDespacho;
	}

}