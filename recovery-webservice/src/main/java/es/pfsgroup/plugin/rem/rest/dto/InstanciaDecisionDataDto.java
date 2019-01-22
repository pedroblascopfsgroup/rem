package es.pfsgroup.plugin.rem.rest.dto;

import es.pfsgroup.commons.utils.Checks;

public class InstanciaDecisionDataDto {

	public final static short PROPUESTA_VENTA = 1;
	public final static short PROPUESTA_CONTRAOFERTA = 3;
	public final static short PROPUESTA_HONORARIOS = 6;
	public final static short PROPUESTA_TITULARES = 5;
	public final static short PROPUESTA_CONDICIONANTES_ECONOMICOS = 4;
	
	public final static short TIPO_IMPUESTO_SIN_IMPUESTO = 0;
	public final static short TIPO_IMPUESTO_ITP = 1;
	public final static short TIPO_IMPUESTO_IVA = 2;
	public final static short TIPO_IMPUESTO_IGIC = 3;
	public final static short TIPO_IMPUESTO_IPSI = 4;
	

	private Integer identificadorActivoEspecial;
	private Long importeConSigno; //Es el de cada activo. Se calcula con el % de la oferta de cada activo por el importe de la oferta
	private short tipoDeImpuesto;
	private int porcentajeImpuesto;
	private Boolean renunciaExencion;
	

	public Integer getIdentificadorActivoEspecial() {
		return identificadorActivoEspecial;
	}
	public void setIdentificadorActivoEspecial(Integer identificadorActivoEspecial) {
		this.identificadorActivoEspecial = identificadorActivoEspecial;
	}
	public Long getImporteConSigno() {
		return importeConSigno;
	}
	public void setImporteConSigno(Long importeConSigno) {
		this.importeConSigno = importeConSigno;
	}
	public short getTipoDeImpuesto() {
		return tipoDeImpuesto;
	}
	public void setTipoDeImpuesto(short tipoDeImpuesto) {
		this.tipoDeImpuesto = tipoDeImpuesto;
	}
	public int getPorcentajeImpuesto() {
		return porcentajeImpuesto;
	}
	public void setPorcentajeImpuesto(int porcentajeImpuesto) {
		this.porcentajeImpuesto = porcentajeImpuesto;
	}
	public Boolean getRenunciaExencion() {
		return renunciaExencion;
	}
	public void setRenunciaExencion(Boolean renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}
}
