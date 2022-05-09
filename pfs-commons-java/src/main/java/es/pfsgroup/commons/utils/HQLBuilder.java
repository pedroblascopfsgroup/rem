package es.pfsgroup.commons.utils;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import org.hibernate.Query;

import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;

/**
 * Constructor de sentencias HQL. Esta clase sirve de ayuda para generar una
 * consulta HQL
 * 
 * @author bruno
 * 
 */
public class HQLBuilder {

	public static final String ORDER_ASC = "asc";
	public static final String ORDER_DESC = "desc";
	public static final boolean QUIERE_OR_TRUE = true;

	public static class Parametros {
		@SuppressWarnings("unchecked")
		private final HashMap<String, Collection> collectionMap = new HashMap<String, Collection>();

		private final HashMap<String, Object> objectMap = new HashMap<String, Object>();

		/**
		 * Añade un parámetro de tipo colección a la consulta
		 * 
		 * @param key
		 * @param value
		 */
		@SuppressWarnings("unchecked")
		void putCollection(final String key, final Collection value) {
			collectionMap.put(key, value);

		}

		@SuppressWarnings("unchecked")
		HashMap<String, Collection> getCollectionMap() {
			return this.collectionMap;
		}

		HashMap<String, Object> getObjectMap() {
			return this.objectMap;
		}

		void putObject(String key, Object value) {
			this.objectMap.put(key, value);

		}

	}

	/**
	 * Este contador lo usamos para la generación automática de nobre de
	 * parámetros. Cuando generamos sentencias HQL se usan parámetros por
	 * nombre. Para evitar tener que introducir el nombre de parámetro como
	 * argumento lo generamos automáticamente, y para evitar que se dupliquen
	 * los nombres de parámetro se le añade al nombre como sufijo el contador.
	 */
	private static Long contador = 0L;

	private final Parametros parametros;

	/**
	 * añade los parámetros de una consulta HQL a un objeto Query de Hibernate
	 * 
	 * @param query
	 * @param hql
	 */
	public static void parametrizaQuery(final Query query, final HQLBuilder hql) {
		for (Entry<String, Object> e : hql.getParameters().entrySet()) {
			query.setParameter(e.getKey(), e.getValue());
		}
	}

	/**
	 * Ayuda a crear una cláusula WHERE campo = valor en dónde valor se
	 * referencia a través de un parámetro con nombre. <strong>sólo en el caso
	 * que el valor no sea null</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 */
	public static void addFiltroIgualQueSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			hqlBuilder.appendWhere(nombreCampo.concat(" = :").concat(nombreParametro));
			hqlBuilder.getParametros().putObject(nombreParametro, valor);
		}
	}
	
	/**
	 * Ayuda a crear una cláusula WHERE campo >= valor en dónde valor se
	 * referencia a través de un parámetro con nombre. <strong>sólo en el caso
	 * que el valor no sea null</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 */
	public static void addFiltroIgualOMayorQueSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			hqlBuilder.appendWhere(nombreCampo.concat(" >= :").concat(nombreParametro));
			hqlBuilder.getParametros().putObject(nombreParametro, valor);
		}
	}
	
	/**
	 * Ayuda a crear una cláusula WHERE campo <= valor en dónde valor se
	 * referencia a través de un parámetro con nombre. <strong>sólo en el caso
	 * que el valor no sea null</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 */
	public static void addFiltroIgualOMenorQueSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			hqlBuilder.appendWhere(nombreCampo.concat(" <= :").concat(nombreParametro));
			hqlBuilder.getParametros().putObject(nombreParametro, valor);
		}
	}
	
	
	

	/**
	 * Ayuda a crear una cláusula WHERE campo = valor en dónde valor se
	 * referencia a través de un parámetro con nombre. <strong>Si 'valor' es
	 * NULL va a lanzar una excepción.</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 * @throws IllegalArgumentException
	 *             En el caso que 'valor' sea NULL
	 */
	public static void addFiltroIgualQue(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor) {

		if (valor == null) {
			throw new IllegalArgumentException(nombreCampo.concat(": no puede ser NULL"));
		}
		final String nombreParametro = nombraParametro(nombreCampo);

		hqlBuilder.appendWhere(nombreCampo.concat(" = :").concat(nombreParametro));
		hqlBuilder.getParametros().putObject(nombreParametro, valor);

	}
	
	

	/**
	 * Ayuda a crear una cláusula WHERE campo between valormin and valormax. Hay
	 * que tener en cuenta lo siguiente.
	 * 
	 * <ul>
	 * <li><strong>Si ambos valores son null no se va a añadir la
	 * cláusula</strong></li>
	 * <li><strong>Si valorMax es null la clausula será para valor &gt;=
	 * valorMin</strong></li>
	 * <li><strong>Si valorMin es null ca clausula será para valor &lt;=
	 * valorMax</strong></li>
	 * </ul>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valorMin
	 *            valor mínimo del parámetro
	 * 
	 * @param valorMin
	 *            valor máximo del parámetro
	 */
	public static void addFiltroBetweenSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo,
			final Object valorMin, final Object valorMax) {
		final String nombreParametroMin = nombraParametro(nombreCampo);
		final String nombreParametroMax = nombraParametro(nombreCampo);

		if (!Checks.esNulo(valorMin) && !Checks.esNulo(valorMax)) {
			hqlBuilder.appendWhere(nombreCampo.concat(" between :").concat(nombreParametroMin).concat(" and :")
					.concat(nombreParametroMax));
			hqlBuilder.getParametros().putObject(nombreParametroMin, valorMin);
			hqlBuilder.getParametros().putObject(nombreParametroMax, valorMax);
		} else if (!Checks.esNulo(valorMin) && Checks.esNulo(valorMax)) {
			hqlBuilder.appendWhere(nombreCampo.concat(" >= :").concat(nombreParametroMin));
			hqlBuilder.getParametros().putObject(nombreParametroMin, valorMin);
		} else if (Checks.esNulo(valorMin) && !Checks.esNulo(valorMax)) {
			hqlBuilder.appendWhere(nombreCampo.concat(" <= :").concat(nombreParametroMax));
			hqlBuilder.getParametros().putObject(nombreParametroMax, valorMax);
		}
	}

	/**
	 * Ayuda a crear una cláusula WHERE campo IN (valor1, valor2 ...) en dónde
	 * el conjunto se referencia a través de un parámetro con nombre.
	 * <strong>sólo en el caso que el conjunto de valores no está vacío</strong>
	 * 
	 * <strong>El conjunto de valores tiene que ser una colección,</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo para la cláusula WHERE IN
	 * 
	 * @param valores
	 *            Conjunto de valores entre los que se debe encontrar el valor
	 *            del campo
	 */
	@SuppressWarnings("unchecked")
	public static void addFiltroWhereInSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo,
			final Collection valores) {
		if (!Checks.estaVacio(valores)) {
			final StringBuilder b = new StringBuilder();
			boolean first = true;
			for (Object o : valores) {
				if(o !=null) {
					if (!first) {
						b.append(", ");
					} else {
						first = false;
					}
					b.append(o.toString());
				}
			}
			hqlBuilder.appendWhere(nombreCampo.concat(" in (").concat(b.toString()).concat(")"));
		}
	}

	
	/**
	 * Ayuda a crear una cláusula WHERE campo IN (valor1, valor2 ...) en dónde
	 * el conjunto se referencia a través de un parámetro con nombre.
	 * <strong>sólo en el caso que el conjunto de valores no está vacío</strong>
	 * 
	 * <strong>El conjunto de valores tiene que ser una colección,</strong>
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo para la cláusula WHERE IN
	 * 
	 * @param valores
	 *            Conjunto de valores entre los que se debe encontrar el valor
	 *            del campo
	 */

	@SuppressWarnings("unchecked")
	public static void addFiltroWhereInStringSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo,
			final Collection valores) {
		if (!Checks.estaVacio(valores)) {
			final StringBuilder b = new StringBuilder();
			boolean first = true;
			for (Object o : valores) {
				if(o !=null) {
					if (!first) {
						b.append(", ");

					} else {
						first = false;
					}
					b.append(o.toString());
				}
			}
			hqlBuilder.appendWhere(nombreCampo.concat(" in ('").concat(b.toString()).concat("')"));
		}
	}
	
	@SuppressWarnings("unchecked")
	public static void addFiltroWhereInSiNotNullForceString(final HQLBuilder hqlBuilder, final String nombreCampo,
			final Collection valores) {
		if (!Checks.estaVacio(valores)) {
			final StringBuilder b = new StringBuilder();
			boolean first = true;
			for (Object o : valores) {
				if(o !=null) {
					if (!first) {
						b.append(", '");
					} else {
						first = false;
					}
					b.append(o.toString());
				}
			}
			hqlBuilder.appendWhere(nombreCampo.concat(" in ('").concat(b.toString()).concat("')"));
		}
	}

	/**
	 * Ayuda a crear una cláusula WHERE campo like %valor% en dónde valor se
	 * referencia a través de un parámetro con nombre <strong>sólo en el caso
	 * que el valor no sea null</strong>
	 * 
	 * <strong>Este método sólo se puede aplicar a valores de tipo
	 * String</strong>
	 * 
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 */
	public static void addFiltroLikeSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo,
			final Object valor) {
		addFiltroLikeSiNotNull(hqlBuilder, nombreCampo, valor, false);
	}

	/**
	 * Ayuda a crear una cláusula WHERE campo is null
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 */
	public static void addFiltroIsNull(final HQLBuilder hqlBuilder, final String nombreCampo) {

		hqlBuilder.appendWhere(nombreCampo.concat(" is null"));
	}

	/**
	 * Ayuda a crear una cláusula WHERE not campo is null
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 */
	public static void addFiltroNotIsNull(final HQLBuilder hqlBuilder, final String nombreCampo) {

		hqlBuilder.appendWhere("not ".concat(nombreCampo.concat(" is null")));
	}

	/**
	 * Ayuda a crear una cláusula WHERE campo like %valor% en dónde valor se
	 * referencia a través de un parámetro con nombre <strong>sólo en el caso
	 * que el valor no sea null</strong>
	 * 
	 * <strong>Este método sólo se puede aplicar a valores de tipo
	 * String</strong>
	 * 
	 * 
	 * @param hqlBuilder
	 *            Constructor de la sentencia
	 * @param nombreCampo
	 *            Nombre del campo
	 * @param valor
	 *            valor del parámetro
	 * @param ignoreCase
	 *            Transforma los datos a mayúsculas para comparar. Modifica la
	 *            sentencia HQL procesando con una función upper() el
	 *            nombreCampo
	 */
	public static void addFiltroLikeSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor, final boolean ignoreCase) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			final String field = ignoreCase ? "upper(".concat(nombreCampo).concat(")") : nombreCampo;
			hqlBuilder.appendWhere(field.concat(" like '%'|| :").concat(nombreParametro).concat(" ||'%'"));
			hqlBuilder.getParametros().putObject(nombreParametro, ignoreCase ? valor.toString().toUpperCase() : valor.toString());
		}
	}

	public static void addFiltroLikeSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor, final boolean ignoreCase, final boolean quiereOr) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			final String field = nombreCampo;
			hqlBuilder.appendWhere(field.concat(" like '%'|| :").concat(nombreParametro).concat(" ||'%'"), quiereOr);
			hqlBuilder.getParametros().putObject(nombreParametro, valor.toString());
		}
	}
	
	public static void montaAppendWhere(final HQLBuilder hqlBuilder, String query, final String[] campo, Object[] valor, 
			String claveBuscar, final boolean upper ) {
		
		if (hqlBuilder != null && query !=null && claveBuscar != null && (campo != null && campo.length>0) 
			&& (valor != null && valor.length>0) && campo.length==valor.length) {
			String nombreParametro = null;
			int posFin;
			int	posIni;
			char charFin;
			char charIni;
			boolean esNulo = true;
			
			for (int i = 0; i < campo.length; i++) {
				String textoCampo = campo[i];
				Object textoValor = valor[i];
				if (textoCampo != null && textoValor != null) {
					esNulo = false;
					posFin = query.indexOf(claveBuscar)+claveBuscar.length();
					posIni = query.indexOf(claveBuscar)-1;
					charFin = query.charAt(posFin);
					charIni = query.charAt(posIni);
					nombreParametro = nombraParametro(textoCampo);
					if(charIni != ' ' && charFin != ' ') {
						query=query.replaceFirst(claveBuscar, " :"+nombreParametro+" ");
					}else if (charIni == ' ' && charFin != ' ') {
						query=query.replaceFirst(claveBuscar, ":"+nombreParametro+" ");
					}else if (charIni != ' ' && charFin == ' ') {
						query=query.replaceFirst(claveBuscar, " :"+nombreParametro);
					}else {
						query=query.replaceFirst(claveBuscar, ":"+nombreParametro);
					}
					if(textoValor instanceof String) {
						hqlBuilder.getParametros().putObject(nombreParametro, upper ? textoValor.toString().toUpperCase() : textoValor.toString());	
					}else {
						hqlBuilder.getParametros().putObject(nombreParametro, textoValor);
					}
					
				}
			}
				if (!esNulo)
				hqlBuilder.appendWhere(query);		
			}
	}

	private final StringBuilder stringBuilder;
	private final StringBuilder order;
	private final int parentesis;

	private boolean hasWhere = false;

	public void setHasWhere(boolean hasWhere) {
		this.hasWhere = hasWhere;
	}

	public HQLBuilder(final String st) {
		int open = buscaCaracter(st, '(');
		int close = buscaCaracter(st, ')');
		this.parentesis = open - close;
		this.stringBuilder = new StringBuilder(st.trim());
		this.order = new StringBuilder();
		this.parametros = new Parametros();
	}

	/**
	 * añade a la cadena HQL una cláusula WHERE
	 * 
	 * @param where
	 */
	public void appendWhere(final String where) {

		initWhereClause();

		this.stringBuilder.append(where).append(")");
	}

	public void appendWhere(final String where, boolean quiereOr) {

		initWhereClause(quiereOr);

		this.stringBuilder.append(where).append(")");
	}

	@Override
	public String toString() {
		for (int i = 0; i < this.parentesis; i++) {
			this.stringBuilder.append(")");
		}
		this.stringBuilder.append(this.order);
		return this.stringBuilder.toString();
	}

	/**
	 * añade una clausula WHERE para comprobar si un determinado campo está
	 * entre unos determinados valores
	 * 
	 * @param field
	 *            Campo
	 * @param values
	 *            Conjunto de valores
	 */
	public void appendWhereIN(final String field, final String[] values) {
		initWhereClause();

		this.stringBuilder.append(field).append(" in (");
		boolean first = true;
		for (String v : values) {
			if (!first) {
				this.stringBuilder.append(", ");
			} else {
				first = false;
			}
			this.stringBuilder.append(v);
		}

		this.stringBuilder.append("))");

	}
	
	/**
	 * añade una clausula WHERE para comprobar si un determinado campo está
	 * entre unos determinados valores
	 * 
	 * @param field
	 *            Campo
	 * @param values
	 *            Conjunto de valores
	 * @param quiereOr
	 * 				Si está a true el valor, se añadira OR en vez de AND en caso de tener varias condiciones
	 */
	public void appendWhereIN(final String field, final String[] values, Boolean quiereOr) {
		initWhereClause(quiereOr);

		this.stringBuilder.append(field).append(" in (");
		boolean first = true;
		for (String v : values) {
			if (!first) {
				this.stringBuilder.append(", ");
			} else {
				first = false;
			}
			this.stringBuilder.append("'");
			this.stringBuilder.append(v);
			this.stringBuilder.append("'");
		}

		this.stringBuilder.append("))");

	}
	/**
	 * Introducir clausula GROUP BY pasando por valor los campos por los que se desea agrupar
	 * 
	 *  @param field
	 *  			campos de la select por los que agrupar
	 */
	public static void appendGroupBy(final HQLBuilder hqlBuilder, String... fields) {
		hqlBuilder.stringBuilder.append(" GROUP BY ");
		boolean primero = true;
		for(String g: fields) {
			if(!primero){
				hqlBuilder.stringBuilder.append(", ");
			}else {
				primero = false;
			}
			hqlBuilder.stringBuilder.append(g);
		}
	}
	
	/**
	 * añade una clausula WHERE para comprobar si un determinado campo está
	 * entre unos determinados valores
	 * 
	 * @param field
	 *            Campo
	 * @param strValores
	 *            Valores. Esta cadena debe contener los valores separados por
	 *            comas, tal y como requiere la clausula IN
	 *@param quiereOr
	 * 	 Si está a true el valor, se añadira "OR" en vez de "AND"
	 */
	public void appendWhereIN(final String field, final String strValores, Boolean quiereOr) {
		initWhereClause(quiereOr);
		this.stringBuilder.append(field);
		this.stringBuilder.append(" in (");
		this.stringBuilder.append(strValores);
		this.stringBuilder.append("))");
	}

	/**
	 * añade una clausula WHERE para comprobar si un determinado campo está
	 * entre unos determinados valores
	 * 
	 * @param field
	 *            Campo
	 * @param strValores
	 *            Valores. Esta cadena debe contener los valores separados por
	 *            comas, tal y como requiere la clausula IN
	 * 
	 */
	public void appendWhereIN(final String field, final String strValores) {
		initWhereClause();
		this.stringBuilder.append(field);
		this.stringBuilder.append(" in (");
		this.stringBuilder.append(strValores);
		this.stringBuilder.append("))");
	}

	/**
	 * añade cláusulas WHERE para filtrar por los campos definidos como
	 * propiedades extendidas en un {@link ExtensibleDto}
	 * 
	 * @param dto
	 *            Subclase de {@link ExtensibleDto}
	 */
	public void appendExtensibleDto(final ExtensibleDto dto) {
		if ((dto != null) && (!Checks.estaVacio(dto.getParametersMap()))) {
			for (Entry<String, String> param : dto.getParametersMap().entrySet()) {
				this.appendWhere(param.getKey() + " = '" + param.getValue() + "'");
			}
		}
	}

	/**
	 * añade ordenación a la consulta HQL
	 * 
	 * @param campo
	 *            Campo por el que queremos ordenar
	 * @param sentido
	 *            Sentido de la ordenacion. Si es NULL usará la ordenación por
	 *            defecto.
	 */
	public void orderBy(final String campo, final String sentido) {
		if ((sentido == null) || ORDER_ASC.equals(sentido) || ORDER_DESC.equals(sentido)) {
			this.order.append(" order by ").append(campo);
			if (sentido != null) {
				this.order.append(" ").append(sentido);
			}
		} else {
			throw new IllegalArgumentException(sentido.concat(": opción no aceptada para el sentido de la ordenación"));
		}
	}
	
	public void orderByMultiple(final String campos) {
			this.order.append(" order by ").append(campos);
		}

	/**
	 * Este método permite cambiar la cláusula FROM
	 * 
	 * @param string
	 *            cadena de búsqueda
	 * @param replacement
	 *            reemplazo
	 * 
	 * @since 2.7.0
	 */
	public void changeFrom(String string, String replacement) {
		if (this.stringBuilder != null) {
			String current = this.stringBuilder.toString();
			String replaced = current.replaceAll(string, replacement);
			this.stringBuilder.replace(0, current.length(), replaced);
		}
	}

	/**
	 * Escribe el principio de la clausula WHERE. éste método deja la clausula
	 * WHERE con un paréntesis abierto para especificar la condición que
	 * queramos. <strong>Cuado terminemos será necesario cerrar el paréntesis
	 * para cerrar la cláusula mediante
	 * <code>this.stringBuilder.append(")");</code></strong>
	 */
	private void initWhereClause() {
		if (hasWhere) {
			this.stringBuilder.append(" and (");
		} else {
			this.stringBuilder.append(" where (");
			this.hasWhere = true;
		}
	}

	private void initWhereClause(boolean quiereOr) {
		if (hasWhere && quiereOr) {
			this.stringBuilder.append(" or (");
		}else if (hasWhere && !quiereOr) {
			this.stringBuilder.append(" and (");
		}else if(!hasWhere) {
			this.stringBuilder.append(" where (");
			this.hasWhere = true;
		}
	}

	/**
	 * Crea un nombre de parámetro para referirse a un determinado campo
	 * 
	 * @param nombreCampo
	 * @return
	 */
	private static String nombraParametro(final String nombreCampo) {
		return nombreCampo.substring(nombreCampo.lastIndexOf('.') + 1).concat("_").concat((contador++).toString());
	}

	/**
	 * Devuelve los parámetros que se han ido usando durante la construcción de
	 * la consulta.
	 * 
	 * @return
	 */
	public HashMap<String, Object> getParameters() {
		return this.parametros.getObjectMap();
	}

	/**
	 * Devuelve un array con los nombres de los parámetros de la consulta
	 * 
	 * @return
	 */
	public String[] getParamNames() {
		return this.getParameters().keySet().toArray(new String[] {});
	}

	/**
	 * Devuelve un array con los valores de los parametros de la consulta
	 * 
	 * @return
	 */
	public Object[] getParamValues() {
		return this.getParameters().values().toArray(new Object[] {});
	}

	private Parametros getParametros() {
		return parametros;
	}

	private int buscaCaracter(final String st, final char c) {
		int count = 0;
		for (int i = 0; i < st.length(); i++) {
			if (st.charAt(i) == c) {
				count++;
			}
		}
		return count;
	}

	/**
	 * Add simple group by
	 * @param groupBy <String> field which group
	 * @return
	 */
	public void addGroupBy(final String groupBy) {
		this.stringBuilder.append(" GROUP BY "+groupBy);
	}
	
	public static void addFiltroDifferentSiNotNull(final HQLBuilder hqlBuilder, final String nombreCampo, final Object valor) {
		if (!Checks.esNulo(valor)) {
			final String nombreParametro = nombraParametro(nombreCampo);
			hqlBuilder.appendWhere(nombreCampo.concat(" <> :").concat(nombreParametro));
			hqlBuilder.getParametros().putObject(nombreParametro, valor);
		}
	}

	
}
