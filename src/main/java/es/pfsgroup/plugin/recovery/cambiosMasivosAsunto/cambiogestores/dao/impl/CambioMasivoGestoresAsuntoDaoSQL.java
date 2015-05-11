package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.impl;

/**
 * Contenedor de sentencias SQL para {@link CambioMasivoGestoresAsuntoDaoImpl}
 * <p>
 * Este bean se configura en classpath:optionalConfiguration/ac-plugin-cambiosMasivosAsunto-dao.xml
 * @author bruno
 *
 */
public class CambioMasivoGestoresAsuntoDaoSQL {

	private String insertDirectoPeticiones;
	private String codigoTipoGestor;
	private String idGestorOriginal;
	private String idSolicitante;
	private String idGestorNuevo;
	private String fechaInicio;
	private String fechaFin;
	private String usuarioCrear;
	private String countPeticiones;
	private String insertDirectoPeticionesPorAsunto;
	private String asuntosAmodificar;
	
	public String getInsertDirectoPeticiones() {
		return insertDirectoPeticiones;
	}
	
	public String getCountPeticiones() {
		return countPeticiones;
	}

	public void setCountPeticiones(String countPeticiones) {
		this.countPeticiones = countPeticiones;
	}

	/*
	 * Nombres de parametros
	 * 
	 */
	public String getCodigoTipoGestor() {
		return codigoTipoGestor;
	}

	public String getIdGestorOriginal() {
		return idGestorOriginal;
	}

	public String getIdSolicitante() {
		return idSolicitante;
	}

	public String getIdGestorNuevo() {
		return idGestorNuevo;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}

	public String getFechaFin() {
		return fechaFin;
	}

	public String getUsuarioCrear() {
		return usuarioCrear;
	}

	public void setInsertDirectoPeticiones(String insertDirectoPeticiones) {
		this.insertDirectoPeticiones = insertDirectoPeticiones;
	}

	public void setCodigoTipoGestor(String codigoTipoGestor) {
		this.codigoTipoGestor = codigoTipoGestor;
	}

	public void setIdGestorOriginal(String idGestorOriginal) {
		this.idGestorOriginal = idGestorOriginal;
	}

	public void setIdSolicitante(String idSolicitante) {
		this.idSolicitante = idSolicitante;
	}

	public void setIdGestorNuevo(String idGestorNuevo) {
		this.idGestorNuevo = idGestorNuevo;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}

	public String getInsertDirectoPeticionesPorAsunto() {
		return insertDirectoPeticionesPorAsunto;
	}

	public void setInsertDirectoPeticionesPorAsunto(
			String insertDirectoPeticionesPorAsunto) {
		this.insertDirectoPeticionesPorAsunto = insertDirectoPeticionesPorAsunto;
	}

	public String getAsuntosAmodificar() {
		return asuntosAmodificar;
	}

	public void setAsuntosAmodificar(String asuntosAmodificar) {
		this.asuntosAmodificar = asuntosAmodificar;
	}

}
