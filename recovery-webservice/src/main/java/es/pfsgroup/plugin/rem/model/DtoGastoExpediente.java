package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los gastos del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoGastoExpediente extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long id;
	private String accion;
	private String codigo;
	private String nombre;
	private String tipoCalculo;
	private Double importeCalculo;
	private Double importeFinal;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getAccion() {
		return accion;
	}
	public void setAccion(String accion) {
		this.accion = accion;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getTipoCalculo() {
		return tipoCalculo;
	}
	public void setTipoCalculo(String tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}
	public Double getImporteCalculo() {
		return importeCalculo;
	}
	public void setImporteCalculo(Double importeCalculo) {
		this.importeCalculo = importeCalculo;
	}
	public Double getImporteFinal() {
		return importeFinal;
	}
	public void setImporteFinal(Double importeFinal) {
		this.importeFinal = importeFinal;
	}
	
   		
}
