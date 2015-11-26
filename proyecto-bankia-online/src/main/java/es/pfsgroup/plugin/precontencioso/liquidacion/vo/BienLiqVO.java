package es.pfsgroup.plugin.precontencioso.liquidacion.vo;

public class BienLiqVO {
	private String fincaRegistral;
	private String direccion;
	private String localidad;

	public BienLiqVO(String fincaRegistral, String direccion, String localidad) {
		this.fincaRegistral = fincaRegistral;
		this.direccion = direccion;
		this.localidad = localidad;
	}

	public String getFincaRegistral() {
		return fincaRegistral;
	}

	public String getDireccion() {
		return direccion;
	}

	public String getLocalidad() {
		return localidad;
	}
}
