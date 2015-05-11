package es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample;

public class OtherImpl implements OtherInfo{

	private String description;
	
	

	public OtherImpl(String description) {
		super();
		this.description = description;
	}



	@Override
	public String getDescripcion() {
		return this.description;
	}

}
