package es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto;

import java.util.Comparator;
import java.util.Date;

import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfoImpl;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

/**
 * Comparador objetos de tipo MEJHistoricoAsuntoViewDto, utilizados en la tabla de la pesta�a hist�rico de asuntos.
 *
 */
public class MEJHistoricoAsuntoViewDtoComparator implements Comparator<MEJHistoricoAsuntoViewDto> {

	public enum DateSortOrder {ASCENDING,DESCENDING};

	private DateSortOrder dateSortOrder;

	public MEJHistoricoAsuntoViewDtoComparator() {
		super();
		this.dateSortOrder = DateSortOrder.ASCENDING;
	}
	
	
	/**
	 * indica el orden de fechas, ascendente o descendente. No afecta al orden de agrupaci�n.
	 * @param sortOrder
	 */
	public MEJHistoricoAsuntoViewDtoComparator(DateSortOrder dateSortOrder) {
	    this.dateSortOrder = dateSortOrder;
	}
	  
	@Override
	public int compare(MEJHistoricoAsuntoViewDto arg0, MEJHistoricoAsuntoViewDto arg1) {
		if (arg0 == null){
			if (arg1 == null){
				return 0;
			}else{
				return 1;
			}
		}else{
			if (arg1 == null){
				return -1;
			}else{
				if(arg0.getGroup().compareTo(arg1.getGroup()) == 0){
					if (DateSortOrder.ASCENDING == this.dateSortOrder){
						return compareTarId(arg0, arg1);
						//return comparaFechas(arg0.getFechaInicio(), arg1.getFechaInicio());
					}
					else{
						return compareTarId(arg1,arg0);
						//return comparaFechas(arg0.getFechaInicio(), arg1.getFechaInicio())*(-1);
					}
				}
				else
					return arg0.getGroup().compareTo(arg1.getGroup());
			}
		}
	}

	private int comparaFechas(Date arg0, Date arg1) {
		if (arg0 == null){
			if (arg1 == null){
				return 0;
			}else{
				return 1;
			}
		}else{
			if (arg1 == null){
				return -1;
			}else{
				return arg0.compareTo(arg1);
			}
		}
	}
	
	public int compareTarId(Object o1, Object o2) {
		
		Long id1 = getTarId(o1);
		Long id2 = getTarId(o2);
		if ((id1 == null) && (id2 == null)) {
			return 0;
		} else if (id1 == null) {
			return 1;
		} else if (id2 == null) {
			return -1;
		}

		return id1.compareTo(id2);
	}
	
	private Long getTarId(Object o) {
		if (o instanceof MEJHistoricoAsuntoViewDto) {
			return ((MEJHistoricoAsuntoViewDto) o).getIdEntidad();
		}
		else { 
			return null;
		}
		
	}

}
