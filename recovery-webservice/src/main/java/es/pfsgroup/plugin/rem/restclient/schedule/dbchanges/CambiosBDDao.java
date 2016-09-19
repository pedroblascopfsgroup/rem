package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;

@Repository
public class CambiosBDDao extends AbstractEntityDao<CambioBD, Long> {

	private static final String TABLA_ACTUAL = "REM01.REM_WEBCOM_STOCK_ACTUAL";
	private static final String TABLA_HISTORICO = "REM01.REM_WEBCOM_STOCK_HISTORICO";
	private static final String PRIMARY_KEY = "ID_ACTIVO_HAYA";
	
	private static final String[] CONFIG_CAMPOS_STOCK = new String[] { "idActivoHaya", "codTipoVia", "nombreCalle",
			"numeroCalle", "escalera", "planta", "puerta", "codMunicipio", "codPedania", "codProvincia", "codigoPostal",
			"actualImporte", "anteriorImporte", "desdeImporte", "hastaImporte", "codTipoInmueble", "codSubtipoInmueble",
			"fincaRegistral", "codMunicipioRegistro", "registro", "referenciaCatastral", "superficie",
			"superficieRegistral", "ascensor", "dormitorios", "banyos", "aseos", "garajes", "nuevo",
			"codEstadoComercial", "codTipoVenta", "lat", "lng", "codEstadoConstruccion", "terrazas",
			"codEstadoPublicacion", "publicadoDesde", "reformas", "codRegimenProteccion", "descripcion", "distribucion",
			"condicionesEspecificas", "codDetallePublicacion", "codigoAgrupacionObraNueva", "codigoCabeceraObraNueva",
			"idProveedorRemAnterior", "idProveedorRem", "nombreGestorComercial", "telefonoGestorComercial",
			"emailGestorComercial", "codCee", "antiguedad", "codCartera", "codRatio" };

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	public List<CambioBD> listCambios() {
		DbIdContextHolder.setDbId(1L);
		ArrayList<CambioBD> cambios = new ArrayList<CambioBD>();
		String queryString = "SELECT * FROM " + TABLA_ACTUAL + " MINUS SELECT * FROM " + TABLA_HISTORICO + "";
		Query query = createQuery(queryString);
		List<Object[]> resultado = query.list();

		if (resultado != null) {
			for (Object[] r : resultado) {
				CambioBD cambio = new CambioBD(CONFIG_CAMPOS_STOCK);
				cambio.setDatosActuales(r);
				Object[] historico = (Object[]) this.sesionFactoryFacade.getSession(this)
						.createSQLQuery("SELECT * FROM " + TABLA_HISTORICO + " WHERE " + PRIMARY_KEY + " = " + r[0])
						.uniqueResult();
				cambio.setDatosHistoricos(historico);
				cambios.add(cambio);

			}
		}
		
		createQuery("TRUNCATE TABLE " + TABLA_HISTORICO).executeUpdate();
		createQuery("INSERT INTO " + TABLA_HISTORICO + " SELECT * FROM " + TABLA_ACTUAL).executeUpdate();
		
		return cambios;

	}

	private SQLQuery createQuery(String queryString) {
		return this.sesionFactoryFacade.getSession(this).createSQLQuery(queryString);
	}

	/**
	 * @param entitySessionFactory
	 *            SessionFactory
	 */
	@Resource
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

}
