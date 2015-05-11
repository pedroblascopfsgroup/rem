package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;

public interface DtoCrearAnotacionInfo {

    public abstract Long getIdUg();
    
    public abstract String getCodUg();

    public abstract List<? extends DtoCrearAnotacionUsuarioInfo> getUsuarios();

    public abstract String getAsuntoMail();

    public abstract String getTipoAnotacion();

    public abstract Date getFechaTodas();

    public abstract String getCuerpoEmail();

    public abstract List<String> getDireccionesMailPara();

    public abstract List<String> getDireccionesMailCc();
    
    public List<DtoAdjuntoMail> getAdjuntosList() ;

}
