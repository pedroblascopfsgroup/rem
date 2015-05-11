package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto;

import java.util.List;

public class DtoCrearAnotacionWeb {

    private List<String> usuarios;

    private Long idUg;
    
    private String codUg;

    private String para;

    private String cc;

    private String asuntoMail;

    private String tipoAnotacion;

    private String fechaTodas;

    private String cuerpoEmail;
    
    private String adjuntosList;

    public String getPara() {
        return para;
    }

    public void setPara(String para) {
        this.para = para;
    }

    public String getCc() {
        return cc;
    }

    public void setCc(String cc) {
        this.cc = cc;
    }

    public String getCuerpoEmail() {
        return cuerpoEmail;
    }

    public void setCuerpoEmail(String cuerpoEmail) {
        this.cuerpoEmail = cuerpoEmail;
    }


    public String getAsuntoMail() {
        return asuntoMail;
    }

    public void setAsuntoMail(String asuntoMail) {
        this.asuntoMail = asuntoMail;
    }

    public List<String> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List<String> usuarios) {
        this.usuarios = usuarios;
    }

    public String getFechaTodas() {
        return fechaTodas;
    }

    public void setFechaTodas(String fechaTodas) {
        this.fechaTodas = fechaTodas;
    }

    public String getTipoAnotacion() {
        return tipoAnotacion;
    }

    public void setTipoAnotacion(String tipoAnotacion) {
        this.tipoAnotacion = tipoAnotacion;
    }

	public void setIdUg(Long idUg) {
		this.idUg = idUg;
	}

	public Long getIdUg() {
		return idUg;
	}

	public void setCodUg(String codUg) {
		this.codUg = codUg;
	}

	public String getCodUg() {
		return codUg;
	}

	public void setAdjuntosList(String adjuntosList) {
		this.adjuntosList = adjuntosList;
	}

	public String getAdjuntosList() {
		return adjuntosList;
	}

}
