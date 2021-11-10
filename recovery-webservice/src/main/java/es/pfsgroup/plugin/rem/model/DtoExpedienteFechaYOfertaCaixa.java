package es.pfsgroup.plugin.rem.model;

public class DtoExpedienteFechaYOfertaCaixa extends DtoOnlyExpedienteYOfertaCaixa {

    private String fechaContArras;

    public String getFechaContArras() {
        return fechaContArras;
    }

    public void setFechaContArras(String fechaContArras) {
        this.fechaContArras = fechaContArras;
    }
}
