package es.capgemini.pfs.persona.dao.impl;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.files.CursorReadCallBack;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * dao de personas.
 * @author jbosnjak
 *
 */
@Repository("PersonaDao")
public class PersonaDaoImpl extends AbstractEntityDao<Persona, Long> implements PersonaDao {

    @Resource
    private MessageService messageService;

    /**
     * {@inheritDoc}
     */
    public List<Bien> getBienes(Long idPersona) {
        Persona per = get(idPersona);
        return per.getBienes();

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Ingreso> getIngresos(Long id) {
        return get(id).getIngresos();
    }

    /**
     * {@inheritDoc}
     */
    public Long obtenerCantidadDeVencidosUsuario(DtoBuscarClientes clientes) {
        String query = generateHQLClientesFilterSQL(clientes);
        query = "SELECT count(*) FROM (" + query + ")";
        Long cantidad = ((BigDecimal) getSession().createSQLQuery(query).uniqueResult()).longValue();

        if (cantidad == null) {
            cantidad = 0L;
        }

        return cantidad;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Page findClientesPaginated(DtoBuscarClientes clientes) {
        String hql = " from Persona per where per.id = ?";
        String sqlPersonas = generateHQLClientesFilterSQL(clientes);
        PageSql page = new PageSql();

        try {
            //Recuperamos los Ids de las personas a mostrar

            Query q = getSession().createSQLQuery(sqlPersonas);
            List<BigDecimal> idList = q.list();
            int size = idList.size();

            int fromIndex = clientes.getStart();
            int toIndex = clientes.getStart() + clientes.getLimit();

            //Paginado, si no existe, creamos la paginación nosotros
            if (fromIndex < 0 || toIndex < 0) {
                fromIndex = 0;
                toIndex = 25;
            }

            if (idList.size() >= clientes.getStart() + clientes.getLimit())
                idList = idList.subList(clientes.getStart(), clientes.getStart() + clientes.getLimit());
            else
                idList = idList.subList(clientes.getStart(), idList.size());

            List<Object> list = new ArrayList<Object>(idList.size());
            for (BigDecimal objId : idList) {
                Object qObj = getHibernateTemplate().find(hql, new Long(objId.longValue())).get(0);
                list.add(qObj);
            }

            page.setResults(list);
            page.setTotalCount(size);
        } catch (Exception e) {
            logger.error(sqlPersonas, e);
        }

        return page;
    }

    /**
     * Genera la query en SQL que devolverá los IDs de los clientes filtrados y ordenados.
     * @param clientes El Dto con los filtros
     * @return La query en SQL
     */
    private String generateHQLClientesFilterSQL(DtoBuscarClientes clientes) {

        StringBuilder hql = new StringBuilder("SELECT p.per_id from PER_PERSONAS p ");
        hql.append(" JOIN ${master.schema}.DD_TPE_TIPO_PERSONA tpe ON tpe.dd_tpe_id = p.dd_tpe_id ");

        boolean necesitaCruzarCliente = ((clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue())
                || (clientes.getSituacion() != null && clientes.getSituacion().length() > 0) || (clientes.getIsPrimerTitContratoPase() != null && clientes
                .getIsPrimerTitContratoPase().booleanValue()));

        boolean necesitaCruzarEstado = (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue());

        boolean saldovencido = false;
        boolean riesgoTotal = false;

        if (clientes.getMaxSaldoVencido() == null || clientes.getMaxSaldoVencido().length() < 1) {
            clientes.setMaxSaldoVencido("" + Integer.MAX_VALUE);
        } else {
            saldovencido = true;
        }
        if (clientes.getMinSaldoVencido() == null || clientes.getMinSaldoVencido().length() < 1) {
            clientes.setMinSaldoVencido("" + Integer.MIN_VALUE);
        } else {
            saldovencido = true;
        }
        if (clientes.getMaxRiesgoTotal() == null || clientes.getMaxRiesgoTotal().length() < 1) {
            clientes.setMaxRiesgoTotal("" + Integer.MAX_VALUE);
        } else {
            riesgoTotal = true;
        }
        if (clientes.getMinRiesgoTotal() == null || clientes.getMinRiesgoTotal().length() < 1) {
            clientes.setMinRiesgoTotal("" + Integer.MIN_VALUE);
        } else {
            riesgoTotal = true;
        }

        String fechaMinima = null;
        String fechaMaxima = null;

        if (clientes.getMinDiasVencido() != null && clientes.getMinDiasVencido().length() > 0) {
            fechaMinima = clientes.getMinDiasVencido();
        }

        if (clientes.getMaxDiasVencido() != null && clientes.getMaxDiasVencido().length() > 0) {
            fechaMaxima = clientes.getMaxDiasVencido();
        }

        if (necesitaCruzarCliente) {
            hql.append(" JOIN CLI_CLIENTES cli ON cli.per_id = p.per_id AND cli.borrado = 0 ");
        }
        if (necesitaCruzarEstado) {
            hql.append(" JOIN EST_ESTADOS est ON est.DD_EST_ID = cli.DD_EST_ID ");
            hql.append(" JOIN ARQ_ARQUETIPOS arq ON cli.ARQ_ID = arq.ARQ_ID and arq.ITI_ID = est.ITI_ID ");
        }
        boolean necesitaCruzarSaldos = (saldovencido || riesgoTotal || fechaMinima != null || fechaMaxima != null);

        hql.append("WHERE p.borrado = 0 ");

        if (necesitaCruzarEstado) {
            int cantPer = 0;
            List<Perfil> perfiles = clientes.getPerfiles();
            if (perfiles != null) {
                cantPer = perfiles.size();
            }
            if (cantPer > 0) {
                hql.append(" and ( ");

                StringBuilder listadoPerfiles = new StringBuilder();
                for (Perfil p : perfiles) {
                    listadoPerfiles.append(p.getId() + ",");
                }
                listadoPerfiles.delete(listadoPerfiles.length() - 1, listadoPerfiles.length());

                hql.append(" est.PEF_ID_GESTOR IN (").append(listadoPerfiles).append(") ");

                //Solo permitimos ver personas de este itinerario al supervisor si no se trata de la búsqueda por GV
                //Los supervisores de GV no tienen que ver personas en gestion de vencidos
                if (!clientes.getIsBusquedaGV()) {
                    hql.append(" or est.PEF_ID_SUPERVISOR IN (").append(listadoPerfiles).append(") ");
                }

                hql.append(" ) ");
            }
        }

        //Input de código de cliente
        String codigoCliente = clientes.getCodigoEntidad();
        if (codigoCliente != null) {
            codigoCliente = codigoCliente.trim();
            if (codigoCliente.length() > 0) {
                hql.append(" and p.PER_COD_CLIENTE_ENTIDAD = " + codigoCliente + " ");
            }
        }

        //Input de nombre de persona
        String nombrePersona = clientes.getNombre();
        if (nombrePersona != null) {
            nombrePersona = nombrePersona.trim().toLowerCase();

            if (nombrePersona.length() > 0) {
                hql.append(" and lower(p.PER_NOMBRE) like '%" + nombrePersona + "%' ");
            }
        }

        //Input de apellido de persona
        String apellido1Persona = clientes.getApellido1();
        if (apellido1Persona != null) {
            apellido1Persona = apellido1Persona.trim().toLowerCase();

            if (apellido1Persona.length() > 0) {
                hql.append(" and lower(p.PER_APELLIDO1) like '%" + apellido1Persona + "%' ");
            }
        }

        //Input de segundo apellido de persona
        String apellido2Persona = clientes.getApellido2();
        if (apellido2Persona != null) {
            apellido2Persona = apellido2Persona.trim().toLowerCase();

            if (apellido2Persona.length() > 0) {
                hql.append(" and lower(p.PER_APELLIDO2) like '%" + apellido2Persona + "%' ");
            }
        }

        //Input de nif de persona
        String nifPersona = clientes.getDocId();
        if (nifPersona != null) {
            nifPersona = nifPersona.trim().toUpperCase();

            if (nifPersona.length() > 0) {
                hql.append(" and p.PER_DOC_ID like '%" + nifPersona + "%' ");
                //hql.append(" and lower(p.docId) like '%" + clientes.getNif().toLowerCase() + "%' ");
            }
        }

        //Combo tipo de persona
        if (clientes.getTipoPersona() != null && clientes.getTipoPersona().length() > 0) {
            hql.append(" and tpe.DD_TPE_CODIGO = '" + clientes.getTipoPersona() + "' ");
        }

        String sqlPersonaId = null;

        //Combo Tipo de intervencion
        if (clientes.getTipoIntervercion() != null && clientes.getTipoIntervercion().length() > 0
                && (clientes.getIsPrimerTitContratoPase() == null || !clientes.getIsPrimerTitContratoPase())) {

            //Subquery que busca personas con algún tipo de intervención
            String filtroTipoIntervencion = "SELECT cp.per_id FROM CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
                    + " WHERE cp.borrado = 0 " + " AND tin.dd_tin_id = cp.dd_tin_id";

            if (PersonaDao.BUSQUEDA_PRIMER_TITULAR.equals(clientes.getTipoIntervercion())) {
                filtroTipoIntervencion += " and cp.CPE_ORDEN = 1 ";
                filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 1 ";
            } else if (PersonaDao.BUSQUEDA_TITULARES.equals(clientes.getTipoIntervercion())) {
                filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 1 ";
            } else if (PersonaDao.BUSQUEDA_AVALISTAS.equals(clientes.getTipoIntervercion())) {
                filtroTipoIntervencion += " and tin.DD_TIN_TITULAR = 0 ";
            }

            sqlPersonaId = "(" + filtroTipoIntervencion + ")";
        }

        //Check contrato de pase
        if (clientes.getIsPrimerTitContratoPase() != null && clientes.getIsPrimerTitContratoPase().booleanValue()) {
            //Subquery que busca personas con contrato de pase
            String filtroContratoPase = "SELECT cp.per_id FROM CNT_CONTRATOS c" + ", CPE_CONTRATOS_PERSONAS cp, DD_TIN_TIPO_INTERVENCION tin"
                    + ", CLI_CLIENTES cli, CCL_CONTRATOS_CLIENTE ccl" + " WHERE cp.borrado = 0 " + " AND cp.cnt_id = c.cnt_id and c.borrado = 0"
                    + " AND cp.dd_tin_id = tin.dd_tin_id" + " AND tin.DD_TIN_TITULAR = 1 "
                    + " AND cli.cli_id = ccl.cli_id AND ccl.cnt_id = cp.cnt_id " + " AND cli.per_id = cp.per_id"
                    + " AND ccl.ccl_pase = 1 AND cp.cpe_orden = 1";

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + filtroContratoPase + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + filtroContratoPase + ")";
            }
        }

        //Input número de contrato
        if (clientes.getNroContrato() != null && clientes.getNroContrato().length() > 0) {

            String filtroContrato = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp "
                    + " WHERE c.borrado = 0 and c.cnt_id = cp.cnt_id and cp.borrado = 0 and c.CNT_CONTRATO like '%" + clientes.getNroContrato()
                    + "%'";

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + filtroContrato + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + filtroContrato + ")";
            }
        }

        //Multicombo tipo de producto
        if ((clientes.getTipoProducto() != null && clientes.getTipoProducto().length() > 0)) {
            String selectTipoProductos = "SELECT cpe.per_id FROM CNT_CONTRATOS c, DD_TPR_TIPO_PROD tpr, CPE_CONTRATOS_PERSONAS cpe "
                    + "WHERE c.dd_tpr_id = tpr.dd_tpr_id and c.borrado = 0 and cpe.cnt_id = c.cnt_id and cpe.borrado = 0 " + "AND dd_tpr_codigo = '"
                    + clientes.getTipoProducto() + "'";

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + selectTipoProductos + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + selectTipoProductos + ")";
            }

        }

        //Multicombo segmento
        String segmentoPersona = clientes.getSegmento();
        if (segmentoPersona != null && segmentoPersona.length() > 0) {
            StringTokenizer tokensSegmentos = new StringTokenizer(segmentoPersona, ",");
            hql.append(" and p.DD_SCL_ID IN (");
            while (tokensSegmentos.hasMoreTokens()) {
                hql.append(tokensSegmentos.nextElement());
                if (tokensSegmentos.hasMoreTokens()) {
                    hql.append(",");
                }
            }
            hql.append(") ");
        }

        //Multicombo situación
        if ((clientes.getSituacion() != null && clientes.getSituacion().length() > 0)) {
            StringTokenizer tokensSituaciones = new StringTokenizer(clientes.getSituacion(), ",");
            hql.append(" and cli.DD_EST_ID IN (SELECT DD_EST_ID FROM ${master.schema}.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO IN (");
            while (tokensSituaciones.hasMoreTokens()) {
                hql.append("'" + tokensSituaciones.nextElement() + "'");
                if (tokensSituaciones.hasMoreTokens()) {
                    hql.append(",");
                }
            }
            hql.append(")) ");
        }

        //Multicombo situación financiera
        if ((clientes.getSituacionFinanciera() != null && clientes.getSituacionFinanciera().length() > 0)) {
            String filtroSituacionFinanciera = "SELECT per.per_id FROM PER_PERSONAS per, DD_EFC_ESTADO_FINAN_CNT efc "
                    + "WHERE per.borrado = 0 and per.dd_efc_id = efc.dd_efc_id AND DD_EFC_CODIGO IN (";

            StringTokenizer tokensSituaciones = new StringTokenizer(clientes.getSituacionFinanciera(), ",");

            while (tokensSituaciones.hasMoreTokens()) {
                filtroSituacionFinanciera += "'" + tokensSituaciones.nextElement() + "'";
                if (tokensSituaciones.hasMoreTokens()) {
                    filtroSituacionFinanciera += ",";
                }
            }
            filtroSituacionFinanciera += ")";

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + filtroSituacionFinanciera + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + filtroSituacionFinanciera + ")";
            }

        }

        //Multicombo situación financiera del contrato
        if ((clientes.getSituacionFinancieraContrato() != null && clientes.getSituacionFinancieraContrato().length() > 0)) {
            String filtroSituacionFinancieraContrato = "select cpe.per_id from CPE_CONTRATOS_PERSONAS cpe "
                    + " JOIN CNT_CONTRATOS c ON cpe.cnt_id = c.cnt_id " + " JOIN DD_EFC_ESTADO_FINAN_CNT efc ON c.dd_efc_id = efc.dd_efc_id "
                    + " JOIN ${master.schema}.DD_ESC_ESTADO_CNT esc ON c.dd_esc_id = esc.dd_esc_id "
                    + " WHERE cpe.borrado = 0 and dd_esc_codigo <> '" + DDEstadoContrato.ESTADO_CONTRATO_CANCELADO + "' AND DD_EFC_CODIGO IN (";

            StringTokenizer tokensSituaciones = new StringTokenizer(clientes.getSituacionFinancieraContrato(), ",");

            while (tokensSituaciones.hasMoreTokens()) {
                filtroSituacionFinancieraContrato += "'" + tokensSituaciones.nextElement() + "'";
                if (tokensSituaciones.hasMoreTokens()) {
                    filtroSituacionFinancieraContrato += ",";
                }
            }
            filtroSituacionFinancieraContrato += ")";

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + filtroSituacionFinancieraContrato + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + filtroSituacionFinancieraContrato + ")";
            }

        }

        int cantZonas = clientes.getCodigoZonas().size();
        String zonas = null;
        if (cantZonas > 0) {
            zonas = " and ( ";
            for (String codigoZ : clientes.getCodigoZonas()) {
                zonas += " zon.zon_cod like '" + codigoZ + "%' OR";
            }
            zonas = zonas.substring(0, zonas.length() - 2);
            zonas += " ) ";

        }

        String jerarquia = null;
        if (clientes.getJerarquia() != null && clientes.getJerarquia().length() > 0) {
            jerarquia = " and zon.ZON_ID >= " + clientes.getJerarquia();
            if (zonas != null) jerarquia += zonas;
        } else if (zonas != null) {
            jerarquia = zonas;
        }

        if (jerarquia != null) {
            String filtroJerarquia = "";

            //Si es primer titular del contrato de pase buscamos directamente en los clientes
            if (clientes.getIsPrimerTitContratoPase() != null && clientes.getIsPrimerTitContratoPase().booleanValue()) {
                filtroJerarquia = "SELECT cli.per_id FROM CLI_CLIENTES cli JOIN OFI_OFICINAS o ON cli.ofi_id = o.ofi_id JOIN ZON_ZONIFICACION zon ON zon.ofi_id = o.ofi_id WHERE cli.borrado = 0 "
                        + jerarquia;
            } else {
                filtroJerarquia = "SELECT cp.per_id FROM CNT_CONTRATOS c, CPE_CONTRATOS_PERSONAS cp, ZON_ZONIFICACION zon "
                        + " WHERE cp.borrado = 0 and c.borrado = 0 and cp.cnt_id = c.cnt_id AND c.ZON_ID = zon.ZON_ID " + jerarquia;
            }

            if (sqlPersonaId == null) {
                sqlPersonaId = "(" + filtroJerarquia + ")";
            } else {
                sqlPersonaId += " INTERSECT (" + filtroJerarquia + ")";
            }
        }

        //Check tipo de gestion
        if (clientes.getCodigoGestion() != null && clientes.getCodigoGestion().length() != 0) {

            //Si ha seleccionado representar clientes sin gestión, decimos que no tenga ningún cliente activo
            if (DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION.equals(clientes.getCodigoGestion())) {
                hql.append(" and not exists (SELECT c.per_id FROM CLI_CLIENTES c where borrado = 0 and c.per_id = p.per_id) ");
            }

            //Si ha seleccionado un itinerario concreto, cruzamos con clientes
            else {
                //Subquery que busca personas con contrato de pase
                String filtroCodigoGestion = "SELECT c.per_id FROM CLI_CLIENTES c, ARQ_ARQUETIPOS a, ITI_ITINERARIOS i, ${master.schema}.DD_TIT_TIPO_ITINERARIOS dd "
                        + " WHERE c.arq_id = a.arq_id and a.iti_id = i.iti_id and i.dd_tit_id = dd.dd_tit_id "
                        + " and dd.dd_tit_codigo = '"
                        + clientes.getCodigoGestion() + "' and c.borrado = 0";

                if (sqlPersonaId == null) {
                    sqlPersonaId = "(" + filtroCodigoGestion + ")";
                } else {
                    sqlPersonaId += " INTERSECT (" + filtroCodigoGestion + ")";
                }
            }
        }

        if (sqlPersonaId != null) {
            hql.append(" and p.per_id IN (" + sqlPersonaId + ")");
        }

        //Inputs de riesgos, saldos y días vencidos
        if (necesitaCruzarSaldos) {
            if (saldovencido) {
                String col = "p.per_deuda_irregular";
                if (PersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes.getTipoRiesgo()))
                    col += "_dir";
                else if (PersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo())) col += "_ind";

                hql.append(" and " + col + " between " + clientes.getMinSaldoVencido() + " and " + clientes.getMaxSaldoVencido());
            }
            if (riesgoTotal) {
                String col = "";

                if (PersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes.getTipoRiesgo()))
                    col = "p.PER_RIESGO";
                else if (PersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo()))
                    col = "p.PER_RIESGO_IND";
                else
                    col = "p.PER_RIESGO_TOTAL";

                hql.append(" and " + col + " between " + clientes.getMinRiesgoTotal() + " and " + clientes.getMaxRiesgoTotal());
            }
            if (fechaMinima != null) {
                String col = "p.PER_FECHA_VENCIDA_";

                if (PersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes.getTipoRiesgo()))
                    col += "DIRECTA";
                else if (PersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo()))
                    col += "INDIRECTA";
                else
                    col += "TOTAL";

                hql.append(" and FLOOR(SYSDATE-" + col + ") >= " + fechaMinima);
            }
            if (fechaMaxima != null) {
                String col = "p.PER_FECHA_VENCIDA_";

                if (PersonaDao.BUSQUEDA_RIESGO_DIRECTO.equals(clientes.getTipoRiesgo()))
                    col += "DIRECTA";
                else if (PersonaDao.BUSQUEDA_RIESGO_INDIRECTO.equals(clientes.getTipoRiesgo()))
                    col += "INDIRECTA";
                else
                    col += "TOTAL";

                hql.append(" and FLOOR(SYSDATE-" + col + ") <= " + fechaMaxima);
            }

        }

        String query = hql.toString() + " ";
        //String query = "SELECT p.per_id FROM PER_PERSONAS p JOIN (" + hql.toString() + ") aux ON aux.per_id = p.per_id ";

        String orderBy = getOrderBy(clientes);
        if (orderBy != null) {
            query += orderBy;
        }

        return query;
    }

    /**
     * Construye la clausula orderBy en SQL en función del parámetro que le pasa.
     * @param clientes El dto para extraer la columna y la orientación de la ordenación
     * @return La clausula order by generada
     */
    private String getOrderBy(DtoBuscarClientes clientes) {
        String orderBy = null;
        String campo = clientes.getSort();

        if (campo == null || campo.length() == 0) { return null; }

        if (campo.equals("nombre")) {
            orderBy = " ORDER BY p.per_nombre ";
        }

        else if (campo.equals("apellido1")) {
            orderBy = " ORDER BY p.per_apellido1 ";
        }

        else if (campo.equals("apellido2")) {
            orderBy = " ORDER BY p.per_apellido2 ";
        }

        else if (campo.equals("codClienteEntidad")) {
            orderBy = " ORDER BY p.per_cod_cliente_entidad ";
        }

        else if (campo.equals("docId")) {
            orderBy = " ORDER BY p.per_doc_id ";
        }

        else if (campo.equals("telefono1")) {
            orderBy = " ORDER BY p.per_telefono_1 ";
        }

        //Saldo vencido
        else if (campo.equals("deudaIrregular")) {
            orderBy = " ORDER BY p.PER_DEUDA_IRREGULAR ";
        }

        //Riesgo total
        else if (campo.equals("totalSaldo")) {
            orderBy = " ORDER BY p.PER_RIESGO_TOTAL ";
        }

        //Riesgo directo
        else if (campo.equals("deudaDirecta")) {
            orderBy = " ORDER BY p.PER_RIESGO ";
        }

        //Riesgo Directo Dañado
        else if (campo.equals("riesgoDirectoNoVencidoDanyado")) {
            orderBy = " ORDER BY p.PER_VR_DANIADO_OTRAS_ENT ";
        }

        //Num contratos
        else if (campo.equals("numContratos")) {
            orderBy = " ORDER BY p.PER_NUM_CONTRATOS ";
        }

        if (orderBy != null && clientes.getDir() != null) {
            orderBy += " " + clientes.getDir();
        }

        return orderBy;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public void exportClientes(DtoBuscarClientes clientes, final CursorReadCallBack callback) {

        String sql = generateHQLClientesFilterSQL(clientes);

        Object[] titulos = new Object[16];
        titulos[0] = messageService.getMessage("menu.clientes.listado.lista.nombre");
        titulos[1] = messageService.getMessage("menu.clientes.listado.lista.apellido1");
        titulos[2] = messageService.getMessage("menu.clientes.listado.lista.apellido2");
        titulos[3] = messageService.getMessage("menu.clientes.listado.lista.codigo");
        titulos[4] = messageService.getMessage("menu.clientes.listado.lista.nif");
        titulos[5] = messageService.getMessage("menu.clientes.listado.lista.segmento");
        titulos[6] = messageService.getMessage("menu.clientes.listado.lista.totaldeuda");
        titulos[7] = messageService.getMessage("menu.clientes.listado.lista.totalsaldo");
        titulos[8] = messageService.getMessage("menu.clientes.listado.lista.nrocontratos");
        titulos[9] = messageService.getMessage("menu.clientes.listado.lista.posantigua");
        titulos[10] = messageService.getMessage("menu.clientes.listado.lista.situacion");
        titulos[11] = messageService.getMessage("menu.clientes.listado.lista.diaspase");
        titulos[12] = messageService.getMessage("menu.clientes.listado.lista.arquetipo");
        titulos[13] = messageService.getMessage("menu.clientes.listado.lista.ofiCntPase");
        titulos[14] = messageService.getMessage("menu.clientes.listado.lista.riesgoDirecto");
        titulos[15] = messageService.getMessage("menu.clientes.listado.lista.riesgoDirectoDaniado");

        String hql = " from Persona per where per.id = ?";

        Query q = getSession().createSQLQuery(sql);
        List<BigDecimal> idList = q.list();

        Persona pp = null;
        Object[] values = new Object[16];

        callback.beforeFirst();
        callback.doWithLine(titulos);

        Locale locale = new Locale("es", "ES");
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);

        for (BigDecimal id : idList) {
            pp = (Persona) getHibernateTemplate().find(hql, new Long(id.longValue())).get(0);

            //pp = (Persona) cursor.get(0);
            values[0] = nvlString(pp.getNombre());
            values[1] = nvlString(pp.getApellido1());
            values[2] = nvlString(pp.getApellido2());
            values[3] = nvlString(pp.getCodClienteEntidad());
            values[4] = nvlString(pp.getDocId().toString());
            values[5] = nvlString(pp.getSegmento().getDescripcion());
            values[6] = nvlString(numberFormat.format(pp.getRiesgoTotal()));
            values[7] = nvlString(numberFormat.format(pp.getRiesgoDirecto()));
            values[8] = nvlString(pp.getNumContratos());
            values[9] = nvlString(pp.getDiasVencido());
            values[10] = nvlString(pp.getSituacion());

            values[11] = "";
            values[12] = "";
            //Dias para pase
            if (pp.getClienteActivo() != null) {
                if (pp.getClienteActivo().getBajoUmbral()) {
                    values[11] = nvlString(pp.getClienteActivo().getDiasParaCambioEstado());
                } else {
                    values[11] = messageService.getMessage("clientes.listado.pendienteDeUmbral");
                }
                //Arquetipo
                values[12] = nvlString(pp.getClienteActivo().getArquetipo().getNombre());
            }

            //Oficina del contrato de pase
            values[13] = nvlString(pp.getOficina());
            //Riesgo Directo
            values[14] = nvlString(pp.getRiesgoDirecto());
            //Riesto Directo Daniado
            values[15] = nvlString(pp.getRiesgoDirectoNoVencidoDanyado());

            callback.doWithLine(values);
        }
        callback.afterLast();

    }

    private static String obtenerExpedientePropuestoPersonaHQL() {
        return "from Expediente exp, ExpedienteContrato ep, ContratoPersona cp, DDEstadoExpediente ee "
                + " where exp.id = ep.expediente.id and ep.contrato.id = cp.contrato.id "
                + " and exp.auditoria.borrado = false and ep.auditoria.borrado = false "
                + " and cp.auditoria.borrado = false and ee.id = exp.estadoExpediente.id " + " and ee.codigo = :expEstProp"
                + " and cp.persona.id = :perId";
    }

    /**
     * {@inheritDoc}
     */
    public Long obtenerIdExpedientePropuestoPersona(Long idPersona) {
        String hql = " select distinct exp.id " + obtenerExpedientePropuestoPersonaHQL();
        Query query = getSession().createQuery(hql);
        query.setParameter("expEstProp", DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO);
        query.setParameter("perId", idPersona);
        return (Long) query.uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    public Expediente obtenerExpedientePropuestoPersona(Long idPersona) {
        String hql = " select distinct exp " + obtenerExpedientePropuestoPersonaHQL();
        Query query = getSession().createQuery(hql);
        query.setParameter("expEstProp", DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO);
        query.setParameter("perId", idPersona);
        return (Expediente) query.uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    public Expediente getExpedienteConContratoPaseTitular(Long idPersona) {
        String hql = " select distinct exp from Expediente exp, ExpedienteContrato cex, ContratoPersona cpe "
                + " where exp.id = cex.expediente.id and cex.contrato.id = cpe.contrato.id "
                + " and exp.auditoria.borrado = false and cex.auditoria.borrado = false  and cpe.auditoria.borrado = false "
                + " and cpe.tipoIntervencion.titular = true and cex.pase = 1  and cpe.persona.id = :perId "
                + " and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ";

        Query query = getSession().createQuery(hql);
        query.setParameter("perId", idPersona);
        return (Expediente) query.uniqueResult();
    }

    private String nvlString(Object o) {
        if (o == null) { return ""; }
        return o.toString();
    }

    /**
     * Devuelve un HQL con los contratos existentes en los procedimientos en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparará solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnProcedimientos(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ProcedimientoContratoExpediente pce, Procedimiento prc ");
        hql.append("WHERE cex.id = pce.expedienteContrato ");
        hql.append("and pce.procedimiento = prc.id ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and prc.estadoProcedimiento.codigo IN ('" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO + "', '"
                + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO + "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO + "', '"
                + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    /**
     * Devuelve un HQL con los contratos existentes en los expedientes en curso.
     * @param columnaRelacion Si se le pasa este parametro (!= null) comparará solamente los contrato.id que relacionen con el parametro
     * @return
     */
    private String getHqlContratosEnExpedientes(String columnaRelacion) {
        StringBuilder hql = new StringBuilder();

        hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, Expediente exp  ");
        hql.append("WHERE exp.id = cex.expediente.id ");
        hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
        hql.append("and exp.estadoExpediente.codigo IN ('" + DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
                + DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '" + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

        if (columnaRelacion != null) {
            hql.append("and cex.contrato.id = ").append(columnaRelacion);
        }

        return hql.toString();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long getContratosParaFuturoCliente(Long personaId) {

        String columnaRelacion = "c.id";

        StringBuilder hql = new StringBuilder();
        hql.append(" select count(distinct c.id) from Contrato c, Persona p, ContratoPersona cpe, DDEstadoContrato ec ");
        hql.append(" where p.id = :idPersona");
        hql.append(" and cpe.persona.id = p.id");
        hql.append(" and cpe.contrato.id = c.id");
        hql.append(" and c.estadoContrato.id = ec.id and ec.codigo != :codigoContratoCancelado ");
        hql.append(" and c.auditoria.borrado = false ");
        hql.append(" and cpe.tipoIntervencion.titular = true ");

        // El contrato no esta en un expediente
        hql.append(" and c.id not in (" + getHqlContratosEnExpedientes(columnaRelacion) + ")");

        // El contrato no esta en un procedimiento
        hql.append(" and c.id not in (" + getHqlContratosEnProcedimientos(columnaRelacion) + ")");

        Query q = getSession().createQuery(hql.toString());

        q.setParameter("idPersona", personaId);
        q.setParameter("codigoContratoCancelado", DDEstadoContrato.ESTADO_CONTRATO_CANCELADO);

        return (Long) q.uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Contrato> obtenerContratosParaFuturoCliente(Long personaId) {

        String columnaRelacion = "c.id";

        String hql = " select c from Contrato c, Persona p, ContratoPersona cpe, DDEstadoContrato ec ";
        hql += " where p.id = ?";
        hql += " and cpe.persona.id = p.id";
        hql += " and cpe.contrato.id = c.id";
        hql += " and c.estadoContrato.id = ec.id and ec.codigo != ?";
        hql += " and c.auditoria.borrado = false";

        // El contrato no esta en un expediente
        hql += " and c.id not in (" + getHqlContratosEnExpedientes(columnaRelacion) + ")";

        // El contrato no esta en un procedimiento
        hql += " and c.id not in (" + getHqlContratosEnProcedimientos(columnaRelacion) + ")";

        return getHibernateTemplate().find(hql, new Object[] { personaId, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO });
    }

    /**
     * Busca persona por codigo.
     * @param codigo string
     * @return Persona
     */
    @SuppressWarnings("unchecked")
    public Persona getByCodigo(String codigo) {
        String hsql = "from Persona where PER_COD_CLIENTE_ENTIDAD=? and auditoria.borrado = false";
        List<Persona> lista = getHibernateTemplate().find(hsql, codigo);
        if (lista != null && lista.size() > 0) { return lista.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Persona> findClientes(DtoBuscarClientes clientes) {
        List<Persona> list = new ArrayList();
        String sql = generateHQLClientesFilterSQL(clientes);

        String hql = " from Persona per where per.id = ?";

        Query q = getSession().createSQLQuery(sql);
        List<BigDecimal> idList = q.list();

        Persona pp = null;

        for (BigDecimal id : idList) {
            pp = (Persona) getHibernateTemplate().find(hql, new Long(id.longValue())).get(0);
            list.add(pp);
        }

        return list;
    }

    /**
     * {@inheritDoc}
     */
    public Cliente getClienteActivo(Long idPersona) {
        Persona persona = get(idPersona);
        getHibernateTemplate().refresh(persona);
        return persona.getClienteActivo();
    }

}
