package es.pfsgroup.plugin.rem.restclient.caixabc;

public class CexDto {

    private Integer titularContratacion;
    private String interlocutorOfertaCod;
    private Double porcionCompra;
    private Integer antiguoDeudor;
    private String vinculoCaixaCod;
    private String estadoInterlocutorCod;
    private Long idComprador;
    private String idPersonaHayaCaixa;

    public Integer getTitularContratacion() {
        return titularContratacion;
    }

    public void setTitularContratacion(Integer titularContratacion) {
        this.titularContratacion = titularContratacion;
    }

    public String getInterlocutorOfertaCod() {
        return interlocutorOfertaCod;
    }

    public void setInterlocutorOfertaCod(String interlocutorOfertaCod) {
        this.interlocutorOfertaCod = interlocutorOfertaCod;
    }

    public Double getPorcionCompra() {
        return porcionCompra;
    }

    public void setPorcionCompra(Double porcionCompra) {
        this.porcionCompra = porcionCompra;
    }

    public Integer getAntiguoDeudor() {
        return antiguoDeudor;
    }

    public void setAntiguoDeudor(Integer antiguoDeudor) {
        this.antiguoDeudor = antiguoDeudor;
    }

    public String getVinculoCaixaCod() {
        return vinculoCaixaCod;
    }

    public void setVinculoCaixaCod(String vinculoCaixaCod) {
        this.vinculoCaixaCod = vinculoCaixaCod;
    }

    public String getEstadoInterlocutorCod() {
        return estadoInterlocutorCod;
    }

    public void setEstadoInterlocutorCod(String estadoInterlocutorCod) {
        this.estadoInterlocutorCod = estadoInterlocutorCod;
    }

    public Long getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(Long idComprador) {
        this.idComprador = idComprador;
    }

    public String getIdPersonaHayaCaixa() {
        return idPersonaHayaCaixa;
    }

    public void setIdPersonaHayaCaixa(String idPersonaHayaCaixa) {
        this.idPersonaHayaCaixa = idPersonaHayaCaixa;
    }
}
