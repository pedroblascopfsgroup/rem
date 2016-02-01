package es.pfsgroup.recovery.ext.impl.despachoExterno;

import java.util.Comparator;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

public class EXTDespachoExternoComparator implements Comparator<DespachoExterno>{

	@Override
	public int compare(DespachoExterno arg0, DespachoExterno arg1) {
		if (arg0 == null){
			if (arg1 == null){
				return 0;
			}else{
				return 1;
			}
		}else{
			if (arg1 == null || arg1.getDespacho()==null || arg0.getDespacho()==null){
				return -1;
			}else{
				return arg0.getDespacho().toUpperCase().compareTo(arg1.getDespacho().toUpperCase());
			}
		}
	}

}
