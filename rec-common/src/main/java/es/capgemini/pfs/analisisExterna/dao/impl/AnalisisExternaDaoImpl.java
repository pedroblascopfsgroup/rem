package es.capgemini.pfs.analisisExterna.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.analisisExterna.dao.AnalisisExternaDao;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaFormulario;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaTabla;
import es.capgemini.pfs.analisisExterna.model.AnalisisExterna;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.utils.CollectionUtils;
import es.capgemini.pfs.utils.StringUtils;

/**
 * 
 * @author pajimene
 * 
 */
@Repository("AnalisisExternaDao")
public class AnalisisExternaDaoImpl extends AbstractEntityDao<AnalisisExterna, Long> implements AnalisisExternaDao {

    protected SimpleDateFormat DF = new SimpleDateFormat("dd/MM/yyyy");

    /**
     * {@inheritDoc}
     */
    @Override
    public Long buscarCount(DtoAnalisisExternaFormulario dto) throws Exception {
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "select count(*) from " + createHqlAndCompleteParameters(dto, parameters);
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);
        setParameters(query, parameters);
        return (Long) query.list().get(0);
    }

    /**
     * {@inheritDoc}
    */
    @Override
    public List<DtoAnalisisExternaTabla> buscarAgrupandoPorTipoProcedimiento(DtoAnalisisExternaFormulario dto) throws Exception {
        return buscarAgrupando(dto, "a.tipoProcedimiento.descripcion ", "a.tipoProcedimiento.descripcion", "a.tipoProcedimiento.descripcion");
    }

    /**
     * {@inheritDoc}
    */
    @Override
    public List<DtoAnalisisExternaTabla> buscarAgrupandoPorDespacho(DtoAnalisisExternaFormulario dto) throws Exception {
        return buscarAgrupando(dto, "a.despacho.despacho ", "a.despacho.despacho", "a.despacho.despacho");
    }

    /**
     * {@inheritDoc}
    */
    @Override
    public List<DtoAnalisisExternaTabla> buscarAgrupandoPorGestor(DtoAnalisisExternaFormulario dto) throws Exception {
        String columnaMostrar = "(CASE WHEN a.gestor.nombre is not null THEN concat(a.gestor.nombre, ' ', coalesce(a.gestor.apellido1, ''), ' ', coalesce(a.gestor.apellido2, '')) ELSE a.gestor.username END)";
        return buscarAgrupando(dto, columnaMostrar, columnaMostrar, columnaMostrar);
    }

    /**
     * {@inheritDoc}
    */
    @Override
    public List<DtoAnalisisExternaTabla> buscarAgrupandoPorSupervisor(DtoAnalisisExternaFormulario dto) throws Exception {
        String columnaMostrar = "(CASE WHEN a.supervisor.nombre is not null THEN concat(a.supervisor.nombre, ' ', coalesce(a.supervisor.apellido1, ''), ' ', coalesce(a.supervisor.apellido2, '')) ELSE a.supervisor.username END)";
        return buscarAgrupando(dto, columnaMostrar, columnaMostrar, columnaMostrar);
    }

    /**
     * {@inheritDoc}
    */
    @Override
    public List<DtoAnalisisExternaTabla> buscarAgrupandoPorFaseProcesal(DtoAnalisisExternaFormulario dto) throws Exception {
        return buscarAgrupando(dto, "a.faseProcesal.descripcion ", "a.faseProcesal.descripcion", "a.faseProcesal.descripcion");
    }

    /**
     * Crea el HQL para la busqueda SIN EL FROM y completa el map de parámetros.
     * @throws ParseException 
     */
    private String createHqlAndCompleteParameters(DtoAnalisisExternaFormulario dto, HashMap<String, Object> parameters) throws ParseException {
        StringBuilder hql = new StringBuilder(" AnalisisExterna a where a.auditoria.borrado = false ");

        if (!StringUtils.emtpyString(dto.getFecha())) {
            hql.append(" and a.fechaExtraccion = :fecha ");
            parameters.put("fecha", DF.parse(dto.getFecha()));
        }

        if (!StringUtils.emtpyString(dto.getIdTipoProcedimientos())) {
            hql.append(" and a.tipoProcedimiento.codigo IN ( ").append(CollectionUtils.convertListToListString(dto.getIdTipoProcedimientos()))
                    .append(") ");
        }

        if (!StringUtils.emtpyString(dto.getCodigoDespachos())) {
            hql.append(" and a.despacho.id IN ( ").append(dto.getCodigoDespachos()).append(") ");
        }

        if (!StringUtils.emtpyString(dto.getIdUsuariosGestor())) {
            hql.append(" and a.gestor.id IN ( ").append(dto.getIdUsuariosGestor()).append(") ");
        }

        if (!StringUtils.emtpyString(dto.getIdUsuariosSupervisor())) {
            hql.append(" and a.supervisor.id IN ( ").append(dto.getIdUsuariosSupervisor()).append(") ");
        }

        if (!StringUtils.emtpyString(dto.getCodigosFase())) {
            hql.append(" and a.faseProcesal.codigo IN ( ").append(CollectionUtils.convertListToListString(dto.getCodigosFase())).append(") ");
        }

        if (!StringUtils.emtpyString(dto.getCodigoPlazo())) {
            hql.append(" and a.plazoAceptacion.codigo = ").append(CollectionUtils.convertListToListString(dto.getCodigoPlazo())).append(" ");
        }

        if (!StringUtils.emtpyString(dto.getbProcedimientoActivo()) && "true".equals(dto.getbProcedimientoActivo())) {
            hql.append(" and a.procedimientoActivo = ").append(dto.getbProcedimientoActivo()).append(" ");
        }

        return hql.toString();

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
    private List<DtoAnalisisExternaTabla> buscarAgrupando(DtoAnalisisExternaFormulario dto, String columnas, String groupBy, String orderBy) throws ParseException{
        HashMap<String, Object> parameters = new HashMap<String, Object>();
        String hql = "select " + columnas;
        hql += ", sum(a.numProcedimientos), sum(a.numAsuntos), sum(a.principal), sum(a.cobrosPagos), sum(a.importeRecuperado), sum(a.importeMenorMenos24), sum(a.importeMenorMenos12), sum(a.importeMenorMenos6), sum(a.importeMenorMenos3), sum(a.importeMenorMenos0), sum(a.importeMenor3), sum(a.importeMenor6), sum(a.importeMenor12), sum(a.importeMenor24), sum(a.importeMayor24) ";
        hql += "from " + createHqlAndCompleteParameters(dto, parameters);
        hql += " group by " + groupBy;
        hql += " order by " + orderBy;

        return createExportRows(hql, parameters);
    }

    /**
     * Ejecuta la query y exporta los datos.
     * @param hql query
     * @param parameters parametros
     * @return lista de DtoExportRow
     */
    @SuppressWarnings("unchecked")
    private List<DtoAnalisisExternaTabla> createExportRows(String hql, HashMap<String, Object> parameters) {
        Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
        Query query = session.createQuery(hql);
        setParameters(query, parameters);
        List<Object[]> list = query.list();
        List<DtoAnalisisExternaTabla> rows = new ArrayList<DtoAnalisisExternaTabla>();
        DtoAnalisisExternaTabla row;
        for (Object[] object : list) {
            row = new DtoAnalisisExternaTabla();
            row.setSalida((String) object[0]);
            row.setNumProcedimientos((Long) object[1]);
            row.setNumAsuntos((Long) object[2]);
            row.setPrincipal((Double) object[3]);
            row.setCobrosPagos((Double) object[4]);
            row.setImporteRecuperado((Double) object[5]);

            row.setHaceMas24Meses((Double) object[6]);
            row.setEntre24y12((Double) object[7]);
            row.setEntre12y6((Double) object[8]);
            row.setEntre6y3((Double) object[9]);
            row.setEntre3yFechaInforme((Double) object[10]);
            row.setMenos3((Double) object[11]);
            row.setMenos6((Double) object[12]);
            row.setMenos12((Double) object[13]);
            row.setMenos24((Double) object[14]);
            row.setMas24((Double) object[15]);

            rows.add(row);
        }
        return rows;
    }

    private void setParameters(Query query, HashMap<String, Object> parameters) {
        if (parameters == null) { return; }
        for (String key : parameters.keySet()) {
            Object param = parameters.get(key);
            query.setParameter(key, param);
        }
    }
}
