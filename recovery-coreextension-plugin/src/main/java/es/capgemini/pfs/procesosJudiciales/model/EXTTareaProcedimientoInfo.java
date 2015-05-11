package es.capgemini.pfs.procesosJudiciales.model;

public interface EXTTareaProcedimientoInfo {
	
	/**
	 * 
	 * @return devuelve true si esa tarea permite autoprorroga
	 */
	Boolean getAutoprorroga();
	
	Integer getMaximoAutoprorrogas();
	

}
