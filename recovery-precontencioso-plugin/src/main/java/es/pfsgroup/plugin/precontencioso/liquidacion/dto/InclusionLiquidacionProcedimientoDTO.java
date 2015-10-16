package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;

public class InclusionLiquidacionProcedimientoDTO extends DtoInclusionExclusionContratoExpediente{
	
	private static final long serialVersionUID = -5674910483230642371L;
	private Long idProcedimiento;
	private String cexs;
	
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	
	/**
	 * @return the cexs
	 */
	public String getCexs() {
		return cexs;
	}
	/**
	 * @param cexs the cexs to set
	 */
	public void setCexs(String cexs) {
		this.cexs = cexs;
	}
}
