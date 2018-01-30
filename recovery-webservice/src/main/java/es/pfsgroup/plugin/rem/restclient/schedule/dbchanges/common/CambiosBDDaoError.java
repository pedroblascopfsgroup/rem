package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

public class CambiosBDDaoError extends RuntimeException {

	private static final long serialVersionUID = -7120797408760910831L;

	private InfoTablasBD infoTablas;

	public CambiosBDDaoError(String message, String queryString, InfoTablasBD infoTablas, Throwable t) {
		super(message + "-> QUERY ERROR [ " + queryString + "] ", t);
		this.infoTablas = infoTablas;
	}
	
	public CambiosBDDaoError(String message, String queryString, Throwable t) {
		super(message + "-> QUERY ERROR [ " + queryString + "] ", t);
		this.infoTablas = null;
	}
	
	
	public CambiosBDDaoError(String string) {
		super(string);
	}

	public CambiosBDDaoError(String string, Throwable e) {
		super(string, e);
	}

	private String stringIze(InfoTablasBD infoTablas) {
		if (infoTablas != null) {
			StringBuilder b = new StringBuilder("[");
			b.append("da=").append(infoTablas.nombreVistaDatosActuales());
			b.append(", dh=").append(infoTablas.nombreTablaDatosHistoricos());
			b.append(", pk=").append(infoTablas.clavePrimaria());
			b.append("]");
			return b.toString();
		} else {
			return "";
		}
	}

	@Override
	public String getMessage() {
		String result = null;
		if(this.infoTablas!= null){
			result = super.getMessage() + " " + stringIze(infoTablas);
		}else{
			result = super.getMessage();
		}
		return result;
	}

}
