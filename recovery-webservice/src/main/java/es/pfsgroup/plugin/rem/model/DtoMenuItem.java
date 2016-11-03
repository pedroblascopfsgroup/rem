package es.pfsgroup.plugin.rem.model;

public class DtoMenuItem {
	
	private String text;
	
	private String view;
	
	private String iconCls;
	
	private String cls;
	
	private String leaf;
	
	private String routeId;
	
	private String secFunPermToRender;
	
	

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getView() {
		return view;
	}

	public void setView(String view) {
		this.view = view;
	}



	public String getIconCls() {
		return iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}

	public String getCls() {
		return cls;
	}

	public void setCls(String cls) {
		this.cls = cls;
	}

	public String getLeaf() {
		return leaf;
	}

	public void setLeaf(String leaf) {
		this.leaf = leaf;
	}

	public String getRouteId() {
		return routeId;
	}

	public void setRouteId(String routeId) {
		this.routeId = routeId;
	}

	public String getSecFunPermToRender() {
		return secFunPermToRender;
	}

	public void setSecFunPermToRender(String secFunPermToRender) {
		this.secFunPermToRender = secFunPermToRender;
	}

	
}
