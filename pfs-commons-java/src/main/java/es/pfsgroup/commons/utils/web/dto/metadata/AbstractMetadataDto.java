package es.pfsgroup.commons.utils.web.dto.metadata;

import static es.pfsgroup.commons.utils.web.dto.metadata.EditorOptions.DD_DATA;
import static es.pfsgroup.commons.utils.web.dto.metadata.EditorOptions.FIELD_EDITOR_OPTION_ALLOWBLANK;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.management.RuntimeErrorException;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.dto.AbstractDto;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.BOReference;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Currencyfield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.DDCombo;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Datefield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Numberfield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Textarea;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Textfield;

public abstract class AbstractMetadataDto<T extends Serializable> extends AbstractDto implements MetadataDto<T> {

    private static final int FORM_OPTION_COLUMNS_DEFAULT = 2;
    private static final long serialVersionUID = 2979790314123954737L;

    private static class Reference {
        public static enum ReferenceType {
            BO, DICT
        }

        public ReferenceType type;
        public Class<Serializable> clazz;
        public Field field;
        public boolean allowNull;
    }

    @Autowired
    private GenericABMDao genericDao;

    private HashMap<String, Object> formConfig;

    private HashMap<String, Object> data = new HashMap<String, Object>();
    private HashMap<String, List<Serializable>> dicts = new HashMap<String, List<Serializable>>();
    private HashMap<String, Reference> references;
    private HashMap<String, MetadataField> field = new HashMap<String, MetadataField>();

    private boolean readOnly = false;

    private HtmlTextElement topHtml;

    public final void setGenericDao(GenericABMDao dao) {
        this.genericDao = dao;
    }

    public AbstractMetadataDto() {
        formConfig = initConfig();
        references = initReferences();
        topHtml = initTopHtml();
    }

    public AbstractMetadataDto(Object... args) {
        formConfig = initConfig(args);
        references = initReferences(args);
        topHtml = initTopHtml(args);
    }

    @Override
    public final List<MetadataField> getFields() {
        ArrayList<MetadataField> fields = new ArrayList<MetadataField>();
        boolean hasfields = true;
        if ((field.values() == null) || field.values().isEmpty()) {
            hasfields = initFields();
        }

        if (hasfields) {
            fields.addAll(field.values());
        }
        Collections.sort(fields);

        return fields;
    }

    @Override
    public final HashMap<String, Object> getFormConfig() {
        return formConfig;
    }

    @Override
    public List<Entry<String, Object>> getData() {
        if (Checks.estaVacio(this.data)) {
            initData();
        }
        ArrayList<Entry<String, Object>> entries = new ArrayList<Entry<String, Object>>();
        for (Entry<String, Object> e : this.data.entrySet()) {
            entries.add(e);
        }
        return entries;
    }

    private void initData() {
        for (Field f : this.getClass().getDeclaredFields()) {
            try {
                if (!Modifier.isStatic(f.getModifiers())) {
                    if (f.getAnnotation(IgnoreField.class) == null) {
                        String name = f.getName();
                        f.setAccessible(true);
                        Object value = f.get(this);
                        if (value != null) {
                            if ((value instanceof String) || (f.getAnnotation(DDCombo.class) == null)) {
                                putValue(name, value);
                            } else {
                                try {
                                    putValue(name, BeanUtils.getProperty(value, "codigo"));
                                } catch (Exception e) {
                                    throw new IllegalStateException(this.getClass().getName() + "." + name + ", IS NOT A DICTIONARY");
                                }
                            }
                        }
                    }
                }
            } catch (IllegalStateException e) {
                throw e;
            } catch (Exception e) {
                // TODO Auto-generated catch block
            }
        }
    }

    @Override
    public Map<String, Object> getValues() {
        if (Checks.estaVacio(this.data)) {
            initData();
        }
        return this.data;
    }

    public final Map<String, List<Serializable>> getDictionaries() {
        check();
        if (this.references == null) {
            return null;
        }
        HashMap<String, List<Serializable>> dds = new HashMap<String, List<Serializable>>();
        for (Entry<String, Reference> e : this.references.entrySet()) {
            if (Reference.ReferenceType.DICT.equals(e.getValue().type)) {
                final Class<Serializable> clazz = e.getValue().clazz;

                dds.put(clazz.getName(), genericDao.getList(clazz));
            }
        }
        return dds;
    }

    @Override
    public Object getValue(String key) {
        if (Checks.esNulo(key))
            return null;
        else
            return this.data.get(key);
    }

    @Override
    public final HashMap<String, List<Serializable>> getDictionary() {
        return dicts;
    }

    @Override
    public final Map<String, MetadataField> getField() {
        if ((field.values() == null) || field.values().isEmpty()) {
            initFields();
        }
        return this.field;
    }

    public final void setTopHtml(HtmlTextElement topHtml) {
        this.topHtml = topHtml;
    }

    public final HtmlTextElement getTopHtml() {
        return topHtml;
    }

    public final String getWindowTitle() {
        if (formConfig == null)
            return null;
        Object t = formConfig.get(FormOptions.FORM_OPTION_TITLE);
        if (t == null) {
            return null;
        } else {
            return t.toString();
        }
    }

    @Override
    public final boolean isReadOnly() {
        return readOnly;
    }

    @Override
    public final void setReadOnly(boolean option) throws ReadOnlyDtoError {
        this.formConfig.put(FormOptions.FORM_OPTION_READONLY, option ? Option.TRUE : Option.FALSE);
        this.readOnly = option;
        changeFieldsReadOnlyMode();

    }

    @Override
    public T createObject() throws Exception {
        return null;
    }

    @Override
    public void loadObject(T o) throws Exception {
        for (Field f : this.getClass().getDeclaredFields()) {
            if (Modifier.isStatic(f.getModifiers()))
                continue;
            Method getter = getAccessor(o, f.getName());

            if (getter != null) {
                f.setAccessible(true);
                getter.setAccessible(true);
                DDCombo dd = f.getAnnotation(DDCombo.class);
                BOReference ref = f.getAnnotation(BOReference.class);
                if ((dd != null) && (getter.getReturnType().equals(dd.dictionary()))) {
                    Object dict = getter.invoke(o);
                    Method getCodigo = getAccessor(dict, "codigo");
                    if (getCodigo != null) {
                        getCodigo.setAccessible(true);
                        f.set(this, getCodigo.invoke(dict));
                    }
                } else if ((ref != null) && (getter.getReturnType().equals(ref.clazz()))) {
                    Object r = getter.invoke(o);
                    Method getId = getAccessor(r, "id");
                    if (getId != null) {
                        getId.setAccessible(true);
                        f.set(this, getId.invoke(r));
                    }
                } else if (f.getType().equals(getter.getReturnType())) {
                    f.set(this, getter.invoke(o));
                }
            }
        }
    }

    private Method getAccessor(Object o, String name) {
        if (o == null)
            return null;
        Method getter;
        try {
            String i = name.substring(0, 1);
            String methodName = "get" + name.replaceFirst(i, i.toUpperCase());
            getter = o.getClass().getMethod(methodName);
        } catch (NoSuchMethodException nsme) {
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return getter;
    }

    @Override
    public T mergeObject(T o) throws Exception {
        return null;
    }

    boolean initFields() {
        boolean has = false;
        Integer contador = 0;
        for (Field f : this.getClass().getDeclaredFields()) {
            if (!Modifier.isStatic(f.getModifiers())) {
                Map<String, Object> cfg = getFieldOptions(f);
                Map<String, Object> ecfg = getEditorOptions(f);
                MetadataField mf = new MetadataField(contador++, f, cfg, ecfg);
                putField(f.getName(), mf);
                has = true;
            }
        }
        return has;
    }

    HtmlTextElement initTopHtml(Object... args) {
        return null;
    }

    HashMap<String, Reference> initReferences(Object... args) {
        HashMap<String, Reference> refs = new HashMap<String, Reference>();
        for (Field f : this.getClass().getDeclaredFields()) {
            BOReference a = f.getAnnotation(BOReference.class);
            if (a != null) {
                Reference ref = new Reference();
                ref.clazz = a.clazz();
                ref.type = Reference.ReferenceType.BO;
                ref.field = f;
                ref.allowNull = !a.required();
                refs.put(a.clazz().getName(), ref);
            }
            DDCombo dd = f.getAnnotation(DDCombo.class);
            if (dd != null) {
                Reference ref = new Reference();
                ref.clazz = dd.dictionary();
                ref.type = Reference.ReferenceType.DICT;
                ref.field = f;
                ref.allowNull = true;
                if (Checks.esNulo(dd.name())) {
                    refs.put(dd.dictionary().getName(), ref);
                } else {
                    refs.put(dd.dictionary().getName() + ":" + dd.name(), ref);
                }
            }
        }
        return refs;
    }

    // public String getDDJson(String name){
    // return jsonDD.get(name);
    // }

    HashMap<String, Object> initConfig(Object... args) {
        HashMap<String, Object> cfg = new HashMap<String, Object>();
        FormOptions options = this.getClass().getAnnotation(FormOptions.class);
        int columns = FORM_OPTION_COLUMNS_DEFAULT;
        if (options != null) {
            for (Option o : options.options()) {
                try {
                    if (FormOptions.FORM_OPTION_COLUMNS.equals(o.key())) {
                        columns = Integer.parseInt(o.value());
                    }
                } catch (Exception e) {
                }
            }
        }
        cfg.put(FORM_OPTION_LABEL_ALIGN, "left");
        cfg.put(FormOptions.FORM_OPTION_COLUMNS, columns);
        cfg.put(FORM_OPTION_LABEL_WIDTH, 80);
        cfg.put(FormOptions.FORM_OPTION_READONLY, readOnly ? Option.TRUE : Option.FALSE);
        return cfg;
    }

    @SuppressWarnings("unchecked")
    Map<String, Object> ddcomboEditorOptions(Map<String, Object> map, Class dictionary) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_DDCOMBO_RO : EditorOptions.XTYPE_DDCOMBO);
        String dictName = dictionary.getSimpleName();
        this.setUpDictionary(dictName, this.getValuesDictionary(dictionary));
        map = putProperty(map, DD_DATA, dictName);
        return map;
    }

    Map<String, Object> boreferenceEditorOptions(Map<String, Object> map) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, EditorOptions.XTYPE_HIDDEN);
        return map;
    }

    Map<String, Object> textfieldEditorOptions(Map<String, Object> map) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_TEXT_FIELD_RO : EditorOptions.XTYPE_TEXT_FIELD);
        return map;
    }

    Map<String, Object> textareaEditorOptions(Map<String, Object> map) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_TEXTAREA_RO : EditorOptions.XTYPE_TEXTAREA);
        return map;
    }

    Map<String, Object> numberfieldEditorOptions(Map<String, Object> map) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_NUMBER_FIELD_RO : EditorOptions.XTYPE_NUMBER_FIELD);
        return map;
    }

    Map<String, Object> currencyfieldEditorOptions(Map<String, Object> map, boolean obligatory) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_CURRENCY_FIELD_RO : EditorOptions.XTYPE_CURRENCY_FIELD);
        if (obligatory) {
            map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_ALLOWBLANK, Option.FALSE);
        }
        return map;
    }

    Map<String, Object> datefieldEditorOptions(Map<String, Object> map) {
        map = putProperty(map, EditorOptions.FIELD_EDITOR_OPTION_XTYPE, isReadOnly(map) ? EditorOptions.XTYPE_DATEFIELD_RO : EditorOptions.XTYPE_DATEFIELD);
        return map;
    }

    Map<String, Object> putCommonProperties(Object o) {
        Map<String, Object> map = null;

        for (Method m : o.getClass().getDeclaredMethods()) {
            try {
                String name = m.getName();
                if (m.getParameterTypes().length == 0) {
                    Object value = m.invoke(o);
                    if ((!Checks.esNulo(name)) && (!Checks.esNulo(value))) {
                        map = putDefaultProperty(map, name, value, EditorOptions.FIELD_EDITOR_OPTION_HEIGHT);
                        map = putDefaultProperty(map, name, value, EditorOptions.FIELD_EDITOR_OPTION_LABEL_STYLE);
                        map = putDefaultProperty(map, name, value, EditorOptions.FIELD_EDITOR_OPTION_WIDTH);
                        map = putDefaultProperty(map, name, value, EditorOptions.FIELD_EDITOR_OPTION_STYLE);
                        map = putDefaultProperty(map, name, value.toString(), EditorOptions.FIELD_EDITOR_OPTION_READONLY);
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

        return map;
    }

    void putField(String name, MetadataField field) {
        this.field.put(name, field);
    }

    protected final Date stringToDate(String s) throws ParseException {
        if (Checks.esNulo(s))
            return null;
        return DateFormat.toDate(s);
    }

    protected final String dateToString(Date d) {
        if (Checks.esNulo(d))
            return null;
        return DateFormat.toString(d);
    }

    protected final <T extends Serializable> T resolve(Class<T> clazz) {
        check();
        Reference ref = getReference(clazz);
        Object o = getReferenceValue(clazz, ref, ref.allowNull);
        if (!(o instanceof Long)) {
            throw new IllegalStateException(this.getClass().getName() + ": Error al resolver: '" + clazz.getName() + "'" + ". '" + ref.field.getName() + "' NO ES UN Long");
        }
        Long id = (Long) o;
        return this.getObjectById(clazz, id);
    }

    /**
     * Devuelve la referencia a un diccionario de datos.
     * 
     * <strong>No funciona correctamente si hay dos referencias al mismo
     * diccionario de datos</strong> en tal caso se debe usar
     * <code>dictionary(Class,String)</code>
     * 
     * @param <T>
     * @param clazz
     * @return
     */
    protected final <T extends Serializable> T dictionary(Class<T> clazz) {
        return dictionary(clazz, null);
    }

    /**
     * Devuelve la referencia a un determinado diccionario y que se ha
     * identificado con un nombre.
     * 
     * Es necesario identificar con un nombre las referencias a {@link DDCombo}
     * cuando va a haber varias de la misma clase. Para ello es necesario anotar
     * la propiedad correctamente
     * <code>@DDcombo(dictionary=Clase.class, labelCode="", name=NOMBRE)</code>
     * 
     * @param <T>
     * @param clazz
     * @param name
     * @return
     */
    protected final <T extends Serializable> T dictionary(Class<T> clazz, String name) {
        check();
        Reference ref;
        if (Checks.esNulo(name)) {
            ref = getReference(clazz);
        } else {
            ref = getReference(clazz, name);
        }
        Object o = getReferenceValue(clazz, ref, ref.allowNull);
        if (Checks.esNulo(o))
            return null;
        String codigo;
        if (o instanceof String) {
            codigo = (String) o;
        } else {
            try {
                codigo = BeanUtils.getProperty(o, "codigo");
            } catch (Exception e) {
                throw new IllegalStateException(this.getClass().getName() + ": Error; " + clazz.getSimpleName() + "." + ref.field.getName() + "; " + o.getClass().getSimpleName()
                        + " No es un diccionario de datos.");
            }
        }
        return this.getDictionaryByCodigo(clazz, codigo);
    }

    protected void putValue(String key, Object value) throws ReadOnlyDtoError {
        if (readOnly) {
            throw new ReadOnlyDtoError();
        }
        if ((key != null) && (value != null)) {
            this.data.put(key, value);
        }
    }

    private Map<String, Object> getEditorOptions(Field f) {
        EditorOptions eo = f.getAnnotation(EditorOptions.class);
        Map<String, Object> ecfg = getTemplateEditorOptions(f);
        if (eo != null) {
            for (Option o : eo.options()) {
                ecfg = putProperty(ecfg, o.key(), o.value());
            }
        }
        if (!allowBlank(f)) {
            ecfg = putProperty(ecfg, FIELD_EDITOR_OPTION_ALLOWBLANK, Option.FALSE);
        }
        if (isId(f)) {
            ecfg = boreferenceEditorOptions(ecfg);
        }
        /*
         * DD solo configurables via @DDCombo String attchedDict =
         * getAttachedDict(eo); if (!Checks.esNulo(attchedDict)) {
         * this.setUpDictionary(attchedDict, this
         * .getValuesDictionary(attchedDict)); ecfg = putProperty(ecfg, DD_DATA,
         * attchedDict); }
         */
        return ecfg;
    }

    private Map<String, Object> getFieldOptions(Field f) {

        FieldOptions fo = f.getAnnotation(FieldOptions.class);
        Map<String, Object> cfg = getTemplateFieldOptions(f);
        if (fo != null) {
            for (Option o : fo.options()) {
                cfg = putProperty(cfg, o.key(), o.value());
            }
        }
        return cfg;
    }

    private Map<String, Object> getTemplateFieldOptions(Field f) {
        Map<String, Object> map = null;
        Datefield df = f.getAnnotation(Datefield.class);
        if (df != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, df.labelCode());
        }
        Currencyfield cf = f.getAnnotation(Currencyfield.class);
        if (cf != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, cf.labelCode());
        }
        Numberfield nf = f.getAnnotation(Numberfield.class);
        if (nf != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, nf.labelCode());
        }
        Textarea ta = f.getAnnotation(Textarea.class);
        if (ta != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, ta.labelCode());
        }
        DDCombo dd = f.getAnnotation(DDCombo.class);
        if (dd != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, dd.labelCode());
        }
        Textfield tf = f.getAnnotation(Textfield.class);
        if (tf != null) {
            map = putProperty(map, FieldOptions.FIELD_OPTION_LABEL_CODE, tf.labelCode());
        }
        return map;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> getTemplateEditorOptions(Field f) {
        Map<String, Object> map = null;
        Datefield df = f.getAnnotation(Datefield.class);
        if (df != null) {
            map = putCommonProperties(df);
            map = datefieldEditorOptions(map);
        }
        Currencyfield cf = f.getAnnotation(Currencyfield.class);
        if (cf != null) {
            boolean obligatory = cf.obligatory();
            map = putCommonProperties(cf);
            map = currencyfieldEditorOptions(map, obligatory);
        }
        Numberfield nf = f.getAnnotation(Numberfield.class);
        if (nf != null) {
            map = putCommonProperties(nf);
            map = numberfieldEditorOptions(map);
        }
        Textarea ta = f.getAnnotation(Textarea.class);
        if (ta != null) {
            map = putCommonProperties(ta);
            map = textareaEditorOptions(map);
        }
        BOReference bo = f.getAnnotation(BOReference.class);
        if (bo != null) {
            map = putCommonProperties(bo);
            map = boreferenceEditorOptions(map);
        }
        DDCombo dd = f.getAnnotation(DDCombo.class);
        if (dd != null) {
            map = putCommonProperties(dd);
            Class dictionary = dd.dictionary();
            map = ddcomboEditorOptions(map, dictionary);
        }
        Textfield tf = f.getAnnotation(Textfield.class);
        if (tf != null) {
            map = putCommonProperties(tf);
            map = textfieldEditorOptions(map);
        }
        return map;
    }

    private Map<String, Object> putDefaultProperty(Map<String, Object> map, String name, Object value, String editorOption) {
        Map<String, Object> newMap = map;
        if (editorOption.equals(name) && (!"".equals(value))) {
            newMap = putProperty(map, editorOption, value.toString());
        }
        return newMap;
    }

    private boolean isId(Field f) {
        Id i = f.getAnnotation(Id.class);
        return i != null;
    }

    private String getAttachedDict(EditorOptions options) {
        if (options == null)
            return null;
        for (Option o : options.options()) {
            if (EditorOptions.DD_TYPE.equals(o.key())) {
                return o.value();
            }
        }
        return null;
    }

    private boolean allowBlank(Field f) {
        NotNull nn = f.getAnnotation(NotNull.class);
        NotEmpty ne = f.getAnnotation(NotEmpty.class);
        return (nn == null) && (ne == null);
    }

    private Map<String, Object> putProperty(Map<String, Object> map, String key, String value) {
        if (map == null) {
            map = new HashMap<String, Object>();
        }
        map.put(key, value);
        return map;
    }

    // public String getDDJson(String name){
    // return jsonDD.get(name);
    // }

    private void setUpDictionary(String name, List<Serializable> data) {

        this.dicts.put(name, data);
    }

    private <T extends Serializable> List<T> getValuesDictionary(Class<T> clazz) {
        check();
        return genericDao.getList(clazz);
    }

    private <T extends Serializable> T getObjectById(Class<T> clazz, Long id) {
        check();
        Filter f = genericDao.createFilter(FilterType.EQUALS, "id", id);
        return genericDao.get(clazz, f);
    }

    private <T extends Serializable> T getDictionaryByCodigo(Class<T> clazz, String codigo) {
        check();
        Filter f = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
        return genericDao.get(clazz, f);
    }

    private void check() {
        if (genericDao == null) {
            genericDao = (GenericABMDao) ApplicationContextUtil.getApplicationContext().getBean("genericABMDao");
            if (genericDao == null) {
                throw new IllegalStateException("genericDao: NO PUEDE SER NULL");
            }
        }
    }

    private <T> Reference getReference(Class<T> clazz) {
        Reference ref = this.references.get(clazz.getName());
        if (Checks.esNulo(ref)) {
            throw new IllegalStateException(this.getClass().getName() + ": @BOReference o @DDCombo no establecida para '" + clazz.getName() + "'");
        }
        return ref;
    }

    private <T> Reference getReference(Class<T> clazz, String name) {
        Reference ref;
        if (Checks.esNulo(name)) {
            ref = this.references.get(clazz.getName());
        } else {
            ref = this.references.get(clazz.getName() + ":" + name);
        }
        if (Checks.esNulo(ref)) {
            throw new IllegalStateException(this.getClass().getName() + ": @BOReference o @DDCombo no establecida para '" + clazz.getName() + "'");
        }
        return ref;
    }

    private <T> Object getReferenceValue(Class<T> clazz, Reference ref, boolean allowNull) {
        Object o = null;
        try {
            ref.field.setAccessible(true);
            o = ref.field.get(this);
            if (Checks.esNulo(o) && (!allowNull)) {
                throw new IllegalStateException(this.getClass().getName() + ": Error al resolver: '" + clazz.getName() + "'" + ". '" + ref.field.getName() + "' ES NULL");
            }
        } catch (IllegalArgumentException e) {
            throw new IllegalStateException(this.getClass().getName() + ": Error al acceder a: '" + ref.field.getName() + "'", e);
        } catch (IllegalAccessException e) {
            throw new IllegalStateException(this.getClass().getName() + ": Error al acceder a: '" + ref.field.getName() + "'", e);
        }
        return o;
    }

    private void changeFieldsReadOnlyMode() {
        List<MetadataField> fields = this.getFields();
        if (fields != null)
            for (MetadataField f : fields) {
                if (readOnly) {
                    changeToReadOnly(f);
                } else {
                    changeToReadWrite(f);
                }
            }

    }

    private void changeToReadWrite(MetadataField f) {
        String xtype = (String) f.getEditor().get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE);
        String rwxtype = getRwXtype(xtype);
        f.getEditor().put(EditorOptions.FIELD_EDITOR_OPTION_XTYPE, rwxtype);

    }

    private void changeToReadOnly(MetadataField f) {
        if ((f != null) && (f.getEditor() != null)) {
            String xtype = (String) f.getEditor().get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE);
            String roxtype = getRoXtype(xtype);
            f.getEditor().put(EditorOptions.FIELD_EDITOR_OPTION_XTYPE, roxtype);
        }

    }

    private String getRoXtype(String xtype) {
        if (EditorOptions.XTYPE_CURRENCY_FIELD.equals(xtype))
            return EditorOptions.XTYPE_CURRENCY_FIELD_RO;
        if (EditorOptions.XTYPE_DATEFIELD.equals(xtype))
            return EditorOptions.XTYPE_DATEFIELD_RO;
        if (EditorOptions.XTYPE_DDCOMBO.equals(xtype))
            return EditorOptions.XTYPE_DDCOMBO_RO;
        if (EditorOptions.XTYPE_NUMBER_FIELD.equals(xtype))
            return EditorOptions.XTYPE_NUMBER_FIELD_RO;
        if (EditorOptions.XTYPE_TEXT_FIELD.equals(xtype))
            return EditorOptions.XTYPE_TEXT_FIELD_RO;
        if (EditorOptions.XTYPE_TEXTAREA.equals(xtype))
            return EditorOptions.XTYPE_TEXTAREA_RO;
        return xtype;
    }

    private String getRwXtype(String xtype) {
        if (EditorOptions.XTYPE_CURRENCY_FIELD_RO.equals(xtype))
            return EditorOptions.XTYPE_CURRENCY_FIELD;
        if (EditorOptions.XTYPE_DATEFIELD_RO.equals(xtype))
            return EditorOptions.XTYPE_DATEFIELD;
        if (EditorOptions.XTYPE_DDCOMBO_RO.equals(xtype))
            return EditorOptions.XTYPE_DDCOMBO;
        if (EditorOptions.XTYPE_NUMBER_FIELD_RO.equals(xtype))
            return EditorOptions.XTYPE_NUMBER_FIELD;
        if (EditorOptions.XTYPE_TEXT_FIELD_RO.equals(xtype))
            return EditorOptions.XTYPE_TEXT_FIELD;
        if (EditorOptions.XTYPE_TEXTAREA_RO.equals(xtype))
            return EditorOptions.XTYPE_TEXTAREA;
        return xtype;

    }

    private boolean isReadOnly(Map<String, Object> map) {
        if (Checks.estaVacio(map))
            return false;
        Object o = map.get(EditorOptions.FIELD_EDITOR_OPTION_READONLY);
        return Option.TRUE.equals(o);
    }
}
