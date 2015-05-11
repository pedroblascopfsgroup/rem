package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto;

import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

public class RecoveryAgendaMultifuncionDtoBusquedaAsunto extends EXTDtoBusquedaAsunto {

    private static final long serialVersionUID = -4205386375034721322L;

    private String usuarioDestinoTarea;
    private String usuarioOrigenTarea;
    private String tipoAnotacion;
    private Boolean soloAsuntosEnvioCorreo;
    private String destinatarioEmail;

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getUsuarioDestinoTarea() {
        return usuarioDestinoTarea;
    }

    public void setUsuarioDestinoTarea(String usuarioDestinoTarea) {
        this.usuarioDestinoTarea = usuarioDestinoTarea;
    }

    public String getUsuarioOrigenTarea() {
        return usuarioOrigenTarea;
    }

    public void setUsuarioOrigenTarea(String usuarioOrigenTarea) {
        this.usuarioOrigenTarea = usuarioOrigenTarea;
    }

    public Boolean getSoloAsuntosEnvioCorreo() {
        return soloAsuntosEnvioCorreo;
    }

    public void setSoloAsuntosEnvioCorreo(Boolean soloAsuntosEnvioCorreo) {
        this.soloAsuntosEnvioCorreo = soloAsuntosEnvioCorreo;
    }

    public String getDestinatarioEmail() {
        return destinatarioEmail;
    }

    public void setDestinatarioEmail(String destinatarioEmail) {
        this.destinatarioEmail = destinatarioEmail;
    }

    public String getTipoAnotacion() {
        return tipoAnotacion;
    }

    public void setTipoAnotacion(String tipoAnotacion) {
        this.tipoAnotacion = tipoAnotacion;
    }

}
