package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class DtoColumnas extends PaginationParamsImpl{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2345472348736981181L;

	private Long id;
	private String header;
	private String dataindex;
	private String width;
	private String align;
	private Integer sortable;
	private Integer hidden;
	private String type;
	private String flowClick;
	private String panelTareas;
	private String etiqueta;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getHeader() {
		return header;
	}
	public void setHeader(String header) {
		this.header = header;
	}
	public String getDataindex() {
		return dataindex;
	}
	public void setDataindex(String dataindex) {
		this.dataindex = dataindex;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getAlign() {
		return align;
	}
	public void setAlign(String align) {
		this.align = align;
	}
	public Integer getSortable() {
		return sortable;
	}
	public void setSortable(Integer sortable) {
		this.sortable = sortable;
	}
	public Integer getHidden() {
		return hidden;
	}
	public void setHidden(Integer hidden) {
		this.hidden = hidden;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public void setFlowClick(String flowClick) {
		this.flowClick = flowClick;
	}
	public String getFlowClick() {
		return flowClick;
	}
	public void setPanelTareas(String panelTareas) {
		this.panelTareas = panelTareas;
	}
	public String getPanelTareas() {
		return panelTareas;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	
}
