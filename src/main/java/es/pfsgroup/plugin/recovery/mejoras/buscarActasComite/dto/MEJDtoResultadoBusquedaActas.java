package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.SesionComite;

/**
 * Dto para Procedimientos Derivados.
 *
 * @author Lisandro Medrano
 *
 */
public class MEJDtoResultadoBusquedaActas extends WebDto {
	
	private static final long serialVersionUID = 6015680735564006223L;
	
	private SesionComite sesion;
	
	public void setSesion(SesionComite sesion) {
		this.sesion = sesion;
	}

	public SesionComite getSesion() {
		return sesion;
	}
	
    /**
     * Retorna el estado del comite segun la ultima sesion seteada.
     * @return string estado
     */
    public String getEstado() {
        if (sesion != null) {
            return sesion.getComite().getEstado();
        }
        return Comite.calcularEstado(sesion);
    }
	
    /**
     * obtiene la cantidad de expedientes decididos.
     * @return cantidad expedientes
     */
    public int getCantidadDeExpedientesDecididos() {
        if (sesion.getFechaFin() != null) {
            return sesion.getCantidadPuntosDecididos();
        }
        return sesion.getComite().getCantidadExpedientes();
    }
}
