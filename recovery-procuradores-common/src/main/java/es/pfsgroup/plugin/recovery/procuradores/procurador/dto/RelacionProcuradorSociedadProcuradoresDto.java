package es.pfsgroup.plugin.recovery.procuradores.procurador.dto;

import java.io.Serializable;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;

/**
 * Clase que modela las {@link RelacionProcuradorSociedadProcuradoresDto}.
 * @author carlos
 *
 */

public class RelacionProcuradorSociedadProcuradoresDto extends PaginationParamsImpl  implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;

	
	private Long id;
	private Procurador procurador;
	private SociedadProcuradores sociedad;
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procurador getProcurador() {
		return procurador;
	}

	public void setProcurador(Procurador procurador) {
		this.procurador = procurador;
	}
	
	public SociedadProcuradores getSociedad() {
		return sociedad;
	}

	public void setSociedad(SociedadProcuradores sociedad) {
		this.sociedad = sociedad;
	}


	
}

