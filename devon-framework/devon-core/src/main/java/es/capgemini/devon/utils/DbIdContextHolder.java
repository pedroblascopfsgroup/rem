package es.capgemini.devon.utils;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class DbIdContextHolder {

    public static final String DB_ID = "DB_ID";

    public static SchemaManager schemaManager;

    public DbIdContextHolder(final SchemaManager schemaManager) {
        this.schemaManager = schemaManager;
        //Intento actualizar el schema
        if (getDbId() != null && (getDbSchema() == null || getDbSchema().isEmpty())) setDbSchema(schemaManager.getSchemaForDbId(getDbId()));

    }

    /*
     private static final ThreadLocal<Long> contextHolder = new ThreadLocal<Long>();

     public static void setDbId(Long dbId) {
         Assert.notNull(dbId);
         contextHolder.set(dbId);
     }

     public static Long getDbId() {
         return contextHolder.get();
     }
     */

    //    private static final AtomicLong uniqueId = new AtomicLong(-1);
    private static final ThreadLocal<Long> dbId = new ThreadLocal<Long>() {
        @Override
        protected Long initialValue() {
            return -1L;
        }
    };
    private static final ThreadLocal<String> dbSchema = new ThreadLocal<String>() {
        @Override
        protected String initialValue() {
            return "";
        }
    };

    public static Long getDbId() {
        return dbId.get();
    }

    public static void setDbId(Long id) {
        dbId.set(id);
        //Verificamos si esta definido el bean schemaManager
        if (schemaManager != null) setDbSchema(schemaManager.getSchemaForDbId(id));
    }

    public static String getDbSchema() {
        return dbSchema.get();
    }

    public static void setDbSchema(String schema) {
        dbSchema.set(schema);
    }

    public static void setDb(Long id, String schema) {
        dbId.set(id);
        setDbSchema(schema);
    }

}
