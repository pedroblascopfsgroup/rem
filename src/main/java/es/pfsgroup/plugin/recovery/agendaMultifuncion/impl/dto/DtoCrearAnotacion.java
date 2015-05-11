package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto;

import java.util.Date;
import java.util.List;

import org.springframework.web.util.HtmlUtils;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;

public class DtoCrearAnotacion implements DtoCrearAnotacionInfo {

    private List<DtoCrearAnotacionUsuario> usuarios;

    private Long idUg;
    
    private String codUg;

    private List<String> direccionesMailPara;

    private List<String> direccionesMailCc;

    private String asuntoMail;

    private String tipoAnotacion;

    private Date fechaTodas;

    private String cuerpoEmail;
    
    private List<DtoAdjuntoMail> adjuntosList;

    @Override
    public List<DtoCrearAnotacionUsuario> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List<DtoCrearAnotacionUsuario> usuarios) {
        this.usuarios = usuarios;
    }

    @Override
    public Date getFechaTodas() {
        return fechaTodas != null ? ((Date) fechaTodas.clone()) : null;
    }

    public void setFechaTodas(Date fechaTodas) {
        this.fechaTodas = fechaTodas != null ? ((Date) fechaTodas.clone()) : null;
    }

    @Override
    public String getCuerpoEmail() {
        return HtmlUtils.htmlUnescape(cuerpoEmail);
    }

    public void setCuerpoEmail(String cuerpoEmail) {
        this.cuerpoEmail = cuerpoEmail;
    }

  

    @Override
    public String getAsuntoMail() {
        return asuntoMail;
    }

    public void setAsuntoMail(String asuntoMail) {
        this.asuntoMail = asuntoMail;
    }

    @Override
    public List<String> getDireccionesMailPara() {
        return direccionesMailPara;
    }

    public void setDireccionesMailPara(List<String> direccionesMailPara) {
        this.direccionesMailPara = direccionesMailPara;
    }

    @Override
    public List<String> getDireccionesMailCc() {
        return direccionesMailCc;
    }

    public void setDireccionesMailCc(List<String> direccionesMailCc) {
        this.direccionesMailCc = direccionesMailCc;
    }

    public String getTipoAnotacion() {
        return tipoAnotacion;
    }

    public void setTipoAnotacion(String tipoAnotacion) {
        this.tipoAnotacion = tipoAnotacion;
    }

	public void setCodUg(String codUg) {
		this.codUg = codUg;
	}

	@Override
	public String getCodUg() {
		return codUg;
	}

	public void setIdUg(Long idUg) {
		this.idUg = idUg;
	}

	@Override
	public Long getIdUg() {
		return idUg;
	}

	public List<DtoAdjuntoMail> getAdjuntosList() {
		return adjuntosList;
	}

	public void setAdjuntosList(List<DtoAdjuntoMail> adjuntosList) {
		this.adjuntosList = adjuntosList;
	}

	

}
