package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

import java.util.Date;

public interface DtoCrearAnotacionUsuarioInfo {

    public abstract Long getId();

    public abstract boolean isIncorporar();

    public abstract Date getFecha();

    public abstract boolean isEmail();

}
