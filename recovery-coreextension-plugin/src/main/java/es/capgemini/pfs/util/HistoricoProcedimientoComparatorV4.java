package es.capgemini.pfs.util;

import java.util.Date;

import es.capgemini.pfs.asunto.dto.DtoProcedimiento;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfoImpl;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

@SuppressWarnings("rawtypes")
public class HistoricoProcedimientoComparatorV4 implements java.util.Comparator {

	@Override
	public int compare(Object o1, Object o2) {
		
		return compareByTarId(o1,o2);
//		Date id1 = getDate(o1);
//		Date id2 = getDate(o2);
//		if ((id1 == null) && (id2 == null)) {
//			return 0;//compareByTarId(o1,o2);
//		} else if (id1 == null) {
//			return 1;
//		} else if (id2 == null) {
//			return -1;
//		}
//
//		return id2.compareTo(id1);// == 0 ? compareByTarId(o1,o2) : id2.compareTo(id1);
	}
	
	private int compareByTarId(Object arg1, Object arg2) {
		Long id1 = getTarId(arg1);
		Long id2 = getTarId(arg2);
		if ((id1 == null) && (id2 == null)) {
			return compareById(arg1,arg2);
		} else if (id1 == null) {
			return 1;
		} else if (id2 == null) {
			return -1;
		}

		return id2.compareTo(id1) == 0 ? compareById(arg1,arg2) : id2.compareTo(id1);
	}
	
	private int compareById(Object arg1, Object arg2) {
		Long id1 = getId(arg1);
		Long id2 = getId(arg2);
		if ((id1 == null) && (id2 == null)) {
			return compareByTarId(arg1,arg2);
		} else if (id1 == null) {
			return 1;
		} else if (id2 == null) {
			return -1;
		}

		return id1.compareTo(id2);
	}
	

	private Long getId(Object o) {
		if (o instanceof HistoricoAsuntoInfoImpl) {
			return ((HistoricoAsuntoInfoImpl) o).getProcedimiento().getId();
		} else if(o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getIdProcedimiento();
		} else if (o instanceof HistoricoAsuntoInfo) {
			return ((HistoricoAsuntoInfo) o).getProcedimiento().getId();
		} else if (o instanceof DtoProcedimiento) {
			return ((DtoProcedimiento) o).getProcedimiento().getId();
		} else {
			return null;
		}
	}
	
	private Long getTarId(Object o) {
		if (o instanceof HistoricoAsuntoInfoImpl) {
			return ((HistoricoAsuntoInfoImpl) o).getIdTarea();
		} else if (o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getIdEntidad();
		} else if (o instanceof HistoricoAsuntoInfo) {
			return ((HistoricoAsuntoInfo) o).getIdTarea();
		} else {
			return null;
		}
	}

	private Date getDate(Object o) {
		if (o instanceof HistoricoAsuntoInfoImpl) {
			return ((HistoricoAsuntoInfoImpl) o).getProcedimiento().getAuditoria().getFechaCrear();
		} else if (o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getFechaIni();
		} else if (o instanceof HistoricoAsuntoInfo) {
			return ((HistoricoAsuntoInfo) o).getTarea().getFechaIni();
		} else if (o instanceof DtoProcedimiento) {
			return ((DtoProcedimiento) o).getProcedimiento().getAuditoria().getFechaCrear();
		} else {
			return null;
		}		
	}

}
