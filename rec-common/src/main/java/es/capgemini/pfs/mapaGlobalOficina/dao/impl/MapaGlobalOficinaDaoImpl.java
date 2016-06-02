package es.capgemini.pfs.mapaGlobalOficina.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.mapaGlobalOficina.dao.MapaGlobalOficinaDao;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoBuscarMapaGlobalOficina;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoExportRow;
import es.capgemini.pfs.mapaGlobalOficina.model.MapaGlobalOficina;

/**
 * Dao de MapaGlobalOficinaDao.
 * @author Andres Esteban
 *
 */
@Repository("MapaGlobalOficinaDao")
public class MapaGlobalOficinaDaoImpl extends AbstractEntityDao<MapaGlobalOficina, Long> implements MapaGlobalOficinaDao {

    protected SimpleDateFormat DF = new SimpleDateFormat("dd/MM/yyyy");

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<MapaGlobalOficina> buscar(DtoBuscarMapaGlobalOficina dto) throws Exception {
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "from " + createHqlAndCompleteParameters(dto, parameters);
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);
        setParameters(query, parameters);
        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    public int buscarCount(DtoBuscarMapaGlobalOficina dto) throws Exception {
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "select count(*) from " + createHqlAndCompleteParameters(dto, parameters);
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);
        setParameters(query, parameters);
        return ((Long)query.list().get(0)).intValue();
    }

    /**
      * {@inheritDoc}
     */
    public List<DtoExportRow> buscarAgrupandoPorProducto(DtoBuscarMapaGlobalOficina dto) throws Exception {
        return buscarAgrupando(dto, "m.tipoProducto.descripcion, '' ", "m.tipoProducto.id, m.tipoProducto.descripcion", "m.tipoProducto.descripcion");
    }

    /**
      * {@inheritDoc}
     */
    @Override
    public List<DtoExportRow> buscarAgrupandoPorJerarquia(DtoBuscarMapaGlobalOficina dto) throws Exception {
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "select z.descripcion, ''";
        hql += ", sum(m.cantidadClientes), sum(m.cantidadContratos), sum(m.sumaPosVivaNoVencida + m.sumaPosVivaVencida), sum(m.sumaPosVivaVencida) ";
        hql += "from DDZona z, ";
        hql += createHqlAndCompleteParameters(dto, parameters);
        hql += " and m.zona.codigo like z.codigo ||'%'";
        hql += " and z.nivel.id = :nivId";
        hql += " group by z.id, z.descripcion";
        hql += " order by z.descripcion ";
        Long nivId = new Long(dto.getCriterioSalidaJerarquico());
        parameters.put("nivId", nivId);

        return createExportRows(hql, parameters);
    }

    /**
      * {@inheritDoc}
     */
    @Override
    public List<DtoExportRow> buscarAgrupandoPorSegmento(DtoBuscarMapaGlobalOficina dto) throws Exception {
        return buscarAgrupando(dto, "m.segmentoPersona.descripcion, '' ", "m.segmentoPersona.id, m.segmentoPersona.descripcion", "m.segmentoPersona.descripcion");
    }

    /**
      * {@inheritDoc}
     */
    @Override
    public List<DtoExportRow> buscarAgrupandoPorSubfases(DtoBuscarMapaGlobalOficina dto) throws Exception {
        return buscarAgrupando(dto, "m.subfase.fase.descripcion, m.subfase.descripcion ",
                "m.subfase.orden, m.subfase.fase.descripcion, m.subfase.id, m.subfase.descripcion", " m.subfase.id");
    }

    /**
     * Busca, agrupa y exporta a una lista de DtoExportRow los MapaGlobal segun las columnas indicadas.
     * @param dto criterios de busquedas
     * @param columnas a recuperar
     * @param groupBy columnas a agrupar, deben incluir las columnas a mostrar
     * @param orderBy columnas a order, deben ser algunas de las columnas a mostrar
     * @return lista de DtoExportRow
     * @throws ParseException 
     */
    private List<DtoExportRow> buscarAgrupando(DtoBuscarMapaGlobalOficina dto, String columnas, String groupBy, String orderBy) throws ParseException{
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "select " + columnas;
        hql += ", sum(m.cantidadClientes), sum(m.cantidadContratos), sum(m.sumaPosVivaNoVencida + m.sumaPosVivaVencida), sum(m.sumaPosVivaVencida) ";
        hql += "from " + createHqlAndCompleteParameters(dto, parameters);
        hql += " group by " + groupBy;
        hql += " order by " + orderBy;

        return createExportRows(hql, parameters);
    }

    /**
     * Crea el HQL para la busqueda SIN EL FROM y completa el map de parámetros.
     * @throws ParseException 
     */
    private String createHqlAndCompleteParameters(DtoBuscarMapaGlobalOficina dto, HashMap<String, Object> parameters) throws ParseException{
        String hql = " MapaGlobalOficina m where m.auditoria.borrado = false ";

        if (!emtpyString(dto.getFecha())) {
            hql += "and m.fechaExtraccion = :fecha";
            parameters.put("fecha", DF.parse(dto.getFecha()));
        }

        if (!emptyArray(dto.getCodigoSegmentos())) {
            hql += " and ( ";
            Set<String> segs = dto.getCodigoSegmentos();
            for (String seg : segs) {
                hql += " m.segmentoPersona.id =  '" + seg + "' OR";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }

        if (!emptyArray(dto.getTiposContratos())) {
            hql += " and ( ";
            Set<String> tpos = dto.getTiposContratos();
            for (String tpo : tpos) {
                hql += " m.tipoProducto.codigo =  '" + tpo + "' OR";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }

        if (dto.getCodigoFase() != null && !dto.getCodigoFase().trim().equals("")) {
            hql += " and m.subfase.fase.codigo = :fase";
            parameters.put("fase", dto.getCodigoFase());
        }

        if (!emptyArray(dto.getCodigoSubfases())) {
            hql += " and ( ";
            Set<String> subfases = dto.getCodigoSubfases();
            for (String subFase : subfases) {
                hql += " m.subfase.codigo =  '" + subFase + "' OR";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }

        if (!emptyArray(dto.getCodigoZonas())) {
            hql += " and ( ";
            Set<String> zonas = dto.getCodigoZonas();
            for (String zona : zonas) {
                hql += " m.zona.codigo like '" + zona + "%' OR";
            }
            hql = hql.substring(0, hql.length() - 2);
            hql += " ) ";
        }
        return hql;

    }

    /**
     * Ejecuta la query y exporta los datos.
     * @param hql query
     * @param parameters parametros
     * @return lista de DtoExportRow
     */
    @SuppressWarnings("unchecked")
    private List<DtoExportRow> createExportRows(String hql, HashMap<String, Object> parameters) {
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);
        setParameters(query, parameters);
        List<Object[]> list = query.list();
        List<DtoExportRow> rows = new ArrayList<DtoExportRow>();
        DtoExportRow row;
        for (Object[] object : list) {
            row = new DtoExportRow();
            row.setDescripcion((String) object[0]);
            row.setDescripcionSecundaria((String) object[1]);
            row.setNumeroClientes((Long) object[2]);
            row.setNumeroContratos((Long) object[3]);
            row.setSaldoTotal((Double) object[4]);
            row.setSaldoVencido((Double) object[5]);
            rows.add(row);
        }
        return rows;
    }

    private void setParameters(Query query, HashMap<String, Object> parameters) {
        if (parameters == null) {
            return;
        }
        for (String key : parameters.keySet()) {
            Object param = parameters.get(key);
            query.setParameter(key, param);
        }
    }

    private boolean emtpyString(String str) {
        return (str == null) || (str.trim().equals(""));
    }

    private boolean emptyArray(Set<String> set) {
        if (set == null) {
            return true;
        }
        if (set.isEmpty()) {
            return true;
        }

        if (set.size() == 1) {
            if (set.iterator().next().trim().equals("")) {
                return true;
            }
        }
        return false;
    }

}
