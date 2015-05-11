package es.pfsgroup.plugin.recovery.mejoras.procedimiento.dto;

import java.math.BigDecimal;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class MEJDtoBloquearProcedimientos extends PaginationParamsImpl{
	
	private static final long serialVersionUID = -5674910483230642371L;
	private static final int N = 10;
    private String tipoProcedimiento;
    private String tipoReclamacion;
    private BigDecimal saldorecuperar;
    private Long asunto;
    private String contratos;
	private Long[] personas;
	
	/**
	 *  constructor.
	 */
	public MEJDtoBloquearProcedimientos() {
		personas = new Long[N];
		for (int i = 0; i < N; i++) {
			personas[i] = new Long(0);
		}
	}

	/**
	 * @return the personas
	 */
	public Long[] getPersonas() {
		return personas;
	}

	/**
	 * @param personas the personas to set
	 */
	public void setPersonas(Long[] personas) {
		this.personas = personas;
	}

	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public String getTipoReclamacion() {
		return tipoReclamacion;
	}

	public void setTipoReclamacion(String tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}

	public BigDecimal getSaldorecuperar() {
		return saldorecuperar;
	}

	public void setSaldorecuperar(BigDecimal saldorecuperar) {
		this.saldorecuperar = saldorecuperar;
	}

	public Long getAsunto() {
		return asunto;
	}

	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}

	public String getContratos() {
		return contratos;
	}

	public void setContratos(String contratos) {
		this.contratos = contratos;
	}
	
}
