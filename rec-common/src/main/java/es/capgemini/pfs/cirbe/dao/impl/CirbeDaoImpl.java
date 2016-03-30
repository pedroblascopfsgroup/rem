package es.capgemini.pfs.cirbe.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.type.Type;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cirbe.dao.CirbeDao;
import es.capgemini.pfs.cirbe.dao.DDCodigoOperacionCirbeDao;
import es.capgemini.pfs.cirbe.dao.DDTipoSituacionCirbeDao;
import es.capgemini.pfs.cirbe.dao.DDTipoVencimientoCirbeDao;
import es.capgemini.pfs.cirbe.dto.DtoCirbe;
import es.capgemini.pfs.cirbe.model.Cirbe;
import es.capgemini.pfs.cirbe.model.DDCodigoOperacionCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoGarantiaCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoSituacionCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoVencimientoCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase de riesgo cirbe.
 *  @author: marruiz
 */
@Repository("CirbeDao")
public class CirbeDaoImpl extends AbstractEntityDao<Cirbe, Long> implements CirbeDao {

    @Autowired
    private DDCodigoOperacionCirbeDao ddCodigoOperacionCirbeDao;

    @Autowired
    private DDTipoSituacionCirbeDao ddTipoSituacionCirbeDao;

    @Autowired
    private DDTipoVencimientoCirbeDao ddtiTipoVencimientoCirbeDao;

    @Resource
    private MessageService messageService;

    /**
     * @param idPersona Long
     * @param fecha1 la fecha seleccionada en el combo 1
     * @param fecha2 la fecha seleccionada en el combo 2
     * @param fecha3 la fecha seleccionada en el combo 3
     * @return List Date: todas las fechas de extracción cirbe
     * donde el cliente tenga una carga.
     */
    @SuppressWarnings("unchecked")
    public List<Date> getFechasExtraccionPersona(Long idPersona, Date fecha1, Date fecha2, Date fecha3) {
        StringBuilder hql = new StringBuilder("select distinct cir.fechaExtraccionCirbe from Cirbe cir ");
        hql.append("where cir.persona.id = ? and cir.auditoria." + Auditoria.UNDELETED_RESTICTION);
        Object[] params = null;
        if (fecha3 != null && fecha2 != null && fecha1 != null) {
            params = new Object[4];
        } else if ((fecha1 != null && fecha2 != null && fecha3 == null) || (fecha3 != null && fecha2 != null && fecha1 == null)
                || (fecha1 != null && fecha3 != null && fecha2 == null)) {
            params = new Object[3];
        } else if ((fecha1 != null && fecha2 == null && fecha3 == null) || (fecha2 != null && fecha1 == null && fecha3 == null)
                || (fecha3 != null && fecha1 == null && fecha2 == null)) {
            params = new Object[2];
        } else if (fecha1 == null && fecha2 == null && fecha3 == null) {
            params = new Object[1];
        }
        int i = 0;
        params[i++] = idPersona;
        if (fecha1 != null) {
            hql.append(" and cir.fechaExtraccionCirbe != ? ");
            params[i++] = fecha1;
        }
        if (fecha2 != null) {
            hql.append(" and cir.fechaExtraccionCirbe != ? ");
            params[i++] = fecha2;
        }
        if (fecha3 != null) {
            hql.append(" and cir.fechaExtraccionCirbe != ? ");
            params[i++] = fecha3;
        }

        hql.append("  order by cir.fechaExtraccionCirbe desc");
        return getHibernateTemplate().find(hql.toString(), params);
    }
    
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Date> getFechasActualizacionPersona(Long idPersona, Date fecha1, Date fecha2, Date fecha3) {
        StringBuilder hql = new StringBuilder("select distinct cir.fechaCargaActualizacion from Cirbe cir ");
        hql.append("where cir.persona.id = ? and cir.auditoria." + Auditoria.UNDELETED_RESTICTION);
        Object[] params = null;
        if (fecha3 != null && fecha2 != null && fecha1 != null) {
            params = new Object[4];
        } else if ((fecha1 != null && fecha2 != null && fecha3 == null) || (fecha3 != null && fecha2 != null && fecha1 == null)
                || (fecha1 != null && fecha3 != null && fecha2 == null)) {
            params = new Object[3];
        } else if ((fecha1 != null && fecha2 == null && fecha3 == null) || (fecha2 != null && fecha1 == null && fecha3 == null)
                || (fecha3 != null && fecha1 == null && fecha2 == null)) {
            params = new Object[2];
        } else if (fecha1 == null && fecha2 == null && fecha3 == null) {
            params = new Object[1];
        }
        int i = 0;
        params[i++] = idPersona;
        if (fecha1 != null) {
            hql.append(" and cir.fechaCargaActualizacion != ? ");
            params[i++] = fecha1;
        }
        if (fecha2 != null) {
            hql.append(" and cir.fechaCargaActualizacion != ? ");
            params[i++] = fecha2;
        }
        if (fecha3 != null) {
            hql.append(" and cir.fechaCargaActualizacion != ? ");
            params[i++] = fecha3;
        }

        hql.append("  order by cir.fechaCargaActualizacion desc");
        return getHibernateTemplate().find(hql.toString(), params);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Date> getFechasExtraccionPersonaDesde(Long idPersona, Date fecha) {
        StringBuilder hql = new StringBuilder("select distinct cir.fechaExtraccionCirbe from Cirbe cir ");
        hql.append("where cir.persona.id = ? and cir.fechaExtraccionCirbe < ? and cir.auditoria." + Auditoria.UNDELETED_RESTICTION);
        hql.append("  order by cir.fechaExtraccionCirbe desc");
        Query query = getSession().createQuery(hql.toString());
        query.setParameters(new Object[] { idPersona, fecha }, new org.hibernate.type.Type[] { Hibernate.LONG, Hibernate.DATE });
        query.setMaxResults(CANT_FECHAS_CARGAS - 1);

        return query.list();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Date> getFechasExtraccionPersonaHasta(Long idPersona, Date desde, Date hasta) {
        if (hasta == null) {
            LinkedList<Date> list = new LinkedList<Date>();
            list.add(desde);
            return list;
        }
        StringBuilder hql = new StringBuilder("select distinct cir.fechaExtraccionCirbe from Cirbe cir ");
        hql.append("where cir.persona.id = ? and cir.fechaExtraccionCirbe between ? and ? and cir.auditoria." + Auditoria.UNDELETED_RESTICTION);
        hql.append("  order by cir.fechaExtraccionCirbe desc");

        Query query = getSession().createQuery(hql.toString());
        query.setParameters(new Object[] { idPersona, hasta, desde },
                new org.hibernate.type.Type[] { Hibernate.LONG, Hibernate.DATE, Hibernate.DATE });
        query.setMaxResults(CANT_FECHAS_CARGAS);

        return query.list();
    }

    @SuppressWarnings("unchecked")
    private List<DtoCirbe> getQuery(Long idPersona, Date fecha) {
        StringBuffer hql = new StringBuffer(500);
        hql.append("select c1.codigoOperacionCirbe,c1.tipoGarantiaCirbe,c1.tipoSituacionCirbe,");
        hql.append("c1.tipoVencimientoCirbe,c1.importeDispuesto,c1.importeDisponible");
        hql.append(" from Cirbe c1");
        hql.append(" where c1.persona.id = ?");
        hql.append(" and c1.fechaCargaActualizacion = ?");
        Query query = getSession().createQuery(hql.toString());
        query.setParameters(new Object[] { idPersona, fecha }, new org.hibernate.type.Type[] { Hibernate.LONG, Hibernate.DATE });
        List<Object[]> result = query.list();
        List<DtoCirbe> ret = new ArrayList<DtoCirbe>();
        for (Object[] o : result) {
            DtoCirbe row = new DtoCirbe();
            row = new DtoCirbe();
            row.setCodigoOperacion((DDCodigoOperacionCirbe) o[0]);
            row.setTipoGarantia((DDTipoGarantiaCirbe) o[1]);
            row.setTipoSituacion((DDTipoSituacionCirbe) o[2]);
            row.setTipoVencimiento((DDTipoVencimientoCirbe) o[3]);
            row.setDispuestoFecha1((Double) o[4]);
            row.setDisponibleFecha1((Double) o[5]);
            ret.add(row);
        }
        return ret;
    }

    /**
     * Mergea los registros que corresponden a las 2da y 3ra fecha con los de la 1ra.
     * Si encuentra el registro, agrega los datos a la 2da o 3ra fecha según corresponda.
     * Si no lo encuentra crea un registro nuevo al final con los datos correspondientes.
     * @param listaFecha1 la lista destino
     * @param listaFecha2 la lista origen
     * @param segunda true si es la 2da fecha false si es la 3ra
     */
    private void mergeDeListasAFecha1(List<DtoCirbe> listaFecha1, List<DtoCirbe> listaFecha2, boolean segunda) {
        List<DtoCirbe> nuevos = new ArrayList<DtoCirbe>();
        for (DtoCirbe dos : listaFecha2) {
            boolean esta = false;
            for (int i = 0; i < listaFecha1.size() && !esta; i++) {
                DtoCirbe uno = listaFecha1.get(i);
                if (uno.getCodigoOperacion().getId().longValue() == dos.getCodigoOperacion().getId().longValue()
                        && uno.getTipoGarantia().getId().longValue() == dos.getTipoGarantia().getId().longValue()
                        && uno.getTipoSituacion().getId().longValue() == dos.getTipoSituacion().getId().longValue()
                        && uno.getTipoVencimiento().getId().longValue() == dos.getTipoVencimiento().getId().longValue()) {
                    esta = true;
                    if (segunda) {
                        //Es la segunda fecha
                        uno.setDisponibleFecha2(dos.getDisponibleFecha1());
                        uno.setDispuestoFecha2(dos.getDispuestoFecha1());
                    } else {
                        uno.setDisponibleFecha3(dos.getDisponibleFecha1());
                        uno.setDispuestoFecha3(dos.getDispuestoFecha1());
                    }
                }
            }//FOR fecha1
            if (!esta) {
                if (segunda) {
                    dos.setDisponibleFecha2(dos.getDisponibleFecha1());
                    dos.setDisponibleFecha1(null);
                    dos.setDispuestoFecha2(dos.getDispuestoFecha1());
                    dos.setDispuestoFecha1(null);
                } else {
                    dos.setDisponibleFecha3(dos.getDisponibleFecha1());
                    dos.setDisponibleFecha1(null);
                    dos.setDispuestoFecha3(dos.getDispuestoFecha1());
                    dos.setDispuestoFecha1(null);
                }
                nuevos.add(dos);
            }
        }//FOR fecha2
        listaFecha1.addAll(nuevos);
    }

    /**
     * Devuelve los registros agrupados por la descripción del código de operación cirbe.
     * Además entre los registros de cada tipo de operación inserta uno que solo tiene el registro de
     * diccionario correspondiente a la operación (el resto es null) y contiene los subtotales.
     * @param listaOriginal
     * @return
     */
    private List<DtoCirbe> agruparPorOperacion(List<DtoCirbe> listaOriginal) {
        List<DDCodigoOperacionCirbe> codOps = ddCodigoOperacionCirbeDao.getList();
        HashMap<String, List<DtoCirbe>> hm = new HashMap<String, List<DtoCirbe>>();
        List<DtoCirbe> listaFinal = new ArrayList<DtoCirbe>();
        for (DDCodigoOperacionCirbe coc : codOps) {
            hm.put(coc.getCodigo(), new ArrayList<DtoCirbe>());
        }
        for (DtoCirbe dto : listaOriginal) {
            hm.get(dto.getCodigoOperacion().getCodigo()).add(dto);
        }
        for (String cod : hm.keySet()) {
            List<DtoCirbe> lista = hm.get(cod);
            if (lista.size() > 0) {
                listaFinal.addAll(lista);
                DtoCirbe subtotal = new DtoCirbe();
                subtotal.setSubTotalizador(true);
                DDCodigoOperacionCirbe ddCodOp = new DDCodigoOperacionCirbe();
                ddCodOp.setDescripcion(lista.get(0).getCodigoOperacion().getDescripcion());
                subtotal.setCodigoOperacion(ddCodOp);

                Double totalDispuestoFecha1 = 0d;
                Double totalDisponibleFecha1 = 0d;
                Double totalDispuestoFecha2 = 0d;
                Double totalDisponibleFecha2 = 0d;
                Double totalDispuestoFecha3 = 0d;
                Double totalDisponibleFecha3 = 0d;
                for (DtoCirbe dto : lista) {
                    if (dto.getDispuestoFecha1() != null) {
                        totalDispuestoFecha1 += dto.getDispuestoFecha1();
                    }
                    if (dto.getDisponibleFecha1() != null) {
                        totalDisponibleFecha1 += dto.getDisponibleFecha1();
                    }
                    if (dto.getDispuestoFecha2() != null) {
                        totalDispuestoFecha2 += dto.getDispuestoFecha2();
                    }
                    if (dto.getDisponibleFecha2() != null) {
                        totalDisponibleFecha2 += dto.getDisponibleFecha2();
                    }
                    if (dto.getDispuestoFecha3() != null) {
                        totalDispuestoFecha3 += dto.getDispuestoFecha3();
                    }
                    if (dto.getDisponibleFecha3() != null) {
                        totalDisponibleFecha3 += dto.getDisponibleFecha3();
                    }
                }

                subtotal.setDispuestoFecha1(totalDispuestoFecha1);
                subtotal.setDisponibleFecha1(totalDisponibleFecha1);
                subtotal.setDispuestoFecha2(totalDispuestoFecha2);
                subtotal.setDisponibleFecha2(totalDisponibleFecha2);
                subtotal.setDispuestoFecha3(totalDispuestoFecha3);
                subtotal.setDisponibleFecha3(totalDisponibleFecha3);

                listaFinal.add(subtotal);
            }
        }
        //AGREGO LOS TOTALES POR TIPO DE VENCIMIENTO
        List<String> tiposVencimiento = ddtiTipoVencimientoCirbeDao.getDescripcionesTiposVencimiento();
        for (String tipoVto : tiposVencimiento) {
            Double totalDispuesto1 = 0d;
            Double totalDisponible1 = 0d;
            Double totalDispuesto2 = 0d;
            Double totalDisponible2 = 0d;
            Double totalDispuesto3 = 0d;
            Double totalDisponible3 = 0d;
            for (DtoCirbe dto : listaFinal) {
                if (dto.getTipoVencimiento() != null && dto.getTipoVencimiento().getDescripcion().equals(tipoVto)) {

                    if (dto.getDisponibleFecha1() != null) {
                        totalDisponible1 += dto.getDisponibleFecha1();
                    }
                    if (dto.getDispuestoFecha1() != null) {
                        totalDispuesto1 += dto.getDispuestoFecha1();
                    }
                    if (dto.getDisponibleFecha2() != null) {
                        totalDisponible2 += dto.getDisponibleFecha2();
                    }
                    if (dto.getDispuestoFecha2() != null) {
                        totalDispuesto2 += dto.getDispuestoFecha2();
                    }
                    if (dto.getDisponibleFecha3() != null) {
                        totalDisponible3 += dto.getDisponibleFecha3();
                    }
                    if (dto.getDispuestoFecha3() != null) {
                        totalDispuesto3 += dto.getDispuestoFecha3();
                    }
                }
            }
            DtoCirbe nuevo = new DtoCirbe();
            nuevo.setTotalizador(true);
            DDTipoVencimientoCirbe aux = new DDTipoVencimientoCirbe();
            aux.setDescripcion(messageService.getMessage("cirbe.total") + " " + tipoVto + " <br />&nbsp;&nbsp;");
            nuevo.setTipoVencimiento(aux);
            nuevo.setDisponibleFecha1(totalDisponible1);
            nuevo.setDispuestoFecha1(totalDispuesto1);
            nuevo.setDisponibleFecha2(totalDisponible2);
            nuevo.setDispuestoFecha2(totalDispuesto2);
            nuevo.setDisponibleFecha3(totalDisponible3);
            nuevo.setDispuestoFecha3(totalDispuesto3);
            listaFinal.add(nuevo);
        }
        //AGREGO LOS TOTALES POR TIPO DE SITUACION
        List<String> tiposSituacion = ddTipoSituacionCirbeDao.getDescripciones();
        for (String tipoSit : tiposSituacion) {
            Double totalDispuesto1 = 0d;
            Double totalDisponible1 = 0d;
            Double totalDispuesto2 = 0d;
            Double totalDisponible2 = 0d;
            Double totalDispuesto3 = 0d;
            Double totalDisponible3 = 0d;

            for (DtoCirbe dto : listaFinal) {
                if (dto.getTipoSituacion() != null && dto.getTipoSituacion().getId() != null
                        && dto.getTipoSituacion().getDescripcion().equals(tipoSit)) {
                    if (dto.getDisponibleFecha1() != null) {
                        totalDisponible1 += dto.getDisponibleFecha1();
                    }
                    if (dto.getDispuestoFecha1() != null) {
                        totalDispuesto1 += dto.getDispuestoFecha1();
                    }
                    if (dto.getDisponibleFecha2() != null) {
                        totalDisponible2 += dto.getDisponibleFecha2();
                    }
                    if (dto.getDispuestoFecha2() != null) {
                        totalDispuesto2 += dto.getDispuestoFecha2();
                    }
                    if (dto.getDisponibleFecha3() != null) {
                        totalDisponible3 += dto.getDisponibleFecha3();
                    }
                    if (dto.getDispuestoFecha3() != null) {
                        totalDispuesto3 += dto.getDispuestoFecha3();
                    }
                }
            }
            DtoCirbe nuevo = new DtoCirbe();
            nuevo.setTotalizador(true);
            DDTipoSituacionCirbe aux = new DDTipoSituacionCirbe();
            aux.setDescripcion(messageService.getMessage("cirbe.total") + " <br />&nbsp;&nbsp;" + tipoSit);
            nuevo.setTipoSituacion(aux);
            nuevo.setDisponibleFecha1(totalDisponible1);
            nuevo.setDispuestoFecha1(totalDispuesto1);
            nuevo.setDisponibleFecha2(totalDisponible2);
            nuevo.setDispuestoFecha2(totalDispuesto2);
            nuevo.setDisponibleFecha3(totalDisponible3);
            nuevo.setDispuestoFecha3(totalDispuesto3);
            listaFinal.add(nuevo);
        }

        return listaFinal;
    }

    /**
     * {@inheritDoc}
     */
    public List<DtoCirbe> getCirbeData(Long idPersona, Date fecha1, Date fecha2, Date fecha3) {
        List<DtoCirbe> listaFecha1 = getQuery(idPersona, fecha1);
        if (fecha2 != null) {
            List<DtoCirbe> listaFecha2 = getQuery(idPersona, fecha2);
            mergeDeListasAFecha1(listaFecha1, listaFecha2, true);
        }
        if (fecha3 != null) {
            List<DtoCirbe> listaFecha3 = getQuery(idPersona, fecha3);
            mergeDeListasAFecha1(listaFecha1, listaFecha3, false);
        }
        return agruparPorOperacion(listaFecha1);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<DtoCirbe> getCirbeDataOLD(Long idPersona, Date fecha1, Date fecha2, Date fecha3) {
        List<Object> params = new ArrayList<Object>();
        List<Type> paramsType = new ArrayList<Type>();
        StringBuilder hql = new StringBuilder("select c1.codigoOperacionCirbe,c1.tipoGarantiaCirbe,c1.tipoSituacionCirbe,");
        hql.append("c1.tipoVencimientoCirbe,c1.importeDispuesto,c1.importeDisponible ");
        if (fecha2 != null) {
            hql.append(",c2.importeDispuesto,c2.importeDisponible ");
        }
        if (fecha3 != null) {
            hql.append(",c3.importeDispuesto,c3.importeDisponible ");
        }
        hql.append(" from Cirbe c1");
        if (fecha2 != null) {
            hql.append(", Cirbe c2");
        }
        if (fecha3 != null) {
            hql.append(", Cirbe c3");
        }

        hql.append(" where ");
        hql.append(" c1.fechaExtraccionCirbe = ?");

        params.add(fecha1);
        paramsType.add(Hibernate.DATE);

        if (fecha2 != null) {
            hql.append(" and c2.fechaExtraccionCirbe    = ?");
            params.add(fecha2);
            paramsType.add(Hibernate.DATE);
        }
        if (fecha3 != null) {
            hql.append(" and c3.fechaExtraccionCirbe    = ?");
            params.add(fecha3);
            paramsType.add(Hibernate.DATE);
        }
        if (fecha2 == null) {
            hql.append(" where ");
        } else {
            hql.append(" and ");
        }
        hql.append(" c1.persona.id                  = ?");
        params.add(idPersona);
        paramsType.add(Hibernate.LONG);
        String hqlS = hql.toString();
        Query query = getSession().createQuery(hqlS);
        query.setParameters(params.toArray(), paramsType.toArray(new Type[0]));

        List<Object[]> list = query.list();
        List<DtoCirbe> rows = new ArrayList<DtoCirbe>();
        DtoCirbe row;
        for (Object[] object : list) {
            row = new DtoCirbe();
            row.setCodigoOperacion((DDCodigoOperacionCirbe) object[0]);
            row.setTipoGarantia((DDTipoGarantiaCirbe) object[1]);
            row.setTipoSituacion((DDTipoSituacionCirbe) object[2]);
            row.setTipoVencimiento((DDTipoVencimientoCirbe) object[3]);
            row.setDispuestoFecha1((Double) object[4]);
            row.setDisponibleFecha1((Double) object[5]);
            if (fecha2 != null) {
                row.setDispuestoFecha2((Double) object[6]);
                row.setDisponibleFecha2((Double) object[7]);
            }
            if (fecha3 != null) {
                row.setDispuestoFecha3((Double) object[8]);
                row.setDisponibleFecha3((Double) object[9]);
            }
            rows.add(row);
        }
        return rows;
    }

    /**
     * Devuelve la fecha próxima igual o anterior para la que hay registros de cirbe a la fecha que se pasa como parámetro.
     * @param d la fecha de referencia
     * @param idPersona el id de la persona
     * @return la fecha inmediata anterior para la que hay registros.
     */

    @SuppressWarnings("unchecked")
    public Date getFechaCirbeProximaAnterior(Long idPersona, Date d) {
        //fechaExtraccionCirbe
        StringBuffer hql = new StringBuffer();
        hql.append("Select c.fechaExtraccionCirbe from Cirbe c");
        hql.append(" where c.persona.id= ? and c.fechaExtraccionCirbe = ");
        hql.append("	(");
        hql.append(" 	 select max(c1.fechaExtraccionCirbe) from Cirbe c1 where ");
        hql.append("	 c1.fechaExtraccionCirbe <= ? and c1.persona.id = ?");
        hql.append("	)");

        List<Date> fechas = getHibernateTemplate().find(hql.toString(), new Object[] { idPersona, d, idPersona });
        if (fechas.size() > 0) {
            return fechas.get(0);
        }
        return null;
    }
}
