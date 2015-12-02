package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

public class ProcedimientoPCODTO extends WebDto {

	private static final long serialVersionUID = -3627628077164157073L;

	private Long id;
	private String estadoActual;
	private String estadoActualCodigo;
	private String tipoPreparacionDesc;
	private String tipoProcPropuestoDesc;
	private String tipoProcIniciadoDesc;
	private Boolean preturnado;
	private String nombreExpJudicial;
	private String numExpInterno;
	private String numExpExterno;
	private String cntPrincipal;
	private List<HistoricoEstadoProcedimientoDTO> estadosPreparacionProc;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipoPreparacionDesc() {
		return tipoPreparacionDesc;
	}
	public void setTipoPreparacionDesc(String tipoPreparacionDesc) {
		this.tipoPreparacionDesc = tipoPreparacionDesc;
	}
	public String getTipoProcPropuestoDesc() {
		return tipoProcPropuestoDesc;
	}
	public void setTipoProcPropuestoDesc(String tipoProcPropuestoDesc) {
		this.tipoProcPropuestoDesc = tipoProcPropuestoDesc;
	}
	public String getTipoProcIniciadoDesc() {
		return tipoProcIniciadoDesc;
	}
	public void setTipoProcIniciadoDesc(String tipoProcIniciadoDesc) {
		this.tipoProcIniciadoDesc = tipoProcIniciadoDesc;
	}
	public Boolean getPreturnado() {
		return preturnado;
	}
	public void setPreturnado(Boolean preturnado) {
		this.preturnado = preturnado;
	}
	public String getNombreExpJudicial() {
		return nombreExpJudicial;
	}
	public void setNombreExpJudicial(String nombreExpJudicial) {
		this.nombreExpJudicial = nombreExpJudicial;
	}
	public String getNumExpInterno() {
		return numExpInterno;
	}
	public void setNumExpInterno(String numExpInterno) {
		this.numExpInterno = numExpInterno;
	}
	public String getCntPrincipal() {
		return cntPrincipal;
	}
	public void setCntPrincipal(String cntPrincipal) {
		this.cntPrincipal = cntPrincipal;
	}
	public List<HistoricoEstadoProcedimientoDTO> getEstadosPreparacionProc() {
		return estadosPreparacionProc;
	}
	public void setEstadosPreparacionProc(List<HistoricoEstadoProcedimientoDTO> estadosPreparacionProc) {
		this.estadosPreparacionProc = estadosPreparacionProc;
	}
	public String getEstadoActual() {
		return estadoActual;
	}
	public void setEstadoActual(String estadoActual) {
		this.estadoActual = estadoActual;
	}
	public String getEstadoActualCodigo() {
		return estadoActualCodigo;
	}
	public void setEstadoActualCodigo(String estadoActualCodigo) {
		this.estadoActualCodigo = estadoActualCodigo;
	}
	public String getNumExpExterno() {
		return numExpExterno;
	}
	public void setNumExpExterno(String numExpExterno) {
		this.numExpExterno = numExpExterno;
	}
}
