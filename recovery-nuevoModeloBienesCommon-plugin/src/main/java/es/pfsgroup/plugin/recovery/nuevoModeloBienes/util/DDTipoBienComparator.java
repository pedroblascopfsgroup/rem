package es.pfsgroup.plugin.recovery.nuevoModeloBienes.util;

import java.util.Comparator;

import es.capgemini.pfs.bien.model.DDTipoBien;
import es.pfsgroup.commons.utils.Checks;

public class DDTipoBienComparator implements Comparator<DDTipoBien> {

	@Override
	public int compare(DDTipoBien o1, DDTipoBien o2) {
		if (Checks.esNulo(o1.getDescripcion()) && (Checks.esNulo(o2))) {
			return 0;
		} else if(Checks.esNulo(o1.getDescripcion())) {
			return 1;
		} else if(Checks.esNulo(o2.getDescripcion())) {
			return -1;
		}
		return o1.getDescripcion().toUpperCase().compareTo(o2.getDescripcion().toUpperCase());
	}

	

}
