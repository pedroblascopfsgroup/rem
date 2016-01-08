package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la búsqueda de clientes.
 */
public class LIQDtoLiquidacionCabecera extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private Date fechaLiquidacion;
    private String acuerdo = null;
    private String autos;
    private String nombre;
    private String dni;
    private Float totalDeuda = null;
    
	public Date getFechaLiquidacion() {
		return fechaLiquidacion;
	}
	public void setFechaLiquidacion(Date fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}
	public String getAcuerdo() {
		return acuerdo;
	}
	public void setAcuerdo(String acuerdo) {
		this.acuerdo = acuerdo;
	}
	public String getAutos() {
		return autos;
	}
	public void setAutos(String autos) {
		this.autos = autos;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDni() {
		return dni;
	}
	public void setDni(String dni) {
		this.dni = dni;
	}
	public void setTotalDeuda(Float totalDeuda) {
		this.totalDeuda = totalDeuda;
	}
	public Float getTotalDeuda() {
		return totalDeuda;
	}    
}
