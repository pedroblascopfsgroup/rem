package es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample;

public class DictImpl implements DictInfo{

	private String des;

	public DictImpl(String description) {
		this.des = description;
	}

	@Override
	public String getDescripcion() {
		return this.des;
	}

}
