package es.capgemini.pfs.acuerdo.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;

/**
 * @author marruiz
 */
public class DtoActuacionesRealizadasAcuerdo extends WebDto {

    private static final long serialVersionUID = 1317814414788732154L;

    private ActuacionesRealizadasAcuerdo actuaciones;
    private Long idAcuerdo;


    /**
     * @return the idAcuerdo
     */
    public Long getIdAcuerdo() {
        return idAcuerdo;
    }

    /**
     * @param idAcuerdo the idAcuerdo to set
     */
    public void setIdAcuerdo(Long idAcuerdo) {
        this.idAcuerdo = idAcuerdo;
    }

    /**
     * @return the actuaciones
     */
    public ActuacionesRealizadasAcuerdo getActuaciones() {
        return actuaciones;
    }

    /**
     * @param actuaciones the actuaciones to set
     */
    public void setActuaciones(ActuacionesRealizadasAcuerdo actuaciones) {
        this.actuaciones = actuaciones;
    }
}
