package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

public interface DDTipoDocumentoActivoDao extends AbstractDao<DDTipoDocumentoActivo, Long> {

    /**
     * Este método obtiene una entrada del diccionario DDTipoDocumentoActivo en base a la matricula asociada al mismo.
     *
     * @param matriculaDocumento: matricula asociada al tipo de documento del activo.
     * @return Devuelve el tipo de documento por la mtricula especificada.
     */
    DDTipoDocumentoActivo getDDTipoDocumentoActivoPorMatricula(String matriculaDocumento);

    /**
     * Este método devuelve True si la matricula pasada por parámetro se encuentra registra en algún tipo de documento,
     * False si no lo está.
     *
     * @return Devuelve True si la matricula existe en algún tipo de documento, False si no existe.
     */
    Boolean existeMatriculaRegistradaEnTipoDocumento(String matricula);
}
