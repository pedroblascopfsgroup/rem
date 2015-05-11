package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.dto;

import java.io.Serializable;

public class MSVTipoResolucionDto implements Comparable<MSVTipoResolucionDto>, Serializable {
	
	private static final long serialVersionUID = 5345199846643354782L;

	private static final String ADVANCE = "ADVANCE";
	private static final String FORWARD = "FORWARD";
	private static final String INFO = "INFO";
	private static final String UPDATE = "UPDATE";
	
	private Long idTipoResolucion;
	
	private String codigoTipoResolucion;
	
	private String descripcionTipoResolucion;
	
	private String codigoTipoAccion;

	public Long getIdTipoResolucion() {
		return idTipoResolucion;
	}

	public void setIdTipoResolucion(Long idTipoResolucion) {
		this.idTipoResolucion = idTipoResolucion;
	}

	public String getCodigoTipoResolucion() {
		return codigoTipoResolucion;
	}

	public void setCodigoTipoResolucion(String codigoTipoResolucion) {
		this.codigoTipoResolucion = codigoTipoResolucion;
	}

	public String getDescripcionTipoResolucion() {
		return descripcionTipoResolucion;
	}

	public void setDescripcionTipoResolucion(String descripcionTipoResolucion) {
		this.descripcionTipoResolucion = descripcionTipoResolucion;
	}

	public String getCodigoTipoAccion() {
		return codigoTipoAccion;
	}

	// Ponemos el valor del tipo de acción según esta prioridad:
	// (INFO < FORWARD < ADVANCE)
	public void setCodigoTipoAccion(String codigoTipoAccion) {
		if (this.codigoTipoAccion==null || this.codigoTipoAccion.equals(INFO)) {
			this.codigoTipoAccion = codigoTipoAccion;
		} else if (this.codigoTipoAccion.equals(FORWARD) && codigoTipoAccion.equals(ADVANCE)) {
			this.codigoTipoAccion = codigoTipoAccion;
		}
	}

	@Override
	public int compareTo(MSVTipoResolucionDto o) {
		MSVTipoResolucionDto otro = (MSVTipoResolucionDto) o;
		return this.getDescripcionTipoResolucion().compareTo(otro.getDescripcionTipoResolucion());
	}
	
	
	/**
	 * @Autor: Pedro
	 *
	 * Sobreescribo para hacer que dos dtos sean inguales cuando lo sea su código de tipo de resolución  
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj != null && obj.getClass() == this.getClass()){
		MSVTipoResolucionDto otro = (MSVTipoResolucionDto) obj;
		return this.getCodigoTipoResolucion().equals(otro.getCodigoTipoResolucion());
		}else{
			return false;
		}
	}
	
	@Override
	public int hashCode() {
		if (this.codigoTipoResolucion == null){
			return 0;
		}else{
			return this.codigoTipoResolucion.hashCode();
		}
	
	}

}
