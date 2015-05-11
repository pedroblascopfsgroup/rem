package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.Comparator;
import java.util.Date;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJHistoricoAsuntoViewDto;


/**
 * Comparador objetos de tipo MEJHistoricoAsuntoViewDto, utilizados en la tabla de la pestaña histórico de asuntos.
 *
 */
public class MSVHistoricoAsuntoViewDtoComparator implements Comparator<MEJHistoricoAsuntoViewDto> {

	public enum MSVSortOrder {ASCENDING,DESCENDING};
	public enum MSVNullsOrder {FIRST, LAST};

	private MSVSortOrder dateSortOrder;
	private MSVSortOrder prcSortOrder;
	private MSVNullsOrder nullsOrder;

	public MSVHistoricoAsuntoViewDtoComparator() {
		super();
		this.dateSortOrder = MSVSortOrder.DESCENDING;
		this.prcSortOrder = MSVSortOrder.DESCENDING;
		this.nullsOrder = MSVNullsOrder.FIRST;
	}
	
	
	/**
	 * indica el orden de fechas, ascendente o descendente. No afecta al orden de agrupación.
	 * @param sortOrder
	 */
	public MSVHistoricoAsuntoViewDtoComparator(MSVSortOrder sortOrder) {
	    this.dateSortOrder = sortOrder;
	}
	  
	/**
	 * indica el orden de fechas y procedimiento, ascendente o descendente y si los nulos se colocan al principio o final. No afecta al orden de agrupación.
	 * @param sortOrder
	 * @param nullsOrder
	 */
	public MSVHistoricoAsuntoViewDtoComparator(MSVSortOrder sortOrder, MSVSortOrder prcOrder, MSVNullsOrder nullsOrder) {
	    this.dateSortOrder = sortOrder;
	    this.prcSortOrder = prcOrder;
	    this.nullsOrder = nullsOrder;
	}
	@Override
	public int compare(MEJHistoricoAsuntoViewDto arg0, MEJHistoricoAsuntoViewDto arg1) {
		if (arg0 == null){
			return (arg1 == null) ?  0 : ((this.nullsOrder==MSVNullsOrder.FIRST) ? -1 : 1);
		} else {
			if (arg1 == null){
				return (this.nullsOrder==MSVNullsOrder.FIRST) ? 1 : -1;
			}else{
				if(arg0.getGroup().compareTo(arg1.getGroup()) == 0){
					if(Checks.esNulo(arg0.getNumeroProcedimiento())) {
						return (Checks.esNulo(arg1.getNumeroProcedimiento())) ? 0 : ((this.nullsOrder==MSVNullsOrder.FIRST) ? -1 : 1);
					} else {
						if (Checks.esNulo(arg1.getNumeroProcedimiento())) {
							return (this.nullsOrder==MSVNullsOrder.FIRST) ? 1 : -1;
						}
					}
	
					if(arg0.getNumeroProcedimiento().compareTo(arg1.getNumeroProcedimiento()) == 0){
						if (arg0.getFechaFin() == null) {
							return (arg1.getFechaFin() == null) ? 0 : ((this.nullsOrder==MSVNullsOrder.FIRST) ? -1 : 1);
						} else {
							if (arg1.getFechaFin() == null){
								return (this.nullsOrder==MSVNullsOrder.FIRST) ? 1 : -1;
							}else{					
								return (MSVSortOrder.ASCENDING == this.dateSortOrder) ? 
										comparaFechas(arg0.getFechaFin(), arg1.getFechaFin()) : 
										comparaFechas(arg0.getFechaFin(), arg1.getFechaFin())*(-1);
							}
						}
					}
					else {
						return (MSVSortOrder.ASCENDING == this.prcSortOrder) ? 
							arg0.getNumeroProcedimiento().compareTo(arg1.getNumeroProcedimiento()) :
							arg0.getNumeroProcedimiento().compareTo(arg1.getNumeroProcedimiento())*(-1);
					}
				} else {
					return arg0.getGroup().compareTo(arg1.getGroup());
				}
			}
		}
	}

	private int comparaFechas(Date arg0, Date arg1) {
		if (arg0 == null) {
			return (arg1 == null) ? 0 : 1;				
		} else{
			return (arg1 == null) ? -1 :  arg0.compareTo(arg1);			
		}
	}

}
