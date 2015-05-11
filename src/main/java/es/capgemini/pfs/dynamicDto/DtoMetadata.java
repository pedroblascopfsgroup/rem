package es.capgemini.pfs.dynamicDto;

/**
 * Metadata de un DTO dinámico.
 * @author marruiz
 */
public class DtoMetadata {

    private String name;
    private String header;
    private String renderer;
    private String align;

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return "width:50px, name:" + name + ", header:" + header + ", renderer:" + renderer + ", align:" + align;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the header
     */
    public String getHeader() {
        return header;
    }

    /**
     * @param header the header to set
     */
    public void setHeader(String header) {
        this.header = header;
    }

    /**
     * @return the renderer
     */
    public String getRenderer() {
        return renderer;
    }

    /**
     * @param renderer the renderer to set
     */
    public void setRenderer(String renderer) {
        this.renderer = renderer;
    }

    /**
     * @return the align
     */
    public String getAlign() {
        return align;
    }

    /**
     * @param align the align to set
     */
    public void setAlign(String align) {
        this.align = align;
    }
}
