package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class DoubleDataType extends WebcomDataType<Double>{
	
	private Double value;

	protected DoubleDataType(Double f){
		this.value = f;
	}

	@Override
	public Double getValue() {
		return this.value;
	}

}
