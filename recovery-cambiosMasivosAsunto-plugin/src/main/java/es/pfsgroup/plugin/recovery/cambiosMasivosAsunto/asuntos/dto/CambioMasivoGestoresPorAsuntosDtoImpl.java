package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dto;

import java.io.Serializable;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.CambioMasivoGestoresPorAsuntosDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;

/**
 * Implementación de la petición de cambio masivo de gestores, pasando por el controller
 * @author bruno
 *
 */
public class CambioMasivoGestoresPorAsuntosDtoImpl implements CambioMasivoGestoresPorAsuntosDto, Serializable{

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

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public void setReasignado(boolean reasignado) {
		this.reasignado = reasignado;
	}

	public void setListaAsuntos(List<Long> listaAsuntos) {
		this.listaAsuntos = listaAsuntos;
	}
	
	private Usuario solicitante;
	private String tipoGestor;
	private Long idGestorOriginal;
	private Date fechaInicio;
	private Date fechaFin;
	private boolean reasignado;
	private List<Long> listaAsuntos;

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

	@Override
	public List<Long> getListaAsuntos() {
		return this.listaAsuntos;
	}

}
