package es.pfsgroup.commons.utils.web.dto.metadata;

public class HtmlTextElement {
	
	public static final String DEFAULT_STYLE= "margin-right:5px;margin-bottom:10px;color:#00008B";
	
	private String html;
	
	private boolean border = false;
	
	private String style = DEFAULT_STYLE;

	public String getHtml() {
		return html;
	}

	public void setHtml(String html) {
		this.html = html;
	}

	public boolean getBorder() {
		return border;
	}

	public void setBorder(boolean border) {
		this.border = border;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

}
