package es.capgemini.pfs.util;

import java.util.Date;

import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.pfsgroup.commons.utils.Checks;

@SuppressWarnings("rawtypes")
public class HistoricoProcedimientoTramiteDeSubastaComparator implements java.util.Comparator {

	private final static String CELEBRACION_SUBASTA_ADJUDICACION = "Celebraci髇 subasta y adjudicaci髇";
	private final static String DICTAR_INSTRUCCIONES = "Dictar Instrucciones";
	private final static String LECTURA_INSTRUCCIONES = "Lectura y aceptacion de instrucciones";

	/**
	 * M茅todo que antepone las tareas de Dictar y Lectura de instrucciones antes
	 * que la de Celebraci贸n de subasta. Las tareas de autopr贸rroga y propuesta
	 * de decisi贸n se autoordenan por defecto gracias a la fecha inicio, ya que
	 * 茅stas no disponen de fecha fin. Los criterios de ordenaci贸n son por fecha
	 * fin, fecha inicio y nombre de la tarea
	 */
	@Override
	public int compare(Object arg1, Object arg2) {

		String t1 = getNombreTarea(arg1);
		String t2 = getNombreTarea(arg2);
		Date f1 = getDate(arg1);
		Date f2 = getDate(arg2);

		if ((t1 == null) && (t2 == null)) {
			return 0;
		} else if (t1 == null) {
			return 1;
		} else if (t2 == null) {
			return -1;
		}

		if (t1.equals(t2)) {
			if ((f1 == null) && (f2 == null)) {
				return 0;
			} else if (f1 == null) {
				return 1;
			} else if (f2 == null) {
				return -1;
			} else {
				return f1.compareTo(f2);
			}
		} else if (t1.equals(CELEBRACION_SUBASTA_ADJUDICACION) && (t2.equals(DICTAR_INSTRUCCIONES) || t2.equals(LECTURA_INSTRUCCIONES))) {
			return 1;
		} else if ((t1.equals(DICTAR_INSTRUCCIONES) || t1.equals(LECTURA_INSTRUCCIONES)) && t2.equals(CELEBRACION_SUBASTA_ADJUDICACION)) {
			return -1;
		}

		if ((f1 == null) && (f2 == null)) {
			return 0;
		} else if (f1 == null) {
			return 1;
		} else if (f2 == null) {
			return -1;
		}

		return f1.compareTo(f2);
	}

	/**
	 * Metodo que devuelve en primera instancia la fecha fin en caso de existir,
	 * si no existe devuelve la fecha inicio de la tarea
	 * 
	 * @param o
	 * @return fecha
	 */
	private Date getDate(Object o) {
		if (o instanceof HistoricoProcedimiento) {
			if (!Checks.esNulo(((HistoricoProcedimiento) o).getFechaFin())) {
				return ((HistoricoProcedimiento) o).getFechaFin();
			} else {
				return ((HistoricoProcedimiento) o).getFechaIni();
			}
		} else {
			if (!Checks.esNulo(((HistoricoAsuntoInfo) o).getTarea().getFechaFin())) {
				return ((HistoricoAsuntoInfo) o).getTarea().getFechaFin();
			} else
				return ((HistoricoAsuntoInfo) o).getTarea().getFechaIni();
		}
	}

	/**
	 * M茅todo que devuelve el nombre de la tarea
	 * 
	 * @param o
	 * @return nombre de la tarea
	 */
	private String getNombreTarea(Object o) {
		if (o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getNombreTarea();
		} else {
			return null;
		}
	}

}
