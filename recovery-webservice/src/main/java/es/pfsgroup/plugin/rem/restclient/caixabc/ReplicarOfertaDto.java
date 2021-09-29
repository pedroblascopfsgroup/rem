package es.pfsgroup.plugin.rem.restclient.caixabc;

public class ReplicarOfertaDto {
    private Long numeroOferta;
    private String estadoExpedienteBcCodigoBC;
    private String estadoScoringAlquilerCodigoBC;
    private String fechaPropuesta;

    public Long getNumeroOferta() {
        return numeroOferta;
    }

    public void setNumeroOferta(Long numeroOferta) {
        this.numeroOferta = numeroOferta;
    }

    public String getEstadoExpedienteBcCodigoBC() {
        return estadoExpedienteBcCodigoBC;
    }

    public void setEstadoExpedienteBcCodigoBC(String estadoExpedienteBcCodigoBC) {
        this.estadoExpedienteBcCodigoBC = estadoExpedienteBcCodigoBC;
    }

    public String getEstadoScoringAlquilerCodigoBC() {
        return estadoScoringAlquilerCodigoBC;
    }

    public void setEstadoScoringAlquilerCodigoBC(String estadoScoringAlquilerCodigoBC) {
        this.estadoScoringAlquilerCodigoBC = estadoScoringAlquilerCodigoBC;
    }

    public String getFechaPropuesta() {
        return fechaPropuesta;
    }

    public void setFechaPropuesta(String fechaPropuesta) {
        this.fechaPropuesta = fechaPropuesta;
    }
}
