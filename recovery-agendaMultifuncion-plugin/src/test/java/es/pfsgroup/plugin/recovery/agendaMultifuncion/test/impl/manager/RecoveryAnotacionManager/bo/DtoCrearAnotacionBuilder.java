package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager.bo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionUsuarioInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoAdjuntoMail;

public class DtoCrearAnotacionBuilder {
    
    protected final Long idUnidadGestion;
    
    protected final List<String> direccionesEmailPara;

    private final List<String> direccionesEmailCC;
    
    private final List<Long> idUsuarios;
    
    public DtoCrearAnotacionBuilder(Long idUnidadGestion, List<Long> idUsuarios, List<String> direccionesEmailPara, List<String> direccionesEmailCC) {
        super();
        this.idUnidadGestion = idUnidadGestion;
        this.direccionesEmailPara = direccionesEmailPara;
        this.direccionesEmailCC = direccionesEmailCC;
        this.idUsuarios = idUsuarios;
    }
    
    
    public DtoCrearAnotacionInfo nuevoDtoCrearAnotacionConUsuarios(final boolean conEmail) {
        return new DtoCrearAnotacionInfo() {

            @Override
            public List<? extends DtoCrearAnotacionUsuarioInfo> getUsuarios() {
                final ArrayList<DtoCrearAnotacionUsuarioInfo> usuarios = new ArrayList<DtoCrearAnotacionUsuarioInfo>();
                for (Long idusu : idUsuarios){
                    usuarios.add(nuevoDtoUsuario(idusu, conEmail));
                }
                return usuarios;
            }

            @Override
            public String getTipoAnotacion() {
                return null;
            }

            @Override
            public Long getIdUg() {
                return idUnidadGestion;
            }

            @Override
            public Date getFechaTodas() {
                return null;
            }

            @Override
            public List<String> getDireccionesMailPara() {
                return direccionesEmailPara;
            }

            @Override
            public List<String> getDireccionesMailCc() {
                return direccionesEmailCC;
            }

            @Override
            public String getCuerpoEmail() {
                return null;
            }

            @Override
            public String getCodUg() {
                return null;
            }

            @Override
            public String getAsuntoMail() {
                return null;
            }

            @Override
            public List<DtoAdjuntoMail> getAdjuntosList() {
                return null;
            }
        };
    }

    private  DtoCrearAnotacionUsuarioInfo nuevoDtoUsuario(final Long idUsuario, final boolean conEmail) {
        return new DtoCrearAnotacionUsuarioInfo() {
            
            @Override
            public boolean isIncorporar() {
                return true;
            }
            
            @Override
            public boolean isEmail() {
                return conEmail;
            }
            
            @Override
            public Long getId() {
                return idUsuario;
            }
            
            @Override
            public Date getFecha() {
                return null;
            }
        };
    }
}
