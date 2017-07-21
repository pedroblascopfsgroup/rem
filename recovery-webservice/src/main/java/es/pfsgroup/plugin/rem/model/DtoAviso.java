package es.pfsgroup.plugin.rem.model;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAviso extends WebDto {

	private static final long serialVersionUID = 0L;

	private String id;
	private String descripcion;
	private List<String> descripciones;

	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public void addDescripcion(String string) {
		if (!Checks.esNulo(string)) {
			if (descripciones == null) {
				descripciones = new ArrayList<String>();
			}
			descripciones.add(string);
		}
		
	}
	public List<String> getDescripciones() {
		if (descripciones == null){
			return null;
		} else {
			ArrayList<String> list = new ArrayList<String>();
			list.addAll(descripciones);
			return list;
		}
	}

	
	
}