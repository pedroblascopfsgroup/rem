package es.pfsgroup.plugin.rem.activo.valoracion.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.valoracion.dao.ActivoValoracionDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

@Repository("ActivoValoracionDao")
public class ActivoValoracionDaoImpl extends AbstractEntityDao<ActivoValoraciones, Long> implements ActivoValoracionDao {


	@Override
	public Double getImporteValoracionVentaWebPorIdActivo(Long idActivo) {
		String sql = "WITH APROBADO_VENTA AS          " +   
				"				 				     (         " + 
				"				 				         SELECT ACT_ID, VAL_IMPORTE         " + 
				"				 				         FROM         " + 
				"				 				         (         " + 
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " + 
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " + 
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " + 
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '02' /*APROBADO_VENTA*/         " + 
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " + 
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " + 
				"				 				                 AND VAL.BORRADO = 0         " + 
				"				 				         )         " + 
				"				 				         WHERE RN = 1         " + 
				"				 				     )         " + 
				"				 				 , PRECIO_MINIMO AS         " + 
				"				 				         (         " + 
				"				 				         SELECT ACT_ID, VAL_IMPORTE         " + 
				"				 				         FROM         " + 
				"				 				         (         " + 
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " + 
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " + 
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " + 
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '04' /*PRECIO_MINIMO*/         " + 
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " + 
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(TO_DATE('31/12/2099', 'DD/MM/YYYY'), 'DD/MM/YYYY')) >= SYSDATE         " + 
				"				 				                 AND VAL.BORRADO = 0         " + 
				"				 				         )         " + 
				"				 				         WHERE RN = 1         " + 
				"				 				     )         " + 
				"				 				 , DESCUENTO_APROBADO AS         " + 
				"				 				     (         " + 
				"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " + 
				"				 				         FROM         " + 
				"				 				         (         " + 
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " + 
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " + 
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " + 
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '07' /*DESCUENTO_APROBADO*/         " + 
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE(TO_DATE('01/01/1980', 'DD/MM/YYYY'), 'DD/MM/YYYY')) <= SYSDATE         " + 
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " + 
				"				 				                 AND VAL.BORRADO = 0         " + 
				"				 				         )         " + 
				"				 				         WHERE RN = 1         " + 
				"				 				     )         " + 
				"				 				 , DESCUENTO_PUBLICADO_WEB AS         " + 
				"				 				     (         " + 
				"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " + 
				"				 				         FROM         " + 
				"				 				         (         " + 
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " + 
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " + 
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " + 
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '13' /*DESCUENTO_PUBLICADO_WEB*/         " + 
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " + 
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " + 
				"				 				                 AND VAL.BORRADO = 0         " + 
				"				 				         )         " + 
				"				 				         WHERE RN = 1         " + 
				"				 				     )         " + 
				"				 				 , OFERTA_TRAMITADA AS          " + 
				"				 				     (         " + 
				"				 				         SELECT AOF.ACT_ID, AOF.ACT_OFR_IMPORTE, ECO.ECO_FECHA_SANCION         " + 
				"				 				         FROM REM01.OFR_OFERTAS OFR         " + 
				"				 				         JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = '01'         " + 
				"				 				         JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0         " + 
				"				 				         JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = '11'         " + 
				"				 				         JOIN REM01.ACT_OFR AOF ON AOF.OFR_ID = OFR.OFR_ID         " + 
				"				 				         WHERE OFR.BORRADO = 0         " + 
				"				 				     )         " + 
				"				 				 SELECT         " + 
				"				 				     CASE   " + 
				"                                         WHEN " + 
				"                                            DESCUENTO_WEB = 0  " + 
				"                                         THEN " + 
				"                                            DESCUENTO_WEB " + 
				"				 				         WHEN          " + 
				"				 				             NVL(OFR.ACT_OFR_IMPORTE, 0) >= ACT.DESCUENTO_WEB AND OFR.ECO_FECHA_SANCION < NVL(ACT.DESCUENTO_WEB_FECHA_INICIO, TO_DATE('01/01/1980', 'DD/MM/YYYY'))         " + 
				"				 				         THEN 0         " + 
				"				 				         ELSE ACT.DESCUENTO_WEB         " + 
				"				 				     END PRECIO_WEB         " + 
				"				 				 FROM         " + 
				"				 				     (         " + 
				"				 				     SELECT         " + 
				"				 				         ACT.ACT_ID         " + 
				"				 				         , CASE " + 
				"                                             WHEN  " + 
				"                                                NVL(APV.VAL_IMPORTE,0) = 0 " + 
				"                                            THEN  " + 
				"                                                0 " + 
				"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " + 
				"				 				                 THEN GREATEST(NVL(DSA.VAL_IMPORTE,0), NVL(DPW.VAL_IMPORTE,0))         " + 
				"				 				                 ELSE GREATEST(NVL(APV.VAL_IMPORTE,0), NVL(PCM.VAL_IMPORTE,0))         " + 
				"				 				             END DESCUENTO_WEB         " + 
				"				 				         , CASE          " + 
				"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " + 
				"				 				                 THEN         " + 
				"				 				                     CASE         " + 
				"				 				                         WHEN DSA.VAL_IMPORTE > DPW.VAL_IMPORTE          " + 
				"				 				                             THEN DSA.VAL_FECHA_INICIO         " + 
				"				 				                         WHEN DPW.VAL_IMPORTE > DSA.VAL_IMPORTE          " + 
				"				 				                             THEN DPW.VAL_FECHA_INICIO         " + 
				"				 				                         ELSE         " + 
				"				 				                             CASE         " + 
				"				 				                                 WHEN DSA.VAL_FECHA_INICIO < DPW.VAL_FECHA_INICIO THEN DSA.VAL_FECHA_INICIO         " + 
				"				 				                                 WHEN DPW.VAL_FECHA_INICIO < DSA.VAL_FECHA_INICIO THEN DPW.VAL_FECHA_INICIO         " + 
				"				 				                                 ELSE COALESCE(DSA.VAL_FECHA_INICIO, DPW.VAL_FECHA_INICIO)        " + 
				"				 				                             END         " + 
				"				 				                         END         " + 
				"				 				                 ELSE NULL         " + 
				"				 				             END DESCUENTO_WEB_FECHA_INICIO         " + 
				"				 				     FROM REM01.ACT_ACTIVO ACT         " + 
				"				 				     LEFT JOIN APROBADO_VENTA APV ON APV.ACT_ID = ACT.ACT_ID         " + 
				"				 				     LEFT JOIN PRECIO_MINIMO PCM ON PCM.ACT_ID = ACT.ACT_ID         " + 
				"				 				     LEFT JOIN DESCUENTO_APROBADO DSA ON DSA.ACT_ID = ACT.ACT_ID         " + 
				"				 				     LEFT JOIN DESCUENTO_PUBLICADO_WEB DPW ON DPW.ACT_ID = ACT.ACT_ID         " + 
				"				 				     LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " + 
				"				 				     WHERE ACT.BORRADO = 0) ACT         " + 
				"				 				 LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " + 
				"				 				 WHERE ACT.ACT_ID = :idActivo";
		
					
					
					Query q = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
					q.setParameter("idActivo", idActivo);
					Double resultadoPrecioWeb;
					if (Checks.esNulo(q.uniqueResult())) {
						 resultadoPrecioWeb = 0.0;
					} else { 
						 resultadoPrecioWeb = ((BigDecimal) q.uniqueResult()).doubleValue();
					} 
					return resultadoPrecioWeb;
					
	}

	@Override
	public Double getImporteValoracionRentaWebPorIdActivo(Long idActivo) {
		Double resultadoPrecioWeb = null; 
		
		HQLBuilder hql = new HQLBuilder("from ActivoValoraciones");
		HQLBuilder.addFiltroIgualQue(hql, "activo.id", idActivo);
		hql.appendWhere("auditoria.borrado = 0");
		hql.appendWhere("fechaFin is null or fechaFin >= sysdate");
		hql.appendWhere("tipoPrecio.codigo = " + DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA);
		ActivoValoraciones query = HibernateQueryUtils.uniqueResult(this, hql);
		
		if (query != null) {
			resultadoPrecioWeb = query.getImporte();
		} else {
			resultadoPrecioWeb = 0.0;
		}
		return resultadoPrecioWeb;
	}

	@Override
	public Double getImporteValoracionVentaWebPorIdAgrupacion(Long idAgrupacion) {

		Double resultadoPrecioWeb = null;
		String sql = "SELECT COUNT(1) FROM (WITH APROBADO_VENTA AS          " +
				"				 				     (         " +
				"				 				         SELECT ACT_ID, VAL_IMPORTE         " +
				"				 				         FROM         " +
				"				 				         (         " +
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " +
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '02' /*APROBADO_VENTA*/         " +
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
				"				 				                 AND VAL.BORRADO = 0         " +
				"				 				         )         " +
				"				 				         WHERE RN = 1         " +
				"				 				     )         " +
				"				 				 , PRECIO_MINIMO AS         " +
				"				 				         (         " +
				"				 				         SELECT ACT_ID, VAL_IMPORTE         " +
				"				 				         FROM         " +
				"				 				         (         " +
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " +
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '04' /*PRECIO_MINIMO*/         " +
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(TO_DATE('31/12/2099', 'DD/MM/YYYY'), 'DD/MM/YYYY')) >= SYSDATE         " +
				"				 				                 AND VAL.BORRADO = 0         " +
				"				 				         )         " +
				"				 				         WHERE RN = 1         " +
				"				 				     )         " +
				"				 				 , DESCUENTO_APROBADO AS         " +
				"				 				     (         " +
				"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " +
				"				 				         FROM         " +
				"				 				         (         " +
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " +
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '07' /*DESCUENTO_APROBADO*/         " +
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE(TO_DATE('01/01/1980', 'DD/MM/YYYY'), 'DD/MM/YYYY')) <= SYSDATE         " +
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
				"				 				                 AND VAL.BORRADO = 0         " +
				"				 				         )         " +
				"				 				         WHERE RN = 1         " +
				"				 				     )         " +
				"				 				 , DESCUENTO_PUBLICADO_WEB AS         " +
				"				 				     (         " +
				"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " +
				"				 				         FROM         " +
				"				 				         (         " +
				"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " +
				"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
				"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
				"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '13' /*DESCUENTO_PUBLICADO_WEB*/         " +
				"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
				"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
				"				 				                 AND VAL.BORRADO = 0         " +
				"				 				         )         " +
				"				 				         WHERE RN = 1         " +
				"				 				     )         " +
				"				 				 , OFERTA_TRAMITADA AS          " +
				"				 				     (         " +
				"				 				         SELECT AOF.ACT_ID, AOF.ACT_OFR_IMPORTE, ECO.ECO_FECHA_SANCION         " +
				"				 				         FROM REM01.OFR_OFERTAS OFR         " +
				"				 				         JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = '01'         " +
				"				 				         JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0         " +
				"				 				         JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = '11'         " +
				"				 				         JOIN REM01.ACT_OFR AOF ON AOF.OFR_ID = OFR.OFR_ID         " +
				"				 				         WHERE OFR.BORRADO = 0         " +
				"				 				     )         " +
				"				 				 SELECT         " +
				"				 				     CASE   " +
				"                                         WHEN " +
				"                                            DESCUENTO_WEB = 0  " +
				"                                         THEN " +
				"                                            DESCUENTO_WEB " +
				"				 				         WHEN          " +
				"				 				             NVL(OFR.ACT_OFR_IMPORTE, 0) >= ACT.DESCUENTO_WEB AND OFR.ECO_FECHA_SANCION < NVL(ACT.DESCUENTO_WEB_FECHA_INICIO, TO_DATE('01/01/1980', 'DD/MM/YYYY'))         " +
				"				 				         THEN 0         " +
				"				 				         ELSE ACT.DESCUENTO_WEB         " +
				"				 				     END PRECIO_WEB         " +
				"				 				 FROM         " +
				"				 				     (         " +
				"				 				     SELECT         " +
				"				 				         ACT.ACT_ID         " +
				"				 				         , CASE " +
				"                                             WHEN  " +
				"                                                NVL(APV.VAL_IMPORTE,0) = 0 " +
				"                                            THEN  " +
				"                                                0 " +
				"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " +
				"				 				                 THEN GREATEST(NVL(DSA.VAL_IMPORTE,0), NVL(DPW.VAL_IMPORTE,0))         " +
				"				 				                 ELSE GREATEST(NVL(APV.VAL_IMPORTE,0), NVL(PCM.VAL_IMPORTE,0))         " +
				"				 				             END DESCUENTO_WEB         " +
				"				 				         , CASE          " +
				"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " +
				"				 				                 THEN         " +
				"				 				                     CASE         " +
				"				 				                         WHEN DSA.VAL_IMPORTE > DPW.VAL_IMPORTE          " +
				"				 				                             THEN DSA.VAL_FECHA_INICIO         " +
				"				 				                         WHEN DPW.VAL_IMPORTE > DSA.VAL_IMPORTE          " +
				"				 				                             THEN DPW.VAL_FECHA_INICIO         " +
				"				 				                         ELSE         " +
				"				 				                             CASE         " +
				"				 				                                 WHEN DSA.VAL_FECHA_INICIO < DPW.VAL_FECHA_INICIO THEN DSA.VAL_FECHA_INICIO         " +
				"				 				                                 WHEN DPW.VAL_FECHA_INICIO < DSA.VAL_FECHA_INICIO THEN DPW.VAL_FECHA_INICIO         " +
				"				 				                                 ELSE COALESCE(DSA.VAL_FECHA_INICIO, DPW.VAL_FECHA_INICIO)        " +
				"				 				                             END         " +
				"				 				                         END         " +
				"				 				                 ELSE NULL         " +
				"				 				             END DESCUENTO_WEB_FECHA_INICIO         " +
				"				 				     FROM REM01.ACT_ACTIVO ACT         " +
				"				 				     LEFT JOIN APROBADO_VENTA APV ON APV.ACT_ID = ACT.ACT_ID         " +
				"				 				     LEFT JOIN PRECIO_MINIMO PCM ON PCM.ACT_ID = ACT.ACT_ID         " +
				"				 				     LEFT JOIN DESCUENTO_APROBADO DSA ON DSA.ACT_ID = ACT.ACT_ID         " +
				"				 				     LEFT JOIN DESCUENTO_PUBLICADO_WEB DPW ON DPW.ACT_ID = ACT.ACT_ID         " +
				"				 				     LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " +
				"				 				     WHERE ACT.BORRADO = 0) ACT         " +
				"				 				 LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " +
				"				 				 WHERE ACT.ACT_ID in (SELECT ACT_ID FROM REM01.ACT_AGA_AGRUPACION_ACTIVO WHERE AGR_ID = :idAgrupacion))" +
				"				 				 GROUP BY PRECIO_WEB" +
				"								 HAVING (PRECIO_WEB = 0 OR PRECIO_WEB IS NULL)";


		Query q = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
		q.setParameter("idAgrupacion", idAgrupacion);
		
		if (Checks.esNulo(q.uniqueResult())
				|| (!Checks.esNulo(q.uniqueResult())
					&& ((BigDecimal) q.uniqueResult()).doubleValue() == 0.0)) {
			sql = "SELECT SUM(PRECIO_WEB) FROM (WITH APROBADO_VENTA AS          " +
					"				 				     (         " +
					"				 				         SELECT ACT_ID, VAL_IMPORTE         " +
					"				 				         FROM         " +
					"				 				         (         " +
					"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " +
					"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
					"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
					"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '02' /*APROBADO_VENTA*/         " +
					"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
					"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
					"				 				                 AND VAL.BORRADO = 0         " +
					"				 				         )         " +
					"				 				         WHERE RN = 1         " +
					"				 				     )         " +
					"				 				 , PRECIO_MINIMO AS         " +
					"				 				         (         " +
					"				 				         SELECT ACT_ID, VAL_IMPORTE         " +
					"				 				         FROM         " +
					"				 				         (         " +
					"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE         " +
					"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
					"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
					"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '04' /*PRECIO_MINIMO*/         " +
					"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
					"				 				                 AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(TO_DATE('31/12/2099', 'DD/MM/YYYY'), 'DD/MM/YYYY')) >= SYSDATE         " +
					"				 				                 AND VAL.BORRADO = 0         " +
					"				 				         )         " +
					"				 				         WHERE RN = 1         " +
					"				 				     )         " +
					"				 				 , DESCUENTO_APROBADO AS         " +
					"				 				     (         " +
					"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " +
					"				 				         FROM         " +
					"				 				         (         " +
					"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " +
					"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
					"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
					"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '07' /*DESCUENTO_APROBADO*/         " +
					"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE(TO_DATE('01/01/1980', 'DD/MM/YYYY'), 'DD/MM/YYYY')) <= SYSDATE         " +
					"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
					"				 				                 AND VAL.BORRADO = 0         " +
					"				 				         )         " +
					"				 				         WHERE RN = 1         " +
					"				 				     )         " +
					"				 				 , DESCUENTO_PUBLICADO_WEB AS         " +
					"				 				     (         " +
					"				 				         SELECT ACT_ID, VAL_IMPORTE, VAL_FECHA_INICIO         " +
					"				 				         FROM         " +
					"				 				         (         " +
					"				 				             SELECT VAL.ACT_ID, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO         " +
					"				 				                 , ROW_NUMBER() OVER(PARTITION BY VAL.ACT_ID ORDER BY VAL.VAL_FECHA_INICIO DESC NULLS LAST) RN         " +
					"				 				             FROM REM01.ACT_VAL_VALORACIONES VAL         " +
					"				 				             JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = '13' /*DESCUENTO_PUBLICADO_WEB*/         " +
					"				 				             WHERE NVL(VAL.VAL_FECHA_INICIO,TO_DATE('01/01/1980', 'DD/MM/YYYY')) <= SYSDATE         " +
					"				 				                 AND NVL(VAL.VAL_FECHA_FIN,TO_DATE('31/12/2099', 'DD/MM/YYYY')) >= SYSDATE         " +
					"				 				                 AND VAL.BORRADO = 0         " +
					"				 				         )         " +
					"				 				         WHERE RN = 1         " +
					"				 				     )         " +
					"				 				 , OFERTA_TRAMITADA AS          " +
					"				 				     (         " +
					"				 				         SELECT AOF.ACT_ID, AOF.ACT_OFR_IMPORTE, ECO.ECO_FECHA_SANCION         " +
					"				 				         FROM REM01.OFR_OFERTAS OFR         " +
					"				 				         JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = '01'         " +
					"				 				         JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0         " +
					"				 				         JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = '11'         " +
					"				 				         JOIN REM01.ACT_OFR AOF ON AOF.OFR_ID = OFR.OFR_ID         " +
					"				 				         WHERE OFR.BORRADO = 0         " +
					"				 				     )         " +
					"				 				 SELECT         " +
					"				 				     CASE   " +
					"                                         WHEN " +
					"                                            DESCUENTO_WEB = 0  " +
					"                                         THEN " +
					"                                            DESCUENTO_WEB " +
					"				 				         WHEN          " +
					"				 				             NVL(OFR.ACT_OFR_IMPORTE, 0) >= ACT.DESCUENTO_WEB AND OFR.ECO_FECHA_SANCION < NVL(ACT.DESCUENTO_WEB_FECHA_INICIO, TO_DATE('01/01/1980', 'DD/MM/YYYY'))         " +
					"				 				         THEN 0         " +
					"				 				         ELSE ACT.DESCUENTO_WEB         " +
					"				 				     END PRECIO_WEB         " +
					"				 				 FROM         " +
					"				 				     (         " +
					"				 				     SELECT         " +
					"				 				         ACT.ACT_ID         " +
					"				 				         , CASE " +
					"                                             WHEN  " +
					"                                                NVL(APV.VAL_IMPORTE,0) = 0 " +
					"                                            THEN  " +
					"                                                0 " +
					"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " +
					"				 				                 THEN GREATEST(NVL(DSA.VAL_IMPORTE,0), NVL(DPW.VAL_IMPORTE,0))         " +
					"				 				                 ELSE GREATEST(NVL(APV.VAL_IMPORTE,0), NVL(PCM.VAL_IMPORTE,0))         " +
					"				 				             END DESCUENTO_WEB         " +
					"				 				         , CASE          " +
					"				 				             WHEN DSA.VAL_IMPORTE IS NOT NULL OR DPW.VAL_IMPORTE IS NOT NULL         " +
					"				 				                 THEN         " +
					"				 				                     CASE         " +
					"				 				                         WHEN DSA.VAL_IMPORTE > DPW.VAL_IMPORTE          " +
					"				 				                             THEN DSA.VAL_FECHA_INICIO         " +
					"				 				                         WHEN DPW.VAL_IMPORTE > DSA.VAL_IMPORTE          " +
					"				 				                             THEN DPW.VAL_FECHA_INICIO         " +
					"				 				                         ELSE         " +
					"				 				                             CASE         " +
					"				 				                                 WHEN DSA.VAL_FECHA_INICIO < DPW.VAL_FECHA_INICIO THEN DSA.VAL_FECHA_INICIO         " +
					"				 				                                 WHEN DPW.VAL_FECHA_INICIO < DSA.VAL_FECHA_INICIO THEN DPW.VAL_FECHA_INICIO         " +
					"				 				                                 ELSE COALESCE(DSA.VAL_FECHA_INICIO, DPW.VAL_FECHA_INICIO)        " +
					"				 				                             END         " +
					"				 				                         END         " +
					"				 				                 ELSE NULL         " +
					"				 				             END DESCUENTO_WEB_FECHA_INICIO         " +
					"				 				     FROM REM01.ACT_ACTIVO ACT         " +
					"				 				     LEFT JOIN APROBADO_VENTA APV ON APV.ACT_ID = ACT.ACT_ID         " +
					"				 				     LEFT JOIN PRECIO_MINIMO PCM ON PCM.ACT_ID = ACT.ACT_ID         " +
					"				 				     LEFT JOIN DESCUENTO_APROBADO DSA ON DSA.ACT_ID = ACT.ACT_ID         " +
					"				 				     LEFT JOIN DESCUENTO_PUBLICADO_WEB DPW ON DPW.ACT_ID = ACT.ACT_ID         " +
					"				 				     LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " +
					"				 				     WHERE ACT.BORRADO = 0) ACT         " +
					"				 				 LEFT JOIN OFERTA_TRAMITADA OFR ON OFR.ACT_ID = ACT.ACT_ID         " +
					"				 				 WHERE ACT.ACT_ID in (SELECT ACT_ID FROM REM01.ACT_AGA_AGRUPACION_ACTIVO WHERE AGR_ID = :idAgrupacion ))";

			 q = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
			 q.setParameter("idAgrupacion", idAgrupacion);
			
			if (Checks.esNulo(q.uniqueResult())) {
				resultadoPrecioWeb = 0.0;
			} else {
				resultadoPrecioWeb = ((BigDecimal) q.uniqueResult()).doubleValue();
			}
		} else{
			resultadoPrecioWeb = 0.0;
		}

		return resultadoPrecioWeb;
	}

	@Override
	public Double getImporteValoracionRentaWebPorIdAgrupacion(Long idAgrupacion) {
		Double resultadoPrecioWeb = null;

		String sql = " SELECT COUNT(1) FROM (SELECT VAL_IMPORTE FROM REM01.ACT_VAL_VALORACIONES           " +
				" WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = "+DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA+" AND BORRADO = 0) " +
				" AND ACT_ID IN (SELECT ACT_ID FROM REM01.ACT_AGA_AGRUPACION_ACTIVO WHERE AGR_ID = :idAgrupacion) AND BORRADO = 0) " +
				" GROUP BY VAL_IMPORTE " +
				" HAVING (VAL_IMPORTE = 0 OR VAL_IMPORTE IS NULL) ";

		 Query q = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
		 q.setParameter("idAgrupacion", idAgrupacion);
		
		if (Checks.esNulo(q.uniqueResult())
			|| (!Checks.esNulo(q.uniqueResult())
				&& ((BigDecimal) q.uniqueResult()).doubleValue() == 0.0)) {
			sql = " SELECT SUM(VAL_IMPORTE) FROM (SELECT VAL_IMPORTE FROM REM01.ACT_VAL_VALORACIONES           " +
					" WHERE DD_TPC_ID = (SELECT DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = "+DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA+") " +
					" AND ACT_ID IN (SELECT ACT_ID FROM REM01.ACT_AGA_AGRUPACION_ACTIVO WHERE AGR_ID = :idAgrupacion) AND BORRADO = 0) ";

			q = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);
			 q.setParameter("idAgrupacion", idAgrupacion);
			
			if (Checks.esNulo(q.uniqueResult())) {
				resultadoPrecioWeb = 0.0;
			} else {
				resultadoPrecioWeb = ((BigDecimal) q.uniqueResult()).doubleValue();
			}
		}else{
			resultadoPrecioWeb = 0.0;
		}

		return resultadoPrecioWeb;
	}
	
	@Override
	public List<ActivoValoraciones> getListActivoValoracionesByIdActivo(Long idActivo) {
		
		HQLBuilder hql = new HQLBuilder("from ActivoValoraciones ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "activo.id", idActivo);
		hql.orderBy("fechaInicio", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.list(this, hql);
	}
	
}