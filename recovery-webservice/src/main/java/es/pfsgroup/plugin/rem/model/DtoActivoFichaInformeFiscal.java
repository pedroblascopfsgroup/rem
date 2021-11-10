package es.pfsgroup.plugin.rem.model;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoImpuestoCompra;
import es.pfsgroup.plugin.rem.model.dd.DDTipoITP;
import es.pfsgroup.plugin.rem.model.dd.DDTipoIVA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImpuestoCompra;

import javax.persistence.*;

/**
 * Dto para la pestaña Informe Fiscal
 */
public class DtoActivoFichaInformeFiscal extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String codigoTipoImpuestoCompra;

	private String bonificado;

	private String codigoTipoImpositivoITP;

	private String codigoTipoImpositivoIVA;

	private Double porcentajeImpuestoCompra;

	private String codigoTpIvaCompra;

	private String renunciaExencionCompra;

	private String deducible;

	public String getCodigoTipoImpuestoCompra() {
		return codigoTipoImpuestoCompra;
	}

	public void setCodigoTipoImpuestoCompra(String codigoTipoImpuestoCompra) {
		this.codigoTipoImpuestoCompra = codigoTipoImpuestoCompra;
	}

	public String getBonificado() {
		return bonificado;
	}

	public void setBonificado(String bonificado) {
		this.bonificado = bonificado;
	}

	public String getCodigoTipoImpositivoITP() {
		return codigoTipoImpositivoITP;
	}

	public void setCodigoTipoImpositivoITP(String codigoTipoImpositivoITP) {
		this.codigoTipoImpositivoITP = codigoTipoImpositivoITP;
	}

	public String getCodigoTipoImpositivoIVA() {
		return codigoTipoImpositivoIVA;
	}

	public void setCodigoTipoImpositivoIVA(String codigoTipoImpositivoIVA) {
		this.codigoTipoImpositivoIVA = codigoTipoImpositivoIVA;
	}

	public Double getPorcentajeImpuestoCompra() {
		return porcentajeImpuestoCompra;
	}

	public void setPorcentajeImpuestoCompra(Double porcentajeImpuestoCompra) {
		this.porcentajeImpuestoCompra = porcentajeImpuestoCompra;
	}

	public String getCodigoTpIvaCompra() {
		return codigoTpIvaCompra;
	}

	public void setCodigoTpIvaCompra(String codigoTpIvaCompra) {
		this.codigoTpIvaCompra = codigoTpIvaCompra;
	}

	public String getRenunciaExencionCompra() {
		return renunciaExencionCompra;
	}

	public void setRenunciaExencionCompra(String renunciaExencionCompra) {
		this.renunciaExencionCompra = renunciaExencionCompra;
	}

	public String getDeducible() {
		return deducible;
	}

	public void setDeducible(String deducible) {
		this.deducible = deducible;
	}
}