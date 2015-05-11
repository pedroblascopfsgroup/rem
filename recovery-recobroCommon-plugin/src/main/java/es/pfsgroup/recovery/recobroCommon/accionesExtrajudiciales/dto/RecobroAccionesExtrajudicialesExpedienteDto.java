package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

/**
 * @author manuel
 * 
 *         Dto utilizado para el filtrado de las acciones en la pantalla de
 *         acciones del expediente.
 */
public class RecobroAccionesExtrajudicialesExpedienteDto extends WebDto {
	private static final long serialVersionUID = -4562204984789531450L;

	private Long idExpediente;

	private Long idAgencia;

	private Long idTipo;

	private Long idCicloRecobroExp;

	private Long idResultado;

	private String fechaHasta;

	private String fechaDesde;
	
	private List<Long> listaAgencias;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdAgencia() {
		return idAgencia;
	}

	public void setIdAgencia(Long idAgencia) {
		this.idAgencia = idAgencia;
	}

	public Long getIdTipo() {
		return idTipo;
	}

	public void setIdTipo(Long idTipo) {
		this.idTipo = idTipo;
	}

	public Long getIdCicloRecobroExp() {
		return idCicloRecobroExp;
	}

	public void setIdCicloRecobroExp(Long idCicloRecobroExp) {
		this.idCicloRecobroExp = idCicloRecobroExp;
	}

	public Long getIdResultado() {
		return idResultado;
	}

	public void setIdResultado(Long idResultado) {
		this.idResultado = idResultado;
	}

	public String getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(String fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public String getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(String fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public List<Long> getListaAgencias() {
		return listaAgencias;
	}

	public void setListaAgencias(List<Long> listaAgencias) {
		this.listaAgencias = listaAgencias;
	}
}
