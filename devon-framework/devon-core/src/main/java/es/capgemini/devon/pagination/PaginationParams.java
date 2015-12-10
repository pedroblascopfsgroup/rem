package es.capgemini.devon.pagination;

/** Este interfaz es el necesario para poder paginar y ordenar los datos en una tabla
 * @author amarinso
 *
 */
public interface PaginationParams {

    /**
     * @return La dirección de la ordenación
     */
    public String getDir();

    public void setDir(String dir);

    /**
     * @return El nombre del campo por el que se quiere ordenar
     */
    public String getSort();

    public void setSort(String sort);

    /**
     * @return Número máximo de resultados a obtener
     */
    public int getLimit();

    public void setLimit(int limit);

    /**
     * @return Indice inicio de la lista de resultados
     */
    public int getStart();

    public void setStart(int start);
}
