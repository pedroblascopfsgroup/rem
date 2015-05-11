package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto;

import java.io.Serializable;
import java.text.ParseException;
import java.util.Date;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;

/**
 * Implementación de la petición de cambio masivo de gestores, pasando por el controller
 * @author bruno
 *
 */
public class PeticionCambioMasivoGestoresDtoImpl implements PeticionCambioMasivoGestoresDto, Serializable{

	private static final long serialVersionUID = -201505910984267360L;

	public void setSolicitante(Usuario solicitante) {
		this.solicitante = solicitante;
	}

	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public void setIdGestorOriginal(Long idGestorOriginal) {
		this.idGestorOriginal = idGestorOriginal;
	}

	public void setIdNuevoGestor(Long idNuevoGestor) {
		this.idNuevoGestor = idNuevoGestor;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public void setReasignado(boolean reasignado) {
		this.reasignado = reasignado;
	}

	private Usuario solicitante;
	private String tipoGestor;
	private Long idGestorOriginal;
	private Long idNuevoGestor;
	private Date fechaInicio;
	private Date fechaFin;
	private boolean reasignado;

	@Override
	public Usuario getSolicitante() {
		return this.solicitante;
	}

	@Override
	public String getTipoGestor() {
		return this.tipoGestor;
	}

	@Override
	public Long getIdGestorOriginal() {
		return this.idGestorOriginal;
	}

	@Override
	public Long getIdNuevoGestor() {
		return this.idNuevoGestor;
	}

	@Override
	public Date getFechaInicio() {
		return this.fechaInicio;
	}

	@Override
	public Date getFechaFin() {
		return this.fechaFin;
	}

	@Override
	public boolean isReasignado() {
		return this.reasignado;
	}

}
