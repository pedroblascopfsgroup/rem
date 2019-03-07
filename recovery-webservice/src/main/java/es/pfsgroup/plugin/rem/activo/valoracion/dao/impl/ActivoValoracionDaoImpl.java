package es.pfsgroup.plugin.rem.activo.valoracion.dao.impl;

import java.math.BigDecimal;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.valoracion.dao.ActivoValoracionDao;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;

@Repository("ActivoValoracionDao")
public class ActivoValoracionDaoImpl extends AbstractEntityDao<ActivoValoraciones, Long> implements ActivoValoracionDao {


	@Override
	public Double getImporteValoracionVentaWebPorIdActivo(Long idActivo) {
		String sql = " SELECT  " + 
				"(CASE        " +  
				"      WHEN       " + 
				"         MAX(NVL(DESCUENTO_WEB,0)) = 0                         " + 
				"      THEN       " + 
				"         MAX(NVL(DESCUENTO_WEB,0))     " + 
				"      WHEN             " + 
				"        MAX(NVL(ACTOFR.ACT_OFR_IMPORTE,0)) >= MAX(DESCUENTO_WEB)             " + 
				"      THEN             " + 
				"        MAX(NVL(ACTOFR.ACT_OFR_IMPORTE,0))              " + 
				"      ELSE            " + 
				"          MAX(DESCUENTO_WEB)            " + 
				"  END) AS PRECIO_WEB       " + 
				"FROM   REM01.ACT_VAL_VALORACIONES ACTVAL          " + 
				"LEFT JOIN REM01.ACT_OFR ACTOFR  ON ACTOFR.ACT_ID = ACTVAL.ACT_ID            " + 
				"LEFT JOIN REM01.OFR_OFERTAS OFR ON OFR.OFR_ID = ACTOFR.OFR_ID  " + 
				"      AND OFR.DD_EOF_ID IN (SELECT EOF.DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '01')            " + 
				"      AND OFR.BORRADO = 0  " + 
				"JOIN (SELECT ACT_ID,       " + 
				"            (CASE      " + 
				"                WHEN      " + 
				"                    NVL(APROBADO_VENTA,0) = 0      " + 
				"                THEN       " + 
				"                    NVL(APROBADO_VENTA,0)      " + 
				"                ELSE      " + 
				"                    GREATEST(NVL(APROBADO_VENTA,0), NVL(PRECIO_MINIMO,0), NVL(DESCUENTO_APROBADO,0), NVL(DESCUENTO_PUBLICADO_WEB,0))      " + 
				"            END) AS DESCUENTO_WEB            " + 
				"          FROM (SELECT         "+idActivo+"        AS ACT_ID , " + 
				"                  (SELECT VAL_IMPORTE  " + 
				"                   FROM (SELECT  ACT_ID, VAL_IMPORTE, BORRADO AS VAL_BORRADO,      " + 
				"                        (CASE DD_TPC_ID WHEN  (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '02')  THEN DD_TPC_ID END) AS APROBADO_VENTA " + 
				"                        FROM REM01.ACT_VAL_VALORACIONES            " + 
				"                        WHERE VAL_FECHA_INICIO IS NOT NULL AND VAL_FECHA_INICIO <= TRUNC(SYSDATE)            " + 
				"                        AND (VAL_FECHA_FIN IS NULL OR VAL_FECHA_FIN >= TRUNC(SYSDATE)) " + 
				"                        AND DD_TPC_ID IN (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN ('02')))            " + 
				"                    WHERE ACT_ID =  "+idActivo+"  " + 
				"                    AND VAL_BORRADO = 0) AS APROBADO_VENTA ,       " + 
				"                  (SELECT VAL_IMPORTE  " + 
				"                  FROM (SELECT  ACT_ID, VAL_IMPORTE, BORRADO AS VAL_BORRADO,      " + 
				"                        (CASE DD_TPC_ID WHEN  (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '04')  THEN DD_TPC_ID END) AS PRECIO_MINIMO " + 
				"                        FROM REM01.ACT_VAL_VALORACIONES            " + 
				"                        WHERE VAL_FECHA_INICIO IS NOT NULL AND VAL_FECHA_INICIO <= TRUNC(SYSDATE)            " + 
				"                        AND (VAL_FECHA_FIN IS NULL OR VAL_FECHA_FIN >= TRUNC(SYSDATE)) " + 
				"                        AND DD_TPC_ID IN (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN ('04')))            " + 
				"                   WHERE ACT_ID =  "+idActivo+"   " + 
				"                   AND VAL_BORRADO = 0) AS PRECIO_MINIMO ,            " + 
				"                  (SELECT VAL_IMPORTE  " + 
				"                   FROM ( SELECT  ACT_ID, VAL_IMPORTE, BORRADO AS VAL_BORRADO,      " + 
				"                        (CASE DD_TPC_ID WHEN  (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '07')  THEN DD_TPC_ID END) AS DESCUENTO_APROBADO " + 
				"                        FROM REM01.ACT_VAL_VALORACIONES            " + 
				"                        WHERE VAL_FECHA_INICIO IS NOT NULL AND VAL_FECHA_INICIO <= TRUNC(SYSDATE)            " + 
				"                        AND (VAL_FECHA_FIN IS NULL OR VAL_FECHA_FIN >= TRUNC(SYSDATE)) " + 
				"                        AND DD_TPC_ID IN (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN ('07')))            " + 
				"                   WHERE ACT_ID =  "+idActivo+"   " + 
				"                   AND VAL_BORRADO = 0) AS DESCUENTO_APROBADO,            " + 
				"                (SELECT VAL_IMPORTE  " + 
				"                 FROM (SELECT  ACT_ID, VAL_IMPORTE, BORRADO AS VAL_BORRADO,      " + 
				"                      (CASE DD_TPC_ID WHEN  (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '13')  THEN DD_TPC_ID END) AS DESCUENTO_PUBLICADO_WEB " + 
				"                       FROM REM01.ACT_VAL_VALORACIONES            " + 
				"                       WHERE VAL_FECHA_INICIO IS NOT NULL AND VAL_FECHA_INICIO <= TRUNC(SYSDATE)            " + 
				"                       AND (VAL_FECHA_FIN IS NULL OR VAL_FECHA_FIN >= TRUNC(SYSDATE)) " + 
				"                       AND DD_TPC_ID IN (SELECT DD_TPC_ID FROM DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO IN ('13')))            " + 
				"                  WHERE ACT_ID =  "+idActivo+"   " + 
				"                  AND VAL_BORRADO = 0) AS DESCUENTO_PUBLICADO_WEB            " + 
				"                FROM DUAL)) CALCULO ON ACTVAL.ACT_ID = CALCULO.ACT_ID   " + 
				"WHERE ACTVAL.BORRADO = 0             " + 
				"AND ACTVAL.VAL_FECHA_INICIO IS NOT NULL AND ACTVAL.VAL_FECHA_INICIO <= TRUNC(SYSDATE)            " + 
				"AND (ACTVAL.VAL_FECHA_FIN IS NULL OR ACTVAL.VAL_FECHA_FIN >= TRUNC(SYSDATE))   " + 
				"AND ACTVAL.ACT_ID =   "+idActivo+"   " + 
				"GROUP BY ACTOFR.ACT_ID, DESCUENTO_WEB";
		
					
					Double resultadoPrecioWeb;
					if (Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
						 resultadoPrecioWeb = 0.0;
					} else { 
						 resultadoPrecioWeb = ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).doubleValue();
					} 
					return resultadoPrecioWeb;
					
	}

	@Override
	public Double getImporteValoracionRentaWebPorIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoValoraciones.class);
		criteria.setProjection(Projections.property("importe"));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("tipoPrecio").add(Restrictions.eq("codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));

		return HibernateUtils.castObject(Double.class, criteria.uniqueResult());
	}
}