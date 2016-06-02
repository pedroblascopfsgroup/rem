package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.io.Serializable;

/**
 * No tenemos un diccionario de esta entidad, porque la cargamos desde un XML
 * 
 * @author pedro
 *
 */
public class DDPropietarioPCODto implements Serializable, Comparable<DDPropietarioPCODto> {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7795472129888487093L;

	private String codigo;

	private String descripcion;

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	@Override
	public int compareTo(DDPropietarioPCODto o) {
		if (this.descripcion != null && o.getDescripcion() != null) {
			return this.descripcion.compareTo(o.getDescripcion());
		}
		return 0;
	}

	
}
