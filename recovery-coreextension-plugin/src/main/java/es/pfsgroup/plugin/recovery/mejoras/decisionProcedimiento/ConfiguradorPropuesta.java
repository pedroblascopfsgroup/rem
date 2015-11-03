package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento;

public class ConfiguradorPropuesta {

	private boolean crearCabecera;
	private boolean crearOActualizar;
	private boolean registrarSaldos;
	private boolean lanzarBPMs;
	private boolean finalizarProcedimiento;
	private boolean paralizarProcedimiento;
	private boolean aplazarBPMs;
	private boolean aceptarDecision;
	private boolean finalizarTareaAsociada;
	private boolean borrarTareaAsociada;
	private boolean finalizarTareasTomaDecision;
	private boolean actualizarEstadoAsunto;
	private boolean notificarGestor;
	private boolean enviarDatos;
	
	public static final String SIN_BPMS = "SIN_BPMS";
	public static final String SIN_ENVIO_DATOS = "SIN_ENVIO_DATOS";
	public static final String SOLO_ENVIAR = "SOLO_ENVIAR";
	
	
	public ConfiguradorPropuesta() {
		this.crearCabecera = true;
		this.crearOActualizar = true;
		this.registrarSaldos = true;
		this.lanzarBPMs = true;
		this.finalizarProcedimiento = true;
		this.paralizarProcedimiento = true;
		this.aplazarBPMs = true;
		this.aceptarDecision = true;
		this.finalizarTareaAsociada = true;
		this.borrarTareaAsociada = true;
		this.finalizarTareasTomaDecision = true;
		this.actualizarEstadoAsunto = true;
		this.notificarGestor = true;
		this.enviarDatos = true;
	}
	
	public boolean isCrearCabecera() {
		return crearCabecera;
	}

	public void setCrearCabecera(boolean crearCabecera) {
		this.crearCabecera = crearCabecera;
	}

	/**
	 * @return the crearOActualizar
	 */
	public boolean isCrearOActualizar() {
		return crearOActualizar;
	}
	
	/**
	 * @param crearOActualizar the crearOActualizar to set
	 */
	public void setCrearOActualizar(boolean crearOActualizar) {
		this.crearOActualizar = crearOActualizar;
	}
	
	/**
	 * @return the registrarSaldos
	 */
	public boolean isRegistrarSaldos() {
		return registrarSaldos;
	}
	
	/**
	 * @param registrarSaldos the registrarSaldos to set
	 */
	public void setRegistrarSaldos(boolean registrarSaldos) {
		this.registrarSaldos = registrarSaldos;
	}
	
	/**
	 * @return the lanzarBPMs
	 */
	public boolean isLanzarBPMs() {
		return lanzarBPMs;
	}
	
	/**
	 * @param lanzarBPMs the lanzarBPMs to set
	 */
	public void setLanzarBPMs(boolean lanzarBPMs) {
		this.lanzarBPMs = lanzarBPMs;
	}
	
	/**
	 * @return the finalizarProcedimiento
	 */
	public boolean isFinalizarProcedimiento() {
		return finalizarProcedimiento;
	}
	
	/**
	 * @param finalizarProcedimiento the finalizarProcedimiento to set
	 */
	public void setFinalizarProcedimiento(boolean finalizarProcedimiento) {
		this.finalizarProcedimiento = finalizarProcedimiento;
	}
	
	/**
	 * @return the paralizarProcedimiento
	 */
	public boolean isParalizarProcedimiento() {
		return paralizarProcedimiento;
	}
	
	/**
	 * @param paralizarProcedimiento the paralizarProcedimiento to set
	 */
	public void setParalizarProcedimiento(boolean paralizarProcedimiento) {
		this.paralizarProcedimiento = paralizarProcedimiento;
	}
	
	public boolean isAplazarBPMs() {
		return aplazarBPMs;
	}

	public void setAplazarBPMs(boolean aplazarBPMs) {
		this.aplazarBPMs = aplazarBPMs;
	}

	/**
	 * @return the aceptarDecision
	 */
	public boolean isAceptarDecision() {
		return aceptarDecision;
	}
	
	/**
	 * @param aceptarDecision the aceptarDecision to set
	 */
	public void setAceptarDecision(boolean aceptarDecision) {
		this.aceptarDecision = aceptarDecision;
	}
	
	/**
	 * @return the finalizarTareaAsociada
	 */
	public boolean isFinalizarTareaAsociada() {
		return finalizarTareaAsociada;
	}
	
	/**
	 * @param finalizarTareaAsociada the finalizarTareaAsociada to set
	 */
	public void setFinalizarTareaAsociada(boolean finalizarTareaAsociada) {
		this.finalizarTareaAsociada = finalizarTareaAsociada;
	}
	
	/**
	 * @return the borrarTareaAsociada
	 */
	public boolean isBorrarTareaAsociada() {
		return borrarTareaAsociada;
	}
	
	/**
	 * @param borrarTareaAsociada the borrarTareaAsociada to set
	 */
	public void setBorrarTareaAsociada(boolean borrarTareaAsociada) {
		this.borrarTareaAsociada = borrarTareaAsociada;
	}
	
	/**
	 * @return the finalizarTareasTomaDecision
	 */
	public boolean isFinalizarTareasTomaDecision() {
		return finalizarTareasTomaDecision;
	}
	
	/**
	 * @param finalizarTareasTomaDecision the finalizarTareasTomaDecision to set
	 */
	public void setFinalizarTareasTomaDecision(boolean finalizarTareasTomaDecision) {
		this.finalizarTareasTomaDecision = finalizarTareasTomaDecision;
	}
	
	/**
	 * @return the actualizarEstadoAsunto
	 */
	public boolean isActualizarEstadoAsunto() {
		return actualizarEstadoAsunto;
	}
	
	/**
	 * @param actualizarEstadoAsunto the actualizarEstadoAsunto to set
	 */
	public void setActualizarEstadoAsunto(boolean actualizarEstadoAsunto) {
		this.actualizarEstadoAsunto = actualizarEstadoAsunto;
	}
	
	public boolean isNotificarGestor() {
		return notificarGestor;
	}

	public void setNotificarGestor(boolean notificarGestor) {
		this.notificarGestor = notificarGestor;
	}

	public boolean isEnviarDatos() {
		return enviarDatos;
	}

	public void setEnviarDatos(boolean enviarDatos) {
		this.enviarDatos = enviarDatos;
	}

	public void setConfiguracion(String tipoConfiguracion) {

		if(tipoConfiguracion.equals(SIN_BPMS)) {
			this.setLanzarBPMs(false);
			this.setAplazarBPMs(false);
			this.setFinalizarTareaAsociada(false);
			this.setBorrarTareaAsociada(false);
		}
		else if(tipoConfiguracion.equals(SIN_ENVIO_DATOS)) {
			this.setEnviarDatos(false);
		}
		else if(tipoConfiguracion.equals(SOLO_ENVIAR)) {
			this.crearOActualizar = false;
			this.registrarSaldos = false;
			this.lanzarBPMs = false;
			this.finalizarProcedimiento = false;
			this.paralizarProcedimiento = false;
			this.aceptarDecision = false;
			this.finalizarTareaAsociada = false;
			this.borrarTareaAsociada = false;
			this.finalizarTareasTomaDecision = false;
			this.actualizarEstadoAsunto = false;
			this.notificarGestor = false;
		}
	}
	
}
