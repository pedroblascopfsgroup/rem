package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class NotificacionRequestDto extends RequestDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<NotificacionDto> data;

	public List<NotificacionDto> getData() {
		return data;
	}

	public void setData(List<NotificacionDto> data) {
		this.data = data;
	}

}
