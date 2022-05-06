package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class CorreoAdjuntoDto implements Serializable {
    
	private static final long serialVersionUID = 8430039744476921326L;
	
	private String originalname;
    private String buffer;
    private String mimetype;

    public CorreoAdjuntoDto() {}

    public CorreoAdjuntoDto(String originalname, String buffer, String mimetype) {
        this.originalname = originalname;
        this.buffer = buffer;
        this.mimetype = mimetype;
    }

    public String getOriginalname() {
        return originalname;
    }

    public void setOriginalname(String originalname) {
        this.originalname = originalname;
    }

    public String getBuffer() {
        return buffer;
    }

    public void setBuffer(String buffer) {
        this.buffer = buffer;
    }

    public String getMimetype() {
        return mimetype;
    }

    public void setMimetype(String mimetype) {
        this.mimetype = mimetype;
    }
    
}