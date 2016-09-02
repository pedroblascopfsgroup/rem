package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el histórico de los estados de informe comercial del activo.
 *
 */
public class DtoEstadosInformeComercialHistorico {
	public static final String ESTADO_MOTIVO_MODIFICACION_MANUAL= "Modificación manual de los datos de informe comercial";
	private Long id;
	private String estadoInfoComercial;
	private String motivo;
	private Date fecha;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getEstadoInfoComercial() {
		return estadoInfoComercial;
	}
	public void setEstadoInfoComercial(String estadoInfoComercial) {
		this.estadoInfoComercial = estadoInfoComercial;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	
}