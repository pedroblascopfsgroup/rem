package es.capgemini.pfs.procesosJudiciales.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;

/**
 * Definici�n del DAO para juzgados.
 * @author pajimene
 *
 */
public interface JuzgadoDao extends AbstractDao<TipoJuzgado, Long> {

    /**
     * Devuelve la lista de juzgados de una plaza.
     * @param codigoPlaza String
     * @return la lista de juzgados.
     */
    List<TipoJuzgado> getJuzgadosByPlaza(String codigoPlaza);

    /**
     * Devuelve un tipo de juzgado seg�n su c�digo.
     * @param codigoJuzgado codigo
     * @return tipo de juzgado.
     */
    TipoJuzgado getByCodigo(String codigoJuzgado);
}
