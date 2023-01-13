package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

public class CorreoDto implements Serializable {
    
	private static final long serialVersionUID = 8430039744476921326L;
	
	private String subject;
    private String body;
    private String html;
    private List<String> to;
    private List<String> toCC;
    private List<CorreoAdjuntoDto> files;
    
    public CorreoDto() {}

    public CorreoDto(String subject, String body, String html, List<String> to, List<String> toCC, List<CorreoAdjuntoDto> files) {
		super();
		this.subject = subject;
		this.body = body;
		this.html = html;
		this.to = to;
		this.toCC = toCC;
		this.files = files;
	}

	public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public String getHtml() {
        return html;
    }

    public void setHtml(String html) {
        this.html = html;
    }

    public List<String> getTo() {
		return to;
	}

	public void setTo(List<String> to) {
		this.to = to;
	}

	public List<String> getToCC() {
		return toCC;
	}

	public void setToCC(List<String> toCC) {
		this.toCC = toCC;
	}

	public List<CorreoAdjuntoDto> getFiles() {
        return files;
    }

    public void setFiles(List<CorreoAdjuntoDto> files) {
        this.files = files;
    }

}