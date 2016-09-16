package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

import java.util.Date;

public class DateDataType extends WebcomDataType<Date> {
	
	private Date value;

	protected DateDataType(Date d){
		this.value = d;
	}

	@Override
	public Date getValue() {
		return value;
	}

}
