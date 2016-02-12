package es.pfsgroup.plugin.recovery.procuradores.procurador.dto;

import java.io.Serializable;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;

/**
 * Clase que modela las {@link RelacionProcuradorProcedimientoDto}.
 * @author anahuac
 *
 */

public class RelacionProcuradorProcedimientoDto extends PaginationParamsImpl  implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;

	
	private Long procuradorProcedimiento;
	private Procurador procurador;
	private Procedimiento procedimiento;
	

	public Procurador getProcurador() {
		return procurador;
	}

	public void setProcurador(Procurador procurador) {
		this.procurador = procurador;
	}
	
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Long getProcuradorProcedimiento() {
		return procuradorProcedimiento;
	}

	public void setProcuradorProcedimiento(Long procuradorProcedimiento) {
		this.procuradorProcedimiento = procuradorProcedimiento;
	}


	
}

