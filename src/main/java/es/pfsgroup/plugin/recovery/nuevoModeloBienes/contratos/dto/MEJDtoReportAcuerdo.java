package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBPersonasBienInfo;


public class MEJDtoReportAcuerdo extends WebDto {
	
	private static final long serialVersionUID = -6715794663560594941L;

	private Contrato contrato;
	
	private List<NMBDtoIntervinientes> intervinientesDemandados;
	
	private List <NMBPersonasBienInfo> personasBienContrato;
	
	private Procedimiento actuacionActual;

	private String actActFechaAuto;
	
	private String hitoActual;
	
	private List <Procedimiento> actuacionesDerivadas;
	
	private List <NMBDtoProcedimientoOrigen> procedimientosOrigen;
	
	private List <NMBBienInfo> bienesTrabados;
	
	private Usuario usuarioLogado;
	
	/* datos subasta */
	
	private Float subastaPrincipal;
	
	private String subastaObservaciones;
	
	private Date subastaFecha;
	
	private Float subastaCosta;
	
	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Procedimiento getActuacionActual() {
		return actuacionActual;
	}

	public void setActuacionActual(Procedimiento actuacionActual) {
		this.actuacionActual = actuacionActual;
	}

	/**
	 * @param bienesTrabados the bienesTrabados to set
	 */
	public void setBienesTrabados(List <NMBBienInfo> bienesTrabados) {
		this.bienesTrabados = bienesTrabados;
	}

	/**
	 * @return the bienesTrabados
	 */
	public List <NMBBienInfo> getBienesTrabados() {
		return bienesTrabados;
	}

	/**
	 * @param personasBienContrato the personasBienContrato to set
	 */
	public void setPersonasBienContrato(List <NMBPersonasBienInfo> personasBienContrato) {
		this.personasBienContrato = personasBienContrato;
	}

	/**
	 * @return the personasBienContrato
	 */
	public List <NMBPersonasBienInfo> getPersonasBienContrato() {
		return personasBienContrato;
	}

	/**
	 * @param actActFechaAuto the actActFechaAuto to set
	 */
	public void setActActFechaAuto(String actActFechaAuto) {
		this.actActFechaAuto = actActFechaAuto;
	}

	/**
	 * @return the actActFechaAuto
	 */
	public String getActActFechaAuto() {
		return actActFechaAuto;
	}

	/**
	 * @param hitoActual the hitoActual to set
	 */
	public void setHitoActual(String hitoActual) {
		this.hitoActual = hitoActual;
	}

	/**
	 * @return the hitoActual
	 */
	public String getHitoActual() {
		return hitoActual;
	}

	/**
	 * @param actuacionesDerivadas the actuacionesDerivadas to set
	 */
	public void setActuacionesDerivadas(List <Procedimiento> actuacionesDerivadas) {
		this.actuacionesDerivadas = actuacionesDerivadas;
	}

	/**
	 * @return the actuacionesDerivadas
	 */
	public List <Procedimiento> getActuacionesDerivadas() {
		return actuacionesDerivadas;
	}

	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}

	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}

	public void setProcedimientosOrigen(List <NMBDtoProcedimientoOrigen> procedimientosOrigen) {
		this.procedimientosOrigen = procedimientosOrigen;
	}

	public List <NMBDtoProcedimientoOrigen> getProcedimientosOrigen() {
		return procedimientosOrigen;
	}

	public void setIntervinientesDemandados(List<NMBDtoIntervinientes> intervinientesDemandados) {
		this.intervinientesDemandados = intervinientesDemandados;
	}

	public List<NMBDtoIntervinientes> getIntervinientesDemandados() {
		return intervinientesDemandados;
	}

	public Float getSubastaPrincipal() {
		return subastaPrincipal;
	}

	public void setSubastaPrincipal(Float subastaPrincipal) {
		this.subastaPrincipal = subastaPrincipal;
	}

	public String getSubastaObservaciones() {
		return subastaObservaciones;
	}

	public void setSubastaObservaciones(String subastaObservaciones) {
		this.subastaObservaciones = subastaObservaciones;
	}

	public Date getSubastaFecha() {
		return subastaFecha;
	}

	public void setSubastaFecha(Date subastaFecha) {
		this.subastaFecha = subastaFecha;
	}

	public Float getSubastaCosta() {
		return subastaCosta;
	}

	public void setSubastaCosta(Float subastaCosta) {
		this.subastaCosta = subastaCosta;
	}


}
