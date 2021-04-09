package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class CierreOficinaBankiaDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@NotNull(groups = { Insert.class, Update.class })
	private String codProveedorAnterior;
	
	@NotNull(groups = { Insert.class, Update.class })
	private String codProveedorNuevo;

	public String getCodProveedorAnterior() {
		return codProveedorAnterior;
	}

	public void setCodProveedorAnterior(String codProveedorAnterior) {
		this.codProveedorAnterior = codProveedorAnterior;
	}

	public String getCodProveedorNuevo() {
		return codProveedorNuevo;
	}

	public void setCodProveedorNuevo(String codProveedorNuevo) {
		this.codProveedorNuevo = codProveedorNuevo;
	}

	
	
	
}
