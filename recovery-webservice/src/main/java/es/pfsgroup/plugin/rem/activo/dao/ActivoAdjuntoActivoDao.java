package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;

public interface ActivoAdjuntoActivoDao extends AbstractDao<ActivoAdjuntoActivo, Long> {

    /**
     * Este método indica si un documento existe en la tabla de adjuntos asociados a activos para un activo en especifico
     * en base al nombre del adjunto, la matrícula del adjunto y el ID del activo.
     *
     * @param nombreAdjunto: nombre del documento.
     * @param matriculaDocumento: matricula asociada al tipo de documento del activo.
     * @param numActivo: ID Haya del activo asociado al documento.
     * @return Devuelve True si el documento con las caracteristicas especificadas está asociado al activo, False si no lo está.
     */
    Boolean existeAdjuntoPorNombreYTipoDocumentoYNumActivo(String nombreAdjunto, String matriculaDocumento, Long numActivo);
}
