package es.capgemini.pfs.metrica.dto;

import java.io.File;
import java.util.Map;

import es.capgemini.devon.files.FileItem;

/**
 * Dto para toda la parte del manejo de métricas.
 * @author aesteban
 *
 */
public class DtoMetrica implements Cloneable {
    private FileItem fileItem;
    private String codigoTipoPersona;
    private String codigoSegmento;
    private int cantidadIntervaloRating;
    private int cantidadIntervaloVRC;

    /**
     * Constructor por defecto.
     */
    public DtoMetrica() {
    }

    /**
     * Constructor que recibe un map con todos los valores a inicializar.
     * @param map Map
     */
    @SuppressWarnings("unchecked")
    public DtoMetrica(Map map) {
        codigoTipoPersona = ((String[]) map.get("codigoTipoPersona"))[0];
        codigoSegmento = ((String[]) map.get("codigoSegmento"))[0];
        if (codigoSegmento != null && codigoSegmento.equals("")) {
            codigoSegmento = null;
        }
        if (codigoTipoPersona != null && codigoTipoPersona.equals("")) {
            codigoTipoPersona = null;
        }
        cantidadIntervaloRating = Integer.valueOf((((String[]) map.get("cantidadIntervaloRating"))[0]));
        cantidadIntervaloVRC = Integer.valueOf((((String[]) map.get("cantidadIntervaloVRC"))[0]));
    }

    /**
     * Clone.
     * @return DtoMetrica
     */
    @Override
    public DtoMetrica clone() {
        DtoMetrica dto = new DtoMetrica();
        dto.setFileItem(this.fileItem);
        dto.setCodigoTipoPersona(this.codigoTipoPersona);
        dto.setCodigoSegmento(this.codigoSegmento);
        return dto;
    }

    /**
     * @return the fileItem
     */
    public FileItem getFileItem() {
        return fileItem;
    }

    /**
     * @return the fileItem
     */
    public File getFile() {
        if (fileItem != null) { return fileItem.getFile(); }
        return null;
    }

    /**
     * @param file the fileItem to set
     */
    public void setFileItem(FileItem file) {
        this.fileItem = file;
    }

    /**
     * @return the codigoTipoPersona
     */
    public String getCodigoTipoPersona() {
        if (codigoTipoPersona == null || codigoTipoPersona.equals(""))
            return null;
        else
            return codigoTipoPersona;
    }

    /**
     * @param codigoTipoPersona the codigoTipoPersona to set
     */
    public void setCodigoTipoPersona(String codigoTipoPersona) {
        this.codigoTipoPersona = codigoTipoPersona;
    }

    /**
     * @return the codigoSegmento
     */
    public String getCodigoSegmento() {
        if (codigoSegmento == null || codigoSegmento.equals(""))
            return null;
        else
            return codigoSegmento;
    }

    /**
     * @param codigoSegmento the codigoSegmento to set
     */
    public void setCodigoSegmento(String codigoSegmento) {
        this.codigoSegmento = codigoSegmento;
    }

    /**
     * @return the rangoIntervalo
     */
    public int getCantidadIntervaloRating() {
        return cantidadIntervaloRating;
    }

    /**
     * @param cantidadIntervalo the rangoIntervalo to set
     */
    public void setCantidadIntervaloRating(int cantidadIntervalo) {
        this.cantidadIntervaloRating = cantidadIntervalo;
    }

    /**
     * @return the rangoVRC
     */
    public int getCantidadIntervaloVRC() {
        return cantidadIntervaloVRC;
    }

    /**
     * @param rangoVRC the rangoVRC to set
     */
    public void setCantidadIntervaloVRC(int rangoVRC) {
        this.cantidadIntervaloVRC = rangoVRC;
    }
}
