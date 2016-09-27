package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.TypeVariable;
import java.text.ParseException;
import java.util.Date;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.DecimalDataTypeFormat;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

public abstract class WebcomDataType<T> {

	private static final String SEPARDOR_DECIMALES = ".";

	public abstract T getValue();

	/*
	 * Wrapper para Long
	 */
	public static LongDataType longDataType(Long l) {
		if (l != null) {
			return new LongDataType(l);
		} else {
			return nullLongDataType();
		}
	}

	public static NullLongDataType nullLongDataType() {
		return new NullLongDataType();
	}

	/*
	 * Wrapper para Date
	 */
	public static DateDataType dateDataType(Date d) {
		if (d != null) {
			return new DateDataType(d);
		} else {
			return nullDateDataType();
		}

	}

	public static NullDateDataType nullDateDataType() {
		return new NullDateDataType();
	}

	/*
	 * Wrapper para String
	 */
	public static StringDataType stringDataType(String s) {
		if (s != null) {
			return new StringDataType(s);
		} else {
			return nullStringDataType();
		}
	}

	public static NullStringDataType nullStringDataType() {
		return new NullStringDataType();
	}

	/*
	 * Wrapper para Float
	 */
	public static DoubleDataType doubleDataType(Double f) {
		if (f != null) {
			return new DoubleDataType(f);
		} else {
			return nullDoubleDataType();
		}
	}

	public static NullDoubleDataType nullDoubleDataType() {
		return new NullDoubleDataType();
	}

	/*
	 * Wrapper para Boolean
	 */
	public static BooleanDataType booleanDataType(Boolean b) {
		if (b != null) {
			return new BooleanDataType(b);
		} else {
			return nullBooleanDataType();
		}
	}

	public static NullBooleanDataType nullBooleanDataType() {
		return new NullBooleanDataType();
	}

	public String toString() {
		if (this instanceof NullDataType) {
			return "NullDataType";
		} else {
			return "DataType <".concat((getValue() != null ? getValue().toString() : "empty")).concat(">");
		}
	}

	public static Object valueOf(Object o) {
		if (o instanceof WebcomDataType) {
			Object value = ((WebcomDataType) o).getValue();
			if ((value == null) && (!(o instanceof NullDataType))) {
				throw new IllegalArgumentException("getValue() es NULL. ¿Debería " + o.getClass().getName()
						+ " implementar " + NullDataType.class.getName() + "?");
			}
			return value;
		} else {
			return o;
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static <E extends WebcomDataType> E parse(Class<E> type, Object data)
			throws WebcomDataTypeParseException, UnknownWebcomDataTypeException {

		try {
			if (LongDataType.class.equals(type)) {
				return (E) longDataType(data != null ? Long.parseLong(data.toString()) : null);

			} else if (BooleanDataType.class.equals(type)) {
				Boolean parseBoolean = null;
				if (data != null) {
					String d = data.toString().trim();
					if ("1".equals(d)) {
						parseBoolean = Boolean.TRUE;
					} else if ("0".equals(d)) {
						parseBoolean = Boolean.FALSE;
					} else {
						parseBoolean = Boolean.parseBoolean(d);
					}
				}
				return (E) booleanDataType(parseBoolean);

			} else if (DateDataType.class.equals(type)) {
				Date parseDate = null;
				if (data != null) {
					if (data instanceof Date) {
						parseDate = (Date) data;
					} else {
						parseDate = WebcomRequestUtils.parseDate(data.toString());
					}
				}
				return (E) dateDataType(parseDate);

			} else if (DoubleDataType.class.equals(type)) {
				return (E) doubleDataType(data != null ? Double.parseDouble(data.toString()) : null);

			} else if (StringDataType.class.equals(type)) {
				return (E) stringDataType(data != null ? data.toString() : null);

			} else {
				throw new UnknownWebcomDataTypeException(type);
			}
		} catch (IllegalArgumentException e) {
			throw new WebcomDataTypeParseException(e);
		} catch (SecurityException e) {
			throw new WebcomDataTypeParseException(e);
		} catch (ParseException e) {
			throw new WebcomDataTypeParseException(e);
		}

	}

	public static Object valueOf(Object o, DecimalDataTypeFormat format) throws WebcomDataTypeParseException {
		Object val = valueOf(o);
		if ((val != null) && (val instanceof Number) && (format != null)) {
			String[] split = val.toString().split("\\" + SEPARDOR_DECIMALES);
			if (split.length > 1) {
				String parteentera = split[0];
				if (split.length == 2) {
					String partedecimal = split[1];
					val = parteentera + SEPARDOR_DECIMALES + recorta(partedecimal, format.decimals());

				} else {
					throw new WebcomDataTypeParseException("No es un formato numérico válido o reconocible" + o);
				}
			}
		}
		return val;
	}

	/**
	 * Recorta una cadana para que tenga una longitud determinada
	 * 
	 * @param string
	 * @param count
	 *            Si es <= 0 no se limita
	 * 
	 * @return
	 */
	private static String recorta(String string, int count) {
		if (string != null) {
			char[] c = string.toCharArray();
			StringBuilder b = new StringBuilder();

			int maximo = (count > 0 ? count : 0);
			for (int i = 0; i < maximo; i++) {
				if (i < c.length) {
					b.append(c[i]);
				} else {
					b.append(0);
				}
			}
			return b.toString();
		} else {
			return null;
		}
	}
}
