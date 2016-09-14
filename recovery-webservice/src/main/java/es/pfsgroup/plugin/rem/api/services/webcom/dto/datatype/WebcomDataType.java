package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

import java.util.Date;

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
		if (o instanceof WebcomDataType){
			return ((WebcomDataType) o).getValue();
		}else{
			return o;
		}
	}
}
