package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto;

import java.io.Serializable;

public class BienCargaDto implements Serializable {

	private static final long serialVersionUID = 913074006597054670L;

	public static String REGISTRAL = "Registral";
	public static String ECONOMICA = "Economica";

	private String tipoCarga;
	private String acreedor;
	private Float importe;

	public String getTipoCarga() {
		return tipoCarga;
	}

	public void setTipoCarga(String tipoCarga) {
		this.tipoCarga = tipoCarga;
	}

	public String getAcreedor() {
		return acreedor;
	}

	public void setAcreedor(String acreedor) {
		this.acreedor = acreedor;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}
}
