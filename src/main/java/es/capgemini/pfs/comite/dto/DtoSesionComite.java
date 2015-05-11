package es.capgemini.pfs.comite.dto;

import java.io.Serializable;
import java.util.Set;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.SesionComite;

/**
 *
 * @author Andrï¿½s Esteban
 *
 */
public class DtoSesionComite extends WebDto implements Serializable, Comparable<DtoSesionComite> {

    private static final long serialVersionUID = 1L;
    private Comite comite;
    private Set<DtoAsistente> dtoAsistentes;
    private SesionComite sesion;
    private boolean ignorarErrores;

    /**
     * Este mï¿½todo lo llamarï¿½ automï¿½ticamente webflow cuando usemos el dto e intentemos salir.
     * <br>
     * Se valida que asistan las personas restrictivas y el supervisor
     * @param messageContext messageContext
     */
    public void validateIniciarSesion(MessageContext messageContext) {
        messageContext.clearMessages();

        int nMiembros = 0;
        int nMiembrosRestrictivos = 0;
        int nMiembrosSupervisores = 0;

        //Contabilizamos los asistentes
        for (DtoAsistente dtoAsistente : dtoAsistentes) {
            if (dtoAsistente.getAsiste()) {

                nMiembros++;
                if (dtoAsistente.getEsRestrictivo()) {
                    nMiembrosRestrictivos++;
                }
                if (dtoAsistente.getEsSupervisor()) {
                    nMiembrosSupervisores++;
                }
            }
        }

        if (nMiembrosSupervisores == 0) {
            messageContext.addMessage(new MessageBuilder().code("celebracionComite.error.asistenciaSupervisor").error().source("").defaultText(
                    "**Falta gente.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        } else if (nMiembrosSupervisores > 1) {
            messageContext.addMessage(new MessageBuilder().code("celebracionComite.error.masdeunsupervisor").error().source("").defaultText(
                    "**Solo puede haber un supervisor del comite activo.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        //Comprobamos que cumple el mínimo de miembros
        int nMinMiembros = 0;
        if (comite.getMiembros() != null) {
            nMinMiembros = comite.getMiembros().intValue();
        }

        if (nMinMiembros > nMiembros) {
            messageContext.addMessage(new MessageBuilder().code("celebracionComite.error.asistenciaMiembros").arg(nMinMiembros).error().source("")
                    .defaultText("**Falta gente.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        //Comprobamos que cumple el mínimo de miembros restrictivos
        int nMinMiembrosRestrictivos = 0;
        if (comite.getMiembrosRestrict() != null) {
            nMinMiembrosRestrictivos = comite.getMiembrosRestrict().intValue();
        }

        if (nMinMiembrosRestrictivos > nMiembrosRestrictivos) {
            messageContext.addMessage(new MessageBuilder().code("celebracionComite.error.asistenciaMiembrosRestrictivos").arg(
                    nMinMiembrosRestrictivos).error().source("").defaultText("**Falta gente.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

    }

    /**
     * @return the comite
     */
    public Comite getComite() {
        return comite;
    }

    /**
     * @param comite the comite to set
     */
    public void setComite(Comite comite) {
        this.comite = comite;
    }

    /**
     * @return the dtoAsistentes
     */
    public Set<DtoAsistente> getAsistentes() {
        return dtoAsistentes;
    }

    /**
     * @param dtoAsistentes the dtoAsistentes to set
     */
    public void setAsistentes(Set<DtoAsistente> dtoAsistentes) {
        this.dtoAsistentes = dtoAsistentes;
    }

    /**
     * Setea a la coleccion de dtoAsistentes si asistio o no.
     * @param asistentcias string concatenando "idUsuario1=asistencia1;idUsuario2=asistencia2"
     */
    public void setAsistencias(String asistentcias) {
        String[] tokens = asistentcias.split(";");
        for (int i = 0; i < tokens.length; i++) {
            String[] data = tokens[i].split("=");
            DtoAsistente dtoAsistente = buscarAsistente(new Long(data[0]));
            dtoAsistente.setAsiste(new Boolean(data[1]));
        }
    }

    private DtoAsistente buscarAsistente(Long usuarioId) {
        for (DtoAsistente dtoAsistente : this.dtoAsistentes) {
            if (dtoAsistente.getUsuario().getId().equals(usuarioId)) {
                return dtoAsistente;
            }
        }
        return null;
    }

    /**
     * @return the sesion
     */
    public SesionComite getSesion() {
        if (sesion == null) {
            sesion = comite.getUltimaSesion();
        }
        return sesion;
    }

    /**
     * @param sesion the sesion to set
     */
    public void setSesion(SesionComite sesion) {
        this.sesion = sesion;
    }

    /**
     * Retorna el estado del comite segun la ultima sesion seteada.
     * @return string estado
     */
    public String getEstado() {
        if (sesion == null) {
            return comite.getEstado();
        }
        return Comite.calcularEstado(sesion);
    }

    /**
     * Indica si el comite del dto esta iniciado.
     * @return Boolean
     */
    public Boolean getEstaIniciado() {
        return getEstado().equals(Comite.INICIADO);
    }

    /**
     * @return the ignorarErrores
     */
    public boolean isIgnorarErrores() {
        return ignorarErrores;
    }

    /**
     * @param ignorarErrores the ignorarErrores to set
     */
    public void setIgnorarErrores(boolean ignorarErrores) {
        this.ignorarErrores = ignorarErrores;
    }

    /**
     * Retorna la cantidad de expedientes sin decidir del comite.
     * @return int
     */
    public int getCantidadDePuntosParaTratar() {
        return comite.getCantidadExpedientes() + comite.getPreasuntos().size();
    }

    /**
     * obtiene la cantidad de expedientes decididos.
     * @return cantidad expedientes
     */
    public int getCantidadDeExpedientesDecididos() {
        if (sesion.getFechaFin() != null) {
            return sesion.getCantidadPuntosDecididos();
        }
        return comite.getCantidadExpedientes();
    }

    /**
     * Compara dtoSesionComite, si tiene sesion las compara, si compara los comites.
     * @param sesion dto
     * @return int
     */
    @Override
    public int compareTo(DtoSesionComite sesion) {
        if (this.sesion != null) {
            return this.sesion.getId().compareTo(sesion.getSesion().getId());
        }
        return this.comite.compareTo(sesion.getComite());
    }

}
