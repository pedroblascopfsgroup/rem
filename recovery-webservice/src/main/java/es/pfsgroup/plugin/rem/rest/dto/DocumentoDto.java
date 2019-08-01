package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



public class DocumentoDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 711043893166372128L;
	
	private String tipoEntidad;
	private String numEntidad;
	private String tipoDocumento;
	private String subTipoDocumento;
	private String nombreDocumento;
	private String descripcionDocumento;
	private String   documento;
	public String getTipoEntidad() {
		return tipoEntidad;
	}
	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}
	public String getNumEntidad() {
		return numEntidad;
	}
	public void setNumEntidad(String numEntidad) {
		this.numEntidad = numEntidad;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getNombreDocumento() {
		return nombreDocumento;
	}
	public void setNombreDocumento(String nombreDocumento) {
		this.nombreDocumento = nombreDocumento;
	}
	public String getDescripcionDocumento() {
		return descripcionDocumento;
	}
	public void setDescripcionDocumento(String descripcionDocumento) {
		this.descripcionDocumento = descripcionDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
	public String getSubTipoDocumento() {
		return subTipoDocumento;
	}
	public void setSubTipoDocumento(String subTipoDocumento) {
		this.subTipoDocumento = subTipoDocumento;
	}
	
	public Map<String, String> getDataFields(){
		Map<String, String> dataFields = new HashMap<String, String>();
		dataFields.put("tipoEntidad", this.tipoEntidad);
		dataFields.put("numEntidad", this.numEntidad);
		dataFields.put("tipoDocumento", this.tipoDocumento);
		dataFields.put("nombreDocumento", this.nombreDocumento);
		dataFields.put("descripcionDocumento", this.descripcionDocumento);
		dataFields.put("documento", this.documento);
		dataFields.put("subTipoDocumento", this.subTipoDocumento);
		return dataFields;
	}

}
