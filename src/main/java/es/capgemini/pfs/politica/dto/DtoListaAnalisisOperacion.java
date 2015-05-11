package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoListaAnalisisOperacion extends WebDto {

    private static final long serialVersionUID = 1L;

    private String listadoId;
    private String listadoIdPersonas;
    private String listadoIdContratos;
    private String listadoCodigoImpactos;
    private String listadoCodigoValoraciones;

    public DtoListaAnalisisOperacion() {

    }

    public DtoAnalisisOperacion[] getAnalisisOperacionLista() {
        String[] listadoId = this.listadoId.split(",");
        String[] listadoIdPersonas = this.listadoIdPersonas.split(",");
        String[] listadoIdContratos = this.listadoIdContratos.split(",");
        String[] listadoCodigoImpactos = this.listadoCodigoImpactos.split(",");
        String[] listadoCodigoValoraciones = this.listadoCodigoValoraciones.split(",");

        if (listadoId.length != listadoIdPersonas.length || listadoIdPersonas.length != listadoIdContratos.length
                || listadoIdContratos.length != listadoCodigoImpactos.length || listadoCodigoImpactos.length != listadoCodigoValoraciones.length) { return new DtoAnalisisOperacion[0]; }

        DtoAnalisisOperacion[] listadoDto = new DtoAnalisisOperacion[listadoIdPersonas.length];

        for (int i = 0; i < listadoIdPersonas.length; i++) {
            DtoAnalisisOperacion dto = new DtoAnalisisOperacion();

            if (listadoId[i] != null && listadoId[i].trim().length() > 0) dto.setIdAnalisisOperacion(new Long(listadoId[i]));

            dto.setIdPersona(new Long(listadoIdPersonas[i]));
            dto.setIdContrato(new Long(listadoIdContratos[i]));
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
     * @param listadoIdContratos the listadoIdContratos to set
     */
    public void setListadoIdContratos(String listadoIdContratos) {
        this.listadoIdContratos = listadoIdContratos;
    }

    /**
     * @return the listadoIdContratos
     */
    public String getListadoIdContratos() {
        return listadoIdContratos;
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

}
