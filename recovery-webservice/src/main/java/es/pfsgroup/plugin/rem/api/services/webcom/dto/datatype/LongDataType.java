package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class LongDataType extends WebcomDataType<Long>{
	
	private Long value;
	
	public LongDataType(Long val){
		this.value = val;
	}

	@Override
	public Long getValue() {
		return this.value;
	}
}
