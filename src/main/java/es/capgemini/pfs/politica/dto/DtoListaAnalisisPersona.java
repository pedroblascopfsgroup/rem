package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoListaAnalisisPersona extends WebDto {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private String listadoIdPersonas;
    private String listadoIdParcelas;
    private String listadoCodigoImpactos;
    private String listadoCodigoValoraciones;
    private String listadoId;

    public DtoListaAnalisisPersona() {

    }

    /**
     * @param listadoIdPersonas the listadoIdPersonas to set
     */
    public void setListadoIdPersonas(String listadoIdPersonas) {
        this.listadoIdPersonas = listadoIdPersonas;
    }

    /**
     * @return the listadoIdPersonas
     */
    public String getListadoIdPersonas() {
        return listadoIdPersonas;
    }

    /**
     * @param listadoIdParcelas the listadoIdParcelas to set
     */
    public void setListadoIdParcelas(String listadoIdParcelas) {
        this.listadoIdParcelas = listadoIdParcelas;
    }

    /**
     * @return the listadoIdParcelas
     */
    public String getListadoIdParcelas() {
        return listadoIdParcelas;
    }

    /**
     * @param listadoCodigoImpactos the listadoCodigoImpactos to set
     */
    public void setListadoCodigoImpactos(String listadoCodigoImpactos) {
        this.listadoCodigoImpactos = listadoCodigoImpactos;
    }

    /**
     * @return the listadoCodigoImpactos
     */
    public String getListadoCodigoImpactos() {
        return listadoCodigoImpactos;
    }

    /**
     * @param listadoCodigoValoraciones the listadoCodigoValoraciones to set
     */
    public void setListadoCodigoValoraciones(String listadoCodigoValoraciones) {
        this.listadoCodigoValoraciones = listadoCodigoValoraciones;
    }

    /**
     * @return the listadoCodigoValoraciones
     */
    public String getListadoCodigoValoraciones() {
        return listadoCodigoValoraciones;
    }

    public DtoAnalisisParcelaPersona[] getListaAnalisisPersona() {
        String[] listadoId = this.listadoId.split(",");
        String[] listadoIdPersonas = this.listadoIdPersonas.split(",");
        String[] listadoIdParcelas = this.listadoIdParcelas.split(",");
        String[] listadoCodigoImpactos = this.listadoCodigoImpactos.split(",");
        String[] listadoCodigoValoraciones = this.listadoCodigoValoraciones.split(",");

        if (listadoId.length != listadoIdPersonas.length || listadoIdPersonas.length != listadoIdParcelas.length
                || listadoIdParcelas.length != listadoCodigoImpactos.length || listadoCodigoImpactos.length != listadoCodigoValoraciones.length) { return new DtoAnalisisParcelaPersona[0]; }

        DtoAnalisisParcelaPersona[] listadoDto = new DtoAnalisisParcelaPersona[listadoIdPersonas.length];

        for (int i = 0; i < listadoIdPersonas.length; i++) {
            DtoAnalisisParcelaPersona dto = new DtoAnalisisParcelaPersona();

            if (listadoId[i] != null && listadoId[i].trim().length() > 0) dto.setIdAnalisisParcelaPersona(new Long(listadoId[i]));

            dto.setIdPersona(new Long(listadoIdPersonas[i]));
            dto.setIdParcela(new Long(listadoIdParcelas[i]));
            dto.setCodigoImpacto(listadoCodigoImpactos[i]);
            dto.setCodigoValoracion(listadoCodigoValoraciones[i]);
            dto.setComentario(null);

            listadoDto[i] = dto;
        }

        return listadoDto;
    }

    /**
     * @param listadoId the listadoId to set
     */
    public void setListadoId(String listadoId) {
        this.listadoId = listadoId;
    }

    /**
     * @return the listadoId
     */
    public String getListadoId() {
        return listadoId;
    }
}
