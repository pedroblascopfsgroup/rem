package es.pfsgroup.commons.utils.web.dto.metadata.xml;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

import es.pfsgroup.commons.utils.web.dto.metadata.HtmlTextElement;

public class XmlHtmlTextElement {
	
	@XStreamAsAttribute
	private Boolean border = Boolean.FALSE;
	
	@XStreamAsAttribute
	private String style = HtmlTextElement.DEFAULT_STYLE;
	
	@XStreamAsAttribute
	private String html;

	public Boolean getBorder() {
		return border;
	}

	public void setBorder(Boolean border) {
		this.border = border;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getHtml() {
		return html;
	}

	public void setHtml(String html) {
		this.html = html;
	}

}
