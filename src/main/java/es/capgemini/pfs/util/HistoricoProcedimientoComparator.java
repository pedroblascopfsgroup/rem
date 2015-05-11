package es.capgemini.pfs.util;

import java.util.Date;

import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

@SuppressWarnings("unchecked")
public class HistoricoProcedimientoComparator implements java.util.Comparator{

	@Override
	public int compare(Object arg1, Object arg2) {
		Date f1 = getDate(arg1);
		Date f2 = getDate(arg2);

		if ((f1 == null) && (f2 == null)) {
			return 0;
		} else if (f1 == null) {
			return 1;
		} else if (f2 == null) {
			return -1;
		}

		return f1.compareTo(f2);
	}
	
	private Date getDate(Object o) {
		if (o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getFechaIni();
		} else {
			return ((HistoricoAsuntoInfo) o).getTarea().getFechaIni();
		}
	}

}
