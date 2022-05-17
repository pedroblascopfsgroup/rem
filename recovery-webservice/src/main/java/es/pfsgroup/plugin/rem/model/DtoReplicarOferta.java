package es.pfsgroup.plugin.rem.model;


/**
 * Dto para encapsular la información de replicar ofertas*
 */
public class DtoReplicarOferta  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    private Long idOferta;
    private String codEstadoOferta ;
	
    
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public String getCodEstadoOferta() {
		return codEstadoOferta;
	}
	public void setCodEstadoOferta(String codEstadoOferta) {
		this.codEstadoOferta = codEstadoOferta;
	}
    
    
	   
    
    
}