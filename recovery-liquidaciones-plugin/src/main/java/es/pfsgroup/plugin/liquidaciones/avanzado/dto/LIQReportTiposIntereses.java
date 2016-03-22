package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.util.Date;

import es.pfsgroup.commons.utils.DateFormat;

public class LIQReportTiposIntereses implements Comparable<LIQReportTiposIntereses> {

	private String fecha;
	private Float tipoInteres;
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public Float getTipoInteres() {
		return tipoInteres;
	}
	public void setTipoInteres(Float tipoInteres) {
		this.tipoInteres = tipoInteres;
	}
	
	@Override
	public int compareTo(LIQReportTiposIntereses o) {
		Date do1;
		Date do2;
		try {
			do1 = DateFormat.toDate(this.getFecha());
			do2 = DateFormat.toDate(o.getFecha());
		} catch (Exception e) {
			return 0;
		}
		return do1.compareTo(do2);
	}

}
