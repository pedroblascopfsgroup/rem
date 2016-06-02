package es.pfsgroup.recovery.gestionClientes;

import java.io.Serializable;

public class GestionClientesCountDTO implements Serializable{
	
	private static final long serialVersionUID = -2208680022698980451L;
	
	private String descripcionTarea;
	private String descripcion;
	private String subtipo;
	private String codigoSubtipoTarea;
	private String dtype;
	private String categoriaTarea;
	
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getSubtipo() {
		return subtipo;
	}
	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}
	public String getCodigoSubtipoTarea() {
		return codigoSubtipoTarea;
	}
	public void setCodigoSubtipoTarea(String codigoSubtipoTarea) {
		this.codigoSubtipoTarea = codigoSubtipoTarea;
	}
	public String getDtype() {
		return dtype;
	}
	public void setDtype(String dtype) {
		this.dtype = dtype;
	}
	public String getCategoriaTarea() {
		return categoriaTarea;
	}
	public void setCategoriaTarea(String categoriaTarea) {
		this.categoriaTarea = categoriaTarea;
	}
	@Override
	public String toString() {
		return "GestionClientesCountDTO [descripcionTarea=" + descripcionTarea + ", descripcion=" + descripcion
				+ ", subtipo=" + subtipo + ", codigoSubtipoTarea=" + codigoSubtipoTarea + ", dtype=" + dtype
				+ ", categoriaTarea=" + categoriaTarea + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((categoriaTarea == null) ? 0 : categoriaTarea.hashCode());
		result = prime * result + ((codigoSubtipoTarea == null) ? 0 : codigoSubtipoTarea.hashCode());
		result = prime * result + ((descripcion == null) ? 0 : descripcion.hashCode());
		result = prime * result + ((descripcionTarea == null) ? 0 : descripcionTarea.hashCode());
		result = prime * result + ((dtype == null) ? 0 : dtype.hashCode());
		result = prime * result + ((subtipo == null) ? 0 : subtipo.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		GestionClientesCountDTO other = (GestionClientesCountDTO) obj;
		if (categoriaTarea == null) {
			if (other.categoriaTarea != null)
				return false;
		} else if (!categoriaTarea.equals(other.categoriaTarea))
			return false;
		if (codigoSubtipoTarea == null) {
			if (other.codigoSubtipoTarea != null)
				return false;
		} else if (!codigoSubtipoTarea.equals(other.codigoSubtipoTarea))
			return false;
		if (descripcion == null) {
			if (other.descripcion != null)
				return false;
		} else if (!descripcion.equals(other.descripcion))
			return false;
		if (descripcionTarea == null) {
			if (other.descripcionTarea != null)
				return false;
		} else if (!descripcionTarea.equals(other.descripcionTarea))
			return false;
		if (dtype == null) {
			if (other.dtype != null)
				return false;
		} else if (!dtype.equals(other.dtype))
			return false;
		if (subtipo == null) {
			if (other.subtipo != null)
				return false;
		} else if (!subtipo.equals(other.subtipo))
			return false;
		return true;
	}
	
	
	

}
