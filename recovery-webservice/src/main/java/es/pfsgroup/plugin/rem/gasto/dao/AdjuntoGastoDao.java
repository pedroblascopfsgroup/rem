package es.pfsgroup.plugin.rem.gasto.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;

public interface AdjuntoGastoDao extends AbstractDao<AdjuntoGasto, Long> {

    /**
     * Este método indica si un documento existe en la tabla de adjuntos asociados al GastoProveedor para un gasto
     * en especifico en base al nombre del adjunto, la matrícula del adjunto y el número Haya del gasto proveedor.
     *
     * @param nombreAdjunto: nombre del documento.
     * @param matriculaDocumento: matricula asociada al tipo de documento del gasto.
     * @param numHayaGasto: número haya del gasto.
     * @return Devuelve True si el documento con las caracteristicas especificadas está asociado al gasto, False si no lo está.
     */
    Boolean existeAdjuntoPorNombreYTipoDocumentoYNumeroHayaGasto(String nombreAdjunto, String matriculaDocumento, Long numHayaGasto);
}
