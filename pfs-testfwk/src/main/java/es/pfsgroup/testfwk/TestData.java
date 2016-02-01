package es.pfsgroup.testfwk;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import es.pfsgroup.commons.utils.Assertions;

public class TestData<T> {

    public static final Map<Class<?>, Object> DEFAULT_TYPES = new HashMap<Class<?>, Object>();
    static {
        try {
            DEFAULT_TYPES.put(String.class, "The answer is 42");
            DEFAULT_TYPES.put(Long.class, new Long(42));
            DEFAULT_TYPES.put(long.class, 42);
            DEFAULT_TYPES.put(Integer.class, new Integer(42));
            DEFAULT_TYPES.put(int.class, 42);
            DEFAULT_TYPES.put(Date.class, new SimpleDateFormat("yyyy-mm-dd").parse("2001-01-01"));
        } catch (ParseException e) {
            throw new IllegalStateException(e);
        }
    }

    private List<T> data;

    public TestData(List<T> list) {
        data = list;
    }

    public static <T> Collection<T> newTestCollectionByFieldCriteria(Class<T> clazz, String field, Collection values) throws Exception {
        Assertions.assertNotNull(values, "values no puede ser null");
        Assertions.assertNotNull(field, "field no puede ser null");

        ArrayList<T> c = new ArrayList<T>();
        for (Object o : values) {
            c.add(newTestObject(clazz, new FieldCriteria(field, o)));
        }
        return c;
    }

    public static <T> T newTestObject(Class<T> clazz, TestDataCriteria... crit) throws Exception {
        T object = clazz.newInstance();

        final Field[] alldeclaredfields = getAllDeclaredFields(clazz);
        for (Field f : alldeclaredfields) {
            if (!Modifier.isStatic(f.getModifiers())) {
                boolean accessible = f.isAccessible();
                boolean accessed = false;
                f.setAccessible(true);
                if (crit != null) {
                    for (TestDataCriteria tdc : crit) {
                        if (tdc.isFieldCriteria() && (tdc.getName().equals(f.getName()))) {
                            f.set(object, tdc.getValue());
                            accessed = true;
                            break;
                        }
                        if (tdc.isTypeCriteria() && tdc.getName().equals(f.getType().getSimpleName())) {
                            f.set(object, tdc.getValue());
                            accessed = true;
                            break;
                        }
                    }
                }
                if (!accessed) {
                    Object value = DEFAULT_TYPES.get(f.getType());
                    f.set(object, value);
                }
                f.setAccessible(accessible);
            }
        }

        return object;
    }

    public static <T> TestData<T> create(Class<T> clazz, String ressName, TestDataCriteria... crit) throws Exception {
        return create(clazz, TestData.class.getResourceAsStream(ressName), crit);
    }

    public static <T> TestData<T> create(Class<T> clazz, InputStream fis, TestDataCriteria... crit) throws Exception {
        Table t = (Table) clazz.getAnnotation(Table.class);
        String tableName = t.name().toUpperCase();
        Document xml = read(fis);
        List<T> list = extracData(xml, tableName, clazz, crit);

        return new TestData(list);
    }

    private static <T> List<T> extracData(Document xml, String tableName, Class<T> clazz, TestDataCriteria[] crit) throws Exception {
        ArrayList<T> list = new ArrayList<T>();
        NodeList nodeLst = xml.getElementsByTagName(tableName);
        for (int s = 0; s < nodeLst.getLength(); s++) {
            Node fstNode = nodeLst.item(s);
            T created = createObject(fstNode, clazz, crit);
            if (created != null) {
                list.add(created);
            }
        }
        return list;
    }

    private static <T> T createObject(Node node, Class<T> clazz, TestDataCriteria[] crit) throws InstantiationException, IllegalAccessException, IllegalArgumentException, SecurityException,
            NoSuchMethodException, InvocationTargetException, ParseException {
        T object = clazz.newInstance();
        boolean hasValues = false;

        final Field[] fields = getAllDeclaredFields(clazz);

        for (Field f : fields) {
            if (!checkCriteria(f, node, crit)) {
                return null;
            }
            Column c = f.getAnnotation(Column.class);
            if (c != null) {
                hasValues = true;
                String colName = c.name();
                Node column = node.getAttributes().getNamedItem(colName);
                if (column != null) {
                    String colValue = column.getNodeValue();
                    if (colValue != null) {
                        if (!setProperty(object, colValue, f, clazz)) {
                            return null;
                        }
                    }
                }
            }
        }

        return hasValues ? object : null;
    }

    private static boolean checkCriteria(final Field f, final Node node, final TestDataCriteria[] crit) {
        String colName;
        String colValue;
        Column c = f.getAnnotation(Column.class);
        JoinColumn jc = f.getAnnotation(JoinColumn.class);

        if (c != null) {
            colName = c.name();
            Node n = node.getAttributes().getNamedItem(c.name());
            if (n != null) {
                colValue = n.getNodeValue();
            } else {
                colValue = null;
            }
        } else if (jc != null) {
            colName = jc.name();
            Node n = node.getAttributes().getNamedItem(jc.name());
            if (n != null) {
                colValue = n.getNodeValue();
            } else {
                colValue = null;
            }
        } else {
            return true;
        }
        for (TestDataCriteria tdc : crit) {
            if (tdc.isColumnCriteria() && (c != null) && tdc.getName().equals(colName)) {
                return compareValue(tdc.getValue(), colValue);
            } else if ((jc != null) && tdc.isJoinColumnCriteria() && (jc != null) && colName.equals(tdc.getName())) {
                return compareValue(tdc.getValue(), colValue);
            }
        }
        return true;
    }

    private static boolean compareValue(Object expected, String current) {
        if (expected == null) {
            return current == null;
        }

        return expected.toString().equals(current);
    }

    private static boolean setProperty(Object o, String v, Field f, Class clazz) throws IllegalArgumentException, IllegalAccessException, SecurityException, NoSuchMethodException,
            InvocationTargetException, ParseException {
        Object value = null;
        String name = f.getName();
        Method m = clazz.getDeclaredMethod("set" + name.replaceFirst(name.substring(0, 1), name.substring(0, 1).toUpperCase()), f.getType());
        if (f.getType().equals(String.class)) {
            value = v;
        } else if (f.getType().equals(Long.class)) {
            value = Long.parseLong(v);
        } else if (f.getType().equals(Integer.class)) {
            value = Integer.parseInt(v);
        } else if (f.getType().equals(Date.class)) {
            value = new SimpleDateFormat("yyyy-mm-dd").parse(v);
        } else if (f.getType().equals(Boolean.class)) {
            if ("1".equals(v))
                v = "true";
            value = Boolean.parseBoolean(v);
        } else {
            throw new IllegalArgumentException(f.getType().toString().concat(": Tipo no soportado"));
        }
        m.invoke(o, value);
        return true;
    }

    private static Document read(InputStream fis) throws ParserConfigurationException, SAXException, IOException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(fis);
        return doc;
    }

    /**
     * Devuelve todos los tests declarados tanto en la clase como en todas sus
     * superclases.
     * 
     * @param clazz
     * @return
     */
    private static <T> Field[] getAllDeclaredFields(Class<T> clazz) {
        final ArrayList<Field> allfields = new ArrayList<Field>();
        allfields.addAll(extractFields(clazz));

        Class<?> superclass = clazz.getSuperclass();
        while (superclass != null) {
            allfields.addAll(extractFields(superclass));
            superclass = superclass.getSuperclass();
        }

        return allfields.toArray(new Field[] {});
    }

    /**
     * Devuelve todos los campos de una clase.
     * 
     * @param clazz
     * @return
     */
    private static <T> Collection<? extends Field> extractFields(final Class<T> clazz) {
        final ArrayList<Field> list = new ArrayList<Field>();
        for (Field f : clazz.getDeclaredFields()) {
            list.add(f);
        }
        return list;
    }

    public List<T> getList() {
        return data;
    }

}
