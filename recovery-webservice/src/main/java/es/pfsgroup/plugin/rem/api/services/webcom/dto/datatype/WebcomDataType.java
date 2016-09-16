package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.TypeVariable;
import java.text.ParseException;
import java.util.Date;

import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

public abstract class WebcomDataType<T> {

	public abstract T getValue();

	/*
	 * Wrapper para Long
	 */
	public static LongDataType longDataType(long l) {
		return new LongDataType(l);
	}

	public static NullLongDataType nullLongDataType() {
		return new NullLongDataType();
	}

	/*
	 * Wrapper para Date
	 */
	public static DateDataType dateDataType(Date d) {
		return new DateDataType(d);
	}

	public static NullDateDataType nullDateDataType() {
		return new NullDateDataType();
	}

	/*
	 * Wrapper para String
	 */
	public static StringDataType stringDataType(String s) {
		return new StringDataType(s);
	}

	public static NullStringDataType nullStringDataType() {
		return new NullStringDataType();
	}

	/*
	 * Wrapper para Float
	 */
	public static FloatDataType floatDataType(float f) {
		return new FloatDataType(f);
	}

	public static NullFloatDataType nullFloatDataType() {
		return new NullFloatDataType();
	}

	/*
	 * Wrapper para Boolean
	 */
	public static BooleanDataType booleanDataType(boolean b) {
		return new BooleanDataType(b);
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
			return ((WebcomDataType) o).getValue();
		} else {
			return o;
		}
	}

	public static <E extends WebcomDataType> E parse(Class<E> type, Object data) throws WebcomDataTypeParseException, UnknownWebcomDataTypeException {
		if (data != null) {
			try {
				if (LongDataType.class.equals(type)) {
					return (E) longDataType(Long.parseLong(data.toString()));
					
				} else if (BooleanDataType.class.equals(type)) {
					return (E) booleanDataType(Boolean.parseBoolean(data.toString()));
					
				} else if (DateDataType.class.equals(type)) {
					Date parseDate = null;{
						if (data instanceof Date){
							parseDate = (Date) data;
						}else{
							 parseDate = WebcomRequestUtils.parseDate(data.toString());
						}
					}
					return (E) dateDataType(parseDate);
					
				} else if (FloatDataType.class.equals(type)) {
					return (E) floatDataType(Float.parseFloat(data.toString()));
				
				} else if (StringDataType.class.equals(type)) {
					return (E) stringDataType(data.toString());
					
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
		return null;
	}
}
